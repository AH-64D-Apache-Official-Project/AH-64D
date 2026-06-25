(function () {
    "use strict";

    var GAME_ID = "lunarlander";
    var SCALE = 1.25; // visual size only, not speed/physics
    var LINE_WIDTH = 3;

    // Canvas setup
    var canvas = document.getElementById("canvas");
    var ctx = canvas.getContext("2d");
    var W = 0, H = 0;

    function resize() {
        W = canvas.clientWidth || window.innerWidth;
        H = canvas.clientHeight || window.innerHeight;
        canvas.width = W;
        canvas.height = H;
    }
    window.addEventListener("resize", resize);
    resize();

    // Audio - real Arma sounds via the bridge, CT_WEBBROWSER can't play Web Audio.
    function sfxCrash() { window.fzaMinigame.playSfx("explosionBig"); window.fzaMinigame.playSfx("death"); }

    window.fza_minigame_setMuted = function (isMuted) {
        var btn = document.getElementById("muteBtn");
        if (btn) { btn.classList.toggle("active", !isMuted); }
    };

    // Pushed by fn_minigamePushScores.sqf on ready and on every scoreboard update.
    window.fza_minigame_setScores = function (myHighScore, scores) {
        if (myHighScore > highScore) { highScore = myHighScore; }
        var hsEl = document.getElementById("highscore");
        if (hsEl) { hsEl.textContent = "HIGH " + highScore; }
        var board = document.getElementById("scoreboard");
        if (!board) { return; }
        var html = '<div class="scoreboardTitle">TOP SCORES</div>';
        if (!scores || !scores.length) {
            html += '<div class="scoreboardRow"><span>no scores yet</span></div>';
        } else {
            for (var i = 0; i < scores.length; i++) {
                html += '<div class="scoreboardRow">' + (i + 1) + '. ' + escapeHtml(String(scores[i][0])) + ' - ' + scores[i][1] + '</div>';
            }
        }
        board.innerHTML = html;
    };

    function escapeHtml(s) {
        return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }

    // Input - native keyboard and SQF-forwarded (fn_minigameHandleInput.sqf), generic up/down/left/right.
    var keys = { up: false, down: false, left: false, right: false };

    function setKey(action, isDown) {
        if (action in keys) { keys[action] = !!isDown; }
        if (isDown && !started) { startGame(); }
        if (isDown && action === "up" && gameOver) { startGame(); }
    }

    window.fza_minigame_input = function (action, isDown) {
        setKey(action, isDown);
    };

    var KEY_MAP = {
        ArrowUp: "up", w: "up", W: "up",
        ArrowLeft: "left", a: "left", A: "left",
        ArrowRight: "right", d: "right", D: "right",
        ArrowDown: "down", s: "down", S: "down",
        " ": "up", Spacebar: "up"
    };
    window.addEventListener("keydown", function (e) {
        var action = KEY_MAP[e.key];
        if (action) { setKey(action, true); e.preventDefault(); }
    });
    window.addEventListener("keyup", function (e) {
        var action = KEY_MAP[e.key];
        if (action) { setKey(action, false); e.preventDefault(); }
    });

    // autoPaused: pushed by fn_minigameUiInit.sqf's per-frame handler (ESC menu open, or player left the seat).
    // manualPaused: toggled by the on-screen/bezel pause button via fn_minigameSetPaused.sqf.
    var autoPaused = false;
    var manualPaused = false;
    window.fza_minigame_setPaused = function (isPaused) {
        autoPaused = !!isPaused;
    };
    window.fza_minigame_setManualPaused = function (isPaused) {
        manualPaused = !!isPaused;
        var btn = document.getElementById("pauseBtn");
        if (btn) { btn.classList.toggle("active", manualPaused); }
    };

    // Physics constants - gravity/thrust are deliberately gentle (real lunar gravity is weak too), with a fuel
    // budget sized to match: weaker thrust needs longer burns to counter the same velocity, so fuel had to grow
    // roughly in proportion or a careful landing would run dry before touchdown.
    var BASE_GRAVITY = 14 * SCALE;
    var THRUST = 31.2 * SCALE; // +20%
    var ROT_SPEED = 2.4;
    var FUEL_MAX = 180;
    var FUEL_BURN_RATE = 10;
    var SHIP_RADIUS = 10 * SCALE;
    var MAX_LANDING_SPEED = 70 * SCALE;
    var MAX_LANDING_ANGLE = 0.35;
    var SEGMENTS = 40; // finer terrain detail than a first pass - more, smaller jagged steps instead of a coarse zigzag
    var LANDING_FUEL_BONUS = 50; // matches the 1979 arcade's "good landing = +50 fuel units" reward

    // Game state
    var ship, terrainHeights, pads, gravity;
    var score, fuel, highScore, started, gameOver, round;
    var camT = 0; // smoothed 0..1 "how zoomed in on the ship" factor - 0 is a full overview, 1 is tight on the ship

    function normalizeAngle(a) {
        a = a % (Math.PI * 2);
        if (a > Math.PI) { a -= Math.PI * 2; }
        if (a < -Math.PI) { a += Math.PI * 2; }
        return a;
    }

    function buildTerrain() {
        var minPadSegs = 1;
        var maxPadSegs = Math.max(1, 2 - Math.floor(round / 6)); // starts up to 2 segments wide, narrows to 1 after a few rounds

        // Two-layer terrain: a handful of broad coarse hills/valleys (interpolated control points), with fine
        // per-segment jaggedness layered on top - a plain per-segment random walk alone looked too uniform.
        var baseY = H * 0.65;
        var bandY = H * 0.22;
        var coarsePoints = 5;
        var coarseHeights = [];
        for (var ci = 0; ci <= coarsePoints; ci++) {
            coarseHeights.push(baseY + (Math.random() - 0.5) * bandY);
        }
        var heights = [];
        for (var i = 0; i <= SEGMENTS; i++) {
            var ct = (i / SEGMENTS) * coarsePoints;
            var idx0 = Math.floor(ct), idx1 = Math.min(coarsePoints, idx0 + 1);
            var localT = ct - idx0;
            var coarseY = coarseHeights[idx0] + (coarseHeights[idx1] - coarseHeights[idx0]) * localT;
            var y = coarseY + (Math.random() - 0.5) * 70 * SCALE;
            y = Math.max(H * 0.5, Math.min(H * 0.95, y));
            heights.push(y);
        }

        // Several small pads scattered across the map - the overview is for picking one, not just landing dead ahead.
        var numPads = 4 + Math.floor(Math.random() * 3); // 4-6
        var padStarts = [];
        var attempts = 0;
        while (padStarts.length < numPads && attempts < 100) {
            attempts++;
            var s = 2 + Math.floor(Math.random() * (SEGMENTS - maxPadSegs - 3));
            var ok = true;
            for (var p = 0; p < padStarts.length; p++) {
                if (Math.abs(padStarts[p] - s) < maxPadSegs + 2) { ok = false; }
            }
            if (ok) { padStarts.push(s); }
        }

        pads = [];
        var segWidth = W / SEGMENTS;
        padStarts.forEach(function (s) {
            var padSegs = minPadSegs + Math.floor(Math.random() * (maxPadSegs - minPadSegs + 1));
            var padY = heights[s];
            for (var k = 0; k <= padSegs; k++) {
                if (s + k <= SEGMENTS) { heights[s + k] = padY; }
            }
            // Narrower pads (fewer segments) are harder to hit, worth more points.
            var points = Math.round(500 - (padSegs - 1) * 200);
            pads.push({
                xStart: s * segWidth,
                xEnd: Math.min(SEGMENTS, s + padSegs) * segWidth,
                y: padY,
                points: Math.max(150, points)
            });
        });

        terrainHeights = heights;
    }

    function terrainYAt(x) {
        var segWidth = W / SEGMENTS;
        var idx = Math.max(0, Math.min(SEGMENTS - 1, Math.floor(x / segWidth)));
        var t = (x - idx * segWidth) / segWidth;
        return terrainHeights[idx] + (terrainHeights[idx + 1] - terrainHeights[idx]) * t;
    }

    function padAt(x) {
        for (var i = 0; i < pads.length; i++) {
            if (x >= pads[i].xStart && x <= pads[i].xEnd) { return pads[i]; }
        }
        return null;
    }

    function spawnShip() {
        ship = {
            x: W / 2 + (Math.random() - 0.5) * W * 0.4,
            y: H * 0.1,
            vx: (Math.random() - 0.5) * 20 * SCALE,
            vy: 10 * SCALE,
            angle: 0
        };
    }

    // Fuel is a single budget for the whole run, not refilled each descent - matching the original Lunar Lander
    // games (1969 PDP-8 text version, 1979 Atari arcade), where conserving fuel across the whole session is the
    // entire point, and a good landing earns a partial fuel bonus rather than a full top-up.
    function startDescent() {
        gravity = BASE_GRAVITY * (1 + Math.min(0.6, round * 0.05));
        camT = 0;
        buildTerrain();
        spawnShip();
    }

    function startGame() {
        if (started && !gameOver) { return; }
        score = 0;
        round = 0;
        fuel = FUEL_MAX;
        gameOver = false;
        started = true;
        startDescent();
        document.getElementById("overlay").classList.add("hidden");
    }

    // b4 bezel button - returns to the start screen (does not immediately begin a new game, unlike pressing a key).
    window.fza_minigame_restart = function () {
        started = false;
        gameOver = false;
        score = 0;
        document.getElementById("score").textContent = "SCORE 0";
        document.getElementById("fuel").textContent = "FUEL " + FUEL_MAX;
        document.getElementById("overlaySub").textContent = "press any key to start";
        document.getElementById("overlay").classList.remove("hidden");
    };

    function endGame() {
        gameOver = true;
        sfxCrash();
        if (score > highScore) { highScore = score; }
        window.fzaMinigame.reportScore(GAME_ID, score);
        document.getElementById("overlaySub").textContent = "SCORE " + score + " - press UP to restart";
        document.getElementById("overlay").classList.remove("hidden");
    }

    function resolveLanding() {
        var pad = padAt(ship.x);
        var speed = Math.sqrt(ship.vx * ship.vx + ship.vy * ship.vy);
        var uprightOk = Math.abs(normalizeAngle(ship.angle)) <= MAX_LANDING_ANGLE;
        if (pad && speed <= MAX_LANDING_SPEED && uprightOk) {
            score += pad.points;
            fuel = Math.min(FUEL_MAX, fuel + LANDING_FUEL_BONUS);
            round += 1;
            startDescent();
        } else {
            endGame();
        }
    }

    // Update
    function update(dt) {
        if (!started || gameOver) { return; }

        if (keys.left) { ship.angle -= ROT_SPEED * dt; }
        if (keys.right) { ship.angle += ROT_SPEED * dt; }
        ship.angle = normalizeAngle(ship.angle);

        if (keys.up && fuel > 0) {
            ship.vx += Math.sin(ship.angle) * THRUST * dt;
            ship.vy += -Math.cos(ship.angle) * THRUST * dt;
            fuel = Math.max(0, fuel - FUEL_BURN_RATE * dt);
        }
        ship.vy += gravity * dt;
        ship.x += ship.vx * dt;
        ship.y += ship.vy * dt;
        ship.x = Math.max(0, Math.min(W, ship.x));

        var groundY = terrainYAt(ship.x);

        // Camera snaps (not eases) between a full overview and a tight zoom on the ship, so the player gets the
        // whole map for planning a descent but a hard cut to fine pixel-level control right before touchdown.
        // Hysteresis (separate in/out thresholds) stops it flickering back and forth while hovering near the edge.
        var altitude = Math.max(0, groundY - ship.y);
        if (camT < 1 && altitude < H * 0.14) { camT = 1; }
        else if (camT > 0 && altitude > H * 0.2) { camT = 0; }

        if (ship.y + SHIP_RADIUS >= groundY) {
            ship.y = groundY - SHIP_RADIUS;
            resolveLanding();
        }
    }

    // Render
    function drawTerrain() {
        var segWidth = W / SEGMENTS;
        ctx.strokeStyle = "#33ff33";
        ctx.lineWidth = LINE_WIDTH;
        ctx.beginPath();
        for (var i = 0; i <= SEGMENTS; i++) {
            var x = i * segWidth, y = terrainHeights[i];
            if (i === 0) { ctx.moveTo(x, y); } else { ctx.lineTo(x, y); }
        }
        ctx.lineTo(W, H);
        ctx.lineTo(0, H);
        ctx.closePath();
        ctx.stroke();

        ctx.strokeStyle = "#33ccff";
        ctx.lineWidth = LINE_WIDTH * 1.5;
        for (i = 0; i < pads.length; i++) {
            var pad = pads[i];
            ctx.beginPath();
            ctx.moveTo(pad.xStart, pad.y);
            ctx.lineTo(pad.xEnd, pad.y);
            ctx.stroke();
            ctx.fillStyle = "#33ccff";
            ctx.font = (16 * SCALE) + "px 'Courier New', monospace";
            ctx.textAlign = "center";
            ctx.fillText(String(pad.points), (pad.xStart + pad.xEnd) / 2, pad.y - 8 * SCALE);
        }
    }

    // r is the ship's draw radius for this frame - shrunk as the camera zooms in (see render()), so the ship
    // reads as a small, precise object against the now much larger-looking terrain/pads, rather than just
    // growing along with everything else the way a plain camera zoom would.
    function drawShip(r) {
        ctx.save();
        ctx.translate(ship.x, ship.y);
        ctx.rotate(ship.angle);
        ctx.strokeStyle = "#33ff33";
        ctx.lineWidth = LINE_WIDTH;
        ctx.beginPath();
        ctx.moveTo(0, -r);
        ctx.lineTo(r * 0.7, r * 0.6);
        ctx.lineTo(0, r * 0.2);
        ctx.lineTo(-r * 0.7, r * 0.6);
        ctx.closePath();
        ctx.stroke();
        // Legs
        ctx.beginPath();
        ctx.moveTo(-r * 0.5, r * 0.3);
        ctx.lineTo(-r * 0.9, r * 1.1);
        ctx.moveTo(r * 0.5, r * 0.3);
        ctx.lineTo(r * 0.9, r * 1.1);
        ctx.stroke();
        if (keys.up && fuel > 0) {
            ctx.strokeStyle = "#ff9933";
            ctx.beginPath();
            ctx.moveTo(0, r * 0.2);
            ctx.lineTo(0, r * 1.6);
            ctx.stroke();
        }
        ctx.restore();
    }

    function render() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);

        if (!started || gameOver) { return; }

        var camZoom = 1 + camT * 1.8;
        var focusX = W / 2 + (ship.x - W / 2) * camT;
        var focusY = H / 2 + (ship.y - H / 2) * camT;
        // Drawn (not physics) radius - divided by camZoom^2 so the on-screen size still shrinks once the outer
        // ctx.scale(camZoom) below is applied, instead of just cancelling the zoom out to a constant size.
        var shipDrawRadius = SHIP_RADIUS / (camZoom * camZoom);
        ctx.save();
        ctx.translate(W / 2, H / 2);
        ctx.scale(camZoom, camZoom);
        ctx.translate(-focusX, -focusY);
        drawTerrain();
        drawShip(shipDrawRadius);
        ctx.restore();

        document.getElementById("score").textContent = "SCORE " + score;
        document.getElementById("fuel").textContent = "FUEL " + Math.round(fuel);
        document.getElementById("highscore").textContent = "HIGH " + highScore;
    }

    // Main loop
    score = 0; fuel = FUEL_MAX; highScore = 0; started = false; gameOver = false; round = 0;
    pads = []; terrainHeights = [];

    var lastTime = null;
    function frame(t) {
        if (lastTime === null) { lastTime = t; }
        var dt = Math.min(0.05, (t - lastTime) / 1000);
        lastTime = t;
        if (!autoPaused && !manualPaused) { update(dt); }
        render();
        requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);

    window.fzaMinigame.ready(GAME_ID);
}());
