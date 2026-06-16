#!/usr/bin/env python3
"""Build launcher + splash logo assets from logo_full (keeps Fácil & Seguro visible)."""
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "assets/images/xisti/logo_full.png"
OUT_DIR = ROOT / "assets/images/xisti"
DARK = ROOT / "assets/images/dark"
LIGHT = ROOT / "assets/images/light"
SIZE = 1024
BG = (11, 11, 11)


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


def main() -> None:
    src = Image.open(SRC).convert("RGBA")

    # iOS + legacy Android icon — full logo with small margin so tagline is never clipped
    launcher = Image.new("RGB", (SIZE, SIZE), BG)
    fit_center(launcher, src, scale=0.94, y_offset=-8)
    launcher.save(OUT_DIR / "app_launcher.png", optimize=True)

    # Adaptive icon foreground — ~58% safe zone so Android mask does not cut tagline
    foreground = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    fit_center(foreground, src, scale=0.58, y_offset=0)
    foreground.save(OUT_DIR / "app_launcher_foreground.png", optimize=True)

    # Splash / in-app logo (transparent outside map tile)
    splash = Image.new("RGBA", (1600, 1600), (0, 0, 0, 0))
    fit_center(splash, src, scale=1.35, y_offset=0)
    splash.save(DARK / "splash_logo.png", optimize=True)
    splash.save(LIGHT / "splash_logo.png", optimize=True)

    print("✓ app_launcher.png")
    print("✓ app_launcher_foreground.png")
    print("✓ dark/light splash_logo.png")


if __name__ == "__main__":
    main()
