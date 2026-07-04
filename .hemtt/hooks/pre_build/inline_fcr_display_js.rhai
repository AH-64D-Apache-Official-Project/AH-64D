// Inline CSS and JS into FCR display HTML files so the packed PBO is self-contained.
// Arma 3's browser control cannot resolve relative file paths inside a PBO.
// This mirrors the approach used in inline_minigame_js.rhai for the minigame pages.

let fcr_ui_root = HEMTT_VFS
    .join("addons")
    .join("fza_ah64_fcr")
    .join("ui");

let shared_dir = fcr_ui_root.join("shared");
let displays = ["rmap", "tpm"];

for display_name in displays {
    let display_dir = fcr_ui_root.join(display_name);
    let html = display_dir.join(display_name + ".html").open_file().read();

    // Inline display-specific CSS
    let css_content = display_dir.join(display_name + ".css").open_file().read();
    let css_tag = "<link rel=\"stylesheet\" href=\"" + display_name + ".css\">";
    html.replace(css_tag, "<style>\n" + css_content + "\n</style>");

    // Inline shared FCR bridge JS
    let bridge_content = shared_dir.join("fcr_display_bridge.js").open_file().read();
    let bridge_tag = "<script src=\"../shared/fcr_display_bridge.js\"></script>";
    html.replace(bridge_tag, "<script>\n" + bridge_content + "\n</script>");

    // Inline display-specific JS
    let js_content = display_dir.join(display_name + ".js").open_file().read();
    let js_tag = "<script src=\"" + display_name + ".js\"></script>";
    html.replace(js_tag, "<script>\n" + js_content + "\n</script>");

    let out = display_dir.join(display_name + ".html").create_file();
    out.write(html);
}
