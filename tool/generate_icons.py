"""Draws the PacketPal icon and writes every Android / iOS / Play size.

Run from the repo root:  python3 tool/generate_icons.py   (needs Pillow)

Design: a "packet" of three stacked sheets (the app's job: gather the right
documents), the front sheet carrying a check mark, with an amber clip on top.
Teal comes from the app theme seed colour.
"""
import json
import os

from PIL import Image, ImageDraw, ImageFilter

TEAL_DARK = (21, 78, 99)
TEAL = (31, 111, 139)
TEAL_LIGHT = (62, 150, 177)
PAPER = (255, 255, 255)
PAPER_BACK = (214, 234, 241)
PAPER_MID = (236, 246, 249)
FOLD = (200, 224, 232)
AMBER = (242, 169, 59)
AMBER_DARK = (196, 123, 18)

SS = 2  # supersampling factor
W = 1024 * SS


def px(v):
    return int(round(v * SS))


def sheet(w, h, radius=36, fold=0, color=PAPER, fold_color=FOLD):
    """A rounded page with an optional folded top-right corner (RGBA)."""
    layer = Image.new('RGBA', (px(w), px(h)), (0, 0, 0, 0))
    mask = Image.new('L', layer.size, 0)
    d = ImageDraw.Draw(mask)
    d.rounded_rectangle([0, 0, px(w) - 1, px(h) - 1], radius=px(radius), fill=255)
    if fold:
        d.polygon([(px(w - fold), 0), (px(w), 0), (px(w), px(fold))], fill=0)
    body = Image.new('RGBA', layer.size, color + (255,))
    layer.paste(body, (0, 0), mask)
    if fold:
        d2 = ImageDraw.Draw(layer)
        d2.polygon(
            [(px(w - fold), 0), (px(w - fold), px(fold)), (px(w), px(fold))],
            fill=fold_color + (255,),
        )
        # round the fold's inner corner slightly by overdrawing nothing: keep crisp
    return layer


