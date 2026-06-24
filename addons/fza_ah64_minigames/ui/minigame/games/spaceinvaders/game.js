(function () {
    "use strict";

    var GAME_ID = "spaceinvaders";
    var SCALE = 1.25;
    var LINE_WIDTH = 3;

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

    function sfxShoot() { window.fzaMinigame.playSfx("shoot"); }
    function sfxKill() { window.fzaMinigame.playSfx("explosionSmall"); }
    function sfxDeath() { window.fzaMinigame.playSfx("death"); }

    window.fza_minigame_setMuted = function (isMuted) {
        var btn = document.getElementById("muteBtn");
        if (btn) { btn.classList.toggle("active", !isMuted); }
    };

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

    // Input: left/right move the cannon, down fires. Up is unused for this game.
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
    var player, invaders, playerBullets, invaderBullets, particles, bunkers;
    var score, lives, highScore, started, gameOver, fireTimer, invaderFireTimer;
    var fleetDir, fleetStepTimer, fleetStepInterval, waveNumber;
    var ufo, ufoTimer;

    var ROWS = 4;
    var COLS = 8;
    var INVADER_W = 24 * SCALE;
    var INVADER_H = 16 * SCALE;
    var INVADER_GAP_X = 14 * SCALE;
    var INVADER_GAP_Y = 16 * SCALE;

    var BUNKER_COUNT = 4;
    var BUNKER_W = 44 * SCALE;
    var BUNKER_H = 26 * SCALE;
    var BUNKER_MAX_HP = 4;

    var UFO_W = 36 * SCALE;
    var UFO_H = 14 * SCALE;
    var UFO_Y = 16 * SCALE;
    var UFO_SCORES = [50, 100, 150, 300];

    // Diver - from wave 2 onward, an invader periodically breaks formation and dives at the player. Tougher than a
    // regular invader (2 hits, like Galaga's "Boss Galaga" - color shifts on the first hit as a clear warning) and
    // dangerous if ignored: reaching the bottom uncontested ends the game outright, same severity as the whole
    // fleet reaching the player's row. Dodging is deliberate but partial, not a guaranteed escape: a bullet has to
    // get fairly close before it's noticed, and there's a short reaction lag before it actually moves - so it
    // visibly tries to juke a close shot, but standing still and leading your shots correctly still kills it. The
    // first version of this had a long detection range and no reaction lag, which let it dodge every single shot
    // with time to spare - tuned down after testing showed it was literally unkillable.
    var diverTimer;
    var MIN_WAVE_FOR_DIVERS = 1; // waveNumber is 0-indexed, so this is "the 2nd wave"
    var DIVE_SPEED = 70 * SCALE;
    var DIVE_HOMING = 50 * SCALE;
    var DIVE_DODGE_SPEED = 137 * SCALE;
    var DIVER_MAX_HP = 2;
    var DIVER_DODGE_RANGE_X = 26 * SCALE;
    var DIVER_DODGE_RANGE_Y = 35 * SCALE;
    var DIVER_DODGE_REACTION = 0.07;

    function spawnBunkers() {
        bunkers = [];
        var totalW = W * 0.7;
        var startX = (W - totalW) / 2;
        var gap = totalW / BUNKER_COUNT;
        for (var i = 0; i < BUNKER_COUNT; i++) {
            bunkers.push({
                x: startX + gap * i + (gap - BUNKER_W) / 2,
                y: player.y - 120 * SCALE,
                w: BUNKER_W,
                h: BUNKER_H,
                hp: BUNKER_MAX_HP
            });
        }
    }

    function resetUfoTimer() {
        ufoTimer = 8 + Math.random() * 8;
    }

    function spawnUfo() {
        var fromLeft = Math.random() < 0.5;
        ufo = {
            x: fromLeft ? -UFO_W : W + UFO_W,
            y: UFO_Y,
            w: UFO_W,
            h: UFO_H,
            vx: (fromLeft ? 1 : -1) * 70 * SCALE
        };
    }

    function resetPlayer() {
        player = {
            x: W / 2,
            y: H - 90 * SCALE,
            w: 22 * SCALE,
            h: 14 * SCALE,
            invuln: 1.5
        };
    }

    function spawnWave() {
        invaders = [];
        var fleetW = COLS * (INVADER_W + INVADER_GAP_X);
        var startX = (W - fleetW) / 2;
        var startY = 40 * SCALE;
        for (var r = 0; r < ROWS; r++) {
            for (var c = 0; c < COLS; c++) {
                invaders.push({
                    x: startX + c * (INVADER_W + INVADER_GAP_X),
                    y: startY + r * (INVADER_H + INVADER_GAP_Y),
                    w: INVADER_W,
                    h: INVADER_H,
                    row: r,
                    alive: true,
                    diving: false,
                    hp: 1
                });
            }
        }
        fleetDir = 1;
        fleetStepTimer = 0;
        fleetStepInterval = Math.max(0.06, 0.4 - waveNumber * 0.05);
    }

    function startGame() {
        if (started && !gameOver) { return; }
        score = 0;
        lives = 3;
        waveNumber = 0;
        playerBullets = [];
        invaderBullets = [];
        particles = [];
        fireTimer = 0;
        invaderFireTimer = 1;
        gameOver = false;
        started = true;
        resetPlayer();
        spawnWave();
        spawnBunkers();
        ufo = null;
        resetUfoTimer();
        diverTimer = 5 + Math.random() * 3;
        document.getElementById("overlay").classList.add("hidden");
    }

    // b4 bezel button - returns to the start screen (does not immediately begin a new game, unlike pressing a key).
    window.fza_minigame_restart = function () {
        started = false;
        gameOver = false;
        score = 0;
        lives = 3;
        waveNumber = 0;
        invaders = [];
        playerBullets = [];
        invaderBullets = [];
        particles = [];
        bunkers = [];
        ufo = null;
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

    function explode(x, y, n) {
        for (var i = 0; i < n; i++) {
            var a = Math.random() * Math.PI * 2;
            var s = 30 + Math.random() * 60;
            particles.push({ x: x, y: y, vx: Math.cos(a) * s, vy: Math.sin(a) * s, life: 0.4 + Math.random() * 0.3 });
        }
    }

    function aliveInvaders() {
        var out = [];
        for (var i = 0; i < invaders.length; i++) { if (invaders[i].alive) { out.push(invaders[i]); } }
        return out;
    }

    // Diving invaders break off from the formation, so they're excluded from the fleet march/edge-detection.
    function marchingInvaders() {
        var out = [];
        for (var i = 0; i < invaders.length; i++) { if (invaders[i].alive && !invaders[i].diving) { out.push(invaders[i]); } }
        return out;
    }

    function update(dt) {
        if (!started || gameOver) { return; }

        if (keys.left) { player.x -= 160 * SCALE * dt; }
        if (keys.right) { player.x += 160 * SCALE * dt; }
        player.x = Math.max(player.w / 2, Math.min(W - player.w / 2, player.x));
        if (player.invuln > 0) { player.invuln -= dt; }

        fireTimer -= dt;
        if (keys.down && fireTimer <= 0) {
            fireTimer = 0.6; // half the rate of fire
            playerBullets.push({ x: player.x, y: player.y - player.h, vy: -300 });
            sfxShoot();
        }

        for (var pbi = playerBullets.length - 1; pbi >= 0; pbi--) {
            playerBullets[pbi].y += playerBullets[pbi].vy * dt;
            if (playerBullets[pbi].y < -10) { playerBullets.splice(pbi, 1); }
        }
        for (var ibi = invaderBullets.length - 1; ibi >= 0; ibi--) {
            invaderBullets[ibi].y += invaderBullets[ibi].vy * dt;
            if (invaderBullets[ibi].y > H + 10) { invaderBullets.splice(ibi, 1); }
        }

        // Bunkers absorb both player and invader bullets before they can reach their target, eroding as they take hits.
        for (var bi = 0; bi < bunkers.length; bi++) {
            var bunker = bunkers[bi];
            if (bunker.hp <= 0) { continue; }
            for (pbi = playerBullets.length - 1; pbi >= 0; pbi--) {
                var pbb = playerBullets[pbi];
                if (pbb.x > bunker.x && pbb.x < bunker.x + bunker.w && pbb.y > bunker.y && pbb.y < bunker.y + bunker.h) {
                    playerBullets.splice(pbi, 1);
                    bunker.hp -= 1;
                }
            }
            for (ibi = invaderBullets.length - 1; ibi >= 0; ibi--) {
                var ibb = invaderBullets[ibi];
                if (ibb.x > bunker.x && ibb.x < bunker.x + bunker.w && ibb.y > bunker.y && ibb.y < bunker.y + bunker.h) {
                    invaderBullets.splice(ibi, 1);
                    bunker.hp -= 1;
                }
            }
        }

        // Bonus UFO - periodic, optional kill for extra points, no penalty if it's allowed to cross.
        if (ufo) {
            ufo.x += ufo.vx * dt;
            if (ufo.x < -UFO_W * 2 || ufo.x > W + UFO_W * 2) {
                ufo = null;
                resetUfoTimer();
            }
        } else {
            ufoTimer -= dt;
            if (ufoTimer <= 0) { spawnUfo(); }
        }
        if (ufo) {
            for (pbi = playerBullets.length - 1; pbi >= 0; pbi--) {
                var ufoBullet = playerBullets[pbi];
                if (ufoBullet.x > ufo.x - ufo.w / 2 && ufoBullet.x < ufo.x + ufo.w / 2 && ufoBullet.y > ufo.y && ufoBullet.y < ufo.y + ufo.h) {
                    playerBullets.splice(pbi, 1);
                    explode(ufo.x, ufo.y + ufo.h / 2, 10);
                    sfxKill();
                    score += UFO_SCORES[Math.floor(Math.random() * UFO_SCORES.length)];
                    ufo = null;
                    resetUfoTimer();
                    break;
                }
            }
        }

        // Fleet march: step sideways continuously, drop a row and reverse at the edges. Diving invaders are excluded.
        var alive = marchingInvaders();
        var minX = Infinity, maxX = -Infinity, maxY = -Infinity;
        for (var i = 0; i < alive.length; i++) {
            minX = Math.min(minX, alive[i].x);
            maxX = Math.max(maxX, alive[i].x + alive[i].w);
            maxY = Math.max(maxY, alive[i].y + alive[i].h);
        }
        fleetStepTimer -= dt;
        if (alive.length > 0 && fleetStepTimer <= 0) {
            fleetStepTimer = fleetStepInterval;
            var hitEdge = (fleetDir > 0 && maxX >= W - 10) || (fleetDir < 0 && minX <= 10);
            if (hitEdge) {
                fleetDir *= -1;
                for (i = 0; i < alive.length; i++) { alive[i].y += INVADER_H + INVADER_GAP_Y; }
            } else {
                for (i = 0; i < alive.length; i++) { alive[i].x += fleetDir * 11 * SCALE; }
            }
        }

        // Invaders reaching the player's row is an instant loss, classic rule (a lone diver doesn't count - see below).
        if (alive.length > 0 && maxY >= player.y - player.h) { endGame(); return; }

        invaderFireTimer -= dt;
        if (alive.length > 0 && invaderFireTimer <= 0) {
            invaderFireTimer = Math.max(0.4, 1.4 - waveNumber * 0.1);
            var shooter = alive[Math.floor(Math.random() * alive.length)];
            invaderBullets.push({ x: shooter.x + shooter.w / 2, y: shooter.y + shooter.h, vy: 180 });
        }

        // Diver - peels an invader off the formation to dive at the player. Tougher than regular invaders (2 HP)
        // and a real threat: reaching the bottom uncontested ends the game, same as the whole fleet getting through.
        if (waveNumber >= MIN_WAVE_FOR_DIVERS) {
            diverTimer -= dt;
            if (diverTimer <= 0 && alive.length > 0) {
                diverTimer = 6 + Math.random() * 5;
                var newDiver = alive[Math.floor(Math.random() * alive.length)];
                newDiver.diving = true;
                newDiver.hp = DIVER_MAX_HP;
            }
        }
        for (i = 0; i < invaders.length; i++) {
            var diver = invaders[i];
            if (!diver.alive || !diver.diving) { continue; }
            diver.y += DIVE_SPEED * dt;

            // Deliberately dodge the most urgent player bullet lined up with this column, instead of homing that
            // frame - a sustained straight-up stream keeps triggering this every frame, so camping in one spot
            // no longer guarantees a free kill; leading the shot or moving to follow the diver does.
            var threatX = null, threatDist = Infinity;
            for (pbi = 0; pbi < playerBullets.length; pbi++) {
                var tb = playerBullets[pbi];
                var dy = tb.y - diver.y;
                if (dy > 0 && dy < DIVER_DODGE_RANGE_Y && Math.abs(tb.x - diver.x) < DIVER_DODGE_RANGE_X && dy < threatDist) {
                    threatX = tb.x;
                    threatDist = dy;
                }
            }
            if (threatX !== null) {
                diver.dodgeTimer = (diver.dodgeTimer || 0) + dt;
                if (diver.dodgeTimer > DIVER_DODGE_REACTION) {
                    diver.x += (diver.x >= threatX ? 1 : -1) * DIVE_DODGE_SPEED * dt;
                }
            } else {
                diver.dodgeTimer = 0;
                diver.x += Math.sign(player.x - diver.x) * DIVE_HOMING * dt;
            }
            diver.x = Math.max(diver.w / 2, Math.min(W - diver.w / 2, diver.x));

            if (diver.y > H) { endGame(); return; }
            if (player.invuln <= 0 && diver.x > player.x - player.w / 2 && diver.x < player.x + player.w / 2 && diver.y + diver.h > player.y - player.h && diver.y < player.y) {
                diver.alive = false;
                explode(player.x, player.y, 14);
                lives -= 1;
                if (lives <= 0) { endGame(); return; }
                resetPlayer();
            }
        }

        // Player bullet vs invader - regular invaders die in one hit, but a diver (2 HP) takes a second to confirm.
        for (pbi = playerBullets.length - 1; pbi >= 0; pbi--) {
            var pb = playerBullets[pbi];
            for (i = 0; i < invaders.length; i++) {
                var inv = invaders[i];
                if (!inv.alive) { continue; }
                if (pb.x > inv.x && pb.x < inv.x + inv.w && pb.y > inv.y && pb.y < inv.y + inv.h) {
                    playerBullets.splice(pbi, 1);
                    inv.hp -= 1;
                    if (inv.hp <= 0) {
                        inv.alive = false;
                        explode(inv.x + inv.w / 2, inv.y + inv.h / 2, 8);
                        sfxKill();
                        score += (ROWS - inv.row) * 10;
                    } else {
                        sfxShoot();
                    }
                    break;
                }
            }
        }

        // Invader bullet vs player
        if (player.invuln <= 0) {
            for (ibi = invaderBullets.length - 1; ibi >= 0; ibi--) {
                var ib = invaderBullets[ibi];
                if (ib.x > player.x - player.w / 2 && ib.x < player.x + player.w / 2 && ib.y > player.y - player.h && ib.y < player.y) {
                    invaderBullets.splice(ibi, 1);
                    explode(player.x, player.y, 14);
                    lives -= 1;
                    if (lives <= 0) { endGame(); return; }
                    resetPlayer();
                    break;
                }
            }
        }

        if (aliveInvaders().length === 0) {
            waveNumber += 1;
            spawnWave();
        }

        for (var pi = particles.length - 1; pi >= 0; pi--) {
            var p = particles[pi];
            p.x += p.vx * dt;
            p.y += p.vy * dt;
            p.life -= dt;
            if (p.life <= 0) { particles.splice(pi, 1); }
        }
    }

    function drawPlayer() {
        if (player.invuln > 0 && Math.floor(player.invuln * 8) % 2 === 0) { return; }
        ctx.strokeStyle = "#33ff33";
        ctx.lineWidth = LINE_WIDTH;
        ctx.beginPath();
        ctx.moveTo(player.x - player.w / 2, player.y);
        ctx.lineTo(player.x + player.w / 2, player.y);
        ctx.lineTo(player.x + player.w / 2, player.y - player.h * 0.4);
        ctx.lineTo(player.x + player.w * 0.15, player.y - player.h * 0.4);
        ctx.lineTo(player.x, player.y - player.h);
        ctx.lineTo(player.x - player.w * 0.15, player.y - player.h * 0.4);
        ctx.lineTo(player.x - player.w / 2, player.y - player.h * 0.4);
        ctx.closePath();
        ctx.stroke();
    }

    function drawInvader(inv) {
        var color = "#33ff33";
        if (inv.diving) { color = inv.hp <= 1 ? "#ff3333" : "#ff6633"; }
        ctx.strokeStyle = color;
        ctx.lineWidth = LINE_WIDTH;
        ctx.strokeRect(inv.x, inv.y, inv.w, inv.h);
        ctx.beginPath();
        ctx.moveTo(inv.x + 3, inv.y + inv.h);
        ctx.lineTo(inv.x + inv.w - 3, inv.y + inv.h);
        ctx.stroke();
    }

    function drawBunker(b) {
        if (b.hp <= 0) { return; }
        var ratio = b.hp / BUNKER_MAX_HP;
        var w = b.w * ratio;
        var h = b.h * ratio;
        var colors = ["#ff3333", "#ff9933", "#cccc33", "#33ff33"];
        ctx.fillStyle = colors[Math.max(0, b.hp - 1)];
        ctx.fillRect(b.x + (b.w - w) / 2, b.y + (b.h - h), w, h);
    }

    function drawUfo() {
        if (!ufo) { return; }
        ctx.strokeStyle = "#ff33ff";
        ctx.lineWidth = LINE_WIDTH;
        ctx.beginPath();
        ctx.ellipse(ufo.x, ufo.y + ufo.h / 2, ufo.w / 2, ufo.h / 2, 0, 0, Math.PI * 2);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(ufo.x - ufo.w * 0.3, ufo.y + ufo.h * 0.3);
        ctx.lineTo(ufo.x + ufo.w * 0.3, ufo.y + ufo.h * 0.3);
        ctx.stroke();
    }

    function render() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);

        if (!started || gameOver) { return; }

        drawPlayer();
        for (var i = 0; i < invaders.length; i++) { if (invaders[i].alive) { drawInvader(invaders[i]); } }
        for (i = 0; i < bunkers.length; i++) { drawBunker(bunkers[i]); }
        drawUfo();

        ctx.fillStyle = "#33ff33";
        var bulletSize = 2 * SCALE;
        for (i = 0; i < playerBullets.length; i++) {
            ctx.fillRect(playerBullets[i].x - bulletSize / 2, playerBullets[i].y - bulletSize / 2, bulletSize, bulletSize * 3);
        }
        ctx.fillStyle = "#ff9933";
        for (i = 0; i < invaderBullets.length; i++) {
            ctx.fillRect(invaderBullets[i].x - bulletSize / 2, invaderBullets[i].y - bulletSize / 2, bulletSize, bulletSize * 3);
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

    score = 0; lives = 3; highScore = 0; started = false; gameOver = false;
    invaders = []; playerBullets = []; invaderBullets = []; particles = []; waveNumber = 0;
    bunkers = []; ufo = null; ufoTimer = 0;

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
