(function () {
    "use strict";

    var GAME_ID = "tictactoe";
    var LINE_WIDTH = 4;
    var GRID_SIZE = 3;
    var LINES = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]];

    // Canvas setup
    var canvas = document.getElementById("canvas");
    var ctx = canvas.getContext("2d");
    var W = 0, H = 0, TOP_MARGIN = 0;
    var gridX = 0, gridY = 0, CELL = 0;

    function resize() {
        W = canvas.clientWidth || window.innerWidth;
        H = canvas.clientHeight || window.innerHeight;
        canvas.width = W;
        canvas.height = H;
        TOP_MARGIN = H * 0.12;
        var gridPixels = Math.min(W * 0.55, (H - TOP_MARGIN) * 0.78);
        CELL = gridPixels / GRID_SIZE;
        gridX = (W - gridPixels) / 2;
        gridY = TOP_MARGIN + (H - TOP_MARGIN - gridPixels) / 2;
    }
    window.addEventListener("resize", resize);
    resize();

    // Audio - real Arma sounds via the bridge, CT_WEBBROWSER can't play Web Audio.
    function sfxPlace() { window.fzaMinigame.playSfx("shoot"); }
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

    // Generic 2-player session (same heli+seat model Pong/Battleship use). Unlike Battleship, neither side has any
    // hidden state - both keep an identical board, so a move is just broadcast and applied directly, no
    // attacker/defender resolve-and-reply round trip needed.
    var role = null;
    var peerConnected = false;
    var vsAI = true;
    var myName = "", peerName = "";

    window.fza_minigame_netRecv = function (payload) {
        var tag = payload[0];
        if (tag === "role") {
            role = payload[1];
            var wasPeerConnected = peerConnected;
            peerConnected = (payload[2] !== -1);
            vsAI = !peerConnected;
            myName = payload[3] || "";
            peerName = payload[4] || "";
            updateNames();
            updateRecords();
            if (peerConnected && !wasPeerConnected) { window.fzaMinigame.netSend(GAME_ID, ["record", myRecord.wins, myRecord.losses]); }
        } else if (tag === "peer") {
            var wasConnected = peerConnected;
            var hostLeft = payload[2];
            peerConnected = !!payload[1];
            vsAI = !peerConnected;
            peerName = payload[3] || "";
            if (!peerConnected) { peerRecord.wins = 0; peerRecord.losses = 0; }
            updateNames();
            updateRecords();
            if (peerConnected && !wasConnected) { window.fzaMinigame.netSend(GAME_ID, ["record", myRecord.wins, myRecord.losses]); }
            if (hostLeft) {
                started = false;
                phase = "menu";
                document.getElementById("overlaySub").textContent = "HOST DISCONNECTED - press any key to start";
                document.getElementById("overlay").classList.remove("hidden");
            } else if (started && phase !== "menu" && peerConnected !== wasConnected) {
                // Connection state changed mid-match - reset both sides to a neutral start screen rather than
                // resuming play unilaterally on just this side, which left the OTHER side stuck on their own
                // untouched menu never having started anything at all (a permanent soft lock, not a transient
                // one - their game state was simply never initialized for the match this side jumped into).
                started = false;
                phase = "menu";
                document.getElementById("overlaySub").textContent = "press any key to start";
                document.getElementById("overlay").classList.remove("hidden");
            }
        } else if (tag === "record") {
            peerRecord.wins = payload[1]; peerRecord.losses = payload[2];
            updateRecords();
        } else if (tag === "start") {
            startGame();
        } else if (tag === "place") {
            var oppSym = mySymbol === "X" ? "O" : "X";
            board[payload[1]] = oppSym;
            sfxPlace();
            afterMove(oppSym);
        }
    };

    // Input - native keyboard and SQF-forwarded (fn_minigameHandleInput.sqf). up/down/left/right move the cursor
    // one cell per press (discrete); "fire" (default Space, mirrored by b4) places a mark at the cursor.
    var keys = { up: false, down: false, left: false, right: false };

    function setKey(action, isDown) {
        var wasDown = keys[action];
        if (action in keys) { keys[action] = !!isDown; }
        if (isDown && !wasDown) { handleDirectionPress(action); }
    }

    function handleDirectionPress(action) {
        if (!started) { beginMatch(); return; }
        if (phase === "gameover") { beginMatch(); return; }
        if (phase === "playing" && myTurn) { moveCursor(action); }
    }

    function triggerConfirm() {
        if (!started) { beginMatch(); return; }
        if (phase === "gameover") { beginMatch(); return; }
        if (phase === "playing" && myTurn) { placeMyMark(cursor.row * GRID_SIZE + cursor.col); }
    }

    // Starting (or restarting) is broadcast to a connected peer, so both sides begin the exact same fresh match
    // together rather than just this side - startGame() itself is fully deterministic from each side's own role,
    // so the peer applying it independently on "start" produces identical state, no parameters needed.
    function beginMatch() {
        startGame();
        if (!vsAI) { window.fzaMinigame.netSend(GAME_ID, ["start"]); }
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

    // b4 ("restart") places a mark - nothing meaningful to "restart mid-match" in a turn-based game with no
    // ongoing simulation. b5 ("pause") is likewise left as a no-op for the same reason.
    window.fza_minigame_restart = function () {
        triggerConfirm();
    };
    window.fza_minigame_setManualPaused = function () {};

    // Game state
    var phase; // "menu" | "playing" | "gameover"
    var started;
    var board, cursor, mySymbol, myTurn, statusText, aiTurnTimer;

    function checkWinner(b) {
        for (var i = 0; i < LINES.length; i++) {
            var l = LINES[i];
            if (b[l[0]] && b[l[0]] === b[l[1]] && b[l[1]] === b[l[2]]) { return b[l[0]]; }
        }
        return null;
    }

    function isFull(b) {
        return b.every(function (c) { return c !== ""; });
    }

    function moveCursor(action) {
        if (action === "up") { cursor.row -= 1; }
        if (action === "down") { cursor.row += 1; }
        if (action === "left") { cursor.col -= 1; }
        if (action === "right") { cursor.col += 1; }
        cursor.row = Math.max(0, Math.min(GRID_SIZE - 1, cursor.row));
        cursor.col = Math.max(0, Math.min(GRID_SIZE - 1, cursor.col));
    }

    // Simple, beatable heuristic (not full minimax): take a winning move if there is one, else block the
    // opponent's winning move, else center, else a corner, else whatever's left.
    function aiPickMove() {
        var aiSym = mySymbol === "X" ? "O" : "X";
        var humanSym = mySymbol;
        var i;
        for (i = 0; i < 9; i++) {
            if (board[i] === "") { board[i] = aiSym; if (checkWinner(board) === aiSym) { board[i] = ""; return i; } board[i] = ""; }
        }
        for (i = 0; i < 9; i++) {
            if (board[i] === "") { board[i] = humanSym; if (checkWinner(board) === humanSym) { board[i] = ""; return i; } board[i] = ""; }
        }
        if (board[4] === "") { return 4; }
        var corners = [0, 2, 6, 8].filter(function (c) { return board[c] === ""; });
        if (corners.length) { return corners[Math.floor(Math.random() * corners.length)]; }
        var empties = [];
        for (i = 0; i < 9; i++) { if (board[i] === "") { empties.push(i); } }
        return empties[Math.floor(Math.random() * empties.length)];
    }

    function afterMove(sym) {
        var winner = checkWinner(board);
        if (winner) { endGame(winner === mySymbol); return; }
        if (isFull(board)) { endGameDraw(); return; }
        myTurn = !myTurn;
        statusText = myTurn ? "YOUR TURN" : (vsAI ? "AI THINKING..." : "OPPONENT'S TURN");
        if (!myTurn && vsAI) { aiTurnTimer = 0.5 + Math.random() * 0.4; }
    }

    function placeMyMark(index) {
        if (board[index] !== "") { return; }
        board[index] = mySymbol;
        sfxPlace();
        if (!vsAI) { window.fzaMinigame.netSend(GAME_ID, ["place", index]); }
        afterMove(mySymbol);
    }

    function aiFire() {
        var idx = aiPickMove();
        var aiSym = mySymbol === "X" ? "O" : "X";
        board[idx] = aiSym;
        sfxPlace();
        afterMove(aiSym);
    }

    function startGame() {
        started = true;
        board = ["", "", "", "", "", "", "", "", ""];
        cursor = { row: 1, col: 1 };
        mySymbol = vsAI ? "X" : (role === "host" ? "X" : "O");
        myTurn = (mySymbol === "X");
        phase = "playing";
        statusText = myTurn ? "YOUR TURN" : (vsAI ? "AI THINKING..." : "OPPONENT'S TURN");
        if (!myTurn && vsAI) { aiTurnTimer = 0.5 + Math.random() * 0.4; }
        document.getElementById("overlay").classList.add("hidden");
    }

    function endGame(won) {
        phase = "gameover";
        window.fzaMinigame.reportResult(GAME_ID, won);
        if (won) { sfxWin(); } else { sfxLose(); }
        document.getElementById("overlaySub").textContent = (won ? "VICTORY" : "DEFEAT") + " - press any key to restart";
        document.getElementById("overlay").classList.remove("hidden");
    }

    function endGameDraw() {
        phase = "gameover";
        document.getElementById("overlaySub").textContent = "DRAW - press any key to restart";
        document.getElementById("overlay").classList.remove("hidden");
    }

    // Update
    function update(dt) {
        if (!started || phase !== "playing") { return; }
        if (!myTurn && vsAI) {
            aiTurnTimer -= dt;
            if (aiTurnTimer <= 0) { aiFire(); }
        }
    }

    // Render
    function drawGrid() {
        ctx.strokeStyle = "#226622";
        ctx.lineWidth = LINE_WIDTH;
        for (var i = 1; i < GRID_SIZE; i++) {
            ctx.beginPath();
            ctx.moveTo(gridX + i * CELL, gridY);
            ctx.lineTo(gridX + i * CELL, gridY + GRID_SIZE * CELL);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(gridX, gridY + i * CELL);
            ctx.lineTo(gridX + GRID_SIZE * CELL, gridY + i * CELL);
            ctx.stroke();
        }
    }

    function drawMark(row, col, sym) {
        var cx = gridX + col * CELL + CELL / 2, cy = gridY + row * CELL + CELL / 2;
        var r = CELL * 0.32;
        ctx.lineWidth = LINE_WIDTH;
        if (sym === "X") {
            ctx.strokeStyle = "#33ff33";
            ctx.beginPath();
            ctx.moveTo(cx - r, cy - r); ctx.lineTo(cx + r, cy + r);
            ctx.moveTo(cx + r, cy - r); ctx.lineTo(cx - r, cy + r);
            ctx.stroke();
        } else {
            ctx.strokeStyle = "#ff9933";
            ctx.beginPath();
            ctx.arc(cx, cy, r, 0, Math.PI * 2);
            ctx.stroke();
        }
    }

    function drawBoard() {
        drawGrid();
        for (var i = 0; i < 9; i++) {
            if (board[i] !== "") { drawMark(Math.floor(i / GRID_SIZE), i % GRID_SIZE, board[i]); }
        }
        if (myTurn) {
            ctx.strokeStyle = "#ffcc33";
            ctx.lineWidth = LINE_WIDTH * 1.2;
            ctx.strokeRect(gridX + cursor.col * CELL + 3, gridY + cursor.row * CELL + 3, CELL - 6, CELL - 6);
        }
    }

    function updateHud() {
        var statusEl = document.getElementById("status");
        if (statusEl) { statusEl.textContent = statusText || "TIC TAC TOE"; }
        var markEl = document.getElementById("mark");
        if (markEl) { markEl.textContent = "MARK " + (mySymbol || "X"); }
    }

    function render() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);
        if (started && (phase === "playing" || phase === "gameover")) { drawBoard(); }
        updateHud();
    }

    // Main loop
    started = false;
    phase = "menu";
    statusText = "TIC TAC TOE";
    board = ["", "", "", "", "", "", "", "", ""];
    mySymbol = "X";

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
