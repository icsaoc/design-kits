#!/usr/bin/env bash
# Regenerate the README gallery thumbnails in .github/screenshots/.
#
# Requirements: a Chromium-based browser (Edge or Chrome), python3 with Pillow.
# Usage:
#   python -m http.server 8899   # from the repo root, in another shell
#   bash tools/capture-screenshots.sh
set -u

PORT="${PORT:-8899}"
BASE="http://localhost:${PORT}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RAW="${TMPDIR:-/tmp}/design-kits-shots"
OUT="${ROOT}/.github/screenshots"

BROWSER="${BROWSER_BIN:-}"
if [ -z "$BROWSER" ]; then
  for c in \
    "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
    "/c/Program Files/Google/Chrome/Application/chrome.exe" \
    "$(command -v google-chrome || true)" \
    "$(command -v chromium || true)"; do
    [ -x "$c" ] && BROWSER="$c" && break
  done
fi
[ -n "$BROWSER" ] || { echo "No Chromium-based browser found; set BROWSER_BIN." >&2; exit 1; }

mkdir -p "$RAW" "$OUT"

# Headless Chromium occasionally drops a capture when profiles are reused,
# so every attempt gets its own profile directory and up to 4 retries.
shoot() {
  local name="$1" path="$2"
  rm -f "$RAW/$name.png"
  for try in 1 2 3 4; do
    [ -s "$RAW/$name.png" ] && break
    "$BROWSER" --headless=new --no-sandbox --disable-gpu --hide-scrollbars \
      --user-data-dir="$RAW/profile-$name-$try" --window-size=1440,900 \
      --screenshot="$RAW/$name.png" --virtual-time-budget=9000 \
      "$BASE/$path" >/dev/null 2>&1
  done
  [ -s "$RAW/$name.png" ] && echo "  captured $name" || echo "  FAILED   $name" >&2
}

echo "Capturing kit screenshots from $BASE ..."
shoot 21th       "21th/ui_kits/dashboard/index.html"
shoot apple      "Apple/ui_kits/website/index.html"
shoot barbie     "Barbie/ui_kits/dashboard/index.html"
shoot claude     "Claude/ui_kits/website/index.html"
shoot doubao     "Doubao/ui_kits/dashboard/index.html"
shoot goldentime "GoldenTime/ui_kits/dashboard/index.html"
shoot google     "Google/ui_kits/dashboard/index.html"
shoot minimalist "Minimalist/ui_kits/dashboard/index.html"
shoot motionfit  "MotionFit/ui_kits/dashboard/index.html"
shoot nerv       "Nerv/ui_kits/dashboard/index.html"
shoot tiktok     "TikTok/ui_kits/app/index.html"
shoot trae       "TRAE/ui_kits/dashboard/index.html"
shoot traework   "TRAEWork/ui_kits/dashboard/index.html"
shoot vercel     "Vercel/ui_kits/dashboard/index.html"
shoot vibecamp   "VibeCamp/ui_kits/dashboard/index.html"
shoot volcengine "Volcengine/ui_kits/data-dashboard/index.html"

echo "Resizing to 720x450 in $OUT ..."
RAW="$RAW" OUT="$OUT" python3 - <<'PY'
import glob, os
from PIL import Image
raw, out = os.environ["RAW"], os.environ["OUT"]
for src in sorted(glob.glob(os.path.join(raw, "*.png"))):
    name = os.path.basename(src)
    dst = os.path.join(out, name)
    Image.open(src).convert("RGB").resize((720, 450), Image.LANCZOS).save(dst, optimize=True)
    print(f"  {name} {os.path.getsize(dst) // 1024} KB")
PY
echo "Done."
