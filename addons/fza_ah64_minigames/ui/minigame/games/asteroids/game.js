(function () {
    "use strict";

    var GAME_ID = "asteroids";
    var SCALE = 1.25; // visual size only, not speed/physics
    var LINE_WIDTH = 3; // fixed, decoupled from SCALE

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
    function sfxShoot() { window.fzaMinigame.playSfx("shoot"); }
    function sfxExplosionBig() { window.fzaMinigame.playSfx("explosionBig"); }
    function sfxExplosionSmall() { window.fzaMinigame.playSfx("explosionSmall"); }
    function sfxDeath() { window.fzaMinigame.playSfx("death"); }

    window.fza_minigame_setMuted = function (isMuted) {
        var btn = document.getElementById("muteBtn");
        if (btn) { btn.classList.toggle("active", !isMuted); }
    };

    // Pushed by fn_minigamePushScores.sqf on ready and on every scoreboard update.
    window.fza_minigame_setScores = function (myHighScore, scores) {
        if (myHighScore > highScore) { highScore = myHighScore; }
        // Updated directly here too, not just in render(), since render() skips the HUD update while on the start screen (not yet "started").
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
        if (isDown && action === "down" && gameOver) { startGame(); }
    }

    window.fza_minigame_input = function (action, isDown) {
        setKey(action, isDown);
    };

    var KEY_MAP = {
        ArrowUp: "up", w: "up", W: "up",
        ArrowLeft: "left", a: "left", A: "left",
        ArrowRight: "right", d: "right", D: "right",
        ArrowDown: "down", s: "down", S: "down",
        " ": "down", Spacebar: "down"
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

    // Game state
    var ship, asteroids, bullets, particles;
    var score, lives, highScore, started, gameOver, respawnTimer, fireTimer;
    var gameTime; // difficulty ramps up the longer a session runs, capped so it stays playable

    function difficultyMul() {
        return 1 + Math.min(1.5, gameTime / 90);
    }

    function wrap(p) {
        if (p.x < 0) { p.x += W; }
        if (p.x > W) { p.x -= W; }
        if (p.y < 0) { p.y += H; }
        if (p.y > H) { p.y -= H; }
    }

    function makeAsteroid(x, y, radius) {
        var points = [];
        var count = 8 + Math.floor(Math.random() * 5);
        for (var i = 0; i < count; i++) {
            var a = (i / count) * Math.PI * 2;
            var r = radius * (0.75 + Math.random() * 0.5);
            points.push({ a: a, r: r });
        }
        var mul = difficultyMul();
        var speed = (20 + Math.random() * 40) * mul;
        var dir = Math.random() * Math.PI * 2;
        return {
            x: x, y: y,
            vx: Math.cos(dir) * speed, vy: Math.sin(dir) * speed,
            radius: radius,
            angle: 0,
            spin: (Math.random() - 0.5) * 1.5 * mul,
            points: points
        };
    }

    function spawnWave(count) {
        for (var i = 0; i < count; i++) {
            var edge = Math.floor(Math.random() * 4);
            var x, y;
            if (edge === 0) { x = 0; y = Math.random() * H; }
            else if (edge === 1) { x = W; y = Math.random() * H; }
            else if (edge === 2) { x = Math.random() * W; y = 0; }
            else { x = Math.random() * W; y = H; }
            asteroids.push(makeAsteroid(x, y, 45 * SCALE));
        }
    }

    function resetShip() {
        ship = {
            x: W / 2, y: H / 2,
            vx: 0, vy: 0,
            angle: -Math.PI / 2,
            radius: 12 * SCALE,
            invuln: 2.0
        };
    }

    function startGame() {
        if (started && !gameOver) { return; }
        score = 0;
        lives = 3;
        asteroids = [];
        bullets = [];
        particles = [];
        fireTimer = 0;
        respawnTimer = 0;
        gameTime = 0;
        gameOver = false;
        started = true;
        resetShip();
        spawnWave(4);
        document.getElementById("overlay").classList.add("hidden");
    }

    function endGame() {
        gameOver = true;
        sfxDeath();
        if (score > highScore) { highScore = score; }
        window.fzaMinigame.reportScore(GAME_ID, score);
        document.getElementById("overlaySub").textContent = "SCORE " + score + " - press DOWN to restart";
        document.getElementById("overlay").classList.remove("hidden");
    }

    function explode(x, y, n) {
        for (var i = 0; i < n; i++) {
            var a = Math.random() * Math.PI * 2;
            var s = 40 + Math.random() * 80;
            particles.push({ x: x, y: y, vx: Math.cos(a) * s, vy: Math.sin(a) * s, life: 0.5 + Math.random() * 0.3 });
        }
    }

    function splitAsteroid(idx) {
        var ast = asteroids[idx];
        asteroids.splice(idx, 1);
        explode(ast.x, ast.y, 10);
        if (ast.radius > 18 * SCALE) {
            sfxExplosionSmall();
            score += 50;
            for (var i = 0; i < 2; i++) {
                var child = makeAsteroid(ast.x, ast.y, ast.radius * 0.55);
                asteroids.push(child);
            }
        } else {
            sfxExplosionBig();
            score += 100;
        }
        if (asteroids.length === 0) { spawnWave(Math.min(8, 4 + Math.floor(score / 1000))); }
    }

    // Update
    function update(dt) {
        if (!started || gameOver) { return; }
        gameTime += dt;

        if (keys.left) { ship.angle -= 3.2 * dt; }
        if (keys.right) { ship.angle += 3.2 * dt; }
        if (keys.up) {
            ship.vx += Math.cos(ship.angle) * 140 * dt;
            ship.vy += Math.sin(ship.angle) * 140 * dt;
        }
        ship.vx *= 0.992;
        ship.vy *= 0.992;
        ship.x += ship.vx * dt;
        ship.y += ship.vy * dt;
        wrap(ship);
        if (ship.invuln > 0) { ship.invuln -= dt; }

        fireTimer -= dt;
        if (keys.down && fireTimer <= 0) {
            fireTimer = 0.22;
            bullets.push({
                x: ship.x + Math.cos(ship.angle) * ship.radius,
                y: ship.y + Math.sin(ship.angle) * ship.radius,
                vx: ship.vx + Math.cos(ship.angle) * 320,
                vy: ship.vy + Math.sin(ship.angle) * 320,
                ttl: 1.1
            });
            sfxShoot();
        }

        // Bullets
        for (var bi = bullets.length - 1; bi >= 0; bi--) {
            var b = bullets[bi];
            b.x += b.vx * dt;
            b.y += b.vy * dt;
            b.ttl -= dt;
            wrap(b);
            if (b.ttl <= 0) { bullets.splice(bi, 1); }
        }

        // Asteroids
        for (var ai = 0; ai < asteroids.length; ai++) {
            var a = asteroids[ai];
            a.x += a.vx * dt;
            a.y += a.vy * dt;
            a.angle += a.spin * dt;
            wrap(a);
        }

        // Bullet vs asteroid
        for (bi = bullets.length - 1; bi >= 0; bi--) {
            var bullet = bullets[bi];
            for (ai = asteroids.length - 1; ai >= 0; ai--) {
                var ast = asteroids[ai];
                var dx = bullet.x - ast.x, dy = bullet.y - ast.y;
                if ((dx * dx + dy * dy) < ast.radius * ast.radius) {
                    bullets.splice(bi, 1);
                    splitAsteroid(ai);
                    break;
                }
            }
        }

        // Ship vs asteroid
        if (ship.invuln <= 0) {
            for (ai = asteroids.length - 1; ai >= 0; ai--) {
                var aa = asteroids[ai];
                var sdx = ship.x - aa.x, sdy = ship.y - aa.y;
                if ((sdx * sdx + sdy * sdy) < (aa.radius + ship.radius) * (aa.radius + ship.radius)) {
                    explode(ship.x, ship.y, 16);
                    lives -= 1;
                    if (lives <= 0) { endGame(); return; }
                    resetShip();
                    break;
                }
            }
        }

        // Particles
        for (var pi = particles.length - 1; pi >= 0; pi--) {
            var p = particles[pi];
            p.x += p.vx * dt;
            p.y += p.vy * dt;
            p.life -= dt;
            if (p.life <= 0) { particles.splice(pi, 1); }
        }
    }

    // Render
    function drawShip() {
        if (ship.invuln > 0 && Math.floor(ship.invuln * 8) % 2 === 0) { return; }
        ctx.save();
        ctx.translate(ship.x, ship.y);
        ctx.rotate(ship.angle);
        ctx.strokeStyle = "#33ff33";
        ctx.lineWidth = LINE_WIDTH;
        ctx.beginPath();
        ctx.moveTo(ship.radius, 0);
        ctx.lineTo(-ship.radius * 0.8, ship.radius * 0.7);
        ctx.lineTo(-ship.radius * 0.4, 0);
        ctx.lineTo(-ship.radius * 0.8, -ship.radius * 0.7);
        ctx.closePath();
        ctx.stroke();
        if (keys.up) {
            ctx.strokeStyle = "#ff9933";
            ctx.beginPath();
            ctx.moveTo(-ship.radius * 0.4, 0);
            ctx.lineTo(-ship.radius * 1.4, 0);
            ctx.stroke();
        }
        ctx.restore();
    }

    function drawAsteroid(a) {
        ctx.save();
        ctx.translate(a.x, a.y);
        ctx.rotate(a.angle);
        ctx.strokeStyle = "#33ff33";
        ctx.lineWidth = LINE_WIDTH;
        ctx.beginPath();
        for (var i = 0; i < a.points.length; i++) {
            var pt = a.points[i];
            var px = Math.cos(pt.a) * pt.r, py = Math.sin(pt.a) * pt.r;
            if (i === 0) { ctx.moveTo(px, py); } else { ctx.lineTo(px, py); }
        }
        ctx.closePath();
        ctx.stroke();
        ctx.restore();
    }

    function render() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);

        if (!started || gameOver) { return; }

        drawShip();
        for (var i = 0; i < asteroids.length; i++) { drawAsteroid(asteroids[i]); }

        ctx.fillStyle = "#33ff33";
        var bulletSize = 2 * SCALE;
        for (i = 0; i < bullets.length; i++) {
            ctx.fillRect(bullets[i].x - bulletSize / 2, bullets[i].y - bulletSize / 2, bulletSize, bulletSize);
        }

        ctx.strokeStyle = "#226622";
        for (i = 0; i < particles.length; i++) {
            var p = particles[i];
            ctx.globalAlpha = Math.max(0, p.life);
            ctx.beginPath();
            ctx.moveTo(p.x, p.y);
            ctx.lineTo(p.x - p.vx * 0.02, p.y - p.vy * 0.02);
            ctx.stroke();
        }
        ctx.globalAlpha = 1;

        document.getElementById("score").textContent = "SCORE " + score;
        document.getElementById("lives").textContent = "LIVES " + Math.max(0, lives);
        document.getElementById("highscore").textContent = "HIGH " + highScore;
    }

    // Main loop
    score = 0; lives = 3; highScore = 0; started = false; gameOver = false;
    asteroids = []; bullets = []; particles = [];

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
