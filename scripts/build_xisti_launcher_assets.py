#!/usr/bin/env python3
"""Build launcher, adaptive-icon, splash, Android mipmaps, and iOS AppIcon assets."""

from __future__ import annotations

import json
from pathlib import Path

from PIL import Image

from xisti_brand_icon import LOGO_FULL, fit_crop_in_circle, load_brand_crop

ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = ROOT / "assets/images/xisti"
DARK = ROOT / "assets/images/dark"
LIGHT = ROOT / "assets/images/light"
RES = ROOT / "android/app/src/main/res"
IOS_ICON_DIR = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
SIZE = 1024
BG = (11, 11, 11)

MIPMAP_SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

FOREGROUND_SIZES = {
    "drawable-mdpi": 108,
    "drawable-hdpi": 162,
    "drawable-xhdpi": 216,
    "drawable-xxhdpi": 324,
    "drawable-xxxhdpi": 432,
}


def fit_center(canvas: Image.Image, src: Image.Image, scale: float, y_offset: int = 0) -> None:
    w = int(src.width * scale)
    h = int(src.height * scale)
    resized = src.resize((w, h), Image.Resampling.LANCZOS)
    x = (canvas.width - w) // 2
    y = (canvas.height - h) // 2 + y_offset
    if canvas.mode == "RGBA":
        canvas.paste(resized, (x, y), resized if resized.mode == "RGBA" else None)
    else:
        canvas.paste(resized.convert("RGB"), (x, y))


def write_resized_png(src: Image.Image, path: Path, size: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    src.resize((size, size), Image.Resampling.LANCZOS).save(path, optimize=True)


def generate_ios_icons(launcher: Image.Image) -> None:
    contents_path = IOS_ICON_DIR / "Contents.json"
    if not contents_path.exists():
        return
    data = json.loads(contents_path.read_text())
    for entry in data.get("images", []):
        filename = entry.get("filename")
        scale = float(str(entry.get("scale", "1x")).replace("x", ""))
        base = float(str(entry.get("size", "0x0")).split("x")[0])
        px = int(round(base * scale))
        write_resized_png(launcher, IOS_ICON_DIR / filename, px)
        print(f"✓ ios/{filename} ({px}px)")


def main() -> None:
    brand_crop = load_brand_crop(include_tagline=True)
    src = Image.open(LOGO_FULL).convert("RGBA")

    # Full square icon — wordmark fits inside the circular mask (no clipping).
    launcher = fit_crop_in_circle(brand_crop, SIZE, circle_margin=0.86, background=BG)
    launcher.save(OUT_DIR / "app_launcher.png", optimize=True)

    # Adaptive foreground — same circle-safe scale as launcher.
    foreground = fit_crop_in_circle(brand_crop, SIZE, circle_margin=0.86, background=None)
    foreground.save(OUT_DIR / "app_launcher_foreground.png", optimize=True)

    splash = Image.new("RGBA", (1600, 1600), (0, 0, 0, 0))
    fit_center(splash, src, scale=1.35, y_offset=0)
    splash.save(DARK / "splash_logo.png", optimize=True)
    splash.save(LIGHT / "splash_logo.png", optimize=True)

    for folder, px in MIPMAP_SIZES.items():
        target = RES / folder / "launcher_icon.png"
        write_resized_png(launcher, target, px)
        print(f"✓ {folder}/launcher_icon.png ({px}px)")

    for folder, px in FOREGROUND_SIZES.items():
        target = RES / folder / "ic_launcher_foreground.png"
        write_resized_png(foreground, target, px)
        print(f"✓ {folder}/ic_launcher_foreground.png ({px}px)")

    generate_ios_icons(launcher)

    print("✓ app_launcher.png")
    print("✓ app_launcher_foreground.png")
    print("✓ dark/light splash_logo.png")


if __name__ == "__main__":
    main()
