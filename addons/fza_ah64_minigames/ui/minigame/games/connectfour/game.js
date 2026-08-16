(function () {
    "use strict";

    var GAME_ID = "connectfour";
    var LINE_WIDTH = 3;
    var COLS = 7, ROWS = 6;

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
        TOP_MARGIN = H * 0.17; // clears the now-taller name/record/status HUD stack at the top
        var availW = W * 0.85, availH = (H - TOP_MARGIN) * 0.78;
        CELL = Math.min(availW / COLS, availH / (ROWS + 0.8));
        gridX = (W - CELL * COLS) / 2;
        gridY = TOP_MARGIN + CELL * 0.8 + (H - TOP_MARGIN - CELL * 0.8 - CELL * ROWS) / 2;
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

    // Generic 2-player session (same heli+seat model Pong/Battleship/Tic-Tac-Toe use). No hidden state on either
    // side, so a move is just broadcast and applied directly - no resolve-and-reply round trip needed.
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
        } else if (tag === "drop") {
            var col = payload[1];
            var row = lowestEmptyRow(col);
            if (row < 0) { return; }
            var oppSym = mySymbol === "X" ? "O" : "X";
            setCellAt(row, col, oppSym);
            sfxPlace();
            afterMove(row, col, oppSym);
        }
    };

    // Input - native keyboard and SQF-forwarded (fn_minigameHandleInput.sqf). left/right move the column
    // selector one column per press (discrete); "fire" (default Space, mirrored by b4) drops a piece.
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
        if (phase === "playing" && myTurn) { placeMyMove(cursorCol); }
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

    // b4 ("restart") drops a piece - nothing meaningful to "restart mid-match" in a turn-based game with no
    // ongoing simulation. b5 ("pause") is likewise left as a no-op for the same reason.
    window.fza_minigame_restart = function () {
        triggerConfirm();
    };
    window.fza_minigame_setManualPaused = function () {};

    // Game state
    var phase; // "menu" | "playing" | "gameover"
    var started;
    var board, cursorCol, mySymbol, myTurn, statusText, aiTurnTimer;

    function cellAt(row, col) { return board[row * COLS + col]; }
    function setCellAt(row, col, sym) { board[row * COLS + col] = sym; }

    function lowestEmptyRow(col) {
        for (var r = ROWS - 1; r >= 0; r--) {
            if (cellAt(r, col) === "") { return r; }
        }
        return -1;
    }

    function isBoardFull() {
        for (var c = 0; c < COLS; c++) { if (lowestEmptyRow(c) >= 0) { return false; } }
        return true;
    }

    function countDir(row, col, sym, dr, dc) {
        var count = 0, r = row + dr, c = col + dc;
        while (r >= 0 && r < ROWS && c >= 0 && c < COLS && cellAt(r, c) === sym) {
            count++; r += dr; c += dc;
        }
        return count;
    }

    function checkWinAt(row, col, sym) {
        var dirs = [[0, 1], [1, 0], [1, 1], [1, -1]];
        for (var i = 0; i < dirs.length; i++) {
            var dr = dirs[i][0], dc = dirs[i][1];
            var total = 1 + countDir(row, col, sym, dr, dc) + countDir(row, col, sym, -dr, -dc);
            if (total >= 4) { return true; }
        }
        return false;
    }

    function moveCursor(action) {
        if (action === "left") { cursorCol -= 1; }
        if (action === "right") { cursorCol += 1; }
        cursorCol = Math.max(0, Math.min(COLS - 1, cursorCol));
    }

    // Simple, beatable heuristic (not full minimax): take a winning drop if there is one, else block the
    // opponent's winning drop, else prefer central columns (stronger in Connect Four) with some randomness.
    function aiPickColumn() {
        var aiSym = mySymbol === "X" ? "O" : "X";
        var humanSym = mySymbol;
        var col, row;
        for (col = 0; col < COLS; col++) {
            row = lowestEmptyRow(col);
            if (row < 0) { continue; }
            setCellAt(row, col, aiSym);
            if (checkWinAt(row, col, aiSym)) { setCellAt(row, col, ""); return col; }
            setCellAt(row, col, "");
        }
        for (col = 0; col < COLS; col++) {
            row = lowestEmptyRow(col);
            if (row < 0) { continue; }
            setCellAt(row, col, humanSym);
            if (checkWinAt(row, col, humanSym)) { setCellAt(row, col, ""); return col; }
            setCellAt(row, col, "");
        }
        var validCols = [];
        for (col = 0; col < COLS; col++) { if (lowestEmptyRow(col) >= 0) { validCols.push(col); } }
        var weights = validCols.map(function (c) { return COLS - Math.abs(c - 3); });
        var totalWeight = weights.reduce(function (a, b) { return a + b; }, 0);
        var pick = Math.random() * totalWeight;
        for (var i = 0; i < validCols.length; i++) {
            pick -= weights[i];
            if (pick <= 0) { return validCols[i]; }
        }
        return validCols[validCols.length - 1];
    }

    function afterMove(row, col, sym) {
        if (checkWinAt(row, col, sym)) { endGame(sym === mySymbol); return; }
        if (isBoardFull()) { endGameDraw(); return; }
        myTurn = !myTurn;
        statusText = myTurn ? "YOUR TURN" : (vsAI ? "AI THINKING..." : "OPPONENT'S TURN");
        if (!myTurn && vsAI) { aiTurnTimer = 0.5 + Math.random() * 0.4; }
    }

    function placeMyMove(col) {
        var row = lowestEmptyRow(col);
        if (row < 0) { return; }
        setCellAt(row, col, mySymbol);
        sfxPlace();
        if (!vsAI) { window.fzaMinigame.netSend(GAME_ID, ["drop", col]); }
        afterMove(row, col, mySymbol);
    }

    function aiFire() {
        var col = aiPickColumn();
        var row = lowestEmptyRow(col);
        var aiSym = mySymbol === "X" ? "O" : "X";
        setCellAt(row, col, aiSym);
        sfxPlace();
        afterMove(row, col, aiSym);
    }

    function startGame() {
        started = true;
        board = [];
        for (var i = 0; i < ROWS * COLS; i++) { board.push(""); }
        cursorCol = Math.floor(COLS / 2);
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
    function drawBoard() {
        ctx.strokeStyle = "#226622";
        ctx.lineWidth = LINE_WIDTH;
        ctx.strokeRect(gridX - CELL * 0.1, gridY - CELL * 0.1, CELL * COLS + CELL * 0.2, CELL * ROWS + CELL * 0.2);
        for (var r = 0; r < ROWS; r++) {
            for (var c = 0; c < COLS; c++) {
                var cx = gridX + c * CELL + CELL / 2, cy = gridY + r * CELL + CELL / 2;
                var sym = cellAt(r, c);
                ctx.beginPath();
                ctx.arc(cx, cy, CELL * 0.38, 0, Math.PI * 2);
                if (sym === "") {
                    ctx.strokeStyle = "#226622";
                    ctx.lineWidth = LINE_WIDTH;
                    ctx.stroke();
                } else {
                    ctx.fillStyle = sym === "X" ? "#33ff33" : "#ff9933";
                    ctx.fill();
                }
            }
        }
        if (myTurn) {
            var ax = gridX + cursorCol * CELL + CELL / 2;
            ctx.fillStyle = "#ffcc33";
            ctx.beginPath();
            ctx.moveTo(ax, gridY - CELL * 0.35);
            ctx.lineTo(ax - CELL * 0.22, gridY - CELL * 0.68);
            ctx.lineTo(ax + CELL * 0.22, gridY - CELL * 0.68);
            ctx.closePath();
            ctx.fill();
        }
    }

    function updateHud() {
        var statusEl = document.getElementById("status");
        if (statusEl) { statusEl.textContent = statusText || "CONNECT 4"; }
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
    statusText = "CONNECT 4";
    board = [];
    for (var i0 = 0; i0 < ROWS * COLS; i0++) { board.push(""); }
    mySymbol = "X";
    cursorCol = Math.floor(COLS / 2);

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
