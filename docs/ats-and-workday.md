# Applicant tracking systems (Workday and friends)

Most large employers take applications through an applicant tracking system (ATS) such as Workday, Greenhouse, Lever, iCIMS or Taleo. Many offer "autofill from resume": they parse your file and pre-fill the work history form. What the recruiter later opens is usually the file you attached.

## File formats

- Upload boxes usually accept **DOC, DOCX, PDF, HTML and TXT**. They rarely accept `.md`.
- This kit builds all three useful formats from your Markdown:
  - **`.docx`**: the safest choice for parsing.
  - **`.pdf`**: the nicest for a human to read. Text-based PDFs (like the ones built here) parse fine; scanned or image PDFs don't.
  - **`.txt`**: plain text with the Markdown symbols removed, for "paste your resume" boxes. It includes your mailing address and drops the `+1` from your phone number.
  - **`.wd.txt`** (tailored resumes only): a stripped-down version made for Workday's autofill. See below.
- A good routine: use the `.wd.txt` or `.docx` for autofill, check every field, then attach the `.pdf` (or `.docx`) as the document the recruiter will see. Some systems keep the first file you uploaded, so check before you submit.

## What we learned uploading to Workday

From real uploads of a plain-text resume to a Workday application:

1. **It wants a full mailing address.** Put yours in your resume as a hidden comment right after the contact line:
   ```
   <!-- address: 123 Main St, Town, ST 12345 -->
   ```
   It shows up only in the `.txt` and `.wd.txt` files, never in the PDF, Word file or website.
2. **It rejects the country code on phone numbers.** The text files drop `+1`.
3. **Commas in job titles get read as delimiters**, even on a labelled "Job Title:" line: "Director, IT Cloud Services" was split in two. Replacing the comma with a slash fixed that, but then Workday seemed to take "IT Cloud Services" for a company name. The `.wd.txt` uses "of" instead: "Director of IT Cloud Services". Titles that already had a slash and no comma ("DevOps Manager / Engineer") are left alone.
4. **It drops the first "-" in each role description.** We tried repeating the job title as the first line of the description to absorb it, but dropped that; losing one dash is harmless.
5. **It can't untangle a combined company, location and date line**, especially with commas or parentheses in the company name ("Cyan, Inc. (acquired by Ciena, 2015)"). Even on its own line, the comma in "Cyan, Inc." seemed to break company, location and dates, so the `.wd.txt` drops commas from company names ("Cyan Inc.").
6. **Labels didn't help.** A version with "Job Title:", "Company:" and similar labels on every line still got companies wrong, apparently at random. Our working theory is that Workday uses some kind of AI to find the fields, and unusual titles or internal names confuse it more than layout does. So the `.wd.txt` is values only, and plain, conventional job titles in your resume help more than formatting tricks.

`scripts/wd_txt.py` builds `<resume>.wd.txt` to work around all of these. It puts every value on its own line in a fixed order (title, company, location, from, to, description), turns commas in job titles into "of", drops commas and parenthetical notes from company names, and writes dates as MM/YYYY:

```
Director of IT Cloud Services
Ciena Corporation
Petaluma, CA and remote
09/2020
05/2022
- Led a team of 12 …
```

Whatever you upload, check every autofilled field before you submit. No format we've tried parses perfectly.

It only understands the tailored layout below, so it skips the master resume and cover letters. It needs Python 3, which GitHub's build runner has.

## Structure that parses well

- One block per job, in this order:
  ```
  ### Job Title
  Company · City, ST · Mon YYYY – Mon YYYY
  - Bullet
  ```
- Consistent dates everywhere: `Mon YYYY – Mon YYYY` (or `– Present`).
- No tables, columns, text boxes, headers or footers for important content. Parsers often skip them.
- Don't group several roles under one heading ("Earlier roles"); the parser will treat the heading as a job.
- Don't put bold subheadings inside a job; they can be read as extra job titles.
- Standard section names: Summary, Experience (or Professional Experience), Education, Certifications, Skills.

## After autofill

- Check every field: job titles, company names, dates, and whether descriptions were cut off.
- Look for stray symbols (`#`, `*`, `·`) that leaked into fields.
- Add your LinkedIn and personal site in the "Websites" fields if there are any.

## Keywords

- Recruiters and some ATS searches match the posting's own words. Mirror the posting's terms where they're true for you ("Infrastructure as Code", not only "Terraform").
- Don't paste keywords you can't back up. A human will read it, and an interviewer will ask.

## Things only you can do

- Create the ATS account, answer the eligibility and demographic questions, and press Submit. The skills can help draft answers to free-text questions.
