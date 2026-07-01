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
        TOP_MARGIN = H * 0.17; // clears the now-taller name/record/score HUD stack at the top
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

    // Non-authoritative ball rendering: between bounces, the ball's path is fully deterministic (constant
    // velocity, predictable wall bounces, speedMul barely moves over one network interval) - so rather than
    // streaming continuous position updates, only the "handoff" event itself (bounce or serve) is ever sent,
    // and the exact position is recomputed fresh every frame from that single known reference point and how
    // much real time has passed since - see predictNonAuthoritativeBall below.
    var groundTruthBall = null;
    var groundTruthTime = 0;

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
        } else if (type === "handoff") {
            // payload[6] is who's actually authoritative now - NOT necessarily me. This message also gets sent
            // when authority isn't changing at all (e.g. a fresh serve heading toward the sender's own paddle),
            // just to give me a ball to render/predict - so it can't just assume receiving it means I take over.
            ballAuthority = payload[6];
            groundTruthBall = { x: payload[1], y: payload[2], vx: payload[3], vy: payload[4], speedMul: payload[5] };
            groundTruthTime = performance.now();
            ball = ball || {};
            ball.x = groundTruthBall.x; ball.y = groundTruthBall.y;
            ball.vx = groundTruthBall.vx; ball.vy = groundTruthBall.vy; ball.speedMul = groundTruthBall.speedMul;
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

    // Sends the ball's current state to the other side along with who's actually authoritative for it now - NOT
    // necessarily them: this also covers telling them about a fresh ball when authority ISN'T changing (e.g. a
    // serve heading toward my own paddle), since without that the other side never gets a reference at all for
    // any rally that starts heading away from them, and would render no ball whatsoever until I eventually hit
    // it back. Also records the same state as MY OWN ground truth when I'm giving authority away, since
    // predictNonAuthoritativeBall only ever gets a reference from a "handoff" it RECEIVES, never one it sends -
    // without this, the instant authority changes hands, my own prediction would have nothing to work from.
    function sendBallState(newAuthority) {
        window.fzaMinigame.netSend(GAME_ID, ["handoff", ball.x, ball.y, ball.vx, ball.vy, ball.speedMul, newAuthority]);
        ballAuthority = newAuthority;
        if (newAuthority !== role) {
            groundTruthBall = { x: ball.x, y: ball.y, vx: ball.vx, vy: ball.vy, speedMul: ball.speedMul };
            groundTruthTime = performance.now();
        }
    }

    function resetBall(dir) {
        ball = { x: W / 2, y: playAreaCenterY(), vx: 220 * dir, vy: (Math.random() * 160 - 80), speedMul: 1 };
        ballAuthority = "host";
        if (peerConnected) {
            window.fzaMinigame.netSend(GAME_ID, ["score", score1, score2, gameOver]);
            // Always tell the guest about the fresh ball, whichever way it's headed - if it's heading toward my
            // own paddle, authority doesn't change, but they still need a reference to render/predict it.
            sendBallState(dir > 0 ? "guest" : "host");
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
                if (peerConnected) { sendBallState("guest"); }
                return;
            }
            if (ball.x < -20) {
                sfxScore();
                score2 += 1;
                if (score2 >= WIN_SCORE) { endGame(); } else { resetBall(1); }
                return;
            }
            if (!peerConnected) {
                // Solo vs AI - there's no guest to ever hand off to, so unlike multiplayer (where the guest takes
                // over before the ball gets anywhere near their side), I'm responsible for the WHOLE court here,
                // including the AI's own paddle and the right-edge miss, not just my own half.
                if (ball.vx > 0 && ball.x >= W - PADDLE_MARGIN - PADDLE_W && ball.x < W - PADDLE_MARGIN + 10 && Math.abs(ball.y - paddleR.y) < PADDLE_H / 2 + 6) {
                    ball.x = W - PADDLE_MARGIN - PADDLE_W;
                    ball.vx *= -1.05;
                    ball.vy += (ball.y - paddleR.y) * 2.5;
                    sfxHit();
                    return;
                }
                if (ball.x > W + 20) {
                    sfxScore();
                    score1 += 1;
                    if (score1 >= WIN_SCORE) { endGame(); } else { resetBall(-1); }
                }
            }
        } else {
            if (ball.vx > 0 && ball.x >= W - PADDLE_MARGIN - PADDLE_W && ball.x < W - PADDLE_MARGIN + 10 && Math.abs(ball.y - paddleR.y) < PADDLE_H / 2 + 6) {
                ball.x = W - PADDLE_MARGIN - PADDLE_W;
                ball.vx *= -1.05;
                ball.vy += (ball.y - paddleR.y) * 2.5;
                sfxHit();
                sendBallState("host");
                return;
            }
            if (ball.x > W + 20) {
                // I missed - I don't own score state, so just report it and wait for the host's authoritative
                // reply (a fresh "score"/"handoff" for the next rally). The ball is off-screen at this point so
                // there's nothing visible to predict in the meantime, but set ground truth anyway for consistency.
                window.fzaMinigame.netSend(GAME_ID, ["scored"]);
                ballAuthority = "host";
                groundTruthBall = { x: ball.x, y: ball.y, vx: ball.vx, vy: ball.vy, speedMul: ball.speedMul };
                groundTruthTime = performance.now();
            }
        }
    }

    // Simulates a ball's position/y-velocity forward by `elapsed` seconds from a known starting state, including
    // any wall bounces along the way (same approach as predictBallY above, generalized to also return x and the
    // resulting vy rather than just a final y). speedMul is treated as constant across the window - it ramps up
    // continuously, but the change over a single network interval is negligible.
    function simulateForward(from, elapsed) {
        var x = from.x + from.vx * from.speedMul * elapsed;
        var y = from.y, vy = from.vy;
        var top = TOP_MARGIN + 6, bottom = H - BOTTOM_MARGIN - 6;
        var remaining = elapsed;
        var guard = 0;
        while (remaining > 0 && guard < 20) {
            guard++;
            if (vy === 0) { break; }
            var speed = Math.abs(vy) * from.speedMul;
            var distToWall = vy > 0 ? (bottom - y) : (y - top);
            var timeToWall = distToWall / speed;
            if (timeToWall >= remaining) {
                y += vy * from.speedMul * remaining;
                remaining = 0;
            } else {
                y += vy * from.speedMul * timeToWall;
                vy *= -1;
                remaining -= timeToWall;
            }
        }
        return { x: x, y: y, vy: vy };
    }

    // Non-authoritative side only: recomputes the ball's exact position fresh every frame from the last known
    // ground truth (set in the "handoff" netRecv branch) and how much time has actually passed - rather than
    // incrementally stepping forward and periodically blend-correcting, which visibly tugged the ball every
    // update once any tiny drift crept in. Since the physics is fully deterministic between bounces, there's
    // nothing to accumulate or correct: each frame's answer is exact given the known starting state.
    function predictNonAuthoritativeBall() {
        if (!ball || !groundTruthBall || ballAuthority === role) { return; }
        // No separate time cap here (deliberately) - the ball can legitimately take multiple seconds to cross
        // the full court, so capping elapsed at some fixed small value would freeze it partway through every
        // single rally. The timeToEdge clamp just below already provides the safety net a stalled/paused
        // authoritative side needs: the ball simply waits at the paddle's edge rather than running away.
        var elapsed = (performance.now() - groundTruthTime) / 1000;
        // Never predict the ball past the paddle it's heading toward - I have no way of knowing in advance
        // whether the other side will actually block it (that's decided locally, with zero latency, on their
        // end), so projecting straight through would visibly overshoot the paddle and then snap back the
        // instant their handoff (bounce) or score report (miss) arrives. Clamping the elapsed time itself
        // (rather than just the resulting x) means x and y both freeze at the same instant - the ball waits
        // right at the edge rather than sliding vertically along a frozen x while still extrapolating y - so a
        // bounce handoff lands almost exactly where it's already sitting, no visible correction at all.
        if (groundTruthBall.vx !== 0) {
            var paddleEdgeX = groundTruthBall.vx > 0 ? (W - PADDLE_MARGIN - PADDLE_W) : (PADDLE_MARGIN + PADDLE_W);
            var timeToEdge = (paddleEdgeX - groundTruthBall.x) / (groundTruthBall.vx * groundTruthBall.speedMul);
            if (timeToEdge >= 0) { elapsed = Math.min(elapsed, timeToEdge); }
        }
        var predicted = simulateForward(groundTruthBall, elapsed);
        ball.x = predicted.x; ball.y = predicted.y;
        ball.vx = groundTruthBall.vx; ball.vy = predicted.vy; ball.speedMul = groundTruthBall.speedMul;
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

        // Only the paddle position needs continuous broadcasting - the ball's path between bounces is fully
        // deterministic (constant velocity, predictable wall bounces), so "handoff" alone (sent the instant it
        // bounces or is served - see stepBall/resetBall) gives the other side everything needed to predict it
        // exactly with no further updates required, and no periodic re-sync to ever introduce drift/correction.
        netSendTimer -= dt;
        if (netSendTimer <= 0) {
            netSendTimer = NET_SEND_INTERVAL;
            if (peerConnected) {
                window.fzaMinigame.netSend(GAME_ID, ["paddle", myPaddle.y]);
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
        if (!autoPaused && !manualPaused) { update(dt); predictNonAuthoritativeBall(); interpolatePeerVisuals(dt); }
        render();
        requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);

    window.fzaMinigame.ready(GAME_ID);
    window.fzaMinigame.netJoin(GAME_ID);
}());
