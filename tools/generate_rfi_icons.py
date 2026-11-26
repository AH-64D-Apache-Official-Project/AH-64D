# Draws the RFI and RLWR threat symbol textures on the RLWR icons' 128 px canvas, each frame fitted to what it holds.
# Layouts (the characters themselves are the icon's text, fza_mpd_fnc_rfiIdent and FzaIconTypes IconTypeI/I1):
#   f2 - fine, two characters at the triangle's upper left and right, against the frame
#   f1 - fine, one character at the triangle's upper right, the triangle moved left
#   c2 - coarse, two characters together in the middle, no triangle
#   c1 - coarse, one character in the middle
# Per layout: box (acquisition and track), home (No. 1 emitter), dash (No. 1 emitter searching), fill (selected
# emitter); per fine layout: tri (open triangle, RFI fine) and sol (filled, RLWR and the selected emitter).
# Writes PNGs; convert to .paa with hemtt utils paa convert into addons/fza_ah64_mpd/tex/aseIcons, then re-run
# generate_tsd_html_icon_data.ps1.
# Usage: python generate_rfi_icons.py <out dir>
import sys
import os
import math
from PIL import Image, ImageDraw

CANVAS = 128
SS = 8
STROKE = 4.0
DASH = 12.0
GAP = 8.0

# The frame's left, top, right, bottom, and the homeplate's straight sides' foot and point
FRAMES = {
    "f2": (17, 17, 111, 103, 100, 122),
    "f1": (26, 17, 106, 103, 100, 122),
    "c2": (35, 44, 93, 84, 78, 98),
    "c1": (47, 44, 81, 84, 78, 98),
}
TRIANGLES = {
    "f2": [(64, 49), (90, 96), (38, 96)],
    "f1": [(58, 49), (84, 96), (32, 96)],
}


def s(v):
    return v * SS


def stroke_line(d, a, b):
    d.line([(s(a[0]), s(a[1])), (s(b[0]), s(b[1]))], fill=255, width=int(s(STROKE)))
    r = s(STROKE) / 2
    for p in (a, b):
        d.ellipse([s(p[0]) - r, s(p[1]) - r, s(p[0]) + r, s(p[1]) + r], fill=255)


def outline(d, pts):
    for i in range(len(pts)):
        stroke_line(d, pts[i], pts[(i + 1) % len(pts)])


def dashed(d, pts):
    # Dashes run on round the outline, so corners keep their pattern
    on, left = True, DASH
    for i in range(len(pts)):
        a, b = pts[i], pts[(i + 1) % len(pts)]
        length = math.dist(a, b)
        pos = 0.0
        while pos < length:
            step = min(left, length - pos)
            if on:
                t0, t1 = pos / length, (pos + step) / length
                stroke_line(d, (a[0] + (b[0] - a[0]) * t0, a[1] + (b[1] - a[1]) * t0),
                               (a[0] + (b[0] - a[0]) * t1, a[1] + (b[1] - a[1]) * t1))
            pos += step
            left -= step
            if left <= 0:
                on = not on
                left = DASH if on else GAP


def filled(d, pts):
    d.polygon([(s(x), s(y)) for x, y in pts], fill=255)


def save(draw_fn, path):
    alpha = Image.new("L", (CANVAS * SS, CANVAS * SS), 0)
    draw_fn(ImageDraw.Draw(alpha))
    alpha = alpha.resize((CANVAS, CANVAS), Image.LANCZOS)
    img = Image.new("RGBA", (CANVAS, CANVAS), (255, 255, 255, 0))
    img.putalpha(alpha)
    img.save(path)


def main():
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    for layout, (left, top, right, bottom, foot, point) in FRAMES.items():
        box = [(left, top), (right, top), (right, bottom), (left, bottom)]
        home = [(left, top), (right, top), (right, foot), ((left + right) / 2, point), (left, foot)]
        save(lambda d: outline(d, box), os.path.join(out, "rfi_box_%s_ca.png" % layout))
        save(lambda d: outline(d, home), os.path.join(out, "rfi_home_%s_ca.png" % layout))
        save(lambda d: dashed(d, home), os.path.join(out, "rfi_dash_%s_ca.png" % layout))
        save(lambda d: filled(d, home), os.path.join(out, "rfi_fill_%s_ca.png" % layout))
    for layout, tri in TRIANGLES.items():
        save(lambda d: outline(d, tri), os.path.join(out, "rfi_tri_%s_ca.png" % layout))
        save(lambda d: filled(d, tri), os.path.join(out, "rfi_sol_%s_ca.png" % layout))


if __name__ == "__main__":
    main()
