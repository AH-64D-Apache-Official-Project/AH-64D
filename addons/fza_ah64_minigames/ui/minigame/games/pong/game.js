(function () {
    "use strict";

    var GAME_ID = "pong";
    var LINE_WIDTH = 3;

    var canvas = document.getElementById("canvas");
    var ctx = canvas.getContext("2d");
    var W = 0, H = 0;
    // Play area is inset from the full canvas - top clears the name/score HUD rows, bottom clears the bezel buttons.
    var TOP_MARGIN = 0, BOTTOM_MARGIN = 0;

    function resize() {
        W = canvas.clientWidth || window.innerWidth;
        H = canvas.clientHeight || window.innerHeight;
        canvas.width = W;
        canvas.height = H;
        TOP_MARGIN = H * 0.14;
        BOTTOM_MARGIN = H * 0.16;
    }
    window.addEventListener("resize", resize);
    resize();

    function sfxHit() { window.fzaMinigame.playSfx("shoot"); }
    function sfxScore() { window.fzaMinigame.playSfx("explosionSmall"); }
    function sfxWin() { window.fzaMinigame.playSfx("death"); }

    window.fza_minigame_setMuted = function (isMuted) {
        var btn = document.getElementById("muteBtn");
        if (btn) { btn.classList.toggle("active", !isMuted); }
    };

    // My own record, pushed by fn_minigameReportResult.sqf/fn_minigameReady.sqf. Forwarded to a connected peer
    // immediately, since their machine has no way to read my profileNamespace - see updateRecords() below.
    var myRecord = { wins: 0, losses: 0 };
    var peerRecord = { wins: 0, losses: 0 };

    window.fza_minigame_setRecord = function (wins, losses) {
        myRecord.wins = wins; myRecord.losses = losses;
        updateRecords();
        if (peerConnected) { window.fzaMinigame.netSend(GAME_ID, ["record", wins, losses]); }
    };

    function updateRecords() {
        var elLeft = document.getElementById("recordLeft");
        var elRight = document.getElementById("recordRight");
        var myText = "W-L " + myRecord.wins + "-" + myRecord.losses;
        var peerText = peerConnected ? ("W-L " + peerRecord.wins + "-" + peerRecord.losses) : "—";
        if (elLeft) { elLeft.textContent = role === "guest" ? peerText : myText; }
        if (elRight) { elRight.textContent = role === "guest" ? myText : peerText; }
    }

    // Input: up/down move your own paddle (left if host, right if guest). left/right unused.
    var keys = { up: false, down: false, left: false, right: false };

    function setKey(action, isDown) {
        if (!(action in keys)) { return; }
        keys[action] = !!isDown;
        if (role === "host" && isDown && (!started || gameOver)) { startGame(); }
    }

    window.fza_minigame_input = function (action, isDown) {
        setKey(action, isDown);
    };

    var KEY_MAP = {
        ArrowUp: "up", w: "up", W: "up",
        ArrowDown: "down", s: "down", S: "down"
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
    window.fza_minigame_setPaused = function (isPaused) { autoPaused = !!isPaused; };
    window.fza_minigame_setManualPaused = function (isPaused) {
        manualPaused = !!isPaused;
        var btn = document.getElementById("pauseBtn");
        if (btn) { btn.classList.toggle("active", manualPaused); }
    };

    // Networking - role/peer assignment comes from the server via fn_minigameNetJoin.sqf's handshake.
    var role = null; // "host" (always left paddle) or "guest" (always right paddle)
    var peerConnected = false;
    var reportedThisGame = false;
    var myName = "", peerName = "";

    // Ball physics authority is distributed by half-court rather than always living on the host: whichever side
    // the ball is currently on runs its own movement/bounce/paddle-collision locally, using its own zero-latency
    // input, then hands off to the other side immediately after bouncing off its own paddle (or, for the very
    // first hit of a serve, right when the serve direction is decided) - not at the center line, since that gave
    // the receiving side only half the ball's cross-court travel time to receive and act on the handoff before
    // needing to check their own paddle collision. Handing off at the source instead gives them the maximum
    // possible time. Irrelevant when solo vs AI - host always holds authority in that case.
    var ballAuthority = "host";
    var targetPeerPaddleY = 0;

    function updateNames() {
        var elLeft = document.getElementById("nameLeft");
        var elRight = document.getElementById("nameRight");
        if (elLeft) { elLeft.textContent = (role === "host" ? myName : peerName) || "HOST"; }
        if (elRight) { elRight.textContent = (role === "host" ? (peerName || "AI") : myName) || "GUEST"; }
    }

    function showOverlay(text) {
        document.getElementById("overlaySub").textContent = text;
        document.getElementById("overlay").classList.remove("hidden");
    }

    function applyScore(newScore1, newScore2, isGameOver) {
        score1 = newScore1; score2 = newScore2;
        if (isGameOver && !gameOver) {
            gameOver = true;
            reportedThisGame = false;
        }
        if (!isGameOver && gameOver) {
            gameOver = false;
            document.getElementById("overlay").classList.add("hidden");
        }
        if (gameOver && !reportedThisGame) {
            reportedThisGame = true;
            sfxWin();
            // Only ever called from the guest's own "score" netRecv branch (host reports its own result directly
            // in endGame()), so this is always the guest's perspective: they won if their own score (score2, the
            // right paddle) ended up higher.
            window.fzaMinigame.reportResult(GAME_ID, score2 > score1);
            showOverlay((score1 > score2 ? "LEFT" : "RIGHT") + " WINS " + score1 + "-" + score2);
        }
    }

    window.fza_minigame_netRecv = function (payload) {
        var type = payload[0];
        if (type === "role") {
            role = payload[1];
            var peerOwner = payload[2];
            myName = payload[3] || "";
            peerName = payload[4] || "";
            var wasPeerConnected = peerConnected;
            peerConnected = (role === "host") ? (peerOwner !== -1) : true;
            updateNames();
            updateRecords();
            if (peerConnected && !wasPeerConnected) { window.fzaMinigame.netSend(GAME_ID, ["record", myRecord.wins, myRecord.losses]); }
            // "connecting..." (the static default) only applies before role is known - once assigned, guest
            // is genuinely connected and just waiting on the host, which is a different state worth saying clearly.
            showOverlay(role === "host" ? "press any key to start" : "waiting for host to start");
        } else if (type === "peer") {
            var wasConnected = peerConnected;
            peerConnected = payload[1];
            var hostLeft = payload[2];
            peerName = payload[3] || "";
            if (!peerConnected) { peerRecord.wins = 0; peerRecord.losses = 0; }
            updateNames();
            updateRecords();
            if (peerConnected && !wasConnected) { window.fzaMinigame.netSend(GAME_ID, ["record", myRecord.wins, myRecord.losses]); }
            if (role === "guest" && hostLeft) {
                started = false;
                showOverlay("HOST DISCONNECTED");
            }
            if (role === "host" && !peerConnected && ball) {
                // Guest left (or was never there) - reclaim ball authority unconditionally so the rally doesn't
                // freeze waiting for a side that's no longer going to respond, then let AI take over as usual.
                ballAuthority = "host";
                if (started && !gameOver) { resetBall(Math.random() < 0.5 ? 1 : -1); }
            }
        } else if (type === "record") {
            peerRecord.wins = payload[1]; peerRecord.losses = payload[2];
            updateRecords();
        } else if (type === "paddle") {
            // Either side's own paddle position, for rendering the OTHER paddle only - never used for collision,
            // since collision against a given paddle only ever happens on that same paddle's own side locally.
            targetPeerPaddleY = payload[1];
        } else if (type === "ballSync") {
            if (ballAuthority === role) { return; } // I'm authoritative right now, my own simulation is the truth
            var syncX = payload[1], syncY = payload[2], syncVx = payload[3], syncVy = payload[4], syncSpeedMul = payload[5];
            if (!ball) {
                ball = { x: syncX, y: syncY, vx: syncVx, vy: syncVy, speedMul: syncSpeedMul };
            } else {
                // Dead-reckoning (see ghostStepBall) already keeps this close between updates since both sides
                // run identical movement/wall-bounce math - blend in any drift rather than snapping outright.
                ball.x += (syncX - ball.x) * 0.5;
                ball.y += (syncY - ball.y) * 0.5;
                ball.vx = syncVx; ball.vy = syncVy; ball.speedMul = syncSpeedMul;
            }
        } else if (type === "handoff") {
            ballAuthority = role;
            ball = ball || {};
            ball.x = payload[1]; ball.y = payload[2];
            ball.vx = payload[3]; ball.vy = payload[4]; ball.speedMul = payload[5];
        } else if (type === "scored") {
            // Only ever sent guest -> host: the guest missed on their own half, so the host's score increments.
            if (role !== "host") { return; }
            sfxScore();
            score1 += 1;
            if (score1 >= WIN_SCORE) { endGame(); } else { resetBall(-1); }
        } else if (type === "score") {
            if (role !== "guest") { return; }
            applyScore(payload[1], payload[2], payload[3]);
            if (!started) {
                started = true;
                // My own paddle is always locally controlled, never set from the network - but it still needs a
                // sane starting position the first time the game actually starts, same as the host's does in
                // startGame(), or it'd sit wherever it was last left (the very top, on a fresh load).
                paddleR.y = playAreaCenterY();
                document.getElementById("overlay").classList.add("hidden");
            }
        } else if (type === "reset") {
            // Host hit the restart button and went back to their start screen - mirror that rather than
            // freezing on the last known state with no indication the host backed out.
            if (role !== "guest") { return; }
            started = false;
            score1 = 0; score2 = 0;
            document.getElementById("scoreLeft").textContent = "0";
            document.getElementById("scoreRight").textContent = "0";
            showOverlay("waiting for host to start");
        }
    };

    // Game state
    var ball, paddleL, paddleR, score1, score2, started, gameOver;
    var PADDLE_H = 70, PADDLE_W = 12, PADDLE_MARGIN = 24;
    var WIN_SCORE = 6;
    var netSendTimer = 0;
    var NET_SEND_INTERVAL = 1 / 18; // ~18Hz - faster than the mod's usual 10Hz throttle since the ball moves quickly

    // Ball speeds up the longer a rally runs (not per-bounce, continuously over time), resetting each new rally.
    var RALLY_SPEEDUP_PER_SEC = 0.035;
    var RALLY_MAX_SPEED_MUL = 1.6;

    // AI: reacts in bursts rather than tracking every frame, and aims with some imprecision - feels less robotic.
    var aiTargetY = 0;
    var aiReactionTimer = 0;

    function playAreaCenterY() {
        return (TOP_MARGIN + (H - BOTTOM_MARGIN)) / 2;
    }

    // Predicts where the ball will actually be when it reaches the AI's paddle, by simulating the straight-line
    // path and any wall bounces along the way - not just chasing the ball's current Y, which has no way to
    // anticipate a bounce and falls further behind as the rally speeds up.
    function predictBallY() {
        if (!ball || ball.vx <= 0) { return playAreaCenterY(); } // moving away - no need to predict, just recenter
        var effVx = ball.vx * ball.speedMul;
        var effVy = ball.vy * ball.speedMul;
        var targetX = W - PADDLE_MARGIN - PADDLE_W;
        var remaining = (targetX - ball.x) / effVx;
        if (remaining <= 0) { return ball.y; }

        var simY = ball.y, simVy = effVy;
        var top = TOP_MARGIN + 6, bottom = H - BOTTOM_MARGIN - 6;
        var guard = 0;
        while (remaining > 0 && guard < 20) {
            guard++;
            if (simVy === 0) { break; }
            var distToWall = simVy > 0 ? (bottom - simY) : (simY - top);
            var timeToWall = distToWall / Math.abs(simVy);
            if (timeToWall >= remaining) {
                simY += simVy * remaining;
                remaining = 0;
            } else {
                simY += simVy * timeToWall;
                simVy *= -1;
                remaining -= timeToWall;
            }
        }
        return simY;
    }

    function resetBall(dir) {
        ball = { x: W / 2, y: playAreaCenterY(), vx: 220 * dir, vy: (Math.random() * 160 - 80), speedMul: 1 };
        ballAuthority = "host";
        if (peerConnected) {
            window.fzaMinigame.netSend(GAME_ID, ["score", score1, score2, gameOver]);
            if (dir > 0) {
                // Serving toward the guest - hand off immediately rather than waiting for any bounce or position
                // threshold, giving them the full cross-court travel time to prepare for it.
                window.fzaMinigame.netSend(GAME_ID, ["handoff", ball.x, ball.y, ball.vx, ball.vy, ball.speedMul]);
                ballAuthority = "guest";
            }
        }
    }

    function startGame() {
        if (started && !gameOver) { return; }
        score1 = 0; score2 = 0;
        gameOver = false;
        started = true;
        paddleL.y = playAreaCenterY();
        paddleR.y = playAreaCenterY();
        aiReactionTimer = 0;
        resetBall(Math.random() < 0.5 ? 1 : -1);
        document.getElementById("overlay").classList.add("hidden");
    }

    // b4 bezel button - host-only (guest doesn't run the simulation, so their button is a no-op). Returns to the
    // start screen rather than immediately beginning a new match, and tells a connected guest to do the same -
    // otherwise the guest's last known state just freezes on screen with no indication the host backed out.
    window.fza_minigame_restart = function () {
        if (role === "guest") { return; }
        started = false;
        gameOver = false;
        score1 = 0; score2 = 0;
        ball = null;
        ballAuthority = "host";
        document.getElementById("scoreLeft").textContent = "0";
        document.getElementById("scoreRight").textContent = "0";
        showOverlay("press any key to start");
        if (peerConnected) { window.fzaMinigame.netSend(GAME_ID, ["reset"]); }
    };

    function endGame() {
        gameOver = true;
        sfxWin();
        window.fzaMinigame.reportResult(GAME_ID, score1 > score2);
        showOverlay((score1 > score2 ? "LEFT" : "RIGHT") + " WINS " + score1 + "-" + score2 + " - press any key to restart");
        if (peerConnected) {
            window.fzaMinigame.netSend(GAME_ID, ["score", score1, score2, true]);
        }
    }

    function aiMove(dt) {
        aiReactionTimer -= dt;
        if (aiReactionTimer <= 0) {
            aiReactionTimer = 0.15 + Math.random() * 0.15; // reacts every 150-300ms, not every frame
            aiTargetY = predictBallY() + (Math.random() - 0.5) * 50; // imprecise aim, not a dead-on lock
        }
        var dz = 10; // deadzone so the AI isn't perfectly precise
        var speed = 150;
        if (Math.abs(paddleR.y - aiTargetY) > dz) {
            paddleR.y += (paddleR.y < aiTargetY ? 1 : -1) * speed * dt;
        }
        paddleR.y = Math.max(TOP_MARGIN + PADDLE_H / 2, Math.min(H - BOTTOM_MARGIN - PADDLE_H / 2, paddleR.y));
    }

    // Runs ball movement/wall-bounce/own-paddle-collision for whichever side currently holds ballAuthority - only
    // ever called when ballAuthority === role, so "my own paddle" always means paddleL for host, paddleR for
    // guest. Hands off to the other side immediately once it bounces off my own paddle (the ball is now
    // definitely heading away from me), or reports/applies a score if it gets past my own paddle without ever
    // needing the other side's input at all.
    function stepBall(dt) {
        ball.speedMul = Math.min(RALLY_MAX_SPEED_MUL, ball.speedMul + RALLY_SPEEDUP_PER_SEC * dt);
        ball.x += ball.vx * ball.speedMul * dt;
        ball.y += ball.vy * ball.speedMul * dt;
        if (ball.y < TOP_MARGIN + 6) { ball.y = TOP_MARGIN + 6; ball.vy *= -1; }
        if (ball.y > H - BOTTOM_MARGIN - 6) { ball.y = H - BOTTOM_MARGIN - 6; ball.vy *= -1; }

        if (role === "host") {
            if (ball.vx < 0 && ball.x <= PADDLE_MARGIN + PADDLE_W && ball.x > PADDLE_MARGIN - 10 && Math.abs(ball.y - paddleL.y) < PADDLE_H / 2 + 6) {
                ball.x = PADDLE_MARGIN + PADDLE_W;
                ball.vx *= -1.05;
                ball.vy += (ball.y - paddleL.y) * 2.5;
                sfxHit();
                if (peerConnected) {
                    window.fzaMinigame.netSend(GAME_ID, ["handoff", ball.x, ball.y, ball.vx, ball.vy, ball.speedMul]);
                    ballAuthority = "guest";
                }
                return;
            }
            if (ball.x < -20) {
                sfxScore();
                score2 += 1;
                if (score2 >= WIN_SCORE) { endGame(); } else { resetBall(1); }
            }
        } else {
            if (ball.vx > 0 && ball.x >= W - PADDLE_MARGIN - PADDLE_W && ball.x < W - PADDLE_MARGIN + 10 && Math.abs(ball.y - paddleR.y) < PADDLE_H / 2 + 6) {
                ball.x = W - PADDLE_MARGIN - PADDLE_W;
                ball.vx *= -1.05;
                ball.vy += (ball.y - paddleR.y) * 2.5;
                sfxHit();
                window.fzaMinigame.netSend(GAME_ID, ["handoff", ball.x, ball.y, ball.vx, ball.vy, ball.speedMul]);
                ballAuthority = "host";
                return;
            }
            if (ball.x > W + 20) {
                // I missed - I don't own score state, so just report it and wait for the host's authoritative reply.
                window.fzaMinigame.netSend(GAME_ID, ["scored"]);
                ballAuthority = "host";
            }
        }
    }

    // Non-authoritative side only: dead-reckons the ball forward every frame using its last known velocity (and
    // the same wall-bounce math the authoritative side uses), so it never visibly stops moving between the
    // ~18Hz ballSync updates - those just lightly correct any drift (see the "ballSync" netRecv branch) rather
    // than the ball sitting frozen at a stale position until the next one arrives.
    function ghostStepBall(dt) {
        if (!ball || ballAuthority === role) { return; }
        ball.x += ball.vx * ball.speedMul * dt;
        ball.y += ball.vy * ball.speedMul * dt;
        if (ball.y < TOP_MARGIN + 6) { ball.y = TOP_MARGIN + 6; ball.vy *= -1; }
        if (ball.y > H - BOTTOM_MARGIN - 6) { ball.y = H - BOTTOM_MARGIN - 6; ball.vy *= -1; }
    }

    // Interpolates the peer's paddle (always received over the network, purely for rendering) toward its latest
    // reported value - never my own paddle, which is predicted locally with zero network involvement.
    function interpolatePeerVisuals(dt) {
        if (!peerConnected) { return; }
        var rate = Math.min(1, dt / NET_SEND_INTERVAL);
        var peerPaddle = role === "host" ? paddleR : paddleL;
        peerPaddle.y += (targetPeerPaddleY - peerPaddle.y) * rate;
    }

    function update(dt) {
        if (!started || gameOver) { return; }

        var speed = 220;
        var myPaddle = role === "host" ? paddleL : paddleR;
        if (keys.up) { myPaddle.y -= speed * dt; }
        if (keys.down) { myPaddle.y += speed * dt; }
        myPaddle.y = Math.max(TOP_MARGIN + PADDLE_H / 2, Math.min(H - BOTTOM_MARGIN - PADDLE_H / 2, myPaddle.y));

        if (role === "host" && !peerConnected) {
            aiMove(dt);
        }

        if (ball && ballAuthority === role) {
            stepBall(dt);
        }

        netSendTimer -= dt;
        if (netSendTimer <= 0) {
            netSendTimer = NET_SEND_INTERVAL;
            if (peerConnected) {
                window.fzaMinigame.netSend(GAME_ID, ["paddle", myPaddle.y]);
                if (ball && ballAuthority === role) {
                    window.fzaMinigame.netSend(GAME_ID, ["ballSync", ball.x, ball.y, ball.vx, ball.vy, ball.speedMul]);
                }
            }
        }
    }

    function drawNet() {
        ctx.strokeStyle = "#226622";
        ctx.lineWidth = LINE_WIDTH;
        ctx.setLineDash([10, 10]);
        ctx.beginPath();
        ctx.moveTo(W / 2, TOP_MARGIN);
        ctx.lineTo(W / 2, H - BOTTOM_MARGIN);
        ctx.stroke();
        ctx.setLineDash([]);
    }

    function drawPaddle(x, y) {
        ctx.fillStyle = "#33ff33";
        ctx.fillRect(x - PADDLE_W / 2, y - PADDLE_H / 2, PADDLE_W, PADDLE_H);
    }

    function render() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);

        if (!started || !ball) { return; }

        drawNet();
        drawPaddle(PADDLE_MARGIN, paddleL.y);
        drawPaddle(W - PADDLE_MARGIN, paddleR.y);
        if (!gameOver) {
            ctx.fillStyle = "#33ff33";
            ctx.fillRect(ball.x - 6, ball.y - 6, 12, 12);
        }

        document.getElementById("scoreLeft").textContent = score1;
        document.getElementById("scoreRight").textContent = score2;
    }

    score1 = 0; score2 = 0; started = false; gameOver = false;
    paddleL = { y: 0 }; paddleR = { y: 0 };

    var lastTime = null;
    function frame(t) {
        if (lastTime === null) { lastTime = t; }
        var dt = Math.min(0.05, (t - lastTime) / 1000);
        lastTime = t;
        if (!autoPaused && !manualPaused) { update(dt); ghostStepBall(dt); interpolatePeerVisuals(dt); }
        render();
        requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);

    window.fzaMinigame.ready(GAME_ID);
    window.fzaMinigame.netJoin(GAME_ID);
}());
