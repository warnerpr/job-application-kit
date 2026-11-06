---
name: interview-slides
description: Build a speaking-guide slide deck for one job interview, with short cues on screen, talking points in speaker notes, and a printable notes PDF, saved in applications/<folder>/. Use when the user has an interview coming up, wants slides or a talk track for it, keeps getting sidetracked telling their story, or wants their draft deck reviewed.
---

# Interview slides

You build a small deck that keeps the user on one story in an interview. The slides show short cues the interviewer can follow. The speaker notes hold what the user actually wants to say, in their voice. The build makes an HTML deck to share on screen and a PDF of the notes to print.

Read `docs/writing-guide.md` first. The same voice and honesty rules apply: every claim on a slide must be backed by `master_resume.md`.

## Steps

### 1. Gather context

- The application folder: `job_description.md`, the tailored resume and cover letter, and any fit notes.
- The interview: who (recruiter, hiring manager, panel), when, how long, and notes from earlier rounds. Ask if you don't know.
- What the user wants the deck to do. Ask what story they want to tell, and where they tend to lose the thread.

### 2. Write the outline

Create `applications/<folder>/interview_slides.md`:

```markdown
---
title: <a short theme for the story>
subtitle: <Role> (<requisition ID>)
author: <Their Name>
date: <Company> · <Month YYYY>
slide-style: pipeline
---

# Why me {channel=why-me}

## <Who I am in one line> {channel=intro}

- up to 6 short bullets

::: notes
What to say, in their words, in quotes. How long to spend.
:::
```

- `# Heading` starts a section, `## Heading` starts a slide, and `{channel=name}` gives a short label for the pipeline bar.
- **Intro section (3 or 4 slides):** who they are in one line; their career as ONE timeline, one line per stop, angled at what this role cares about; recent hands-on work that proves the angle; why this role and this company.
- **One slide per main requirement in the posting**, with the evidence from the master resume.
- **Gaps, and how I'd ramp:** name the gap before the interviewer does, then the closest analogs and a 30/60/90-day plan.
- **Questions for them:** questions that show they read the posting. Don't ask what the posting already answers.

### 3. Write the notes

Each slide's `::: notes` block holds:

- What to say, quoted, in the user's voice.
- `Maps to:` the posting's own words, so they can connect the dots out loud.
- Honesty reminders about scope (for example "project admin, not platform admin"; "followed it closely but it wasn't my project").
- `FILL IN:` prompts for stories only they know, such as an incident they ran, a performance problem they handled, or a metric they tracked. Put each on its own `- ` line.

Keep gaps out of the on-screen text and own them out loud in the notes.

### 4. Build and check

- `scripts/slides.sh applications/<folder>/interview_slides.md` writes `interview_slides.html` (press S in the browser for speaker view) and `interview_slides.notes.pdf` (needs WeasyPrint). On `main`, GitHub Actions builds both.
- Check that every slide fits on screen at 1280x720. Six short bullets is about the limit. Trim any slide that runs off the bottom.
- Styles live in `scripts/slides-<style>.css` (and `.js`). The default is `pipeline`, which shows the deck as a CI pipeline run. `scripts/slides.sh --style <name>` builds a side-by-side variant to compare.

### 5. Review their edits

Users iterate on the notes right up to the interview. When they ask for a review, check:

- Numbers and scope that conflict with `master_resume.md` or the tailored resume. Ask which is right, and update the master with any new fact.
- Slides that overflow.
- Vague "why this company" lines. Anchor them to something the user heard in an earlier round.
- Typos, unclear shorthand, and the writing-guide rules (no em dashes by default).
- FILL IN prompts still open. Offer draft answers from the master resume, marked as drafts.

Commit and push only when they ask.
