(function () {
    "use strict";

    var GAME_ID = "checkers";
    var LINE_WIDTH = 3;
    var BOARD_SIZE = 8;

    // Canvas setup
    var canvas = document.getElementById("canvas");
    var ctx = canvas.getContext("2d");
    var W = 0, H = 0, TOP_MARGIN = 0;
    var boardX = 0, boardY = 0, CELL = 0;

    function resize() {
        W = canvas.clientWidth || window.innerWidth;
        H = canvas.clientHeight || window.innerHeight;
        canvas.width = W;
        canvas.height = H;
        TOP_MARGIN = H * 0.17; // clears the now-taller name/record/status HUD stack at the top
        var boardPixels = Math.min(W * 0.8, (H - TOP_MARGIN) * 0.85);
        CELL = boardPixels / BOARD_SIZE;
        boardX = (W - boardPixels) / 2;
        boardY = TOP_MARGIN + (H - TOP_MARGIN - boardPixels) / 2;
    }
    window.addEventListener("resize", resize);
    resize();

    // Audio - real Arma sounds via the bridge, CT_WEBBROWSER can't play Web Audio.
    function sfxMove() { window.fzaMinigame.playSfx("shoot"); }
    function sfxCapture() { window.fzaMinigame.playSfx("explosionSmall"); }
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

    // Generic 2-player session (same heli+seat model the other games use). No hidden state on either side, so
    // moves are broadcast and applied identically - but unlike Tic-Tac-Toe/Connect Four, a single turn can be
    // several messages long (a multi-jump chain), so an explicit "endTurn" message marks when control passes,
    // rather than the receiver having to guess whether another jump is coming.
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
            } else if (started && phase === "playing" && peerConnected !== wasConnected) {
                startGame();
            }
        } else if (tag === "record") {
            peerRecord.wins = payload[1]; peerRecord.losses = payload[2];
            updateRecords();
        } else if (tag === "move") {
            var capR = payload[5] === -1 ? undefined : payload[5];
            var capC = payload[6] === -1 ? undefined : payload[6];
            doApplyMove(payload[1], payload[2], payload[3], payload[4], capR, capC);
        } else if (tag === "endTurn") {
            if (checkPieceCounts()) { return; }
            if (checkStalemateForSideAboutToMove(mySymbol)) { return; }
            myTurn = true;
            statusText = "YOUR TURN";
        } else if (tag === "gameOver") {
            // The opponent's own move/turn just concluded the match on their end (by elimination or stalemate) -
            // their turn-ending code paths return early in that case and never send "move"/"endTurn", so this is
            // the only signal we get; without it our screen would just sit frozen showing "OPPONENT'S TURN" forever.
            endGame(!payload[1], true);
        }
    };

    // Input - native keyboard and SQF-forwarded (fn_minigameHandleInput.sqf). up/down/left/right move the cursor
    // one square per press; "fire" (default Space, mirrored by b4) selects a piece / confirms a move. b2 ("aux",
    // mirrored on screen as END TURN) stops a multi-jump chain early or deselects the current piece.
    var keys = { up: false, down: false, left: false, right: false };

    function setKey(action, isDown) {
        var wasDown = keys[action];
        if (action in keys) { keys[action] = !!isDown; }
        if (isDown && !wasDown) { handleDirectionPress(action); }
    }

    function handleDirectionPress(action) {
        if (!started) { startGame(); return; }
        if (phase === "gameover") { startGame(); return; }
        if (phase === "playing" && myTurn) { moveCursor(action); }
    }

    function triggerConfirm() {
        if (!started) { startGame(); return; }
        if (phase === "gameover") { startGame(); return; }
        if (phase === "playing" && myTurn) { handleSelectOrMove(); }
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

    window.fza_minigame_aux = function () {
        if (phase !== "playing" || !myTurn) { return; }
        if (midJump) { finishMyTurn(); }
        else if (selected) { selected = null; legalMoves = []; }
    };
    // b4 ("restart") selects a piece / confirms a move - nothing meaningful to "restart mid-match" here. b5
    // ("pause") is likewise left as a no-op, same reasoning as the other turn-based games.
    window.fza_minigame_restart = function () {
        triggerConfirm();
    };
    window.fza_minigame_setManualPaused = function () {};

    // Game state
    var phase; // "menu" | "playing" | "gameover"
    var started;
    var board, cursor, selected, legalMoves, midJump;
    var mySymbol, myTurn, statusText, aiTurnTimer;
    // Pieces always start at rows 5-7 ("X") and 0-2 ("O") in absolute board coordinates, but each player should
    // see their OWN pieces near the bottom of their own screen - so the "O" side's view is rotated 180 degrees
    // (both axes) purely for rendering/input purposes; absolute board coordinates never change.
    var flipped = false;

    function inBounds(r, c) { return r >= 0 && r < BOARD_SIZE && c >= 0 && c < BOARD_SIZE; }
    function forwardDir(sym) { return sym === "X" ? -1 : 1; }

    function setupBoard() {
        board = [];
        var r, c;
        for (r = 0; r < BOARD_SIZE; r++) { board.push([null, null, null, null, null, null, null, null]); }
        for (r = 0; r < 3; r++) { for (c = 0; c < BOARD_SIZE; c++) { if ((r + c) % 2 === 1) { board[r][c] = { sym: "O", king: false }; } } }
        for (r = 5; r < 8; r++) { for (c = 0; c < BOARD_SIZE; c++) { if ((r + c) % 2 === 1) { board[r][c] = { sym: "X", king: false }; } } }
    }

    function pieceCaptures(r, c) {
        var piece = board[r][c];
        if (!piece) { return []; }
        var oppSym = piece.sym === "X" ? "O" : "X";
        var dirs = piece.king ? [[-1, -1], [-1, 1], [1, -1], [1, 1]] : [[forwardDir(piece.sym), -1], [forwardDir(piece.sym), 1]];
        var caps = [];
        dirs.forEach(function (d) {
            var mr = r + d[0], mc = c + d[1], lr = r + 2 * d[0], lc = c + 2 * d[1];
            if (inBounds(lr, lc) && board[mr] && board[mr][mc] && board[mr][mc].sym === oppSym && !board[lr][lc]) {
                caps.push({ toRow: lr, toCol: lc, capRow: mr, capCol: mc });
            }
        });
        return caps;
    }

    function pieceSimpleMoves(r, c) {
        var piece = board[r][c];
        if (!piece) { return []; }
        var dirs = piece.king ? [[-1, -1], [-1, 1], [1, -1], [1, 1]] : [[forwardDir(piece.sym), -1], [forwardDir(piece.sym), 1]];
        var moves = [];
        dirs.forEach(function (d) {
            var tr = r + d[0], tc = c + d[1];
            if (inBounds(tr, tc) && !board[tr][tc]) { moves.push({ toRow: tr, toCol: tc }); }
        });
        return moves;
    }

    function sideHasAnyMove(sym) {
        for (var r = 0; r < BOARD_SIZE; r++) {
            for (var c = 0; c < BOARD_SIZE; c++) {
                if (board[r][c] && board[r][c].sym === sym) {
                    if (pieceCaptures(r, c).length || pieceSimpleMoves(r, c).length) { return true; }
                }
            }
        }
        return false;
    }

    function doApplyMove(fromR, fromC, toR, toC, capR, capC) {
        var piece = board[fromR][fromC];
        board[fromR][fromC] = null;
        if (capR !== undefined && capR !== null) {
            board[capR][capC] = null;
            sfxCapture();
        } else {
            sfxMove();
        }
        var kingRow = piece.sym === "X" ? 0 : 7;
        if (toR === kingRow) { piece.king = true; }
        board[toR][toC] = piece;
    }

    function moveCursor(action) {
        var sign = flipped ? -1 : 1; // 180-degree rotation flips the effect of every direction, not just up/down
        if (action === "up") { cursor.row -= sign; }
        if (action === "down") { cursor.row += sign; }
        if (action === "left") { cursor.col -= sign; }
        if (action === "right") { cursor.col += sign; }
        cursor.row = Math.max(0, Math.min(BOARD_SIZE - 1, cursor.row));
        cursor.col = Math.max(0, Math.min(BOARD_SIZE - 1, cursor.col));
    }

    function cellScreenPos(r, c) {
        var sr = flipped ? (BOARD_SIZE - 1 - r) : r;
        var sc = flipped ? (BOARD_SIZE - 1 - c) : c;
        return { x: boardX + sc * CELL, y: boardY + sr * CELL };
    }

    function handleSelectOrMove() {
        var r = cursor.row, c = cursor.col;
        if (!selected) {
            if (board[r][c] && board[r][c].sym === mySymbol) {
                var moves = pieceCaptures(r, c).concat(pieceSimpleMoves(r, c));
                if (moves.length) { selected = { row: r, col: c }; legalMoves = moves; }
            }
            return;
        }
        if (r === selected.row && c === selected.col) { selected = null; legalMoves = []; return; }
        var match = null;
        for (var i = 0; i < legalMoves.length; i++) {
            if (legalMoves[i].toRow === r && legalMoves[i].toCol === c) { match = legalMoves[i]; break; }
        }
        if (match) {
            var fromR = selected.row, fromC = selected.col;
            doApplyMove(fromR, fromC, r, c, match.capRow, match.capCol);
            if (!vsAI) {
                window.fzaMinigame.netSend(GAME_ID, ["move", fromR, fromC, r, c,
                    match.capRow === undefined ? -1 : match.capRow, match.capCol === undefined ? -1 : match.capCol]);
            }
            if (match.capRow !== undefined) {
                if (checkPieceCounts()) { return; }
                var moreCaps = pieceCaptures(r, c);
                if (moreCaps.length) {
                    selected = { row: r, col: c };
                    legalMoves = moreCaps;
                    midJump = true;
                    statusText = "JUMP AGAIN OR PRESS B2 TO END TURN";
                    return;
                }
            }
            finishMyTurn();
            return;
        }
        if (!midJump && board[r][c] && board[r][c].sym === mySymbol) {
            var moves2 = pieceCaptures(r, c).concat(pieceSimpleMoves(r, c));
            if (moves2.length) { selected = { row: r, col: c }; legalMoves = moves2; }
        }
    }

    function checkPieceCounts() {
        var myCount = 0, oppCount = 0;
        for (var r = 0; r < BOARD_SIZE; r++) {
            for (var c = 0; c < BOARD_SIZE; c++) {
                if (board[r][c]) { if (board[r][c].sym === mySymbol) { myCount++; } else { oppCount++; } }
            }
        }
        if (oppCount === 0) { endGame(true); return true; }
        if (myCount === 0) { endGame(false); return true; }
        return false;
    }

    function checkStalemateForSideAboutToMove(sym) {
        if (!sideHasAnyMove(sym)) { endGame(sym !== mySymbol); return true; }
        return false;
    }

    function finishMyTurn() {
        selected = null; legalMoves = []; midJump = false;
        if (checkPieceCounts()) { return; }
        var oppSym = mySymbol === "X" ? "O" : "X";
        if (checkStalemateForSideAboutToMove(oppSym)) { return; }
        if (!vsAI) { window.fzaMinigame.netSend(GAME_ID, ["endTurn"]); }
        myTurn = false;
        statusText = vsAI ? "AI THINKING..." : "OPPONENT'S TURN";
        if (vsAI) { aiTurnTimer = 0.6 + Math.random() * 0.5; }
    }

    function wouldBeCapturable(fromR, fromC, toR, toC, aiSym) {
        var piece = board[fromR][fromC];
        var originalAtTo = board[toR][toC];
        board[fromR][fromC] = null;
        board[toR][toC] = piece;
        var humanSym = aiSym === "X" ? "O" : "X";
        var capturable = false;
        for (var r = 0; r < BOARD_SIZE; r++) {
            for (var c = 0; c < BOARD_SIZE; c++) {
                if (board[r][c] && board[r][c].sym === humanSym) {
                    if (pieceCaptures(r, c).some(function (m) { return m.capRow === toR && m.capCol === toC; })) { capturable = true; }
                }
            }
        }
        board[fromR][fromC] = piece;
        board[toR][toC] = originalAtTo;
        return capturable;
    }

    // Captures are mandatory-if-available for the AI (a reasonable policy, not a rules requirement) and it
    // always continues a multi-jump greedily; otherwise it prefers moves that don't leave it open to an
    // immediate recapture. Not full minimax, but a step up from pure randomness.
    function aiTakeTurn() {
        var aiSym = mySymbol === "X" ? "O" : "X";
        var captureSources = [], simpleSources = [];
        for (var r = 0; r < BOARD_SIZE; r++) {
            for (var c = 0; c < BOARD_SIZE; c++) {
                if (board[r][c] && board[r][c].sym === aiSym) {
                    var caps = pieceCaptures(r, c);
                    if (caps.length) { captureSources.push({ row: r, col: c, moves: caps }); } else {
                        var simple = pieceSimpleMoves(r, c);
                        if (simple.length) { simpleSources.push({ row: r, col: c, moves: simple }); }
                    }
                }
            }
        }
        if (captureSources.length) {
            var src = captureSources[Math.floor(Math.random() * captureSources.length)];
            var mv = src.moves[Math.floor(Math.random() * src.moves.length)];
            aiContinueFrom(src.row, src.col, mv, aiSym);
            return;
        }
        if (simpleSources.length) {
            var safeSources = [];
            simpleSources.forEach(function (s) {
                var safeMoves = s.moves.filter(function (m) { return !wouldBeCapturable(s.row, s.col, m.toRow, m.toCol, aiSym); });
                if (safeMoves.length) { safeSources.push({ row: s.row, col: s.col, moves: safeMoves }); }
            });
            var pool = safeSources.length ? safeSources : simpleSources;
            var src2 = pool[Math.floor(Math.random() * pool.length)];
            var mv2 = src2.moves[Math.floor(Math.random() * src2.moves.length)];
            aiContinueFrom(src2.row, src2.col, mv2, aiSym);
            return;
        }
        endGame(true); // AI has no legal move at all
    }

    function aiContinueFrom(fromR, fromC, move, aiSym) {
        doApplyMove(fromR, fromC, move.toRow, move.toCol, move.capRow, move.capCol);
        if (move.capRow !== undefined) {
            if (checkPieceCounts()) { return; }
            var moreCaps = pieceCaptures(move.toRow, move.toCol);
            if (moreCaps.length) {
                var next = moreCaps[Math.floor(Math.random() * moreCaps.length)];
                aiContinueFrom(move.toRow, move.toCol, next, aiSym);
                return;
            }
        }
        if (checkPieceCounts()) { return; }
        if (checkStalemateForSideAboutToMove(mySymbol)) { return; }
        myTurn = true;
        statusText = "YOUR TURN";
    }

    function startGame() {
        started = true;
        setupBoard();
        cursor = { row: 4, col: 1 };
        selected = null; legalMoves = []; midJump = false;
        mySymbol = vsAI ? "X" : (role === "host" ? "X" : "O");
        flipped = (mySymbol === "O");
        myTurn = (mySymbol === "X");
        phase = "playing";
        statusText = myTurn ? "YOUR TURN" : (vsAI ? "AI THINKING..." : "OPPONENT'S TURN");
        if (!myTurn && vsAI) { aiTurnTimer = 0.6 + Math.random() * 0.5; }
        document.getElementById("overlay").classList.add("hidden");
    }

    function endGame(won, fromRemote) {
        phase = "gameover";
        if (!fromRemote && !vsAI) { window.fzaMinigame.netSend(GAME_ID, ["gameOver", won]); }
        window.fzaMinigame.reportResult(GAME_ID, won);
        if (won) { sfxWin(); } else { sfxLose(); }
        document.getElementById("overlaySub").textContent = (won ? "VICTORY" : "DEFEAT") + " - press any key to restart";
        document.getElementById("overlay").classList.remove("hidden");
    }

    // Update
    function update(dt) {
        if (!started || phase !== "playing") { return; }
        if (!myTurn && vsAI) {
            aiTurnTimer -= dt;
            if (aiTurnTimer <= 0) { aiTakeTurn(); }
        }
    }

    // Render
    function drawBoard() {
        var r, c, p;
        for (r = 0; r < BOARD_SIZE; r++) {
            for (c = 0; c < BOARD_SIZE; c++) {
                p = cellScreenPos(r, c);
                ctx.fillStyle = (r + c) % 2 === 1 ? "#113311" : "#001a00";
                ctx.fillRect(p.x, p.y, CELL, CELL);
            }
        }
        legalMoves.forEach(function (m) {
            var p2 = cellScreenPos(m.toRow, m.toCol);
            var cx = p2.x + CELL / 2, cy = p2.y + CELL / 2;
            ctx.fillStyle = m.capRow !== undefined ? "rgba(255,51,51,0.45)" : "rgba(255,204,51,0.4)";
            ctx.beginPath();
            ctx.arc(cx, cy, CELL * 0.15, 0, Math.PI * 2);
            ctx.fill();
        });
        for (r = 0; r < BOARD_SIZE; r++) {
            for (c = 0; c < BOARD_SIZE; c++) {
                var piece = board[r][c];
                if (!piece) { continue; }
                p = cellScreenPos(r, c);
                var cx2 = p.x + CELL / 2, cy2 = p.y + CELL / 2;
                ctx.beginPath();
                ctx.arc(cx2, cy2, CELL * 0.38, 0, Math.PI * 2);
                ctx.fillStyle = piece.sym === "X" ? "#1a4d1a" : "#4d2a1a";
                ctx.fill();
                ctx.strokeStyle = piece.sym === "X" ? "#33ff33" : "#ff9933";
                ctx.lineWidth = LINE_WIDTH;
                ctx.stroke();
                if (piece.king) {
                    ctx.beginPath();
                    ctx.arc(cx2, cy2, CELL * 0.16, 0, Math.PI * 2);
                    ctx.strokeStyle = "#ffcc33";
                    ctx.stroke();
                }
            }
        }
        if (selected) {
            var sp = cellScreenPos(selected.row, selected.col);
            ctx.strokeStyle = "#ffcc33";
            ctx.lineWidth = LINE_WIDTH * 1.3;
            ctx.strokeRect(sp.x + 2, sp.y + 2, CELL - 4, CELL - 4);
        }
        var cp = cellScreenPos(cursor.row, cursor.col);
        ctx.strokeStyle = "#ffffff";
        ctx.lineWidth = LINE_WIDTH;
        ctx.strokeRect(cp.x + 4, cp.y + 4, CELL - 8, CELL - 8);
    }

    function updateHud() {
        var statusEl = document.getElementById("status");
        if (statusEl) { statusEl.textContent = statusText || "CHECKERS"; }
        var piecesEl = document.getElementById("pieces");
        if (piecesEl && board) {
            var count = 0;
            for (var r = 0; r < BOARD_SIZE; r++) { for (var c = 0; c < BOARD_SIZE; c++) { if (board[r][c] && board[r][c].sym === mySymbol) { count++; } } }
            piecesEl.textContent = "PIECES " + count;
        }
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
    statusText = "CHECKERS";
    setupBoard();
    cursor = { row: 4, col: 1 };
    selected = null; legalMoves = []; midJump = false;
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
