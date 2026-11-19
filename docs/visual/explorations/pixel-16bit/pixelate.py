"""Pixel-art mockup of a captured PANOPTICON encounter.

Inputs (same folder): art.png (text hidden), full.png (normal frame), text.json
(every visible text element's rect, size, colour and alignment), and two pixel
fonts. Writes one mockup per variant plus a comparison sheet.
"""
import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

HERE = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
W, H = 1600, 1000
BODY = HERE / "PixelifySans.ttf"
HEAD = HERE / "PressStart2P.ttf"

VARIANTS = {
    # name: (art pixel size, palette colours, text pixel size)
    "8bit": (5, 32, 2),
    "16bit": (4, 64, 2),
}


def pixelate_art(art: Image.Image, cell: int, colours: int) -> Image.Image:
    small = art.convert("RGB").resize((W // cell, H // cell), Image.BOX)
    # Build the palette with the hand, HUD and ICE plaques weighted up, so the
    # big atrium background does not use up every colour.
    sw, sh = small.size
    hand = small.crop((0, int(sh * 0.72), sw, sh))
    plaques = small.crop((int(sw * 0.18), int(sh * 0.38), int(sw * 0.82), int(sh * 0.6)))
    sample = Image.new("RGB", (sw, sh + hand.height * 6 + plaques.height * 2))
    sample.paste(small, (0, 0))
    for i in range(6):
        sample.paste(hand, (0, sh + i * hand.height))
    for i in range(2):
        sample.paste(plaques, (0, sh + 6 * hand.height + i * plaques.height))
    palette = sample.quantize(colors=colours, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    small = small.quantize(palette=palette, dither=Image.Dither.NONE).convert("RGB")
    return small.resize((W, H), Image.NEAREST)


def parse_colour(html: str) -> tuple:
    h = html.lstrip("#")
    r, g, b = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)
    a = int(h[6:8], 16) if len(h) >= 8 else 255
    return (r, g, b, a)


def wrap(text: str, font: ImageFont.FreeTypeFont, width: float) -> list:
    lines = []
    for para in text.split("\n"):
        words, line = para.split(" "), ""
        for word in words:
            trial = (line + " " + word).strip()
            if font.getlength(trial) <= width or not line:
                line = trial
            else:
                lines.append(line)
                line = word
        lines.append(line)
    return lines


SMALL = 13.0  # screen px: smaller text goes on the 1 px grid so it stays readable


def draw_text(layers: dict, row: dict) -> None:
    # Pixel fonts lack a few symbols the game uses; swap in pixel-safe ones.
    text = row["text"].strip().translate(str.maketrans({"▸": ">", "→": ">", "−": "-", "⨯": "x"}))
    if not text:
        return
    size = row["size"]
    grid = 2 if size >= SMALL else 1
    layer = layers[grid]
    x, y, w, h = (row[k] / grid for k in ("x", "y", "w", "h"))
    draw = ImageDraw.Draw(layer)
    draw.fontmode = "1"  # no anti-aliasing: hard pixel edges
    colour = parse_colour(row["color"])
    lines, font, line_h = None, None, 0
    # Big single-line text (titles, big numbers, END TURN): Press Start 2P,
    # no wider than the original text was.
    if size >= 20 and len(text) <= 24 and "\n" not in text:
        target = len(text) * size * 0.62 / grid
        for px in (24, 16, 8):
            f = ImageFont.truetype(str(HEAD), px)
            if f.getlength(text) <= max(target, 8 * len(text)) and f.getlength(text) <= w + 2:
                font, lines, line_h = f, [text], px + 2
                break
    if font is None:
        px = max(9 if grid == 1 else 8, round(size / grid * 1.1))
        while True:
            font = ImageFont.truetype(str(BODY), px)
            lines = wrap(text, font, w) if row["wrap"] else [text]
            line_h = px + (1 if grid == 2 else 2)
            fits = len(lines) * line_h <= h + 2 and all(font.getlength(l) <= w + 1 for l in lines)
            if fits or px <= (9 if grid == 1 else 8):
                break
            px -= 1
    block_h = len(lines) * line_h
    top = y + (h - block_h) / 2 if row["valign"] == 1 else (y + h - block_h if row["valign"] == 2 else y)
    for i, line in enumerate(lines):
        lw = font.getlength(line)
        left = x + (w - lw) / 2 if row["halign"] == 1 else (x + w - lw if row["halign"] == 2 else x)
        draw.text((round(left), round(top + i * line_h)), line, font=font, fill=colour)


def main() -> None:
    art = Image.open(HERE / "art.png")
    full = Image.open(HERE / "full.png").convert("RGB")
    rows = json.loads((HERE / "text.json").read_text())
    outputs = {"current": full}
    for name, (cell, colours, grid) in VARIANTS.items():
        base = pixelate_art(art, cell, colours).convert("RGBA")
        layers = {1: Image.new("RGBA", (W, H), (0, 0, 0, 0)), 2: Image.new("RGBA", (W // 2, H // 2), (0, 0, 0, 0))}
        for row in rows:
            draw_text(layers, row)
        base.alpha_composite(layers[2].resize((W, H), Image.NEAREST))
        base.alpha_composite(layers[1])
        out = base.convert("RGB")
        out.save(HERE / f"PANOPTICON_Encounter_{name}.png")
        outputs[name] = out
    print("wrote", ", ".join(f"PANOPTICON_Encounter_{n}.png" for n in VARIANTS))


if __name__ == "__main__":
    main()
