"""Builds the 1024x500 Google Play feature graphic.

Run after tool/generate_icons.py:  python3 tool/generate_feature_graphic.py
Fonts: Outfit and Instrument Sans (SIL OFL). Set FONT_DIR to their folder.
"""
import os

from PIL import Image, ImageDraw, ImageFilter, ImageFont

FONT_DIR = os.environ.get('FONT_DIR', '/mnt/skills/examples/canvas-design/canvas-fonts')
TEAL_DARK = (21, 78, 99)
TEAL_LIGHT = (62, 150, 177)
AMBER = (242, 169, 59)
INK = (255, 255, 255)
SOFT = (214, 234, 241)

S = 2
W, H = 1024 * S, 500 * S


def f(name, size):
    return ImageFont.truetype(os.path.join(FONT_DIR, name), size * S)


def gradient():
    img = Image.new('RGB', (W, H))
    p = img.load()
    for y in range(H):
        for x in range(W):
            t = (x / W * 0.75 + y / H * 0.25)
            p[x, y] = tuple(int(TEAL_LIGHT[i] * (1 - t) + TEAL_DARK[i] * t) for i in range(3))
    return img.convert('RGBA')


def pill(base, xy, text, font):
    d = ImageDraw.Draw(base)
    w = d.textlength(text, font=font)
    pad_x, h = 20 * S, 44 * S
    x, y = xy
    layer = Image.new('RGBA', base.size, (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    ld.rounded_rectangle([x, y, x + w + 2 * pad_x, y + h], radius=h // 2,
                         fill=(255, 255, 255, 40), outline=(255, 255, 255, 110), width=2)
    base.alpha_composite(layer)
    d.text((x + pad_x, y + h / 2), text, font=font, fill=INK, anchor='lm')
    return x + w + 2 * pad_x + 14 * S


def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    brand = os.path.join(root, 'assets/branding')
    img = gradient()

    # Soft decorative discs.
    deco = Image.new('RGBA', img.size, (0, 0, 0, 0))
    dd = ImageDraw.Draw(deco)
    dd.ellipse([W * 0.56, -H * 0.55, W * 1.25, H * 0.95], fill=(255, 255, 255, 22))
    dd.ellipse([W * 0.70, H * 0.35, W * 1.15, H * 1.3], fill=(255, 255, 255, 16))
    img.alpha_composite(deco)

    # Artwork (icon glyph) on the right, with a privacy lock badge.
    art = Image.open(os.path.join(brand, 'icon_foreground.png')).convert('RGBA')
    size = int(560 * S)
    art = art.resize((size, size), Image.LANCZOS).rotate(-4, resample=Image.BICUBIC)
    img.alpha_composite(art, (int(W - size - 20 * S), int((H - size) / 2 + 8 * S)))

    badge_r = 58 * S
    bx, by = int(W - 190 * S), int(112 * S)
    shadow = Image.new('RGBA', img.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).ellipse([bx - badge_r, by - badge_r + 8 * S, bx + badge_r, by + badge_r + 8 * S],
                                   fill=(5, 30, 40, 110))
    img.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(10 * S)))
    d = ImageDraw.Draw(img)
    d.ellipse([bx - badge_r, by - badge_r, bx + badge_r, by + badge_r], fill=AMBER)
    # Padlock.
    d.rounded_rectangle([bx - 26 * S, by - 2 * S, bx + 26 * S, by + 36 * S], radius=8 * S, fill=TEAL_DARK)
    d.arc([bx - 17 * S, by - 36 * S, bx + 17 * S, by + 10 * S], 180, 360, fill=TEAL_DARK, width=9 * S)
    d.ellipse([bx - 5 * S, by + 10 * S, bx + 5 * S, by + 20 * S], fill=AMBER)

    # Text block.
    left = 64 * S
    d.text((left, 70 * S), 'PacketPal', font=f('Outfit-Bold.ttf', 26), fill=SOFT, anchor='lm')
    head = f('Outfit-Bold.ttf', 64)
    d.text((left, 118 * S), 'Scans that never', font=head, fill=INK, anchor='la')
    d.text((left, 190 * S), 'leave your phone', font=head, fill=INK, anchor='la')
    d.text((left, 290 * S), 'Private PDF scanner for rental,', font=f('InstrumentSans-Regular.ttf', 27),
           fill=SOFT, anchor='la')
    d.text((left, 326 * S), 'loan & visa application packets', font=f('InstrumentSans-Regular.ttf', 27),
           fill=SOFT, anchor='la')

    x = left
    pf = f('InstrumentSans-Bold.ttf', 21)
    for label in ('No watermark', 'No account', 'On-device'):
        x = pill(img, (x, 394 * S), label, pf)

    out = img.resize((1024, 500), Image.LANCZOS).convert('RGB')
    out.save(os.path.join(brand, 'feature_graphic_1024x500.png'))
    print('feature graphic written', out.size)


if __name__ == '__main__':
    main()
