#!/bin/zsh
# Rebuild the site from content/, data/, layouts/ and static/, then push public/ to GitHub Pages.
# Usage:  ./publish.sh "message describing the change"
#         ./publish.sh --preview        (live local preview at http://localhost:1313, no publishing)
set -e
cd "$(dirname "$0")"

if ! command -v hugo >/dev/null; then
  echo "Hugo is not installed. See the setup notes (Hugo 0.147.3 extended)." >&2
  exit 1
fi

if [[ "$1" == "--preview" ]]; then
  exec hugo server --disableFastRender
fi

rm -f .hugo_build.lock
hugo --gc

cd public
git add -A
if git diff --cached --quiet; then
  echo "Nothing changed in the built site; nothing to publish."
  exit 0
fi
git commit -m "${1:-Update site}"
git push origin main
echo "Published. GitHub Pages usually updates within a minute or two."
