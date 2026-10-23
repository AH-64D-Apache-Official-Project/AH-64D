// Inline CSS, JS and the font into the IHADSS page - the browser control cannot resolve relative paths inside a PBO

fn inline_tag(html, tag, replacement) {
    if !html.contains(tag) {
        fatal("inline_ihadss_js: ihadss.html has no tag " + tag);
    }
    html.replace(tag, replacement);
    html
}

let ui = HEMTT_VFS
    .join("addons")
    .join("fza_ah64_ihadss")
    .join("ui");

let scripts = ["ihadss_common.js", "ihadss_base.js", "ihadss_flight.js", "ihadss_weapon.js", "ihadss_main.js"];

let html = ui.join("ihadss.html").open_file().read();

let font = ui.join("font").join("BMKApacheFont.b64").open_file().read();
font.trim();
let css = ui.join("ihadss.css").open_file().read();
let font_tag = "/*@IHADSS_FONT@*/";
if !css.contains(font_tag) {
    fatal("inline_ihadss_js: ihadss.css has no " + font_tag);
}
css.replace(font_tag, "@font-face { font-family: BMKApacheFont; src: url(data:font/ttf;base64," + font + ") format(\"truetype\"); }");
html = inline_tag(html, "<link rel=\"stylesheet\" href=\"ihadss.css\">", "<style>\n" + css + "\n</style>");

for name in scripts {
    let js = ui.join("js").join(name).open_file().read();
    html = inline_tag(html, "<script src=\"js/" + name + "\"></script>", "<script>\n" + js + "\n</script>");
}

// Written under a name with no loose source file, so -filePatching cannot serve the un-inlined page
let out = ui.join("ihadss_built.html").create_file();
out.write(html);
