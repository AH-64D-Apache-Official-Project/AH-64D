// Inline the CSS and the FCR picture scripts into the MPD FCR video underlay page - the browser control cannot resolve
// relative paths inside a PBO

fn inline_tag(html, tag, replacement) {
    if !html.contains(tag) {
        fatal("inline_mpd_fcrvideo_js: fcrvideo.html has no tag " + tag);
    }
    html.replace(tag, replacement);
    html
}

let addons = HEMTT_VFS.join("addons");
let ui = addons.join("fza_ah64_mpd").join("ui").join("fcrvideo");
let fcr_shared = addons.join("fza_ah64_fcr").join("ui").join("shared");

let html = ui.join("fcrvideo.html").open_file().read();

let css = ui.join("fcrvideo.css").open_file().read();
html = inline_tag(html, "<link rel=\"stylesheet\" href=\"fcrvideo.css\">", "<style>\n" + css + "\n</style>");

for name in ["fcr_rmap_view.js", "fcr_tpm_view.js", "fcr_video_layer.js"] {
    let js = fcr_shared.join(name).open_file().read();
    html = inline_tag(html, "<script src=\"fcr/" + name + "\"></script>", "<script>\n" + js + "\n</script>");
}
let js = ui.join("fcrvideo.js").open_file().read();
html = inline_tag(html, "<script src=\"fcrvideo.js\"></script>", "<script>\n" + js + "\n</script>");

// Written under a name with no loose source file, so -filePatching cannot serve the un-inlined page
let out = ui.join("fcrvideo_built.html").create_file();
out.write(html);
