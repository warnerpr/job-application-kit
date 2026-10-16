# Applicant tracking systems (Workday and friends)

Most large employers take applications through an applicant tracking system (ATS) such as Workday, Greenhouse, Lever, iCIMS or Taleo. Many offer "autofill from resume": they parse your file and pre-fill the work history form. What the recruiter later opens is usually the file you attached.

## File formats

- Upload boxes usually accept **DOC, DOCX, PDF, HTML and TXT**. They rarely accept `.md`.
- This kit builds all three useful formats from your Markdown:
  - **`.docx`**: the safest choice for parsing.
  - **`.pdf`**: the nicest for a human to read. Text-based PDFs (like the ones built here) parse fine; scanned or image PDFs don't.
  - **`.txt`**: plain text with the Markdown symbols removed, for "paste your resume" boxes.
- A good routine: use the `.docx` for autofill, check every field, then attach the `.pdf` (or `.docx`) as the document the recruiter will see. Some systems keep the first file you uploaded, so check before you submit.

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
