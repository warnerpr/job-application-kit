#!/usr/bin/env bash
# Build .txt, .docx and .pdf versions of the resumes and cover letters.
#
#   master_resume.md, public_resume.md  -> build/
#   applications/<folder>/*.md          -> next to each file
#
# README.md and job_description.md files are skipped.
# Needs pandoc. PDF also needs weasyprint; without it, PDFs are skipped.
set -euo pipefail
cd "$(dirname "$0")/.."

css="scripts/pdf.css"
have_pdf=1
command -v pandoc >/dev/null || { echo "pandoc not found: https://pandoc.org/installing.html" >&2; exit 1; }
command -v weasyprint >/dev/null || { echo "weasyprint not found, skipping PDFs"; have_pdf=0; }

# Single line breaks count, so address blocks in cover letters stay on separate lines.
from="gfm+hard_line_breaks"

build() {  # build <source.md> <output path without extension>
  local md="$1" out="$2"
  echo "Building $out"
  pandoc "$md" -f "$from" -t plain --wrap=none -o "$out.txt"
  pandoc "$md" -f "$from" -o "$out.docx"
  if [ "$have_pdf" = 1 ]; then
    pandoc "$md" -f "$from" -s --metadata pagetitle="$(basename "$out")" \
      -c "$css" --pdf-engine=weasyprint -o "$out.pdf"
  fi
}

mkdir -p build
for md in master_resume.md public_resume.md; do
  [ -f "$md" ] && build "$md" "build/${md%.md}"
done

find applications -name '*.md' ! -name README.md ! -name job_description.md -print0 |
  while IFS= read -r -d '' md; do build "$md" "${md%.md}"; done
