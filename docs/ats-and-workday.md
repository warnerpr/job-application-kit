# Applicant tracking systems (Workday and friends)

Most large employers take applications through an applicant tracking system (ATS) such as Workday, Greenhouse, Lever, iCIMS or Taleo. Many offer "autofill from resume": they parse your file and pre-fill the work history form. What the recruiter later opens is usually the file you attached.

## File formats

- Upload boxes usually accept **DOC, DOCX, PDF, HTML and TXT**. They rarely accept `.md`.
- This kit builds all three useful formats from your Markdown:
  - **`.docx`**: the safest choice for parsing.
  - **`.pdf`**: the nicest for a human to read. Text-based PDFs (like the ones built here) parse fine; scanned or image PDFs don't.
  - **`.txt`**: plain text with the Markdown symbols removed, for "paste your resume" boxes. It includes your mailing address and drops the `+1` from your phone number.
  - **`.wd.txt`** (tailored resumes only): a "Label: Value" version made for Workday's autofill. See below.
- A good routine: use the `.wd.txt` or `.docx` for autofill, check every field, then attach the `.pdf` (or `.docx`) as the document the recruiter will see. Some systems keep the first file you uploaded, so check before you submit.

## What we learned uploading to Workday

From real uploads of a plain-text resume to a Workday application:

1. **It wants a full mailing address.** Put yours in your resume as a hidden comment right after the contact line:
   ```
   <!-- address: 123 Main St, Town, ST 12345 -->
   ```
   It shows up only in the `.txt` and `.wd.txt` files, never in the PDF, Word file or website.
2. **It rejects the country code on phone numbers.** The text files drop `+1`.
3. **Commas in job titles get read as delimiters.** "Director, IT Cloud Services" was split in two. Slashes ("DevOps Manager / Engineer") were fine.
4. **It can't untangle a combined company, location and date line**, especially with commas or parentheses in the company name ("Cyan, Inc. (acquired by Ciena, 2015)").

`scripts/wd_txt.py` builds `<resume>.wd.txt` to work around all four. It puts every field on its own labelled line, splits company, location and dates apart, drops parenthetical notes from company names, and writes dates as MM/YYYY:

```
Job Title: Director, IT Cloud Services
Company: Ciena Corporation
Location: Petaluma, CA and remote
From: 09/2020
To: 05/2022
Role Description:
- Led a team of 12 …
```

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
