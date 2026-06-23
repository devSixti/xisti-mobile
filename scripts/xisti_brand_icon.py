"""Shared helpers to crop and scale the XISTI wordmark for circular icons."""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
LOGO_FULL = ROOT / "assets/images/xisti/logo_full.png"


def is_brand_green(r: int, g: int, b: int, a: int) -> bool:
    return a > 48 and g > 110 and g > r + 20


def is_tagline_white(r: int, g: int, b: int, a: int) -> bool:
    return a > 48 and r > 200 and g > 200 and b > 200


def brand_content_bbox(im: Image.Image, *, include_tagline: bool = True) -> tuple[int, int, int, int]:
    px = im.load()
    w, h = im.size
    min_x, min_y, max_x, max_y = w, h, 0, 0
    found = False
    tagline_max_y = 0

    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if is_brand_green(r, g, b, a):
                found = True
                min_x = min(min_x, x)
                min_y = min(min_y, y)
                max_x = max(max_x, x)
                max_y = max(max_y, y)
            elif include_tagline and is_tagline_white(r, g, b, a):
                tagline_max_y = max(tagline_max_y, y)

    if not found:
        return 0, 0, w - 1, h - 1

    if include_tagline and tagline_max_y > max_y:
        max_y = tagline_max_y

    pad = 8
    return (
        max(0, min_x - pad),
        max(0, min_y - pad),
        min(w - 1, max_x + pad),
        min(h - 1, max_y + pad),
    )


def load_brand_crop(*, include_tagline: bool = True) -> Image.Image:
    src = Image.open(LOGO_FULL).convert("RGBA")
    left, top, right, bottom = brand_content_bbox(src, include_tagline=include_tagline)
    return src.crop((left, top, right + 1, bottom + 1))


def fit_crop_in_square(
    crop: Image.Image,
    size: int,
    *,
    fill: float = 0.94,
    background: tuple[int, int, int] | tuple[int, int, int, int] | None = None,
) -> Image.Image:
    """Scale crop to fill a square canvas (circle mask uses ~94% of radius)."""
    max_side = max(1, int(size * fill))
    scale = min(max_side / crop.width, max_side / crop.height)
    w = max(1, int(crop.width * scale))
    h = max(1, int(crop.height * scale))
    resized = crop.resize((w, h), Image.Resampling.LANCZOS)

    if background is None:
        canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        canvas.paste(resized, ((size - w) // 2, (size - h) // 2), resized)
        return canvas

    if len(background) == 3:
        canvas = Image.new("RGB", (size, size), background)
        canvas.paste(resized.convert("RGB"), ((size - w) // 2, (size - h) // 2))
    else:
        canvas = Image.new("RGBA", (size, size), background)
        canvas.paste(resized, ((size - w) // 2, (size - h) // 2), resized)
    return canvas


def brand_white_silhouette(crop: Image.Image) -> Image.Image:
    mark = Image.new("RGBA", crop.size, (0, 0, 0, 0))
    spx = crop.load()
    mpx = mark.load()
    for y in range(crop.height):
        for x in range(crop.width):
            r, g, b, a = spx[x, y]
            if is_brand_green(r, g, b, a):
                mpx[x, y] = (255, 255, 255, 255)
    return mark
