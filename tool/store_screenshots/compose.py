"""Turns raw app renders into Play Store screenshots.

usage: python3 compose.py RAW_DIR OUT_DIR
Phone: 1080x1920. Tablet: 1600x2560 (10") and 1200x1920 (7"), both 5:8.
"""
import os
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

RAW, OUT = sys.argv[1], sys.argv[2]
FONTS = os.environ.get('FONT_DIR', '/mnt/skills/examples/canvas-design/canvas-fonts')
TEAL_DARK = (21, 78, 99)
TEAL_LIGHT = (62, 150, 177)
SOFT = (214, 234, 241)
WHITE = (255, 255, 255)
BEZEL = (14, 22, 27)

SHOTS = [
    ('library_grid', 'Scans that never\nleave your phone', 'No account. Organised in folders.', False),
    ('crop', 'Crop every page\nyourself', 'Drag the corners for a perfect fit.', False),
    ('search', 'Search inside\nyour scans', 'Find any word in any document.', False),
    ('filters', 'Clean, readable\npages', 'Enhanced, grayscale or black & white.', False),
    ('export', 'Share a searchable\nPDF', 'One file, or one picture per page.', False),
    ('detail', 'Your originals\nare always kept', 'Edit, reorder or add pages anytime.', False),
    ('settings', 'Private by design', 'Text recognition runs on your phone.', False),
    ('library_list_dark', 'Light and dark\nthemes', 'Easy on the eyes, day or night.', True),
]
# settings has a one-line headline: handled by the generic path.


def font(name, size):
    return ImageFont.truetype(os.path.join(FONTS, name), size)


def gradient(w, h):
    """Smooth diagonal gradient: computed small, then scaled up (fast)."""
    sw, sh = max(2, w // 16), max(2, h // 16)
    img = Image.new('RGB', (sw, sh))
    p = img.load()
    for y in range(sh):
        for x in range(sw):
            t = x / sw * 0.55 + y / sh * 0.45
            p[x, y] = tuple(int(TEAL_LIGHT[i] * (1 - t) + TEAL_DARK[i] * t) for i in range(3))
    return img.resize((w, h), Image.BICUBIC).convert('RGBA')


def status_bar(screen, ink, strip):
    """Draws a simple Android status bar into the blank top strip."""
    d = ImageDraw.Draw(screen)
    w = screen.width
    cy = strip // 2
    s = strip / 28.0  # px per dp
    d.text((int(18 * s), cy), '9:41', font=font('InstrumentSans-Bold.ttf', int(13 * s)), fill=ink, anchor='lm')
    # battery
    bx = w - int(22 * s)
    d.rounded_rectangle([bx - int(22 * s), cy - int(6 * s), bx, cy + int(6 * s)], radius=int(2.5 * s),
                        outline=ink, width=max(2, int(1.4 * s)))
    d.rounded_rectangle([bx - int(20 * s), cy - int(4 * s), bx - int(7 * s), cy + int(4 * s)], radius=int(1.5 * s), fill=ink)
    # wifi (three arcs)
    wx = bx - int(40 * s)
    for r in (13, 9, 5):
        rr = int(r * s)
        d.arc([wx - rr, cy - rr + int(6 * s), wx + rr, cy + rr + int(6 * s)], 225, 315, fill=ink, width=max(2, int(1.6 * s)))
    # signal bars
    sx = wx - int(26 * s)
    for i in range(4):
        hgt = int((4 + i * 3) * s)
        d.rectangle([sx + int(i * 5 * s), cy + int(6 * s) - hgt, sx + int(i * 5 * s + 3 * s), cy + int(6 * s)], fill=ink)


def device(raw, dark, bezel, radius, target_w, strip):
    """Screen image inside a rounded device body (RGBA, 2x supersampled)."""
    ss = 2
    w = target_w * ss
    scale = w / raw.width
    screen = raw.resize((w, int(raw.height * scale)), Image.LANCZOS).convert('RGBA')
    status_bar(screen, WHITE if dark else (28, 32, 36), int(strip * scale))
    r = radius * ss
    inner = Image.new('L', screen.size, 0)
    ImageDraw.Draw(inner).rounded_rectangle([0, 0, screen.width - 1, screen.height * 2], radius=r, fill=255)
    b = bezel * ss
    body = Image.new('RGBA', (screen.width + 2 * b, screen.height + 2 * b), (0, 0, 0, 0))
    ImageDraw.Draw(body).rounded_rectangle([0, 0, body.width - 1, body.height * 2], radius=r + b, fill=BEZEL + (255,))
    body.paste(screen, (b, b), inner)
    return body


def compose(shot, headline, sub, dark, w, h, kind):
    raw = Image.open(os.path.join(RAW, f'{kind}_{shot}.png')).convert('RGB')
    ss = 2
    canvas = gradient(w * ss, h * ss)
    d = ImageDraw.Draw(canvas)

    if kind == 'phone':
        title_px, sub_px, top, dev_w, bezel, radius, strip, dev_top = 84, 38, 110, 880, 16, 56, 84, 470
    else:
        title_px, sub_px, top, dev_w, bezel, radius, strip, dev_top = 104, 48, 130, 1240, 26, 56, 56, 600
    cx = w // 2
    f_title = font('Outfit-Bold.ttf', title_px * ss)
    f_sub = font('InstrumentSans-Regular.ttf', sub_px * ss)
    d.multiline_text((cx * ss, top * ss), headline, font=f_title, fill=WHITE, anchor='ma',
                     align='center', spacing=int(title_px * 0.12 * ss))
    lines = headline.count('\n') + 1
    sub_y = top + lines * int(title_px * 1.12) + 26
    d.text((cx * ss, sub_y * ss), sub, font=f_sub, fill=SOFT, anchor='ma')

    body = device(raw, dark, bezel, radius, dev_w, strip)
    x = cx * ss - body.width // 2
    y = dev_top * ss
    # drop shadow
    sh = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(sh).rounded_rectangle([x, y + 30 * ss, x + body.width, y + body.height], radius=70 * ss, fill=(4, 28, 38, 150))
    canvas.alpha_composite(sh.filter(ImageFilter.GaussianBlur(26 * ss)))
    canvas.alpha_composite(body, (x, y))
    return canvas.resize((w, h), Image.LANCZOS).convert('RGB')


def main():
    for kind, sizes in (('phone', {'phone': (1080, 1920)}),
                        ('tablet', {'tablet_10in': (1600, 2560), 'tablet_7in': (1200, 1920)})):
        for folder, (w, h) in sizes.items():
            os.makedirs(os.path.join(OUT, folder), exist_ok=True)
            for i, (shot, headline, sub, dark) in enumerate(SHOTS, 1):
                if folder == 'tablet_7in':
                    img = Image.open(os.path.join(OUT, 'tablet_10in', f'{i:02d}_{shot}.png')).resize((w, h), Image.LANCZOS)
                else:
                    img = compose(shot, headline, sub, dark, w, h, kind)
                img.save(os.path.join(OUT, folder, f'{i:02d}_{shot}.png'), optimize=True)
    print('composed', OUT)


if __name__ == '__main__':
    main()
