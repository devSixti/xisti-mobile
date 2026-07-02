#!/usr/bin/env python3
"""Recolor legacy yellow/amber illustration pixels to XISTI brand green/purple."""

from __future__ import annotations

import colorsys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1] / "assets" / "images"

# XISTI brand from xisti_ui_tokens.dart / app_theme_colors.dart
BRAND_GREEN = (0x39, 0xFF, 0x14)
BRAND_PURPLE = (0x93, 0x33, 0xEA)

ILLUSTRATION_FILES = [
    "light/avatar.png",
    "dark/avatar.png",
    "light/emergency_contact.png",
    "dark/emergency_contact.png",
    "light/empty_manage_address.png",
    "dark/empty_manage_address.png",
    "light/empty_report_issue.png",
    "dark/empty_report_issue.png",
    "light/empty_ride_history.png",
    "dark/empty_ride_history.png",
    "light/empty_wallet_transaction.png",
    "dark/empty_wallet_transaction.png",
    "light/invite_friend.png",
    "dark/invite_friend.png",
    "light/ob_page1.png",
    "dark/ob_page1.png",
    "light/ob_page2.png",
    "dark/ob_page2.png",
    "light/ob_page3.png",
    "dark/ob_page3.png",
    "light/product_sheet.png",
    "dark/product_sheet.png",
    "light/trip_published.png",
    "dark/trip_published.png",
    "light/verification_pending.png",
    "dark/verification_pending.png",
    "light/warning.png",
    "dark/warning.png",
    "splash_bg.png",
    "img_error_doc.png",
    "finger_print_img.png",
]


def _target_for_pixel(r: int, g: int, b: int, a: int) -> tuple[int, int, int] | None:
    if a < 20:
        return None

    rf, gf, bf = r / 255.0, g / 255.0, b / 255.0
    h, s, v = colorsys.rgb_to_hsv(rf, gf, bf)

    if s < 0.18 or v < 0.12:
        return None

    # Yellow / gold / amber -> brand green, preserve perceived brightness.
    if 0.11 <= h <= 0.20:
        return _tint_with_luminance(BRAND_GREEN, v)

    # Orange accents -> brand purple.
    if 0.04 <= h < 0.11:
        return _tint_with_luminance(BRAND_PURPLE, v)

    # Legacy ZIMO yellow (#FFB600-ish) can sit near hue 0.12 with high saturation.
    if h < 0.04 and s > 0.35 and r > 180 and g > 120:
        return _tint_with_luminance(BRAND_GREEN, v)

    return None


def _tint_with_luminance(rgb: tuple[int, int, int], value: float) -> tuple[int, int, int]:
    tr, tg, tb = rgb
    th, ts, _ = colorsys.rgb_to_hsv(tr / 255.0, tg / 255.0, tb / 255.0)
    nr, ng, nb = colorsys.hsv_to_rgb(th, min(1.0, ts * 0.95 + 0.05), min(1.0, max(0.2, value)))
    return int(nr * 255), int(ng * 255), int(nb * 255)


def recolor_image(path: Path) -> int:
    image = Image.open(path).convert("RGBA")
    pixels = image.load()
    width, height = image.size
    changed = 0

    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            target = _target_for_pixel(r, g, b, a)
            if target is None:
                continue
            pixels[x, y] = (*target, a)
            changed += 1

    image.save(path, optimize=True)
    return changed


def main() -> None:
    total_changed = 0
    for relative in ILLUSTRATION_FILES:
        path = ROOT / relative
        if not path.exists():
            print(f"skip missing: {relative}")
            continue
        changed = recolor_image(path)
        total_changed += changed
        print(f"updated {relative}: {changed} px")

    splash_variants = ROOT / "splash_variants"
    if splash_variants.exists():
        for path in sorted(splash_variants.glob("*.png")):
            changed = recolor_image(path)
            total_changed += changed
            print(f"updated splash_variants/{path.name}: {changed} px")

    print(f"done, total pixels recolored: {total_changed}")


if __name__ == "__main__":
    main()
