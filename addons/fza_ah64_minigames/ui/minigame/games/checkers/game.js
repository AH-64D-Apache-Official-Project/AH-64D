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
        TOP_MARGIN = H * 0.12;
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

    // Pushed by fn_minigameReportResult.sqf - personal win/loss record (no points scoreboard for this game).
    var wins = 0, losses = 0;
    window.fza_minigame_setRecord = function (w, l) {
        wins = w; losses = l;
    };

    // Generic 2-player session (same heli+seat model the other games use). No hidden state on either side, so
    // moves are broadcast and applied identically - but unlike Tic-Tac-Toe/Connect Four, a single turn can be
    // several messages long (a multi-jump chain), so an explicit "endTurn" message marks when control passes,
    // rather than the receiver having to guess whether another jump is coming.
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
            } else if (started && phase === "playing" && peerConnected !== wasConnected) {
                startGame();
            }
        } else if (tag === "move") {
            var capR = payload[5] === -1 ? undefined : payload[5];
            var capC = payload[6] === -1 ? undefined : payload[6];
            doApplyMove(payload[1], payload[2], payload[3], payload[4], capR, capC);
        } else if (tag === "endTurn") {
            if (checkPieceCounts()) { return; }
            if (checkStalemateForSideAboutToMove(mySymbol)) { return; }
            myTurn = true;
            statusText = "YOUR TURN";
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
        if (action === "up") { cursor.row -= 1; }
        if (action === "down") { cursor.row += 1; }
        if (action === "left") { cursor.col -= 1; }
        if (action === "right") { cursor.col += 1; }
        cursor.row = Math.max(0, Math.min(BOARD_SIZE - 1, cursor.row));
        cursor.col = Math.max(0, Math.min(BOARD_SIZE - 1, cursor.col));
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
        myTurn = (mySymbol === "X");
        phase = "playing";
        statusText = myTurn ? "YOUR TURN" : (vsAI ? "AI THINKING..." : "OPPONENT'S TURN");
        if (!myTurn && vsAI) { aiTurnTimer = 0.6 + Math.random() * 0.5; }
        document.getElementById("overlay").classList.add("hidden");
    }

    function endGame(won) {
        phase = "gameover";
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
        var r, c;
        for (r = 0; r < BOARD_SIZE; r++) {
            for (c = 0; c < BOARD_SIZE; c++) {
                var x = boardX + c * CELL, y = boardY + r * CELL;
                ctx.fillStyle = (r + c) % 2 === 1 ? "#113311" : "#001a00";
                ctx.fillRect(x, y, CELL, CELL);
            }
        }
        legalMoves.forEach(function (m) {
            var cx = boardX + m.toCol * CELL + CELL / 2, cy = boardY + m.toRow * CELL + CELL / 2;
            ctx.fillStyle = m.capRow !== undefined ? "rgba(255,51,51,0.45)" : "rgba(255,204,51,0.4)";
            ctx.beginPath();
            ctx.arc(cx, cy, CELL * 0.15, 0, Math.PI * 2);
            ctx.fill();
        });
        for (r = 0; r < BOARD_SIZE; r++) {
            for (c = 0; c < BOARD_SIZE; c++) {
                var piece = board[r][c];
                if (!piece) { continue; }
                var cx2 = boardX + c * CELL + CELL / 2, cy2 = boardY + r * CELL + CELL / 2;
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
            ctx.strokeStyle = "#ffcc33";
            ctx.lineWidth = LINE_WIDTH * 1.3;
            ctx.strokeRect(boardX + selected.col * CELL + 2, boardY + selected.row * CELL + 2, CELL - 4, CELL - 4);
        }
        ctx.strokeStyle = "#ffffff";
        ctx.lineWidth = LINE_WIDTH;
        ctx.strokeRect(boardX + cursor.col * CELL + 4, boardY + cursor.row * CELL + 4, CELL - 8, CELL - 8);
    }

    function updateHud() {
        var recordEl = document.getElementById("record");
        if (recordEl) { recordEl.textContent = "W-L " + wins + "-" + losses; }
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
