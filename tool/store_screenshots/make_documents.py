"""Draws sample documents and a desk photo used only for store screenshots.

usage: python3 make_documents.py OUT_DIR
Everything is fictional (no real people, numbers or companies).
"""
import json
import math
import os
import random
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

OUT = sys.argv[1]
os.makedirs(OUT, exist_ok=True)
random.seed(7)

FD = '/usr/share/fonts/truetype/'
def font(size, bold=False):
    for p in ([FD + 'dejavu/DejaVuSans-Bold.ttf'] if bold else []) + [
            FD + 'liberation/LiberationSans-Regular.ttf', FD + 'dejavu/DejaVuSans.ttf']:
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()

W, H = 850, 1100
INK = (38, 42, 48)
GREY = (150, 156, 164)


def paper():
    img = Image.new('RGB', (W, H), (252, 251, 248))
    px = img.load()
    for y in range(H):
        for x in range(W):
            n = random.randint(-3, 3)
            px[x, y] = tuple(max(0, min(255, c + n)) for c in px[x, y])
    return img


WORDS = ('the tenant shall pay rent monthly on the first day of each calendar month and agrees to keep '
         'the premises clean safe and in good condition notice must be given in writing at least thirty days '
         'before the end of the term payment balance account statement employer income period amount due '
         'service address total charges received thank you for your business please retain this document').split()


def bars(d, x, y, widths, gap=26, h=9, color=None):
    """Draws believable body text. `widths` gives each line's length in px
    (0 = blank line)."""
    f = font(17)
    for w in widths:
        if w:
            line = ''
            while d.textlength(line + ' x', font=f) < w:
                line += (random.choice(WORDS) + ' ')
            d.text((x, y - 6), line.strip(), font=f, fill=(70, 74, 82))
        y += gap
    return y


def para(d, x, y, lines, f, fill=INK, gap=30):
    for line in lines:
        d.text((x, y), line, font=f, fill=fill)
        y += gap
    return y


def header(d, title, sub, accent):
    d.rectangle([0, 0, W, 150], fill=accent)
    d.text((56, 52), title, font=font(34, True), fill=(255, 255, 255))
    d.text((56, 100), sub, font=font(19), fill=(235, 242, 245))


def table(d, y, rows, accent):
    d.rectangle([56, y, W - 56, y + 38], fill=(*accent,))
    for i, h in enumerate(['Date', 'Description', 'Amount']):
        d.text([70, 330, 690][i], y + 8, h, font=font(18, True), fill=(255, 255, 255)) if False else \
            d.text(([70, 200, 680][i], y + 8), h, font=font(18, True), fill=(255, 255, 255))
    y += 48
    for r in rows:
        d.text((70, y), r[0], font=font(18), fill=INK)
        d.text((200, y), r[1], font=font(18), fill=INK)
        d.text((680, y), r[2], font=font(18), fill=INK)
        d.line([56, y + 30, W - 56, y + 30], fill=(228, 230, 233), width=1)
        y += 40
    return y


def bank():
    img = paper(); d = ImageDraw.Draw(img); a = (31, 111, 139)
    header(d, 'FIRST NATIONAL BANK', 'Statement period: March 1 - March 31, 2026', a)
    y = para(d, 56, 190, ['Account holder: Alex Morgan', '14 Oak Avenue, Springfield',
                          'Account ending in 4821'], font(20), gap=32)
    d.text((56, y + 20), 'Account summary', font=font(24, True), fill=a)
    y = table(d, y + 70, [('03/02', 'Payroll deposit', '+2,640.00'), ('03/05', 'Rent payment', '-1,250.00'),
                          ('03/09', 'Grocery market', '-86.42'), ('03/14', 'Electric service', '-74.10'),
                          ('03/21', 'Transfer to savings', '-300.00'), ('03/28', 'Payroll deposit', '+2,640.00')], a)
    d.text((56, y + 30), 'Ending balance', font=font(22, True), fill=INK)
    d.text((640, y + 30), '$5,873.46', font=font(22, True), fill=a)
    bars(d, 56, y + 100, [700, 640, 690, 420])
    return img


