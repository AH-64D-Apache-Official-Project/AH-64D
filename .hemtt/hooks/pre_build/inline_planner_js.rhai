// inline_planner_js.rhai
// Before packing, inlines all external CSS and JS into planner.html and writes the
// result to planner.built.html (HEMTT_VFS only). ArmA's CEF browser receives a fully
// self-contained page with no external resource dependencies. Source files stay on
// disk, unmodified, for development.
//
// Written to a SEPARATE filename (not planner.html in place) deliberately: HEMTT's
// dev-mode -filePatching symlinks each addon's entire raw source folder, so any path
// that also exists in loose source gets shadowed by that loose copy at runtime - and
// planner.html's loose source still has un-inlined <script src> tags pointing at
// sibling .js files, which silently fail to resolve inside CT_WEBBROWSER's local-
// content sandbox (no console, no error - the JS just never runs past that point).
// planner.built.html has no loose-source counterpart anywhere in the addon folder,
// so -filePatching has nothing to shadow it with; RscDisplay.hpp's url points here.

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

let out = ui.join("planner.built.html").create_file();
out.write(html);
