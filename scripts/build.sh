#!/usr/bin/env bash
# Build .txt, .docx and .pdf versions of the resumes and cover letters.
#
#   master_resume.md, public_resume.md  -> build/
#   applications/<folder>/*.md          -> next to each file
#
# README.md and job_description.md files are skipped. Tailored resumes also get
# a Workday-style <name>.wd.txt (scripts/wd_txt.py, needs python3).
# If footer.md exists, it is appended to every document (and the website).
# Needs pandoc. PDF also needs weasyprint; without it, PDFs are skipped.
set -euo pipefail
cd "$(dirname "$0")/.."

# Top-level documents to build into build/.
root_docs="master_resume.md public_resume.md"

css="scripts/pdf.css"
have_pdf=1
command -v pandoc >/dev/null || { echo "pandoc not found: https://pandoc.org/installing.html" >&2; exit 1; }
command -v weasyprint >/dev/null || { echo "weasyprint not found, skipping PDFs"; have_pdf=0; }

have_python=1
command -v python3 >/dev/null && python3 -c "" 2>/dev/null || { echo "python3 not found, skipping .wd.txt"; have_python=0; }

# Plain text fixes learned from Workday uploads: drop the +1 country code, and
# show the mailing address (kept in a hidden <!-- address: ... --> comment so
# no other format shows it) on the line after the contact line.
fix_txt() {  # fix_txt <source.md> <file.txt>
  local addr
  addr="$(sed -n -E 's/.*<!-- *address: *(.*[^ ]) *-->.*/\1/p' "$1" | head -1)"
  sed -i -E 's/\+1[ .-]?([0-9]{3})/\1/' "$2"
  if [ -n "$addr" ]; then
    awk -v a="$addr" '{ print } !done && /@/ { print a; done = 1 }' "$2" > "$2.tmp" && mv "$2.tmp" "$2"
  fi
}

# Single line breaks count, so address blocks in cover letters stay on separate lines.
from="gfm+hard_line_breaks"

build() {  # build <source.md> <output path without extension>
  local md="$1" out="$2"
  local inputs=("$md")
  [ -f footer.md ] && inputs+=(footer.md)
  echo "Building $out"
  pandoc "${inputs[@]}" -f "$from" -t plain --wrap=none -o "$out.txt"
  fix_txt "$md" "$out.txt"
  pandoc "${inputs[@]}" -f "$from" -o "$out.docx"
  # Workday-style "Label: Value" version; only written for resumes in the tailored layout
  [ "$have_python" = 1 ] && python3 scripts/wd_txt.py "$md"
  if [ "$have_pdf" = 1 ]; then
    pandoc "${inputs[@]}" -f "$from" -s --metadata pagetitle="$(basename "$out")" \
      -c "$css" --pdf-engine=weasyprint -o "$out.pdf"
  fi
}

mkdir -p build
for md in $root_docs; do
  [ -f "$md" ] && build "$md" "build/${md%.md}"
done

find applications -name '*.md' ! -name README.md ! -name job_description.md -print0 |
  while IFS= read -r -d '' md; do build "$md" "${md%.md}"; done
