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
| `footer.md.example` | Optional "built with" footer. Copy to `footer.md` to turn it on. |
| `.claude/skills/resume-coach/` | Skill: builds and reviews your master resume with you. |
| `.claude/skills/tailor-application/` | Skill: tailors a resume and writes a cover letter for one job. |
| `docs/writing-guide.md` | Voice, style and honesty rules the skills follow. Edit to taste. |
| `docs/ats-and-workday.md` | How applicant tracking systems read your resume, and upload tips. |
| `docs/publishing.md` | Setting up the optional website. |
| `scripts/build.sh` | Builds `.txt`, `.docx`, `.pdf`. Runs in GitHub Actions (only for the files a push changed); can run locally, for everything or for the files you name. |
| `scripts/new-application.sh` | Creates a new application folder. |
| `.github/workflows/build.yml` | Builds the documents each push changed and commits them back. |
| `.github/workflows/publish.yml` | Publishes the website. Off until you set it up. |

## New to GitHub?

You don't need to know git to use this kit. A few words you'll see:

- **Repository** (or "repo"): a project folder stored on GitHub. Yours will hold your resume.
- **Commit**: a saved snapshot of your changes, with a short note.
- **Push**: send your commits up to GitHub. **Pull**: bring GitHub's latest changes down to your computer.
- **Action**: a small job GitHub runs for you. Here, it turns your Markdown into Word, PDF and text.