def paste_rotated(base, layer, center, angle):
    rot = layer.rotate(angle, resample=Image.BICUBIC, expand=True)
    base.alpha_composite(
        rot, (px(center[0]) - rot.width // 2, px(center[1]) - rot.height // 2)
    )


def shadow_of(layer_img, blur=18, dy=14, opacity=70):
    """Soft drop shadow, padded so the blur is never clipped.

    The result is larger than the input by the same margin on every side, so
    centring it where the layer is centred keeps it aligned.
    """
    pad = px(blur * 4)
    padded = Image.new('RGBA', (layer_img.width + 2 * pad, layer_img.height + 2 * pad), (0, 0, 0, 0))
    padded.alpha_composite(layer_img, (pad, pad))
    alpha = padded.getchannel('A')
    sh = Image.new('RGBA', padded.size, (0, 0, 0, 0))
    sh.paste(Image.new('RGBA', padded.size, (8, 30, 40, opacity)), (0, 0), alpha)
    sh = sh.filter(ImageFilter.GaussianBlur(px(blur)))
    out = Image.new('RGBA', padded.size, (0, 0, 0, 0))
    out.alpha_composite(sh, (0, px(dy)))
    return out, pad


def check(draw, cx, cy, width=54, color=TEAL):
    pts = [(cx - 92, cy + 18), (cx - 28, cy + 84), (cx + 104, cy - 70)]
    p = [(px(x), px(y)) for x, y in pts]
    draw.line(p, fill=color, width=px(width), joint='curve')
    r = px(width / 2)
    for x, y in (p[0], p[2]):
        draw.ellipse([x - r, y - r, x + r, y + r], fill=color)


def glyph(mono=False):
    """The artwork on a transparent 1024 canvas, centred, ~600px wide."""
    canvas = Image.new('RGBA', (W, W), (0, 0, 0, 0))
    cx, cy = 512, 540
    back_c = PAPER if mono else PAPER_BACK
    mid_c = PAPER if mono else PAPER_MID
    back = sheet(360, 470, color=back_c)
    mid = sheet(360, 470, color=mid_c)
    front = sheet(360, 470, fold=96, color=PAPER)
    if mono:
        # Alpha steps keep the stack readable as a single-colour themed icon.
        for layer, a in ((back, 110), (mid, 180)):
            r, g, b, al = layer.split()
            layer.putalpha(al.point(lambda v, a=a: v * a // 255))

    layers = [
        (back, (cx - 62, cy + 6), 10),
        (mid, (cx + 40, cy + 2), -6),
        (front, (cx, cy + 4), 0),
    ]
    for layer, centre, ang in layers:
        if not mono:
            shadow, _ = shadow_of(layer)
            paste_rotated(canvas, shadow, centre, ang)
        paste_rotated(canvas, layer, centre, ang)

    d = ImageDraw.Draw(canvas)
    if mono:
        # Cut the check out of the front sheet.
        cut = Image.new('L', canvas.size, 255)
        cd = ImageDraw.Draw(cut)
        check(cd, cx, cy + 40, color=0)
        canvas.putalpha(Image.composite(canvas.getchannel('A'), Image.new('L', canvas.size, 0), cut))
    else:
        check(d, cx, cy + 40)

    # Clip across the top of the stack.
    clip = Image.new('RGBA', (px(168), px(84)), (0, 0, 0, 0))
    cd = ImageDraw.Draw(clip)
    cd.rounded_rectangle([0, 0, px(168) - 1, px(84) - 1], radius=px(30),
                         fill=(PAPER if mono else AMBER) + (255,))
    cd.rounded_rectangle([px(44), px(30), px(124), px(54)], radius=px(12),
                         fill=(0, 0, 0, 0) if mono else AMBER_DARK + (255,))
    if not mono:
        shadow, pad = shadow_of(clip, blur=8, dy=8, opacity=60)
        canvas.alpha_composite(shadow, (px(cx) - px(84) - pad, px(cy - 262) - pad))
    canvas.alpha_composite(clip, (px(cx) - px(84), px(cy - 262)))
    return canvas


def background(size=W):
    """Vertical-diagonal teal gradient."""
    img = Image.new('RGB', (size, size))
    px_ = img.load()
    for y in range(size):
        for x in range(size):
            t = (x + y) / (2 * size)
            px_[x, y] = tuple(
                int(TEAL_LIGHT[i] * (1 - t) + TEAL_DARK[i] * t) for i in range(3)
            )
    return img


def scaled(img, factor):
    """Scale artwork about the canvas centre."""
    n = int(img.width * factor)
    s = img.resize((n, n), Image.LANCZOS)
    out = Image.new('RGBA', img.size, (0, 0, 0, 0))
    out.alpha_composite(s, ((img.width - n) // 2, (img.height - n) // 2))
    return out


def down(img, size):
    return img.resize((size, size), Image.LANCZOS)


def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    res = os.path.join(root, 'android/app/src/main/res')
    ios = os.path.join(root, 'ios/Runner/Assets.xcassets/AppIcon.appiconset')
    brand = os.path.join(root, 'assets/branding')

    art = glyph()
    mono = glyph(mono=True)
    bg = background(W).convert('RGBA')

    # Square icon (iOS, Play): artwork a bit larger than in the adaptive layer.
    square = bg.copy()
    square.alpha_composite(scaled(art, 1.14))
    master = down(square, 1024).convert('RGB')  # no alpha: App Store rule
    master.save(os.path.join(brand, 'icon_1024.png'))
    down(square, 512).convert('RGB').save(os.path.join(brand, 'play_store_icon_512.png'))
    down(art, 1024).save(os.path.join(brand, 'icon_foreground.png'))
    down(bg, 1024).convert('RGB').save(os.path.join(brand, 'icon_background.png'))

    # iOS
    with open(os.path.join(ios, 'Contents.json')) as f:
        contents = json.load(f)
    for item in contents['images']:
        base = float(item['size'].split('x')[0])
        scale = int(item['scale'].rstrip('x'))
        n = int(round(base * scale))
        master.resize((n, n), Image.LANCZOS).save(os.path.join(ios, item['filename']))

    # Android adaptive layers (108dp canvas) and legacy launcher icons.
    density = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
    for name, d in density.items():
        folder = os.path.join(res, f'mipmap-{name}')
        os.makedirs(folder, exist_ok=True)
        s = int(108 * d)
        down(art, s).save(os.path.join(folder, 'ic_launcher_foreground.png'))
        down(mono, s).save(os.path.join(folder, 'ic_launcher_monochrome.png'))
        down(bg, s).convert('RGB').save(os.path.join(folder, 'ic_launcher_background.png'))
        legacy = int(48 * d)
        rounded = down(square, legacy * 4)
        m = Image.new('L', rounded.size, 0)
        ImageDraw.Draw(m).rounded_rectangle(
            [0, 0, rounded.width - 1, rounded.height - 1],
            radius=int(rounded.width * 0.22), fill=255)
        rounded.putalpha(m)
        rounded.resize((legacy, legacy), Image.LANCZOS).save(
            os.path.join(folder, 'ic_launcher.png'))

    anydpi = os.path.join(res, 'mipmap-anydpi-v26')
    os.makedirs(anydpi, exist_ok=True)
    with open(os.path.join(anydpi, 'ic_launcher.xml'), 'w') as f:
        f.write('''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
    <monochrome android:drawable="@mipmap/ic_launcher_monochrome" />
</adaptive-icon>
''')
    print('icons written')


if __name__ == '__main__':
    main()
