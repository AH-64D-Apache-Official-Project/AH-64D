// Inline the CSS, the MPD font, the icon atlas, the FCR picture scripts and the script into the HTML TSD page - the browser control cannot resolve
// relative paths inside a PBO

fn inline_tag(html, tag, replacement) {
    if !html.contains(tag) {
        fatal("inline_mpd_tsd_js: tsd.html has no tag " + tag);
    }
    html.replace(tag, replacement);
    html
}

let addons = HEMTT_VFS.join("addons");
let ui = addons.join("fza_ah64_mpd").join("ui").join("tsd");

let html = ui.join("tsd.html").open_file().read();

let font = addons.join("fza_ah64_ihadss").join("ui").join("font").join("BMKApacheFont.b64").open_file().read();
font.trim();
let css = ui.join("tsd.css").open_file().read();
let font_tag = "/*@TSD_FONT@*/";
if !css.contains(font_tag) {
    fatal("inline_mpd_tsd_js: tsd.css has no " + font_tag);
}
css.replace(font_tag, "@font-face { font-family: BMKApacheFont; src: url(data:font/ttf;base64," + font + ") format(\"truetype\"); }");
html = inline_tag(html, "<link rel=\"stylesheet\" href=\"tsd.css\">", "<style>\n" + css + "\n</style>");

let fcr_shared = addons.join("fza_ah64_fcr").join("ui").join("shared");
for name in ["fcr_rmap_view.js", "fcr_tpm_view.js", "fcr_video_layer.js"] {
    let js = fcr_shared.join(name).open_file().read();
    html = inline_tag(html, "<script src=\"fcr/" + name + "\"></script>", "<script>\n" + js + "\n</script>");
}
for name in ["tsd_icon_data.js", "tsd.js"] {
    let js = ui.join(name).open_file().read();
    html = inline_tag(html, "<script src=\"" + name + "\"></script>", "<script>\n" + js + "\n</script>");
}

// Written under a name with no loose source file, so -filePatching cannot serve the un-inlined page
let out = ui.join("tsd_built.html").create_file();
out.write(html);
