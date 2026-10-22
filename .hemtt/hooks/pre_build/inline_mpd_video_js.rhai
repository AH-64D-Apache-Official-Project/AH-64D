// Inline the IHADSS formats, the CSS and the font into the MPD VIDEO page - the browser control cannot resolve relative
// paths inside a PBO

fn inline_tag(html, tag, replacement) {
    if !html.contains(tag) {
        fatal("inline_mpd_video_js: video.html has no tag " + tag);
    }
    html.replace(tag, replacement);
    html
}

let addons = HEMTT_VFS.join("addons");
let ui = addons.join("fza_ah64_mpd").join("ui").join("video");
let ihadss = addons.join("fza_ah64_ihadss").join("ui");

let html = ui.join("video.html").open_file().read();

let font = ihadss.join("font").join("BMKApacheFont.b64").open_file().read();
font.trim();
let css = ui.join("video.css").open_file().read();
let font_tag = "/*@IHADSS_FONT@*/";
if !css.contains(font_tag) {
    fatal("inline_mpd_video_js: video.css has no " + font_tag);
}
css.replace(font_tag, "@font-face { font-family: BMKApacheFont; src: url(data:font/ttf;base64," + font + ") format(\"truetype\"); }");
html = inline_tag(html, "<link rel=\"stylesheet\" href=\"video.css\">", "<style>\n" + css + "\n</style>");

for name in ["ihadss_common.js", "ihadss_base.js", "ihadss_flight.js", "ihadss_weapon.js", "ihadss_main.js"] {
    let js = ihadss.join("js").join(name).open_file().read();
    html = inline_tag(html, "<script src=\"ihadss/" + name + "\"></script>", "<script>\n" + js + "\n</script>");
}
let js = ui.join("video.js").open_file().read();
html = inline_tag(html, "<script src=\"video.js\"></script>", "<script>\n" + js + "\n</script>");

// Written under a name with no loose source file, so -filePatching cannot serve the un-inlined page
let out = ui.join("video_built.html").create_file();
out.write(html);
