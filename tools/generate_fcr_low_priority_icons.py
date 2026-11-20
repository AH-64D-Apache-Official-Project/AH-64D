# Draws the low priority FCR target icons (TSD targets 17-256): the target glyphs at half size with full width lines,
# on the same 128 px canvas as the full icons. Writes PNGs; convert to .paa with hemtt utils paa convert.
# Usage: python generate_fcr_low_priority_icons.py <out dir>
import sys
import os
import math
import numpy as np
from PIL import Image, ImageDraw

CANVAS = 128
SS = 8
CTR = 64.0
HALF = 11.0
STROKE = 4.0
DOT = 6.0


def s(v):
    return v * SS


def new_layer():
    img = Image.new("L", (CANVAS * SS, CANVAS * SS), 0)
    return img, ImageDraw.Draw(img)


def rect(d, x0, y0, x1, y1):
    d.rectangle([s(x0), s(y0), s(x1) - 1, s(y1) - 1], fill=255)


def poly(d, pts):
    d.polygon([(s(x), s(y)) for x, y in pts], fill=255)


def inset(pts, by):
    # Convex polygon, clockwise on screen: each edge moved inwards, corners at the new edges' intersections
    n = len(pts)
    area = sum(pts[i][0] * pts[(i + 1) % n][1] - pts[(i + 1) % n][0] * pts[i][1] for i in range(n))
    sign = 1 if area > 0 else -1
    lines = []
    for i in range(n):
        (x0, y0), (x1, y1) = pts[i], pts[(i + 1) % n]
        dx, dy = x1 - x0, y1 - y0
        ln = math.hypot(dx, dy)
        nx, ny = -dy / ln * sign, dx / ln * sign
        lines.append(((x0 + nx * by, y0 + ny * by), (dx, dy)))
    out = []
    for i in range(n):
        (p, r), (q, t) = lines[i - 1], lines[i]
        den = r[0] * t[1] - r[1] * t[0]
        k = ((q[0] - p[0]) * t[1] - (q[1] - p[1]) * t[0]) / den
        out.append((p[0] + r[0] * k, p[1] + r[1] * k))
    return out


def outline(d, pts):
    poly(d, pts)
    hole, hd = new_layer()
    poly(hd, inset(pts, STROKE))
    return hole


def track(kind):
    img, d = new_layer()
    lo, hi = CTR - HALF, CTR + HALF
    rect(d, lo, lo, lo + STROKE, hi)
    rect(d, hi - STROKE, lo, hi, hi)
    band0, band1 = CTR - 7, CTR + 7
    if kind == "LOAL":
        rect(d, lo, band0, hi, band0 + STROKE)
        rect(d, lo, band1 - STROKE, hi, band1)
    else:
        rect(d, lo, band0, hi, band1)
    return img, None


def unk(kind):
    img, d = new_layer()
    lo, hi = CTR - HALF, CTR + HALF
    rect(d, lo, lo, hi, hi)
    hole = None
    if kind == "LOAL":
        hole, hd = new_layer()
        rect(hd, lo + STROKE, lo + STROKE, hi - STROKE, hi - STROKE)
    return img, hole


def wheel(kind):
    img, d = new_layer()
    r = HALF
    d.ellipse([s(CTR - r), s(CTR - r), s(CTR + r), s(CTR + r)], fill=255)
    hole = None
    if kind == "LOAL":
        hole, hd = new_layer()
        r2 = r - STROKE
        hd.ellipse([s(CTR - r2), s(CTR - r2), s(CTR + r2), s(CTR + r2)], fill=255)
    return img, hole


def adu(kind):
    img, d = new_layer()
    # The full icon's triangle (apex 37.5, base 82, half base 24.5) about the centre, halved
    tri = [(CTR, CTR - 13.25), (CTR + 12.25, CTR + 9.0), (CTR - 12.25, CTR + 9.0)]
    if kind == "LOAL":
        return img, outline(d, tri)
    poly(d, tri)
    return img, None


def heli(kind):
    img, d = new_layer()
    lo, hi = CTR - HALF, CTR + HALF
    top, bot = CTR - 9.25, CTR + 9.25
    left = [(lo, top), (CTR, CTR), (lo, bot)]
    right = [(hi, top), (hi, bot), (CTR, CTR)]
    if kind == "LOAL":
        # 4 px lines leave no hole in triangles this small: 3 px keeps the outline open
        hole, hd = new_layer()
        for tri in (left, right):
            poly(d, tri)
            poly(hd, inset(tri, STROKE - 1))
        return img, hole
    poly(d, left)
    poly(d, right)
    return img, None


def flyer(kind):
    img, d = new_layer()
    lo, hi = CTR - HALF, CTR + HALF
    rect(d, lo, CTR - STROKE / 2, hi, CTR + STROKE / 2)
    w = s(STROKE)
    a, b, c = (CTR - 6.5, CTR - 3.75), (CTR, CTR + 4.75), (CTR + 6.5, CTR - 3.75)
    d.line([(s(a[0]), s(a[1])), (s(b[0]), s(b[1])), (s(c[0]), s(c[1]))], fill=255, width=int(w), joint="curve")
    return img, None


def finish(shape, hole, dot, ring=False):
    if ring:
        rd = ImageDraw.Draw(shape)
        r = DOT / 2 + STROKE
        rd.ellipse([s(CTR - r), s(CTR - r), s(CTR + r), s(CTR + r)], fill=255)
    a = np.asarray(shape, dtype=np.float64) / 255.0
    if hole is not None:
        a = a * (1.0 - np.asarray(hole, dtype=np.float64) / 255.0)
    lum = np.ones_like(a)
    if dot is not None:
        dl, dd = new_layer()
        r = DOT / 2
        box = [s(CTR - r), s(CTR - r), s(CTR + r) - 1, s(CTR + r) - 1]
        dd.ellipse(box, fill=255) if dot == "circle" else dd.rectangle(box, fill=255)
        lum = 1.0 - np.asarray(dl, dtype=np.float64) / 255.0
    # Box filter down with premultiplied colour, so the edges blend as the full icons' do
    pa = a.reshape(CANVAS, SS, CANVAS, SS).mean(axis=(1, 3))
    pc = (a * lum).reshape(CANVAS, SS, CANVAS, SS).mean(axis=(1, 3))
    col = np.where(pa > 0, pc / np.maximum(pa, 1e-9), 0.0)
    rgba = np.zeros((CANVAS, CANVAS, 4), dtype=np.uint8)
    for ch in range(3):
        rgba[..., ch] = np.round(col * 255).astype(np.uint8)
    rgba[..., 3] = np.round(pa * 255).astype(np.uint8)
    return Image.fromarray(rgba, "RGBA")


def main():
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    shapes = {"track": track, "unk": unk, "wheel": wheel, "adu": adu, "heli": heli}
    for name, fn in shapes.items():
        for kind in ("LOAL", "LOBL", "MOVE"):
            shape, hole = fn(kind)
            dot = None if kind != "MOVE" else ("circle" if name == "heli" else "square")
            finish(shape, hole, dot, name == "heli" and kind == "MOVE").save(os.path.join(out, "%s%s_low_ca.png" % (name, kind)))
    shape, hole = flyer("MOVE")
    finish(shape, hole, None).save(os.path.join(out, "flyer_low_ca.png"))


if __name__ == "__main__":
    main()
