#!/usr/bin/env python3
"""Generate XISTI App Store marketing screenshots (1242×2688 px).

Composites raw emulator captures into Zimo-style promotional frames with
XISTI brand colors (#39FF14 neon green, #9333EA purple, #0B0B0B black).
"""
from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

W, H = 1242, 2688
GREEN = (57, 255, 20)
PURPLE = (147, 51, 234)
BLACK = (11, 11, 11)
WHITE = (255, 255, 255)

ROOT = Path(__file__).resolve().parent.parent
ASSETS = Path(
    "/home/jeronimorestrepoangel/.cursor/projects/"
    "home-jeronimorestrepoangel-Documentos-PDP-Xisti/assets"
)
AI_BG_GREEN = ROOT / "store-assets/backgrounds/xisti-bg-green.png"
AI_BG_PURPLE = ROOT / "store-assets/backgrounds/xisti-bg-purple.png"
OUT = ROOT / "store-assets/screenshots/marketing/1242x2688/es"

# Phone mockup — sized like Zimo reference (~68% canvas height, centered)
PHONE_FRAME_W = 800
PHONE_FRAME_H = 1840
PHONE_SCREEN_W = 728
PHONE_SCREEN_H = 1760
PHONE_RADIUS = 56
PHONE_SCREEN_RADIUS = 44
PHONE_SHADOW_PAD = 60

FONT_BOLD = "/usr/share/fonts/julietaula-montserrat-fonts/Montserrat-Black.otf"
FONT_SEMI = "/usr/share/fonts/julietaula-montserrat-fonts/Montserrat-SemiBold.otf"
FONT_REG = "/usr/share/fonts/julietaula-montserrat-fonts/Montserrat-Regular.otf"

SHOTS = [
    {
        "file": "Captura_desde_2026-06-11_13-43-24-3566f721-a5fe-4da2-9bd4-8e72bee59f6e.png",
        "out": "01-bienvenida.png",
        "headline": "Bienvenid@ a XISTI",
        "sub": "Movilidad fácil y segura en Medellín",
        "accent": "green",
    },
    {
        "file": "Captura_desde_2026-06-11_13-46-39-49683d63-02d1-4dfc-93c3-e38ccecdc088.png",
        "out": "02-elige-como-moverte.png",
        "headline": "Elige cómo moverte",
        "sub": "Moto, carro y envíos en la misma app",
        "accent": "purple",
    },
    {
        "file": "Captura_desde_2026-06-11_13-51-48-8749bec1-8bb7-41b2-883b-3fd71432219e.png",
        "out": "03-tu-precio.png",
        "headline": "Tú pones el precio",
        "sub": "Negocia en pasos de $500 COP",
        "accent": "green",
    },
    {
        "file": "Captura_desde_2026-06-11_13-51-34-5ad36830-0d40-4391-9c9d-46433a6e40d8.png",
        "out": "04-nueva-solicitud.png",
        "headline": "Nueva solicitud al instante",
        "sub": "Conéctate y recibe viajes cerca de ti",
        "accent": "purple",
    },
    {
        "file": "Captura_desde_2026-06-11_13-52-01-8b76812d-9dcc-41cb-a98a-e4833e2725fd.png",
        "out": "05-tu-decides.png",
        "headline": "Tú decides cuánto cobrar",
        "sub": "Revisa ruta, tarifa y método de pago",
        "accent": "green",
    },
    {
        "file": "Captura_desde_2026-06-11_13-53-02-378d2746-1b01-453a-a1c5-e51fac1602be.png",
        "out": "06-sigue-en-vivo.png",
        "headline": "Sigue cada metro en vivo",
        "sub": "Conductor, ETA y código de seguridad",
        "accent": "purple",
    },
]


def curve_y(x: float) -> float:
    """Zimo-style curved divider between top and bottom sections."""
    mid = W / 2
    dip = 110 * math.sin(math.pi * x / W)
    base = 780 + 40 * math.sin(2 * math.pi * x / W)
    return base + dip


def lerp(a: int, b: int, t: float) -> int:
    return int(a + (b - a) * t)


