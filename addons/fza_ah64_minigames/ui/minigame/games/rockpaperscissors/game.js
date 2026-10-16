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

    // My own record, pushed by fn_minigameReportResult.sqf/fn_minigameReady.sqf. Forwarded to a connected peer
    // immediately, since their machine has no way to read my profileNamespace - see updateRecords() below.
    var myRecord = { wins: 0, losses: 0 };
    var peerRecord = { wins: 0, losses: 0 };
    window.fza_minigame_setRecord = function (w, l) {
        myRecord.wins = w; myRecord.losses = l;
        updateRecords();
        if (peerConnected) { window.fzaMinigame.netSend(GAME_ID, ["record", w, l]); }
    };

    function updateRecords() {
        var elLeft = document.getElementById("recordLeft");
        var elRight = document.getElementById("recordRight");
        var myText = "W-L " + myRecord.wins + "-" + myRecord.losses;
        var peerText = peerConnected ? ("W-L " + peerRecord.wins + "-" + peerRecord.losses) : "—";
        if (elLeft) { elLeft.textContent = role === "guest" ? peerText : myText; }
        if (elRight) { elRight.textContent = role === "guest" ? myText : peerText; }
    }

    function updateNames() {
        var elLeft = document.getElementById("nameLeft");
        var elRight = document.getElementById("nameRight");
        if (elLeft) { elLeft.textContent = (role === "host" ? myName : peerName) || "HOST"; }
        if (elRight) { elRight.textContent = (role === "host" ? (peerName || "AI") : myName) || "GUEST"; }
    }

    // Generic 2-player session (same heli+seat model the other games use). Unlike the turn-based games, both
    // sides choose at the same time rather than alternating - each side sends its pick the instant it locks one
    // in, and a round resolves once both picks are known, in whichever order they happen to arrive.
    var role = "host";
    var peerConnected = false;
    var peerAway = false;
    var vsAI = true;
    var myName = "", peerName = "";

    function awayText() { return (peerName || "OPPONENT") + " AWAY"; }

    // The start screen doubles as the lobby: who the next match is against, and whether they are here for it
    function lobbyText() {
        if (peerAway) { return awayText() + " - waiting"; }
        if (peerConnected) { return "VS " + (peerName || "OPPONENT") + " - press any key to start"; }
        return "press any key to start";
    }

    function toMenu() {
        started = false;
        phase = "menu";
        statusText = "PICK ONE";
        myScore = 0; peerScore = 0;
        window.fzaMinigame.setText("overlaySub", lobbyText());
        document.getElementById("overlay").classList.remove("hidden");
    }

    window.fza_minigame_netRecv = function (payload) {
        var tag = payload[0];
        if (tag === "session") {
            var s = window.fzaMinigame.readSession(payload);
            role = s.role; myName = s.myName; peerName = s.peerName;
            peerConnected = s.peer !== "none";
            peerAway = s.peer === "away";
            if (!peerConnected) { peerRecord.wins = 0; peerRecord.losses = 0; }
            updateNames();
            updateRecords();
            if (s.reset) {
                vsAI = !peerConnected;
                if (peerConnected) { window.fzaMinigame.netSend(GAME_ID, ["record", myRecord.wins, myRecord.losses]); }
                toMenu();
            } else if (phase === "menu") {
                window.fzaMinigame.setText("overlaySub", lobbyText());
            }
        } else if (tag === "record") {
            peerRecord.wins = payload[1]; peerRecord.losses = payload[2];
            updateRecords();
        } else if (tag === "start") {
            // Both players pressed start together: this side has just begun the same fresh match
            if (performance.now() - lastStartAt < 2000) { return; }
            startGame();
        } else if (tag === "pick") {
            // A fast opponent can pick for the next round while this side is still showing the last one
            if (phase === "reveal") { queuedPeerPick = payload[1]; }
            else if (phase === "picking" && peerPick === null) { peerPick = payload[1]; tryResolveRound(); }
        }
    };

    // Input - left/right cycle the highlighted choice, "fire" (mirrored by b4) locks it in.
    var keys = { up: false, down: false, left: false, right: false };

    function setKey(action, isDown) {
        var wasDown = keys[action];
        if (action in keys) { keys[action] = !!isDown; }
        if (isDown && !wasDown) { handleDirectionPress(action); }
    }

    function handleDirectionPress(action) {
        if (!started) { beginMatch(); return; }
        if (phase === "gameover") { beginMatch(); return; }
        if (phase === "picking" && !myPicked) {
            if (action === "left") { selectorIndex = (selectorIndex + CHOICES.length - 1) % CHOICES.length; }
            if (action === "right") { selectorIndex = (selectorIndex + 1) % CHOICES.length; }
        }
    }

    function triggerConfirm() {
        if (!started) { beginMatch(); return; }
        if (phase === "gameover") { beginMatch(); return; }
        if (phase === "picking" && !myPicked) { lockInPick(); }
    }

    // Starting (or restarting) is broadcast to a connected peer, so both sides begin the exact same fresh match
    // together rather than just this side - startGame() itself is fully deterministic from each side's own role,
    // so the peer applying it independently on "start" produces identical state, no parameters needed.
    function beginMatch() {
        if (peerAway) { return; }
        startGame();
        if (!vsAI) { window.fzaMinigame.netSend(GAME_ID, ["start"]); }
    }

    // "fire" acts on the press only; its release is ignored.
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
    var queuedPeerPick = null;

    function beats(a, b) {
        return ((a - b + 3) % 3) === 1;
    }

    var lastStartAt = -1e9;
    function startGame() {
        lastStartAt = performance.now();
        started = true;
        myScore = 0;
        peerScore = 0;
        queuedPeerPick = null;
        startRound();
        document.getElementById("overlay").classList.add("hidden");
    }

    function startRound() {
        selectorIndex = 0;
        myPicked = false;
        myPick = null;
        peerPick = queuedPeerPick;
        queuedPeerPick = null;
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
        window.fzaMinigame.setText("overlaySub", (won ? "VICTORY" : "DEFEAT") + " - press any key to restart");
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
        if (statusEl) { statusEl.textContent = peerAway ? awayText() : (statusText || "PICK ONE"); }
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
        // Nothing to show while auto-paused (off screen, ESC menu or out of the seat)
        if (!autoPaused) { render(); }
        requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);

    window.fzaMinigame.ready(GAME_ID);
    window.fzaMinigame.netJoin(GAME_ID);
}());
