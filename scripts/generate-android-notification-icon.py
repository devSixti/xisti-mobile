#!/usr/bin/env python3
"""Generate white-on-transparent Android notification icons from the XISTI launcher foreground."""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'assets/images/xisti/app_launcher_foreground.png'
RES = ROOT / 'android/app/src/main/res'
SIZES = {
    'drawable-mdpi': 24,
    'drawable-hdpi': 36,
    'drawable-xhdpi': 48,
    'drawable-xxhdpi': 72,
    'drawable-xxxhdpi': 96,
}


def make_icon(size: int) -> Image.Image:
    im = Image.open(SRC).convert('RGBA').resize((size, size), Image.LANCZOS)
    px = im.load()
    out = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    opx = out.load()
    for y in range(size):
        for x in range(size):
            _, _, _, alpha = px[x, y]
            if alpha > 24:
                opx[x, y] = (255, 255, 255, alpha)
    return out


def main() -> None:
    for folder, size in SIZES.items():
        target = RES / folder / 'ic_notification.png'
        target.parent.mkdir(parents=True, exist_ok=True)
        make_icon(size).save(target, optimize=True)
        print(f'wrote {target} ({size}px)')
    make_icon(24).save(RES / 'drawable' / 'ic_notification.png', optimize=True)
    print(f'wrote {RES / "drawable" / "ic_notification.png"} (24px)')


if __name__ == '__main__':
    main()