def load_ai_background(accent: str) -> Image.Image | None:
    path = AI_BG_GREEN if accent == "green" else AI_BG_PURPLE
    if not path.exists():
        return None
    bg = Image.open(path).convert("RGB")
    scale = max(W / bg.width, H / bg.height)
    new_w, new_h = int(bg.width * scale), int(bg.height * scale)
    bg = bg.resize((new_w, new_h), Image.Resampling.LANCZOS)
    left, top = (new_w - W) // 2, (new_h - H) // 2
    return bg.crop((left, top, left + W, top + H))


def build_background(accent: str) -> Image.Image:
    ai = load_ai_background(accent)
    if ai is not None:
        # Darken top for headline legibility while keeping AI texture below
        overlay = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        draw = ImageDraw.Draw(overlay)
        for y in range(H):
            alpha = int(min(180, max(0, (620 - y) * 0.45)))
            if alpha > 0:
                draw.line((0, y, W, y), fill=(0, 0, 0, alpha))
        return Image.alpha_composite(ai.convert("RGBA"), overlay).convert("RGB")

    img = Image.new("RGB", (W, H), BLACK)
    px = img.load()
    accent_rgb = GREEN if accent == "green" else PURPLE
    other_rgb = PURPLE if accent == "green" else GREEN

    for y in range(H):
        for x in range(W):
            cy = curve_y(x)
            if y < cy:
                # Top: deep black with subtle purple/green tint near curve
                t = max(0.0, (cy - y) / 400)
                r = lerp(accent_rgb[0] // 8, BLACK[0], min(1.0, t))
                g = lerp(accent_rgb[1] // 10, BLACK[1], min(1.0, t))
                b = lerp(accent_rgb[2] // 6, BLACK[2], min(1.0, t))
                px[x, y] = (r, g, b)
            else:
                # Bottom: green → purple vertical gradient
                t = (y - cy) / (H - cy)
                r = lerp(accent_rgb[0], other_rgb[0], t * 0.65)
                g = lerp(accent_rgb[1], other_rgb[1], t * 0.55)
                b = lerp(accent_rgb[2], other_rgb[2], t * 0.45)
                px[x, y] = (r, g, b)

    overlay = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    # Neon glow orbs
    for cx, cy, rad, color, alpha in [
        (180, 520, 280, GREEN, 35),
        (1060, 600, 220, PURPLE, 40),
        (620, 2100, 360, GREEN, 25),
        (300, 2300, 200, PURPLE, 30),
    ]:
        for r in range(rad, 0, -8):
            a = int(alpha * (1 - r / rad))
            draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=(*color, a))

    # Subtle diagonal light streaks (urban night vibe)
    for i in range(6):
        x0 = -200 + i * 260
        draw.line((x0, H, x0 + 500, H - 900), fill=(*GREEN, 18), width=3)

    img = Image.alpha_composite(img.convert("RGBA"), overlay).convert("RGB")
    return img


def wrap_text(text: str, font: ImageFont.FreeTypeFont, max_width: int) -> list[str]:
    words = text.split()
    lines: list[str] = []
    current = ""
    for word in words:
        trial = f"{current} {word}".strip()
        if font.getlength(trial) <= max_width:
            current = trial
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines


def draw_headline(base: Image.Image, headline: str, sub: str) -> None:
    draw = ImageDraw.Draw(base)
    bold = ImageFont.truetype(FONT_BOLD, 64)
    reg = ImageFont.truetype(FONT_REG, 30)

    lines = wrap_text(headline, bold, W - 100)
    y = 72
    for line in lines:
        tw = bold.getlength(line)
        x = (W - tw) / 2
        draw.text((x, y + 2), line, font=bold, fill=(0, 0, 0))
        draw.text((x, y), line, font=bold, fill=WHITE)
        y += 74

    y += 4
    sub_lines = wrap_text(sub, reg, W - 120)
    for line in sub_lines:
        tw = reg.getlength(line)
        x = (W - tw) / 2
        draw.text((x, y), line, font=reg, fill=(220, 220, 220))
        y += 38

    draw.rounded_rectangle((W // 2 - 50, y + 10, W // 2 + 50, y + 16), radius=3, fill=GREEN)


def phone_frame(screenshot: Image.Image) -> Image.Image:
    """Place screenshot inside a large centered phone mockup (Zimo-style)."""
    frame_w, frame_h = PHONE_FRAME_W, PHONE_FRAME_H
    screen_w, screen_h = PHONE_SCREEN_W, PHONE_SCREEN_H
    radius = PHONE_RADIUS
    screen_radius = PHONE_SCREEN_RADIUS
    pad = PHONE_SHADOW_PAD

    frame = Image.new("RGBA", (frame_w, frame_h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(frame)

    shadow = Image.new("RGBA", (frame_w + pad * 2, frame_h + pad * 2), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle(
        (pad, pad + 24, frame_w + pad - 8, frame_h + pad + 16),
        radius=radius + 10,
        fill=(0, 0, 0, 140),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(22))

    # Slim dark bezel (similar to Zimo navy frame)
    draw.rounded_rectangle((0, 0, frame_w - 1, frame_h - 1), radius=radius, fill=(12, 14, 28, 255))
    draw.rounded_rectangle((6, 6, frame_w - 7, frame_h - 7), radius=radius - 3, fill=(22, 24, 38, 255))

    # Scale screenshot to screen area
    shot = screenshot.convert("RGBA")
    shot_ratio = shot.width / shot.height
    target_ratio = screen_w / screen_h
    if shot_ratio > target_ratio:
        new_h = screen_h
        new_w = int(new_h * shot_ratio)
    else:
        new_w = screen_w
        new_h = int(new_w / shot_ratio)
    shot = shot.resize((new_w, new_h), Image.Resampling.LANCZOS)
    left = (new_w - screen_w) // 2
    top = (new_h - screen_h) // 2
    shot = shot.crop((left, top, left + screen_w, top + screen_h))

    # Rounded screen mask
    mask = Image.new("L", (screen_w, screen_h), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, screen_w, screen_h), radius=screen_radius, fill=255)
    screen = Image.new("RGBA", (screen_w, screen_h), (0, 0, 0, 0))
    screen.paste(shot, (0, 0), mask)

    inset_x = (frame_w - screen_w) // 2
    inset_y = (frame_h - screen_h) // 2 + 6
    frame.paste(screen, (inset_x, inset_y), screen)

    di_w, di_h = 130, 36
    di_x = (frame_w - di_w) // 2
    draw.rounded_rectangle((di_x, inset_y + 4, di_x + di_w, inset_y + di_h), radius=18, fill=(0, 0, 0, 255))

    composed = Image.new("RGBA", (frame_w + pad * 2, frame_h + pad * 2), (0, 0, 0, 0))
    composed.alpha_composite(shadow, (0, 0))
    composed.alpha_composite(frame, (pad, pad))
    return composed


def compose(shot_path: Path, headline: str, sub: str, accent: str) -> Image.Image:
    bg = build_background(accent)
    draw_headline(bg, headline, sub)

    screenshot = Image.open(shot_path)
    phone = phone_frame(screenshot)

    canvas = bg.convert("RGBA")
    px = (W - phone.width) // 2
    # Centered vertically like Zimo — phone overlaps top/bottom color sections
    py = (H - phone.height) // 2 + 55
    canvas.alpha_composite(phone, (px, py))

    # Watermark
    draw = ImageDraw.Draw(canvas)
    font = ImageFont.truetype(FONT_SEMI, 28)
    label = "xisti"
    lw = font.getlength(label)
    draw.text((W - lw - 48, H - 52), label, font=font, fill=(*GREEN, 180))

    return canvas.convert("RGB")


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for spec in SHOTS:
        src = ASSETS / spec["file"]
        if not src.exists():
            raise FileNotFoundError(src)
        img = compose(src, spec["headline"], spec["sub"], spec["accent"])
        dest = OUT / spec["out"]
        img.save(dest, "PNG", optimize=True)
        print(f"✓ {dest.name}  ({img.size[0]}×{img.size[1]})")


if __name__ == "__main__":
    main()
