#!/usr/bin/env python3
"""Write a Workday-friendly "Label: Value" text version of a tailored resume.

    python3 scripts/wd_txt.py applications/<folder>/resume.md

Writes resume.wd.txt next to the input. Only works on resumes in the tailored
layout (see docs/ats-and-workday.md):

    ### Job Title
    Company · City, ST · Mon YYYY – Mon YYYY
    - bullet

Does nothing (and writes nothing) if the file has no jobs in that layout, so
it is safe to run on cover letters.

What it does differently from the plain .txt, based on real Workday uploads:
- Every field is on its own "Label: Value" line.
- Commas in job titles become slashes ("Director, IT Cloud Services" becomes
  "Director / IT Cloud Services"). Workday splits titles on commas, even on
  a labelled line, but handles slashes.
- Company, location and dates are split apart. Parenthetical notes in the
  company name ("(acquired by Ciena, 2015)") are dropped.
- Dates become MM/YYYY.
- Each role description starts with the job title, because Workday drops the
  first "-" bullet marker in the description.
- The phone number loses its +1 country code.
- The mailing address comes from a hidden comment in the resume,
  <!-- address: 123 Main St, Town, ST 12345 -->, which no other format shows.
"""
import re
import sys
from pathlib import Path

MONTHS = {m: i for i, m in enumerate(
    "jan feb mar apr may jun jul aug sep oct nov dec".split(), start=1)}
DATE_RANGE = re.compile(r"^(?P<from>.+?)\s+[–-]\s+(?P<to>.+)$")


def clean(text):
    """Strip Markdown formatting down to plain text."""
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)  # links
    text = re.sub(r"(\*\*|__|\*|_|`)", "", text)          # emphasis, code
    return text.strip()


def fmt_date(value):
    value = value.strip()
    if value.lower() in ("present", "current", "now"):
        return "Present"
    m = re.match(r"([A-Za-z]{3})[a-z]*\.?\s+(\d{4})$", value)
    if m and m.group(1).lower() in MONTHS:
        return f"{MONTHS[m.group(1).lower()]:02d}/{m.group(2)}"
    return value  # a bare year, or something we don't recognise


def strip_country_code(phone):
    return re.sub(r"^\+1[\s.-]*", "", phone.strip())


def parse_contact(line):
    info = {}
    for part in (clean(p) for p in line.split("·")):
        if "@" in part:
            info["Email"] = part
        elif "linkedin" in part.lower():
            info["LinkedIn"] = part if part.startswith("http") else "https://" + part
        elif re.search(r"\d{3}.*\d{4}", part):
            info["Phone"] = strip_country_code(part)
        elif part:
            info.setdefault("Location", part)
    return info


def parse(md):
    lines = md.splitlines()
    name = next((clean(l[2:]) for l in lines if l.startswith("# ")), "")
    address = ""
    m = re.search(r"<!--\s*address:\s*(.+?)\s*-->", md)
    if m:
        address = m.group(1)

    contact = {}
    for l in lines[1:6]:
        if "·" in l and "@" in l:
            contact = parse_contact(l)
            break

    jobs, sections = [], []
    section, job, i = None, None, 0
    while i < len(lines):
        l = lines[i].rstrip()
        if l.startswith("## "):
            job = None
            section = {"title": clean(l[3:]), "lines": []}
            sections.append(section)
        elif l.startswith("### "):
            # A job needs a "Company · Location · Dates" line right after it.
            nxt = next((x for x in lines[i + 1:] if x.strip()), "")
            parts = [clean(p) for p in nxt.split("·")]
            dates = DATE_RANGE.match(parts[-1]) if len(parts) >= 2 else None
            if dates:
                company = re.sub(r"\s*\([^)]*\)", "", parts[0]).strip()
                job = {
                    # Workday splits titles on commas; slashes are fine
                    "Job Title": re.sub(r"\s*,\s*", " / ", clean(l[4:])),
                    "Company": company,
                    "Location": ", ".join(parts[1:-1]),
                    "From": fmt_date(dates.group("from")),
                    "To": fmt_date(dates.group("to")),
                    "description": [],
                }
                jobs.append(job)
                i = lines.index(nxt, i + 1)
            else:
                job = None
                if section is not None:
                    section["lines"].append(clean(l[4:]))
        elif job is not None:
            if l.strip() and not l.startswith("<!--"):
                job["description"].append(clean(l.lstrip("-* ").strip()))
        elif section is not None and l.strip() and l.strip() != "---" and not l.startswith("<!--"):
            section["lines"].append(clean(l.lstrip("-* ").strip()))
        i += 1
    return name, address, contact, jobs, sections


def render(name, address, contact, jobs, sections):
    out = ["PERSONAL INFORMATION", f"Name: {name}"]
    if address:
        out.append(f"Address: {address}")
    for key in ("Email", "Phone", "LinkedIn"):
        if key in contact:
            out.append(f"{key}: {contact[key]}")
    out += ["", "WORK EXPERIENCE", ""]
    for job in jobs:
        for key in ("Job Title", "Company", "Location", "From", "To"):
            out.append(f"{key}: {job[key]}")
        out.append("Role Description:")
        # Workday strips the first "-" in the description, so lead with the title
        out.append(job["Job Title"])
        out += [f"- {d}" for d in job["description"]]
        out.append("")
    for s in sections:
        if s["lines"] and "experience" not in s["title"].lower():
            out.append(s["title"].upper())
            out += s["lines"]
            out.append("")
    return "\n".join(out).rstrip() + "\n"


def main(path):
    src = Path(path)
    parsed = parse(src.read_text(encoding="utf-8"))
    if not parsed[3]:
        return  # no jobs in the tailored layout: not a resume
    out = src.with_suffix(".wd.txt")
    out.write_text(render(*parsed), encoding="utf-8", newline="\n")
    print(f"Wrote {out}")


if __name__ == "__main__":
    for p in sys.argv[1:]:
        main(p)
