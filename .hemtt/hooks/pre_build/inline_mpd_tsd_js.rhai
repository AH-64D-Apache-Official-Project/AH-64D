// Inline the CSS, the MPD font, the icon atlas, the shared point layer and the script into the HTML TSD and ASE pages -
// the browser control cannot resolve relative paths inside a PBO

fn inline_tag(html, tag, replacement, page) {
    if !html.contains(tag) {
        fatal("inline_mpd_tsd_js: " + page + ".html has no tag " + tag);
    }
    html.replace(tag, replacement);
    html
}

let addons = HEMTT_VFS.join("addons");
let ui = addons.join("fza_ah64_mpd").join("ui");

let font = addons.join("fza_ah64_ihadss").join("ui").join("font").join("BMKApacheFont.b64").open_file().read();
font.trim();
let font_face = "@font-face { font-family: BMKApacheFont; src: url(data:font/ttf;base64," + font + ") format(\"truetype\"); }";

// [folder and page name, the CSS's font tag, [[a script tag's src, its folder, its file], ...]]
let pages = [
    ["tsd", "/*@TSD_FONT@*/", [
        ["tsd_icon_data.js", "tsd", "tsd_icon_data.js"],
        ["../shared/mpd_points.js", "shared", "mpd_points.js"],
        ["tsd.js", "tsd", "tsd.js"]
    ]],
    ["ase", "/*@MPD_FONT@*/", [
        ["../tsd/tsd_icon_data.js", "tsd", "tsd_icon_data.js"],
        ["../shared/mpd_points.js", "shared", "mpd_points.js"],
        ["ase.js", "ase", "ase.js"]
    ]]
];

for page in pages {
    let name = page[0];
    let dir = ui.join(name);
    let html = dir.join(name + ".html").open_file().read();

    let css = dir.join(name + ".css").open_file().read();
    if !css.contains(page[1]) {
        fatal("inline_mpd_tsd_js: " + name + ".css has no " + page[1]);
    }
    css.replace(page[1], font_face);
    html = inline_tag(html, "<link rel=\"stylesheet\" href=\"" + name + ".css\">", "<style>\n" + css + "\n</style>", name);

    for script in page[2] {
        let js = ui.join(script[1]).join(script[2]).open_file().read();
        html = inline_tag(html, "<script src=\"" + script[0] + "\"></script>", "<script>\n" + js + "\n</script>", name);
    }

    // Written under a name with no loose source file, so -filePatching cannot serve the un-inlined page
    let out = dir.join(name + "_built.html").create_file();
    out.write(html);
}
