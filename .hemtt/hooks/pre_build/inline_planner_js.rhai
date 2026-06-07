// inline_planner_js.rhai
// Before packing, inlines all external CSS and JS into planner.html (HEMTT_VFS only).
// ArmA's CEF browser receives a fully self-contained planner.html with no
// external resource dependencies.  Source files stay on disk for development.

let ui = HEMTT_VFS
    .join("addons")
    .join("fza_ah64_missionplanner")
    .join("ui");

let js_files = [
    "dom_utils.js",
    "sil_data.js",
    "sfm_perf.js",
    "save_load.js",
    "state.js",
    "weapons.js",
    "weights_perf.js"
];

let html = ui.join("planner.html").open_file().read();

// ── Inline CSS ────────────────────────────────────────────────────────────────
let css_content = ui.join("planner.css").open_file().read();
let css_tag = "<link rel=\"stylesheet\" href=\"planner.css\">";
let css_inline = "<style>\n" + css_content + "\n</style>";
html.replace(css_tag, css_inline);

// ── Inline JS ─────────────────────────────────────────────────────────────────
for js_name in js_files {
    let js_content = ui.join(js_name).open_file().read();
    let tag = "<script src=\"" + js_name + "\"></script>";
    let inline_block = "<script>\n" + js_content + "\n</script>";
    html.replace(tag, inline_block);
}

let out = ui.join("planner.html").create_file();
out.write(html);
