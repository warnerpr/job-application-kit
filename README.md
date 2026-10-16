# Job Application Kit

Keep your resume as plain Markdown in a private GitHub repository, tailor it for each job, and let GitHub build the Word, PDF and text versions for you. Two [Claude Code](https://claude.com/claude-code) skills coach you through writing it in your own voice.

## The idea

1. **One master resume** (`master_resume.md`), deliberately long and detailed. It's the true record of your career, and nobody else reads it.
2. **One folder per job** (`applications/2026-10-acme-platform-manager/`) with the saved job posting, a tailored resume and a cover letter, all cut from the master.
3. **Automatic builds.** Push a change and a GitHub Action turns every resume and cover letter into `.docx`, `.pdf` and `.txt`, ready to upload.
4. **Optional website.** Publish a short `public_resume.md` to `https://<you>.github.io`.

```
master_resume.md ──(tailor-application skill)──▶ applications/<job>/resume.md, cover_letter.md
       ▲                                                   │
  (resume-coach skill)                               git push
       │                                                   ▼
   your answers                         GitHub Action builds .docx .pdf .txt
```

## What's inside

| Path | What it is |
|---|---|
| `master_resume.md` | Your master resume. Starts with a fictional example to replace. |
| `public_resume.md` | Short version for the optional website. |
| `applications/` | One folder per job. Includes a finished example. |
| `TODO.md` | Open questions and things to look up. |
| `.claude/skills/resume-coach/` | Skill: builds and reviews your master resume with you. |
| `.claude/skills/tailor-application/` | Skill: tailors a resume and writes a cover letter for one job. |
| `docs/writing-guide.md` | Voice, style and honesty rules the skills follow. Edit to taste. |
| `docs/ats-and-workday.md` | How applicant tracking systems read your resume, and upload tips. |
| `docs/publishing.md` | Setting up the optional website. |
| `scripts/build.sh` | Builds `.txt`, `.docx`, `.pdf`. Runs in GitHub Actions; can run locally. |
| `scripts/new-application.sh` | Creates a new application folder. |
| `.github/workflows/build.yml` | Builds documents on every push and commits them back. |
| `.github/workflows/publish.yml` | Publishes the website. Off until you set it up. |

## Getting started

### 1. Make your own private copy

On GitHub, click **Use this template → Create a new repository**, and choose **Private**. Your resume will hold your contact details and work history, so keep the repository private.

Then clone it:

```bash
git clone git@github.com:<you>/<your-repo>.git
cd <your-repo>
```

### 2. Let the build commit back

The build workflow commits generated files to your repository. In your new repository go to **Settings → Actions → General → Workflow permissions** and choose **Read and write permissions**. (Some accounts have this on already.)

### 3. Write your master resume with Claude

Open Claude Code in the repository folder. The skills in `.claude/skills/` load automatically. Then say something like:

- "Help me build my master resume. Here's my LinkedIn profile: …" or "My old resume is in `old_resume.docx`."
- "Ask me questions about each role so we can add more detail."
- "I made some edits. Review them and suggest changes; let me approve each one."
- "Now update the summary, competencies and skills."

The coach asks numbered questions, and you answer in rough notes. It keeps your phrasing, never invents facts, and asks before big changes. When the file is in good shape, ask it to commit and push.

### 4. Apply for a job

Share the posting:

- "Tailor my resume and write a cover letter for this job: <link>"

The tailor-application skill will:
1. Save the posting.
2. Give you an honest fit analysis: strong matches, and gaps a recruiter will notice.
3. Ask about experience you might not have written down yet, and add your answers to the master too.
4. Draft the tailored resume and cover letter in `applications/<folder>/`.
5. After you push, check the built PDF.

### 5. Get your files

Each push that changes a resume or cover letter runs the build. About a minute later:

```bash
git pull
```

You'll find `resume.docx`, `resume.pdf`, `resume.txt` and the cover letter equivalents next to the Markdown. The master and public resumes build into `build/`. See `docs/ats-and-workday.md` for which file to upload where.

**Always `git pull` before your next edit**, or your next push will be rejected because the build added a commit.

## Building locally (optional)

You don't need to install anything; GitHub builds for you. If you want to build on your own computer:

- Install [pandoc](https://pandoc.org/installing.html). On Windows: `winget install JohnMacFarlane.Pandoc`. On a Mac: `brew install pandoc`.
- For PDFs, also install [WeasyPrint](https://doc.courtbouillon.org/weasyprint/stable/first_steps.html). This is easy on Mac and Linux and fiddly on Windows; the script skips PDFs if it isn't installed.
- Run `scripts/build.sh` from Git Bash or a terminal.

## Using it without Claude

Everything except the coaching works on its own: edit the Markdown, run `scripts/new-application.sh "Company" "Role"`, push, pull your files. The two `SKILL.md` files also work as plain checklists for doing it by hand or with another AI assistant.

## Customizing

- **Look of the PDFs:** `scripts/pdf.css`.
- **Look of the website:** `site/style.css`.
- **Writing rules** (em dashes, banned words, tone): `docs/writing-guide.md`. The skills follow whatever it says.

## Privacy

- Keep your repository private. The master resume and applications are never published.
- Only `public_resume.md` is published, and only if you set up the website.
- Claude reads your files while it helps you. Don't put anything in the repository you wouldn't want an assistant to read, like passwords or ID numbers.

## Similar projects

Plenty of people keep resumes in Markdown. Some of them:

- Markdown resume templates with pandoc and GitHub Actions: [vidluther/markdown-resume](https://github.com/vidluther/markdown-resume), [AleksaC/resume](https://github.com/AleksaC/resume), [mboyea/resume](https://github.com/mboyea/resume), and an [ATS-safe pandoc template](https://pandoc-templates.org/template/ats-safe-resume).
- Claude skills for resume tailoring: [amanattar/resume-tailoring-skill](https://github.com/amanattar/resume-tailoring-skill) and [a bundle by Asad Faizee](https://blog.asadfaizee.is-a.dev/ai/career/2026/04/27/claude-skills-for-job-seekers-asad-faizee.html).

What this kit adds is the combination: a verbose master as the source of truth, one folder per application, automatic Word/PDF/text builds, and coaching that interviews you for detail and keeps your voice.

## License

MIT. See `LICENSE`.
