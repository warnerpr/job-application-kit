# Publishing a resume website (optional)

You can publish `public_resume.md` as a web page at `https://<your-username>.github.io`, rebuilt every time you push a change to it.

## Why a separate public file

Your master resume collects detail you might not want on the open internet: internal program names, usage numbers, vendor relationships, your phone number. So the kit publishes a separate, shorter `public_resume.md` that you choose to make public. The master and your applications are never published.

Keep this repository **private**. GitHub Pages on a free account only serves public repositories, so the workflow pushes the built page into a second, public repository: `<your-username>.github.io`.

## One-time setup

You need the [GitHub CLI](https://cli.github.com/) (`gh`) signed in to your account, and Git Bash or another POSIX shell.

1. **Create the public site repository** (skip if you already have one):

   ```bash
   gh repo create <your-username>.github.io --public --add-readme
   ```

   Then on GitHub, open that repository's **Settings → Pages** and set the source to **Deploy from a branch**, branch `main`, folder `/ (root)`.

2. **Create a deploy key** so this private repo can push to the public one:

   ```bash
   ssh-keygen -t ed25519 -N "" -C "resume-publish" -f publish_key
   gh repo deploy-key add publish_key.pub -R <your-username>/<your-username>.github.io -w -t resume-publish
   gh secret set PAGES_DEPLOY_KEY < publish_key
   rm publish_key publish_key.pub
   ```

   The `gh secret set` command must run inside your private resume repository.

3. **Tell the workflow where to publish:**

   ```bash
   gh variable set PAGES_REPO --body "<your-username>/<your-username>.github.io"
   ```

4. **Push a change to `public_resume.md`**, or run the "Publish public resume" workflow from the Actions tab. The page appears at `https://<your-username>.github.io` within a minute or two.

If `PAGES_REPO` isn't set, the publish workflow does nothing, so the kit works fine without a website.

## Notes

- The workflow overwrites `index.html`, `style.css` and `resume.md` in the public repository. Anything else there is left alone. If you already have an `index.html` you care about, move it first.
- To stop publishing, delete the `PAGES_REPO` variable.
