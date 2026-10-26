---
name: tailor-application
description: Tailor the user's master resume and write a cover letter for one specific job posting, saved in applications/<folder>/. Use when the user shares a job link or job description, asks to customize their resume for a role, wants a cover letter, wants a fit or gap analysis against a posting, or asks how an applicant tracking system (Workday, Greenhouse, Lever, iCIMS) will read their resume.
---

# Tailor an application

You turn `master_resume.md` (the verbose source of truth) into a targeted resume and cover letter for one job, in their voice, without overclaiming. Read `docs/writing-guide.md` and `docs/ats-and-workday.md` before drafting.

## Steps

### 1. Get the job description

- If they give a link, open it. Many applicant tracking sites (Workday especially) render with JavaScript, so a plain web fetch often comes back empty; use a browser tool if you have one, otherwise ask them to paste the text.
- Create the folder: `scripts/new-application.sh "<Company>" "<Role>"`. It makes `applications/YYYY-MM-company-role/` with starter files.
- Save the full posting to `job_description.md` in that folder, with the URL and the date. Postings get taken down. Keep the URL of the page where they actually apply (the company's job board or applicant tracking system, not just an aggregator listing); step 8 hands it back to them.

### 2. Fit analysis (in chat, before drafting)

Give an honest read, short:

- **Strong matches:** requirement → the specific master resume evidence.
- **Gaps a recruiter will notice:** missing keywords, missing experience, seniority or team-size mismatches, a most-recent role that doesn't look like this job.
- Practical notes from the posting: location and onsite days, pay range, team size.

### 3. Gap questions

Ask numbered questions about likely-but-unwritten experience behind each gap (for example: tools used, incidents handled, audits supported, largest team, scripting). Also ask the cover letter questions: **why this role, why this company, anything about location or working style, any connection to the company.**

Write every new fact into `master_resume.md` too, not just the tailored copy, using the resume-coach rules. The master stays the source of truth.

### 4. Draft the tailored resume (`resume.md`)

- **Summary:** rewritten for this role, using their own words where they gave them.
- **Competencies and skills:** reordered and renamed to mirror the posting's language, but only with things the master backs up.
- **Experience:** keep reverse chronological order. Expand the roles that match, trim the ones that don't (one or two bullets for old or unrelated roles). Lead each role with its most relevant bullets.
- **Structure for applicant tracking systems:** one block per job, `### Title`, then `Company · Location · Mon YYYY – Mon YYYY` on the next line, then bullets. No tables, no columns, no grouped "earlier roles" headings, no bold subheadings inside a job.
- Drop anything the user asks to drop for this application (a cloud they barely used, a hobby certificate) even if it stays in the master.

### 5. Draft the cover letter (`cover_letter.md`)

- About 300–450 words, one page. Header with their contact line, date, company and role (with the requisition ID if there is one).
- Open with why this role, in their words. Then two or three paragraphs of evidence mapped to the posting's main sections. Address the biggest gap honestly in one sentence rather than hiding it. Close plainly.
- No claims beyond the master resume. After drafting, tell the user what the letter deliberately does **not** claim, so they're ready for it in an interview.

### 6. Build and check

- Push to build: the GitHub Action turns each `.md` into `.txt`, `.docx` and `.pdf` next to it (see the README). Locally, `scripts/build.sh` does the same if pandoc is installed (PDF also needs weasyprint).
- Open the PDF and check page breaks and length. Two pages is typical; three is fine for senior roles; four is long.
- Remind them to `git pull` after the build so they have the generated files.

### 7. Wrap up

- List the remaining gaps and suggest how to talk about each in an interview.
- Point them to `docs/ats-and-workday.md` for upload tips.
- Commit and push only when they ask.

### 8. Hand off: tell them to apply

Once the resume and cover letter are final, merged, and built (so the PDF and Word files exist), send a separate message whose only job is the next action, so it doesn't get lost in a review thread. Don't fold it into the wrap up or a build report.

- Open with a clear heading such as **Action for you: apply to <Company>, <Role>**.
- The job posting URL from `job_description.md`, as a clickable link. If the posting is gone, say so and give the company careers page instead.
- The requisition ID, if there is one.
- Which files to upload, by path: the resume and cover letter PDFs (or `.docx` if the site asks for Word), and the `.wd.txt` for pasting into Workday fields.
- Anything the application form will likely ask that the files don't answer (salary expectations, work authorization, start date, referral name), with the answer if they already gave it.
- Ask them to reply once they've submitted. Only then mark the application as applied in whatever tracker they use, and set a follow up date.