def lease():
    img = paper(); d = ImageDraw.Draw(img); a = (88, 70, 120)
    d.text((W // 2, 80), 'RESIDENTIAL LEASE AGREEMENT', font=font(30, True), fill=INK, anchor='mm')
    d.line([56, 120, W - 56, 120], fill=a, width=3)
    y = para(d, 56, 150, [
        'This lease is made on March 1, 2026 between the Landlord,',
        'Maple Property Group, and the Tenant, Alex Morgan, for the',
        'premises at 42 Maple Street, Springfield.'], font(20), gap=32)
    for t in ['1. Term', '2. Rent', '3. Security deposit', '4. Utilities']:
        d.text((56, y + 22), t, font=font(22, True), fill=a)
        y = bars(d, 56, y + 62, [738, 720, 690, 380], gap=24)
    d.text((56, y + 40), 'Tenant signature', font=font(18), fill=GREY)
    d.line([56, y + 120, 330, y + 120], fill=INK, width=2)
    d.text((70, y + 70), 'Alex Morgan', font=font(34), fill=(30, 60, 120))
    return img


def paystub():
    img = paper(); d = ImageDraw.Draw(img); a = (33, 120, 80)
    header(d, 'EARNINGS STATEMENT', 'Pay period: Feb 1 - Feb 28, 2026', a)
    y = para(d, 56, 190, ['Employee: Alex Morgan', 'Employer: Brightline Studio LLC', 'Pay date: Feb 28, 2026'],
             font(20), gap=32)
    y = table(d, y + 30, [('Hours', 'Regular pay', '2,880.00'), ('', 'Overtime', '210.00'),
                          ('', 'Federal tax', '-402.50'), ('', 'Health plan', '-96.00')], a)
    d.text((56, y + 36), 'Net pay', font=font(26, True), fill=INK)
    d.text((620, y + 36), '$2,591.50', font=font(26, True), fill=a)
    bars(d, 56, y + 110, [700, 560, 640])
    return img


def passport():
    img = paper(); d = ImageDraw.Draw(img); a = (24, 52, 98)
    d.rectangle([40, 60, W - 40, 700], outline=a, width=4)
    d.text((70, 84), 'PASSPORT', font=font(30, True), fill=a)
    d.rectangle([70, 150, 330, 470], fill=(206, 214, 226))
    d.ellipse([140, 190, 260, 310], fill=(170, 182, 200)); d.rectangle([110, 330, 290, 470], fill=(170, 182, 200))
    f = font(19)
    rows = [('Surname', 'MORGAN'), ('Given names', 'ALEX JORDAN'), ('Nationality', 'UTOPIAN'),
            ('Date of birth', '14 MAR 1992'), ('Place of birth', 'SPRINGFIELD'), ('Expiry', '12 JUN 2033')]
    y = 150
    for k, v in rows:
        d.text((370, y), k, font=font(14), fill=GREY); d.text((370, y + 18), v, font=f, fill=INK); y += 52
    d.text((70, 560), 'P<UTOMORGAN<<ALEX<JORDAN<<<<<<<<<<<<<<<<<<', font=font(22), fill=INK)
    d.text((70, 600), 'X1234567<8UTO9203146M3306127<<<<<<<<<<<<<<04', font=font(22), fill=INK)
    return img


def bill():
    img = paper(); d = ImageDraw.Draw(img); a = (200, 120, 20)
    header(d, 'ELECTRIC SERVICE BILL', 'Billing month: March 2026', a)
    y = para(d, 56, 190, ['Service address: 42 Maple Street, Springfield', 'Account: 0048-2291', 'Usage: 412 kWh'],
             font(20), gap=32)
    d.rounded_rectangle([56, y + 24, W - 56, y + 200], radius=14, outline=a, width=3)
    d.text((84, y + 52), 'Amount due', font=font(22), fill=GREY)
    d.text((84, y + 92), '$74.10', font=font(58, True), fill=a)
    d.text((520, y + 60), 'Due Apr 14, 2026', font=font(22, True), fill=INK)
    bars(d, 56, y + 250, [700, 650, 690, 500])
    return img


def offer():
    img = paper(); d = ImageDraw.Draw(img); a = (190, 60, 80)
    d.text((56, 70), 'Brightline Studio', font=font(32, True), fill=a)
    d.line([56, 120, W - 56, 120], fill=a, width=3)
    y = para(d, 56, 160, ['March 3, 2026', '', 'Alex Morgan', '14 Oak Avenue, Springfield', '',
                          'Dear Alex,', '',
                          'We are pleased to offer you the position of Designer'], font(20), gap=30)
    bars(d, 56, y + 8, [738, 700, 720, 400, 0], gap=24)
    d.text((70, 880), 'Sam Rivera', font=font(34), fill=(30, 60, 120))
    d.text((56, 940), 'Head of People', font=font(18), fill=GREY)
    return img


def license_doc():
    img = paper(); d = ImageDraw.Draw(img); a = (30, 90, 150)
    d.rounded_rectangle([60, 120, W - 60, 620], radius=26, fill=(232, 240, 250), outline=a, width=4)
    d.rectangle([60, 120, W - 60, 190], fill=a)
    d.text((90, 140), "DRIVER'S LICENSE", font=font(30, True), fill=(255, 255, 255))
    d.rectangle([90, 230, 300, 480], fill=(206, 214, 226))
    d.ellipse([145, 260, 245, 360], fill=(170, 182, 200)); d.rectangle([120, 380, 270, 480], fill=(170, 182, 200))
    y = 235
    for k, v in [('Name', 'MORGAN, ALEX'), ('License no.', 'D123 4567 8901'), ('Expires', '06/12/2031'),
                 ('Class', 'C')]:
        d.text((340, y), k, font=font(14), fill=GREY); d.text((340, y + 18), v, font=font(22, True), fill=INK); y += 62
    return img


def tax():
    img = paper(); d = ImageDraw.Draw(img); a = (60, 60, 70)
    header(d, 'FORM W-2  Wage and Tax Statement', 'Tax year 2025', a)
    boxes = [('Employee', 'Alex Morgan'), ('Employer', 'Brightline Studio LLC'), ('Wages', '31,560.00'),
             ('Federal tax withheld', '4,830.00'), ('Social security wages', '31,560.00'), ('State', 'UT')]
    for i, (k, v) in enumerate(boxes):
        x = 56 + (i % 2) * 366; y = 200 + (i // 2) * 130
        d.rectangle([x, y, x + 346, y + 110], outline=a, width=2)
        d.text((x + 14, y + 12), k, font=font(15), fill=GREY); d.text((x + 14, y + 52), v, font=font(24, True), fill=INK)
    bars(d, 56, 640, [738, 700, 650, 720, 380])
    return img


docs = [('bank', bank), ('lease', lease), ('paystub', paystub), ('passport', passport),
        ('bill', bill), ('offer', offer), ('license', license_doc), ('tax', tax)]
pages = {}
for name, fn in docs:
    im = fn()
    pages[name] = im
    im.save(os.path.join(OUT, f'{name}.jpg'), quality=90)


def solve(pairs):
    """Perspective coefficients mapping dst->src (PIL expects output->input)."""
    A, B = [], []
    for (x, y), (u, v) in pairs:  # dst (x,y) <- src (u,v)
        A.append([x, y, 1, 0, 0, 0, -u * x, -u * y]); B.append(u)
        A.append([0, 0, 0, x, y, 1, -v * x, -v * y]); B.append(v)
    n = 8
    M = [row + [b] for row, b in zip(A, B)]
    for i in range(n):
        p = max(range(i, n), key=lambda r: abs(M[r][i])); M[i], M[p] = M[p], M[i]
        for r in range(n):
            if r != i:
                k = M[r][i] / M[i][i]
                M[r] = [a - k * b for a, b in zip(M[r], M[i])]
    return [M[i][n] / M[i][i] for i in range(n)]


# Desk photo of the lease page, slightly rotated with perspective.
DW, DH = 1500, 2000
desk = Image.new('RGB', (DW, DH))
dp = desk.load()
for y in range(DH):
    for x in range(DW):
        t = y / DH
        base = (int(92 - 24 * t), int(78 - 20 * t), int(66 - 16 * t))
        n = random.randint(-5, 5) + int(6 * math.sin(x / 38.0 + y / 210.0))
        dp[x, y] = tuple(max(0, min(255, c + n)) for c in base)
corners_dst = [(270, 250), (1250, 330), (1190, 1700), (200, 1620)]  # tl, tr, br, bl
src = [(0, 0), (W, 0), (W, H), (0, H)]
coef = solve([(d, s) for d, s in zip(corners_dst, src)])
warped = pages['lease'].transform((DW, DH), Image.PERSPECTIVE, coef, Image.BICUBIC)
mask = Image.new('L', (DW, DH), 0)
ImageDraw.Draw(mask).polygon(corners_dst, fill=255)
shadow = mask.filter(ImageFilter.GaussianBlur(26))
desk.paste((20, 16, 12), (24, 34), shadow.point(lambda v: int(v * 0.55)))
desk.paste(warped, (0, 0), mask)
desk.save(os.path.join(OUT, 'desk.jpg'), quality=90)
desk.resize((DW // 2, DH // 2), Image.LANCZOS).save(os.path.join(OUT, 'desk_small.jpg'), quality=88)

# Crop corners a hair outside the paper, as auto edge detection would give.
quad = [[(x + dx) / DW, (y + dy) / DH] for (x, y), (dx, dy) in zip(corners_dst, [(-8, -8), (8, -8), (8, 8), (-8, 8)])]
json.dump({'quad': quad, 'width': DW, 'height': DH}, open(os.path.join(OUT, 'desk_quad.json'), 'w'))
print('documents written to', OUT)
