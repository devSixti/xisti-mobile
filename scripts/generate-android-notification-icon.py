#!/usr/bin/env python3
"""Generate white-on-transparent Android notification icons from the XISTI wordmark."""

from __future__ import annotations

from pathlib import Path

from PIL import Image

from xisti_brand_icon import NOTIFICATION_CIRCLE_MARGIN, brand_white_silhouette, fit_crop_in_circle, load_brand_crop

ROOT = Path(__file__).resolve().parents[1]
RES = ROOT / "android/app/src/main/res"
SIZES = {
    "drawable-mdpi": 24,
    "drawable-hdpi": 36,
    "drawable-xhdpi": 48,
    "drawable-xxhdpi": 72,
    "drawable-xxxhdpi": 96,
}

# Fill the circular notification badge without clipping the wordmark.
NOTIFICATION_FILL = NOTIFICATION_CIRCLE_MARGIN


def make_icon(size: int) -> Image.Image:
    crop = load_brand_crop(include_tagline=False)
    silhouette = brand_white_silhouette(crop)
    return fit_crop_in_circle(silhouette, size, circle_margin=NOTIFICATION_FILL, background=None)


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
