#!/usr/bin/env bash
# Start a new application folder.
#
#   scripts/new-application.sh "Acme Corp" "Platform Engineering Manager"
#
# Creates applications/YYYY-MM-acme-corp-platform-engineering-manager/ with a
# job_description.md to paste the posting into, a resume.md copied from your
# master resume, and a cover_letter.md starter.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ $# -ne 2 ]; then
  echo "Usage: $0 \"Company\" \"Role\"" >&2
  exit 1
fi
company="$1"; role="$2"

slug() { echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-|-$//g'; }
dir="applications/$(date +%Y-%m)-$(slug "$company")-$(slug "$role")"

if [ -e "$dir" ]; then
  echo "$dir already exists" >&2
  exit 1
fi
mkdir -p "$dir"

cat > "$dir/job_description.md" <<MD
# $role, $company

URL:
Saved: $(date +%Y-%m-%d)

<!-- Paste the full posting below. Postings get taken down. -->
MD

cp master_resume.md "$dir/resume.md"

cat > "$dir/cover_letter.md" <<MD
Your Name
City, ST · you@example.com · +1-555-555-5555 · linkedin.com/in/you

$(date +"%B %-d, %Y")

$company Hiring Team
Re: $role

Dear Hiring Team,

<!-- Why this role and this company, in your own words. -->

Sincerely,
Your Name
MD

echo "Created $dir"
