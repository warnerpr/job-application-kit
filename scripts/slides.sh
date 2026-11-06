#!/usr/bin/env bash
# Build HTML slides (reveal.js) from Markdown files named *slides.md.
#
#   scripts/slides.sh applications/<folder>/interview_slides.md
#   scripts/slides.sh --style <style> applications/<folder>/interview_slides.md
#
# Writes <name>.html next to each file, plus <name>.notes.pdf: printable
# speaker notes with each slide's cues (scripts/slides-notes.css; needs
# weasyprint, skipped without it). "# Heading" starts a section,
# "## Heading" starts a slide, and a ::: notes block holds speaker notes
# (press S in the browser for speaker view).
#
# Styles live in scripts/slides-<style>.css (plus an optional .js), inlined
# into the deck:
#   pipeline   the deck as a CI pipeline run: sections are stages, slides are jobs
# Add your own by dropping in scripts/slides-<name>.css (and .js).
# A deck picks its style with "slide-style: <style>" in its front matter
# (default pipeline). --style overrides it and writes <name>.<style>.html,
# so you can compare styles side by side.
#
# reveal.js and the fonts load from CDNs, so the deck needs a network
# connection. Needs pandoc.
set -euo pipefail
cd "$(dirname "$0")/.."

override=""
if [ "${1:-}" = "--style" ]; then
  override="${2:?--style needs a name}"; shift 2
fi
[ $# -ge 1 ] || { echo "Usage: $0 [--style <style>] <slides.md>..." >&2; exit 1; }
command -v pandoc >/dev/null || { echo "pandoc not found: https://pandoc.org/installing.html" >&2; exit 1; }
have_pdf=1
command -v weasyprint >/dev/null || { echo "weasyprint not found, skipping notes PDFs"; have_pdf=0; }

# A list may start right after a line of text ("FILL IN:" then "- item")
from="markdown+lists_without_preceding_blankline"

style_file="$(mktemp)"; script_file="$(mktemp)"
trap 'rm -f "$style_file" "$script_file"' EXIT

for md in "$@"; do
  if [ -n "$override" ]; then
    style="$override"; out="${md%.md}.$style.html"
  else
    style="$(sed -n '1,/^---$/{s/^slide-style: *\([a-z-]*\).*/\1/p}' "$md" | head -1)"
    style="${style:-pipeline}"; out="${md%.md}.html"
  fi
  [ -f "scripts/slides-$style.css" ] || { echo "Unknown slide style: $style" >&2; exit 1; }
  { echo "<style>"; cat "scripts/slides-$style.css"; echo "</style>"; } > "$style_file"
  : > "$script_file"
  [ -f "scripts/slides-$style.js" ] && { echo "<script>"; cat "scripts/slides-$style.js"; echo "</script>"; } > "$script_file"

  echo "Building $out ($style)"
  pandoc "$md" -f "$from" -t revealjs -s --slide-level=2 \
    -V revealjs-url=https://cdn.jsdelivr.net/npm/reveal.js@5.1.0 \
    -V theme=white -V transition=none -V hash=true -V controls=false -V navigationMode=linear \
    -V backgroundTransition=none \
    -V width=1100 -V height=640 \
    --include-in-header "$style_file" --include-after-body "$script_file" -o "$out"

  # Printable notes go with the deck's own style, not --style comparisons
  if [ -z "$override" ] && [ "$have_pdf" = 1 ]; then
    echo "Building ${md%.md}.notes.pdf"
    pandoc "$md" -f "$from" -s --section-divs --metadata pagetitle="$(basename "${md%.md}") notes" \
      -c scripts/slides-notes.css --pdf-engine=weasyprint -o "${md%.md}.notes.pdf"
  fi
done
