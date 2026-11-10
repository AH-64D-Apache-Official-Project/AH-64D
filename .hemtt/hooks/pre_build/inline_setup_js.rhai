// Inlines the controls setup page's CSS and JS into setup.built.html (HEMTT_VFS only), as for the mission planner:
// the browser cannot load sibling files, and the separate name has no loose source to shadow it under -filePatching.

let ui = HEMTT_VFS
    .join("addons")
    .join("fza_ah64_setup")
    .join("ui");

let html = ui.join("setup.html").open_file().read();

let css_tag = "<link rel=\"stylesheet\" href=\"setup.css\">";
if !html.contains(css_tag) {
    fatal("inline_setup_js: setup.html has no tag " + css_tag);
}
html.replace(css_tag, "<style>\n" + ui.join("setup.css").open_file().read() + "\n</style>");

for js_name in ["catalogue.js", "setup.js"] {
    let tag = "<script src=\"" + js_name + "\"></script>";
    if !html.contains(tag) {
        fatal("inline_setup_js: setup.html has no tag " + tag);
    }
    html.replace(tag, "<script>\n" + ui.join(js_name).open_file().read() + "\n</script>");
}

let out = ui.join("setup.built.html").create_file();
out.write(html);
