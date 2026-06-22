let minigame_root = HEMTT_VFS
    .join("addons")
    .join("fza_ah64_minigames")
    .join("ui")
    .join("minigame");

let shared_dir = minigame_root.join("shared");
let games_dir = minigame_root.join("games");

let games = ["asteroids"];

for game_name in games {
    let game_dir = games_dir.join(game_name);
    let html = game_dir.join("game.html").open_file().read();

    // Inline this game's own CSS
    let css_content = game_dir.join("game.css").open_file().read();
    let css_tag = "<link rel=\"stylesheet\" href=\"game.css\">";
    html.replace(css_tag, "<style>\n" + css_content + "\n</style>");

    // Inline the shared bridge, then this game's own JS, in that order
    let bridge_content = shared_dir.join("bridge.js").open_file().read();
    let bridge_tag = "<script src=\"../../shared/bridge.js\"></script>";
    html.replace(bridge_tag, "<script>\n" + bridge_content + "\n</script>");

    let game_js_content = game_dir.join("game.js").open_file().read();
    let game_js_tag = "<script src=\"game.js\"></script>";
    html.replace(game_js_tag, "<script>\n" + game_js_content + "\n</script>");

    let out = game_dir.join("game.html").create_file();
    out.write(html);
}
