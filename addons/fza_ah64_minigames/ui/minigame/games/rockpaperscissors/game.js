(function () {
    "use strict";

    var GAME_ID = "rockpaperscissors";
    var LINE_WIDTH = 4;
    var CHOICES = ["ROCK", "PAPER", "SCISSORS"];
    var WIN_TARGET = 3;

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
    function sfxPick() { window.fzaMinigame.playSfx("shoot"); }
    function sfxWin() { window.fzaMinigame.playSfx("explosionBig"); }
    function sfxLose() { window.fzaMinigame.playSfx("death"); }

    window.fza_minigame_setMuted = function (isMuted) {
        var btn = document.getElementById("muteBtn");
        if (btn) { btn.classList.toggle("active", !isMuted); }
    };

    // Pushed by fn_minigameReportResult.sqf - personal win/loss record (per match, not per round).
    var wins = 0, losses = 0;
    window.fza_minigame_setRecord = function (w, l) {
        wins = w; losses = l;
        var recordEl = document.getElementById("recordLeft");
        if (recordEl) { recordEl.textContent = "W-L " + wins + "-" + losses; }
    };

    // Generic 2-player session (same heli+seat model the other games use). Unlike the turn-based games, both
    // sides choose at the same time rather than alternating - each side sends its pick the instant it locks one
    // in, and a round resolves once both picks are known, in whichever order they happen to arrive.
    var role = null;
    var peerConnected = false;
    var vsAI = true;

    window.fza_minigame_netRecv = function (payload) {
        var tag = payload[0];
        if (tag === "role") {
            role = payload[1];
            peerConnected = (payload[2] !== -1);
            vsAI = !peerConnected;
        } else if (tag === "peer") {
            var wasConnected = peerConnected;
            var hostLeft = payload[2];
            peerConnected = !!payload[1];
            vsAI = !peerConnected;
            if (hostLeft) {
                started = false;
                phase = "menu";
                document.getElementById("overlaySub").textContent = "HOST DISCONNECTED - press any key to start";
                document.getElementById("overlay").classList.remove("hidden");
            } else if (started && phase !== "menu" && phase !== "gameover" && peerConnected !== wasConnected) {
                startGame();
            }
        } else if (tag === "pick") {
            peerPick = payload[1];
            tryResolveRound();
        }
    };

    // Input - left/right cycle the highlighted choice, "fire" (default Space, mirrored by b4) locks it in.
    var keys = { up: false, down: false, left: false, right: false };

    function setKey(action, isDown) {
        var wasDown = keys[action];
        if (action in keys) { keys[action] = !!isDown; }
        if (isDown && !wasDown) { handleDirectionPress(action); }
    }

    function handleDirectionPress(action) {
        if (!started) { startGame(); return; }
        if (phase === "gameover") { startGame(); return; }
        if (phase === "picking" && !myPicked) {
            if (action === "left") { selectorIndex = (selectorIndex + CHOICES.length - 1) % CHOICES.length; }
            if (action === "right") { selectorIndex = (selectorIndex + 1) % CHOICES.length; }
        }
    }

    function triggerConfirm() {
        if (!started) { startGame(); return; }
        if (phase === "gameover") { startGame(); return; }
        if (phase === "picking" && !myPicked) { lockInPick(); }
    }

    // "fire" is a press-only action (CfgUserActionDefPress, no key-up event) - every call is a fresh press.
    window.fza_minigame_input = function (action, isDown) {
        if (action === "fire") {
            if (isDown) { triggerConfirm(); }
            return;
        }
        setKey(action, isDown);
    };

    var KEY_MAP = {
        ArrowUp: "up", w: "up", W: "up",
        ArrowLeft: "left", a: "left", A: "left",
        ArrowRight: "right", d: "right", D: "right",
        ArrowDown: "down", s: "down", S: "down"
    };
    window.addEventListener("keydown", function (e) {
        var action = KEY_MAP[e.key];
        if (action) { setKey(action, true); e.preventDefault(); return; }
        if ((e.key === " " || e.key === "Spacebar") && !e.repeat) { window.fza_minigame_input("fire", true); e.preventDefault(); }
    });
    window.addEventListener("keyup", function (e) {
        var action = KEY_MAP[e.key];
        if (action) { setKey(action, false); e.preventDefault(); }
    });

    // autoPaused: pushed by fn_minigameUiInit.sqf's per-frame handler (ESC menu open, or player left the seat).
    var autoPaused = false;
    window.fza_minigame_setPaused = function (isPaused) {
        autoPaused = !!isPaused;
    };

    // b4 ("restart") locks in the highlighted choice - nothing meaningful to "restart mid-round" here. b5
    // ("pause") is likewise left as a no-op, same reasoning as the other turn-based games.
    window.fza_minigame_restart = function () {
        triggerConfirm();
    };
    window.fza_minigame_setManualPaused = function () {};

    // Game state
    var phase; // "menu" | "picking" | "reveal" | "gameover"
    var started;
    var selectorIndex, myPicked, myPick, peerPick, myScore, peerScore, statusText, revealTimer;

    function beats(a, b) {
        return ((a - b + 3) % 3) === 1;
    }

    function startGame() {
        started = true;
        myScore = 0;
        peerScore = 0;
        startRound();
        document.getElementById("overlay").classList.add("hidden");
    }

    function startRound() {
        selectorIndex = 0;
        myPicked = false;
        myPick = null;
        peerPick = null;
        phase = "picking";
        statusText = "PICK ONE";
    }

    function lockInPick() {
        myPicked = true;
        myPick = selectorIndex;
        sfxPick();
        if (vsAI) {
            peerPick = Math.floor(Math.random() * 3); // pure random AI - the fair, unexploitable RPS strategy
        } else {
            window.fzaMinigame.netSend(GAME_ID, ["pick", myPick]);
        }
        statusText = vsAI ? "..." : "WAITING FOR OPPONENT...";
        tryResolveRound();
    }

    function tryResolveRound() {
        if (!myPicked || peerPick === null) { return; }
        var result; // "win" | "lose" | "tie"
        if (myPick === peerPick) { result = "tie"; }
        else if (beats(myPick, peerPick)) { result = "win"; myScore += 1; }
        else { result = "lose"; peerScore += 1; }

        phase = "reveal";
        statusText = result === "tie" ? "TIE" : (result === "win" ? "YOU WIN THE ROUND" : "YOU LOSE THE ROUND");
        revealTimer = 1.8;

        if (myScore >= WIN_TARGET || peerScore >= WIN_TARGET) {
            revealTimer = 1.8;
            pendingEnd = myScore >= WIN_TARGET;
        } else {
            pendingEnd = null;
        }
    }

    var pendingEnd = null;

    function endGame(won) {
        phase = "gameover";
        window.fzaMinigame.reportResult(GAME_ID, won);
        if (won) { sfxWin(); } else { sfxLose(); }
        document.getElementById("overlaySub").textContent = (won ? "VICTORY" : "DEFEAT") + " - press any key to restart";
        document.getElementById("overlay").classList.remove("hidden");
    }

    // Update
    function update(dt) {
        if (!started) { return; }
        if (phase === "reveal") {
            revealTimer -= dt;
            if (revealTimer <= 0) {
                if (pendingEnd !== null) { endGame(pendingEnd); } else { startRound(); }
            }
        }
    }

    // Render
    function drawChoices() {
        var cy = H * 0.55;
        var spacing = W * 0.22;
        var startX = W / 2 - spacing;
        for (var i = 0; i < CHOICES.length; i++) {
            var cx = startX + i * spacing;
            drawIcon(cx, cy, i, i === selectorIndex && phase === "picking" && !myPicked);
        }
    }

    function drawIcon(cx, cy, index, highlighted) {
        var r = Math.min(W, H) * 0.07;
        ctx.lineWidth = LINE_WIDTH;
        ctx.strokeStyle = highlighted ? "#ffcc33" : "#33ff33";
        if (highlighted) {
            ctx.beginPath();
            ctx.arc(cx, cy, r * 1.5, 0, Math.PI * 2);
            ctx.stroke();
        }
        if (index === 0) { // Rock - circle
            ctx.beginPath();
            ctx.arc(cx, cy, r, 0, Math.PI * 2);
            ctx.stroke();
        } else if (index === 1) { // Paper - square
            ctx.strokeRect(cx - r, cy - r, r * 2, r * 2);
        } else { // Scissors - X
            ctx.beginPath();
            ctx.moveTo(cx - r, cy - r); ctx.lineTo(cx + r, cy + r);
            ctx.moveTo(cx + r, cy - r); ctx.lineTo(cx - r, cy + r);
            ctx.stroke();
        }
        ctx.fillStyle = highlighted ? "#ffcc33" : "#66cc66";
        ctx.font = Math.round(Math.min(W, H) * 0.03) + "px 'Courier New', monospace";
        ctx.textAlign = "center";
        ctx.fillText(CHOICES[index], cx, cy + r * 1.9);
    }

    function drawReveal() {
        var cy = H * 0.55;
        var spacing = W * 0.18;
        drawIcon(W / 2 - spacing, cy, myPick, false);
        drawIcon(W / 2 + spacing, cy, peerPick, false);
        ctx.fillStyle = "#33ff33";
        ctx.font = Math.round(Math.min(W, H) * 0.025) + "px 'Courier New', monospace";
        ctx.textAlign = "center";
        ctx.fillText("YOU", W / 2 - spacing, cy - Math.min(W, H) * 0.1);
        ctx.fillText(vsAI ? "AI" : "OPPONENT", W / 2 + spacing, cy - Math.min(W, H) * 0.1);
    }

    function updateHud() {
        var scoreLeftEl = document.getElementById("scoreLeft");
        if (scoreLeftEl) { scoreLeftEl.textContent = String(myScore || 0); }
        var scoreRightEl = document.getElementById("scoreRight");
        if (scoreRightEl) { scoreRightEl.textContent = String(peerScore || 0); }
        var statusEl = document.getElementById("status");
        if (statusEl) { statusEl.textContent = statusText || "PICK ONE"; }
    }

    function render() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);
        if (started) {
            if (phase === "picking") { drawChoices(); }
            if (phase === "reveal" || phase === "gameover") { drawReveal(); }
        }
        updateHud();
    }

    // Main loop
    started = false;
    phase = "menu";
    statusText = "PICK ONE";
    myScore = 0; peerScore = 0;
    selectorIndex = 0; myPicked = false; myPick = null; peerPick = null;

    var lastTime = null;
    function frame(t) {
        if (lastTime === null) { lastTime = t; }
        var dt = Math.min(0.05, (t - lastTime) / 1000);
        lastTime = t;
        if (!autoPaused) { update(dt); }
        render();
        requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);

    window.fzaMinigame.ready(GAME_ID);
    window.fzaMinigame.netJoin(GAME_ID);
}());