**Create a free account** at [github.com/signup](https://github.com/signup). The free plan is all you need, and it includes private repositories. Pick a username you'd be happy to show an employer, since it appears in your website address if you publish one.

## Getting started

### 1. Make your own private copy

Signed in to GitHub, open this kit's page and click **Use this template → Create a new repository**. Give it a name like `resume`, choose **Private**, and click **Create repository**. Your resume will hold your contact details and work history, so keep the repository private.

### 2. Let the build commit back

The build workflow commits generated files to your repository. In your new repository go to **Settings → Actions → General → Workflow permissions** and choose **Read and write permissions**, then **Save**. (Some accounts have this on already.)

### 3. Choose how you'll work with Claude

Pick whichever suits you. Both use the same skills.

**Option A: in your browser, nothing to install.** Go to [claude.ai/code](https://claude.ai/code), connect your GitHub account when asked, and let Claude access your new repository. Start a session on that repository. Claude makes its changes on a separate branch; when you're happy with them, ask Claude to open a pull request and merge it (or click **Merge pull request** on GitHub). The build runs once the change is merged into `main`.

**Option B: on your own computer.** Install [Claude Code](https://claude.com/claude-code) and get a copy of your repository:

- No git experience: install [GitHub Desktop](https://desktop.github.com/), sign in, and choose **File → Clone repository**. Its **Push origin** and **Fetch / Pull origin** buttons do the pushing and pulling for you.
- Comfortable with a terminal:

  ```bash
  git clone git@github.com:<you>/<your-repo>.git
  cd <your-repo>
  ```

Then open Claude Code in that folder.

### 4. Write your master resume with Claude

The skills in `.claude/skills/` load automatically. Say something like:

- "Help me build my master resume. Here's my LinkedIn profile: …" or "My old resume is in `old_resume.docx`."
- "Ask me questions about each role so we can add more detail."
- "I made some edits. Review them and suggest changes; let me approve each one."
- "Now update the summary, competencies and skills."

The coach asks numbered questions, and you answer in rough notes. It keeps your phrasing, never invents facts, and asks before big changes. When the file is in good shape, ask it to commit and push.

### 5. Apply for a job

Share the posting:

- "Tailor my resume and write a cover letter for this job: <link>"

The tailor-application skill will:
1. Save the posting.
2. Give you an honest fit analysis: strong matches, and gaps a recruiter will notice.
3. Ask about experience you might not have written down yet, and add your answers to the master too.
4. Draft the tailored resume and cover letter in `applications/<folder>/`.
5. After you push, check the built PDF.

### 6. Get your files

Each change to a resume or cover letter on `main` runs the build. About a minute later you'll find `resume.docx`, `resume.pdf`, `resume.txt` and the cover letter equivalents next to the Markdown. The master and public resumes build into `build/`. See `docs/ats-and-workday.md` for which file to upload where.

To download them:

- **On GitHub:** open the file in your repository and click the download button (**Download raw file**) at the top right.
- **GitHub Desktop:** click **Fetch origin**, then **Pull origin**.
- **Terminal:** `git pull`.

If you work on your own computer, **always pull before your next edit**, or your next push will be rejected because the build added a commit. (In the browser option, Claude handles this.)

You can check on a build in your repository's **Actions** tab. A green tick means it finished; a red cross means something went wrong, and you can paste the error to Claude.

## Building locally (optional)

You don't need to install anything; GitHub builds for you. If you want to build on your own computer:

- Install [pandoc](https://pandoc.org/installing.html). On Windows: `winget install JohnMacFarlane.Pandoc`. On a Mac: `brew install pandoc`.
- For PDFs, also install [WeasyPrint](https://doc.courtbouillon.org/weasyprint/stable/first_steps.html). This is easy on Mac and Linux and fiddly on Windows; the script skips PDFs if it isn't installed.
- Run `scripts/build.sh` from Git Bash (installed with [Git for Windows](https://git-scm.com/download/win)) or a terminal.

## Using it with Codex or ChatGPT

The two skills are plain instructions in the open [Agent Skills](https://agentskills.io) format (a folder with a `SKILL.md`), and nothing in them is specific to Claude. Other assistants can follow them, with some setup.

### Codex

[Codex](https://developers.openai.com/codex/skills) reads skills from `.agents/skills/` in a repository, not `.claude/skills/`. Copy them across once in your own repository:

```bash
mkdir -p .agents
cp -r .claude/skills .agents/skills
```

Commit the copy, then use the skills the same way: ask Codex to build your master resume or tailor an application, or name a skill directly with `$resume-coach` or `$tailor-application`. Codex can edit, commit and push like Claude Code, so the rest of this README applies unchanged. If you later edit a skill, edit both copies (or delete the one you don't use).

### ChatGPT

ChatGPT [supports skills](https://help.openai.com/en/articles/20001066) on some plans (Business, Enterprise, Edu and similar at the time of writing; check the article for yours). Upload each skill folder under **Skills → New skill**. ChatGPT can't commit to your repository, so the workflow is more manual:

1. Give it your files: upload `master_resume.md`, `docs/writing-guide.md` and `docs/ats-and-workday.md` to the chat (or a ChatGPT Project so they stay put).
2. Ask it to build your resume or tailor an application, as above.
3. Copy what it writes back into the matching file on github.com (pencil icon → paste → **Commit changes**). The build then makes your Word, PDF and text files as usual.

On a plan without skills, make a ChatGPT Project, paste the contents of the `SKILL.md` you want into the Project's instructions, and upload the same files. It works the same way, just without automatic skill selection.

## Using it without Claude

Everything except the coaching works on its own: edit the Markdown (you can even do this on github.com, using the pencil icon on any file), run `scripts/new-application.sh "Company" "Role"`, push, pull your files. The two `SKILL.md` files also work as plain checklists for doing it by hand.

## Customizing

- **Look of the PDFs:** `scripts/pdf.css`.
- **Look of the website:** `site/style.css`.
- **Writing rules** (em dashes, banned words, tone): `docs/writing-guide.md`. The skills follow whatever it says.
- **"Built with" footer:** copy `footer.md.example` to `footer.md` and edit it. Its text is added, small, to the end of every built resume, cover letter and website page. Use it if you want readers to know how your documents are made; leave it out if not. It's one short line, so it won't confuse applicant tracking systems.

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
