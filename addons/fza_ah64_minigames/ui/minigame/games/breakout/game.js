(function () {
    "use strict";

    var GAME_ID = "breakout";
    var SCALE = 1.25; // visual size only, not speed/physics
    var LINE_WIDTH = 3;

    // Canvas setup
    var canvas = document.getElementById("canvas");
    var ctx = canvas.getContext("2d");
    var W = 0, H = 0, TOP_MARGIN = 0, BOTTOM_MARGIN = 0;
    var PADDLE_W, PADDLE_H, PADDLE_SPEED, BALL_RADIUS;

    function resize() {
        W = canvas.clientWidth || window.innerWidth;
        H = canvas.clientHeight || window.innerHeight;
        canvas.width = W;
        canvas.height = H;
        TOP_MARGIN = H * 0.12;
        BOTTOM_MARGIN = H * 0.2; // keeps the paddle clear of the mute/pause/restart buttons overlaid at the bottom
        PADDLE_W = 85 * SCALE;
        PADDLE_H = 14 * SCALE;
        PADDLE_SPEED = 480 * SCALE;
        BALL_RADIUS = 7 * SCALE;
    }
    window.addEventListener("resize", resize);
    resize();

    // Audio - real Arma sounds via the bridge, CT_WEBBROWSER can't play Web Audio.
    function sfxBounce() { window.fzaMinigame.playSfx("shoot"); }
    function sfxBrick() { window.fzaMinigame.playSfx("explosionSmall"); }
    function sfxDeath() { window.fzaMinigame.playSfx("death"); }

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
        if (isDown && action === "down" && gameOver) { startGame(); }
        if (isDown && action === "down" && started && !gameOver && !launched) { launchBall(); }
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
    var paddle, ball, bricks;
    var score, lives, highScore, started, gameOver, launched;
    var ballSpeed;
    var BASE_BALL_SPEED = 280 * SCALE;
    var MAX_BALL_SPEED = 600 * SCALE;
    var SPEED_RAMP = 1.07;
    var MAX_BOUNCE_ANGLE = Math.PI / 3; // 60 degrees off vertical, at the paddle's outer edges

    var COLS = 8, ROWS = 5;
    var ROW_COLORS = ["#ff3333", "#ff9933", "#ffcc33", "#33ff33", "#33ccff"];
    var ROW_POINTS = [50, 40, 30, 20, 10];
    var BRICK_GAP = 4 * SCALE;
    var BRICK_H = 22 * SCALE;

    function buildBricks() {
        bricks = [];
        var brickW = (W - BRICK_GAP * (COLS + 1)) / COLS;
        for (var r = 0; r < ROWS; r++) {
            for (var c = 0; c < COLS; c++) {
                bricks.push({
                    x: BRICK_GAP + c * (brickW + BRICK_GAP),
                    y: TOP_MARGIN + BRICK_GAP + r * (BRICK_H + BRICK_GAP),
                    w: brickW,
                    h: BRICK_H,
                    row: r,
                    alive: true
                });
            }
        }
    }

    function resetPaddle() {
        paddle = { x: (W - PADDLE_W) / 2, y: H - BOTTOM_MARGIN - PADDLE_H };
    }

    function stickBallToPaddle() {
        launched = false;
        ball = {
            x: paddle.x + PADDLE_W / 2,
            y: paddle.y - BALL_RADIUS,
            vx: 0,
            vy: 0
        };
    }

    function launchBall() {
        if (launched) { return; }
        launched = true;
        var angle = -Math.PI / 2 + (Math.random() - 0.5) * 0.6;
        ball.vx = Math.cos(angle) * ballSpeed;
        ball.vy = Math.sin(angle) * ballSpeed;
    }

    function startGame() {
        if (started && !gameOver) { return; }
        score = 0;
        lives = 3;
        ballSpeed = BASE_BALL_SPEED;
        gameOver = false;
        started = true;
        resetPaddle();
        stickBallToPaddle();
        buildBricks();
        document.getElementById("overlay").classList.add("hidden");
    }

    // b4 bezel button - returns to the start screen (does not immediately begin a new game, unlike pressing a key).
    window.fza_minigame_restart = function () {
        started = false;
        gameOver = false;
        score = 0;
        lives = 3;
        bricks = [];
        document.getElementById("score").textContent = "SCORE 0";
        document.getElementById("lives").textContent = "LIVES 3";
        document.getElementById("overlaySub").textContent = "press any key to start";
        document.getElementById("overlay").classList.remove("hidden");
    };

    function endGame() {
        gameOver = true;
        sfxDeath();
        if (score > highScore) { highScore = score; }
        window.fzaMinigame.reportScore(GAME_ID, score);
        document.getElementById("overlaySub").textContent = "SCORE " + score + " - press DOWN to restart";
        document.getElementById("overlay").classList.remove("hidden");
    }

    function loseLife() {
        lives -= 1;
        if (lives <= 0) { endGame(); return; }
        resetPaddle();
        stickBallToPaddle();
    }

    function nextWave() {
        ballSpeed = Math.min(MAX_BALL_SPEED, ballSpeed * SPEED_RAMP);
        buildBricks();
        stickBallToPaddle();
    }

    // Update
    function update(dt) {
        if (!started || gameOver) { return; }

        if (keys.left) { paddle.x -= PADDLE_SPEED * dt; }
        if (keys.right) { paddle.x += PADDLE_SPEED * dt; }
        paddle.x = Math.max(0, Math.min(W - PADDLE_W, paddle.x));

        if (!launched) {
            ball.x = paddle.x + PADDLE_W / 2;
            ball.y = paddle.y - BALL_RADIUS;
            return;
        }

        ball.x += ball.vx * dt;
        ball.y += ball.vy * dt;

        // Walls
        if (ball.x - BALL_RADIUS < 0) { ball.x = BALL_RADIUS; ball.vx = -ball.vx; sfxBounce(); }
        if (ball.x + BALL_RADIUS > W) { ball.x = W - BALL_RADIUS; ball.vx = -ball.vx; sfxBounce(); }
        if (ball.y - BALL_RADIUS < 0) { ball.y = BALL_RADIUS; ball.vy = -ball.vy; sfxBounce(); }

        // Miss - ball fell past the paddle's row (not all the way to the bottom of the canvas, since the paddle
        // now sits well above the bottom edge to stay clear of the overlaid mute/pause/restart buttons).
        if (ball.y - BALL_RADIUS > paddle.y + PADDLE_H + 20 * SCALE) { loseLife(); return; }

        // Paddle collision - only when moving downward, angle varies with hit position.
        if (ball.vy > 0 &&
            ball.y + BALL_RADIUS >= paddle.y && ball.y - BALL_RADIUS <= paddle.y + PADDLE_H &&
            ball.x + BALL_RADIUS >= paddle.x && ball.x - BALL_RADIUS <= paddle.x + PADDLE_W) {
            var hitPos = ((ball.x - paddle.x) / PADDLE_W) - 0.5; // -0.5..0.5
            var bounceAngle = hitPos * 2 * MAX_BOUNCE_ANGLE;
            ball.vx = Math.sin(bounceAngle) * ballSpeed;
            ball.vy = -Math.cos(bounceAngle) * ballSpeed;
            ball.y = paddle.y - BALL_RADIUS;
            sfxBounce();
        }

        // Bricks - axis-aware AABB bounce (reflect whichever axis has the smaller penetration).
        for (var i = 0; i < bricks.length; i++) {
            var b = bricks[i];
            if (!b.alive) { continue; }
            if (ball.x + BALL_RADIUS < b.x || ball.x - BALL_RADIUS > b.x + b.w ||
                ball.y + BALL_RADIUS < b.y || ball.y - BALL_RADIUS > b.y + b.h) { continue; }

            b.alive = false;
            score += ROW_POINTS[b.row] || 10;
            sfxBrick();

            var overlapX = Math.min(ball.x + BALL_RADIUS - b.x, b.x + b.w - (ball.x - BALL_RADIUS));
            var overlapY = Math.min(ball.y + BALL_RADIUS - b.y, b.y + b.h - (ball.y - BALL_RADIUS));
            if (overlapX < overlapY) { ball.vx = -ball.vx; } else { ball.vy = -ball.vy; }
            break;
        }

        if (bricks.length && bricks.every(function (b) { return !b.alive; })) {
            nextWave();
        }
    }

    // Render
    function drawPaddle() {
        ctx.strokeStyle = "#33ff33";
        ctx.lineWidth = LINE_WIDTH;
        ctx.strokeRect(paddle.x, paddle.y, PADDLE_W, PADDLE_H);
        ctx.fillStyle = "#114411";
        ctx.fillRect(paddle.x, paddle.y, PADDLE_W, PADDLE_H);
    }

    function drawBall() {
        ctx.strokeStyle = "#33ff33";
        ctx.lineWidth = LINE_WIDTH;
        ctx.beginPath();
        ctx.arc(ball.x, ball.y, BALL_RADIUS, 0, Math.PI * 2);
        ctx.stroke();
    }

    function drawBricks() {
        for (var i = 0; i < bricks.length; i++) {
            var b = bricks[i];
            if (!b.alive) { continue; }
            ctx.strokeStyle = ROW_COLORS[b.row] || "#33ff33";
            ctx.lineWidth = LINE_WIDTH;
            ctx.strokeRect(b.x, b.y, b.w, b.h);
        }
    }

    function render() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);

        if (!started || gameOver) { return; }

        drawBricks();
        drawPaddle();
        drawBall();

        document.getElementById("score").textContent = "SCORE " + score;
        document.getElementById("lives").textContent = "LIVES " + Math.max(0, lives);
        document.getElementById("highscore").textContent = "HIGH " + highScore;
    }

    // Main loop
    score = 0; lives = 3; highScore = 0; started = false; gameOver = false; launched = false;
    bricks = [];

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
