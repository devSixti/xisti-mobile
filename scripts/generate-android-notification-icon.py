#!/usr/bin/env python3
"""Generate white-on-transparent Android notification icons from the XISTI mark.

Android notification icons must be a white silhouette on transparency — not a filled
square. We crop the adaptive-icon foreground, keep only logo strokes (green + dark
mark), and inset within the 24dp safe zone.
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "assets/images/xisti/app_launcher_foreground.png"
RES = ROOT / "android/app/src/main/res"
SIZES = {
    "drawable-mdpi": 24,
    "drawable-hdpi": 36,
    "drawable-xhdpi": 48,
    "drawable-xxhdpi": 72,
    "drawable-xxxhdpi": 96,
}

# Logo occupies ~58% of the 24dp slot per Material notification guidelines.
SAFE_SCALE = 0.58


def _is_logo_pixel(r: int, g: int, b: int, a: int) -> bool:
    if a < 48:
        return False
    # Brand neon green strokes from the manual.
    if g > 110 and g > r + 20:
        return True
    # Dark X mark (not anti-aliased outer plate).
    luminance = (r + g + b) / 3
    return luminance < 95 and a > 96


def _content_bbox(im: Image.Image) -> tuple[int, int, int, int]:
    px = im.load()
    w, h = im.size
    min_x, min_y, max_x, max_y = w, h, 0, 0
    found = False
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if _is_logo_pixel(r, g, b, a):
                found = True
                min_x = min(min_x, x)
                min_y = min(min_y, y)
                max_x = max(max_x, x)
                max_y = max(max_y, y)
    if not found:
        return 0, 0, w - 1, h - 1
    return min_x, min_y, max_x, max_y


def make_icon(size: int) -> Image.Image:
    src = Image.open(SRC).convert("RGBA")
    left, top, right, bottom = _content_bbox(src)
    cropped = src.crop((left, top, right + 1, bottom + 1))

    mark = Image.new("RGBA", cropped.size, (0, 0, 0, 0))
    spx = cropped.load()
    mpx = mark.load()
    cw, ch = cropped.size
    for y in range(ch):
        for x in range(cw):
            r, g, b, a = spx[x, y]
            if _is_logo_pixel(r, g, b, a):
                mpx[x, y] = (255, 255, 255, min(255, a))

    inner = max(1, int(size * SAFE_SCALE))
    mark = mark.resize((inner, inner), Image.LANCZOS)
    out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    offset = (size - inner) // 2
    out.paste(mark, (offset, offset), mark)
    return out


def main() -> None:
    for folder, size in SIZES.items():
        target = RES / folder / "ic_notification.png"
        target.parent.mkdir(parents=True, exist_ok=True)
        make_icon(size).save(target, optimize=True)
        print(f"wrote {target} ({size}px)")
    make_icon(24).save(RES / "drawable" / "ic_notification.png", optimize=True)
    print(f"wrote {RES / 'drawable' / 'ic_notification.png'} (24px)")


if __name__ == "__main__":
    main()
