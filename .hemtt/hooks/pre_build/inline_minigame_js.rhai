// Inline CSS/JS into each minigame's HTML — the browser control cannot resolve relative paths inside a PBO

// A tag that is not found would ship a page with a dead relative link, so stop the build instead
fn inline_tag(html, tag, replacement, page) {
    if !html.contains(tag) {
        fatal("inline_minigame_js: " + page + "/game.html has no tag " + tag);
    }
    html.replace(tag, replacement);
    html
}

let minigame_root = HEMTT_VFS
    .join("addons")
    .join("fza_ah64_minigames")
    .join("ui")
    .join("minigame");

let shared_dir = minigame_root.join("shared");
let games_dir = minigame_root.join("games");

let games = ["asteroids", "spaceinvaders", "pong", "breakout", "lunarlander", "battleship", "tictactoe", "connectfour", "rockpaperscissors", "checkers"];

let bridge_content = shared_dir.join("bridge.js").open_file().read();

for game_name in games {
    let game_dir = games_dir.join(game_name);
    let html = game_dir.join("game.html").open_file().read();

    // Inline this game's own CSS
    let css_content = game_dir.join("game.css").open_file().read();
    html = inline_tag(html, "<link rel=\"stylesheet\" href=\"game.css\">",
        "<style>\n" + css_content + "\n</style>", game_name);

    // Inline the shared bridge, then this game's own JS, in that order
    html = inline_tag(html, "<script src=\"../../shared/bridge.js\"></script>",
        "<script>\n" + bridge_content + "\n</script>", game_name);

    let game_js_content = game_dir.join("game.js").open_file().read();
    html = inline_tag(html, "<script src=\"game.js\"></script>",
        "<script>\n" + game_js_content + "\n</script>", game_name);

    let out = game_dir.join("game.html").create_file();
    out.write(html);
}
