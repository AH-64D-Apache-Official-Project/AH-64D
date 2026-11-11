// Inlines manual.js into the offline manual (manual.built.html, HEMTT_VFS only): the browser cannot load sibling files.

let ui = HEMTT_VFS
    .join("addons")
    .join("fza_ah64_docs")
    .join("ui");

let html = ui.join("manual.html").open_file().read();

let js_tag = "<script src=\"manual.js\"></script>";
if !html.contains(js_tag) {
    fatal("inline_manual_js: manual.html has no tag " + js_tag);
}
html.replace(js_tag, "<script>\n" + ui.join("manual.js").open_file().read() + "\n</script>");

let out = ui.join("manual.built.html").create_file();
out.write(html);
