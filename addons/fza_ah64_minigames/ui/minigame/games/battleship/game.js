(function () {
    "use strict";

    var GAME_ID = "battleship";
    var SCALE = 1.25;
    var LINE_WIDTH = 3;
    var GRID_SIZE = 8;
    var SHIP_LENGTHS = [4, 3, 3, 2];

    // Canvas setup
    var canvas = document.getElementById("canvas");
    var ctx = canvas.getContext("2d");
    var W = 0, H = 0, TOP_MARGIN = 0;
    // Placement phase shows a single centered grid; battle/gameover show two side by side (mine + the target's).
    var soloGridX = 0, soloGridY = 0, CELL_SOLO = 0;
    var myGridX = 0, enemyGridX = 0, gridY = 0, CELL = 0;

    function resize() {
        W = canvas.clientWidth || window.innerWidth;
        H = canvas.clientHeight || window.innerHeight;
        canvas.width = W;
        canvas.height = H;
        TOP_MARGIN = H * 0.12;

        // +0.8 cells reserved on each grid block for the A-H/1-8 labels along its top/left edge.
        var availW = W * 0.7, availH = (H - TOP_MARGIN) * 0.8;
        CELL_SOLO = Math.min(availW, availH) / (GRID_SIZE + 0.8);
        soloGridX = (W - CELL_SOLO * (GRID_SIZE + 0.8)) / 2 + CELL_SOLO * 0.8;
        soloGridY = TOP_MARGIN + ((H - TOP_MARGIN) - CELL_SOLO * (GRID_SIZE + 0.8)) / 2 + CELL_SOLO * 0.8;

        var gap = W * 0.08;
        var availW2 = (W - gap) / 2 * 0.9;
        var availH2 = (H - TOP_MARGIN) * 0.74;
        CELL = Math.min(availW2, availH2) / (GRID_SIZE + 0.8);
        var blockW = CELL * (GRID_SIZE + 0.8);
        var totalW = blockW * 2 + gap;
        myGridX = (W - totalW) / 2 + CELL * 0.8;
        enemyGridX = myGridX + blockW + gap;
        gridY = TOP_MARGIN + ((H - TOP_MARGIN) - blockW) / 2 + CELL * 0.8;
    }
    window.addEventListener("resize", resize);
    resize();

    // Audio - real Arma sounds via the bridge, CT_WEBBROWSER can't play Web Audio.
    function sfxShoot() { window.fzaMinigame.playSfx("shoot"); }
    function sfxHit() { window.fzaMinigame.playSfx("explosionSmall"); }
    function sfxSunk() { window.fzaMinigame.playSfx("explosionBig"); }
    function sfxDeath() { window.fzaMinigame.playSfx("death"); }

    window.fza_minigame_setMuted = function (isMuted) {
        var btn = document.getElementById("muteBtn");
        if (btn) { btn.classList.toggle("active", !isMuted); }
    };

    // Pushed by fn_minigameReportResult.sqf - personal win/loss record (no points scoreboard for this game).
    var wins = 0, losses = 0;
    window.fza_minigame_setRecord = function (w, l) {
        wins = w; losses = l;
    };

    // Generic 2-player session (same heli+seat model Pong uses) - each side is permanently authoritative for its
    // own ship placement, so this is plain turn-based message passing, not continuous state sync like Pong's ball.
    var role = null; // "host" or "guest" once assigned, null while solo/unjoined
    var peerConnected = false;
    var vsAI = true;
    var myPlacementDone = false;
    var peerPlacementDone = false;

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
                // Connection state changed mid-match - can't sensibly continue against a now-different opponent
                // (AI vs. a peer who just joined, or vice-versa), so start a fresh match against whoever's available.
                startGame();
            }
        } else if (tag === "fire") {
            handleIncomingFire(payload[1], payload[2]);
        } else if (tag === "fireResult") {
            applyMyShotResult(payload[1] + "," + payload[2], { hit: payload[3], sunk: payload[4], allSunk: payload[5] });
        } else if (tag === "shipsPlaced") {
            peerPlacementDone = true;
            checkBothPlaced();
        }
    };

    // Input - native keyboard and SQF-forwarded (fn_minigameHandleInput.sqf). up/down/left/right move the cursor/
    // ghost one cell per press (discrete, not held-continuous like the physics games); "fire" is the generic
    // confirm/shoot action (default Space), mirrored by the b4 bezel button.
    var keys = { up: false, down: false, left: false, right: false };

    function setKey(action, isDown) {
        var wasDown = keys[action];
        if (action in keys) { keys[action] = !!isDown; }
        if (isDown && !wasDown) { handleDirectionPress(action); }
    }

    function handleDirectionPress(action) {
        if (!started) { startGame(); return; }
        if (phase === "gameover") { startGame(); return; }
        if (phase === "placement") { moveGhost(action); }
        else if (phase === "battle" && myTurn) { moveCursor(action); }
    }

    function triggerConfirm() {
        if (!started) { startGame(); return; }
        if (phase === "gameover") { startGame(); return; }
        if (phase === "placement") { confirmPlacement(); return; }
        if (phase === "battle" && myTurn) { fireAtCursor(); }
    }

    // "fire" is a press-only action (CfgUserActionDefPress, no key-up event) - every call means a fresh press,
    // so no edge-tracking is needed here the way the held directions need.
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
        // e.repeat filters out the browser's own key-repeat while held, matching the in-game press-only action.
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

    // b2 rotates the ghost ship during placement (no-op otherwise). b4 confirms placement / fires at the cursor -
    // same action as the generic "fire" keybind above. b5 ("pause") has no role in a turn-based game with nothing
    // actively ticking between moves, so it's left as a no-op here rather than repurposed.
    window.fza_minigame_aux = function () {
        if (phase === "placement") { rotateGhost(); }
    };
    window.fza_minigame_restart = function () {
        triggerConfirm();
    };
    window.fza_minigame_setManualPaused = function () {};

    // Game state
    var phase; // "menu" | "placement" | "battle" | "gameover"
    var started;
    var myShips, aiShips, shipIndex, ghost, cursor;
    var shotsAtEnemy, shotsAtMe, aiTargetQueue, aiTurnTimer;
    var myTurn, statusText, lastWon;

    function cellsForShip(row, col, length, horizontal) {
        var cells = [];
        for (var i = 0; i < length; i++) {
            cells.push(horizontal ? { row: row, col: col + i } : { row: row + i, col: col });
        }
        return cells;
    }

    function isValidPlacement(cells) {
        for (var i = 0; i < cells.length; i++) {
            var c = cells[i];
            if (c.row < 0 || c.row >= GRID_SIZE || c.col < 0 || c.col >= GRID_SIZE) { return false; }
        }
        for (var s = 0; s < myShips.length; s++) {
            for (var a = 0; a < myShips[s].cells.length; a++) {
                var sc = myShips[s].cells[a];
                for (var j = 0; j < cells.length; j++) {
                    if (cells[j].row === sc.row && cells[j].col === sc.col) { return false; }
                }
            }
        }
        return true;
    }

    function clampGhost() {
        var length = SHIP_LENGTHS[shipIndex];
        var maxRow = ghost.horizontal ? GRID_SIZE - 1 : GRID_SIZE - length;
        var maxCol = ghost.horizontal ? GRID_SIZE - length : GRID_SIZE - 1;
        ghost.row = Math.max(0, Math.min(maxRow, ghost.row));
        ghost.col = Math.max(0, Math.min(maxCol, ghost.col));
    }

    function moveGhost(action) {
        if (action === "up") { ghost.row -= 1; }
        if (action === "down") { ghost.row += 1; }
        if (action === "left") { ghost.col -= 1; }
        if (action === "right") { ghost.col += 1; }
        clampGhost();
    }

    function rotateGhost() {
        ghost.horizontal = !ghost.horizontal;
        clampGhost();
    }

    function confirmPlacement() {
        var length = SHIP_LENGTHS[shipIndex];
        var cells = cellsForShip(ghost.row, ghost.col, length, ghost.horizontal);
        if (!isValidPlacement(cells)) { return; }
        myShips.push({ cells: cells, hits: 0, length: length, sunk: false });
        shipIndex += 1;
        if (shipIndex >= SHIP_LENGTHS.length) {
            if (vsAI) {
                finishPlacementSolo();
            } else {
                myPlacementDone = true;
                window.fzaMinigame.netSend(GAME_ID, ["shipsPlaced"]);
                phase = "waitingForPeer";
                statusText = "WAITING FOR OPPONENT...";
                checkBothPlaced();
            }
        } else {
            ghost = { row: 0, col: 0, horizontal: true };
            clampGhost();
        }
    }

    function placeShipsRandom(targetShips) {
        for (var i = 0; i < SHIP_LENGTHS.length; i++) {
            var length = SHIP_LENGTHS[i];
            var placed = false;
            var attempts = 0;
            while (!placed && attempts < 200) {
                attempts++;
                var horizontal = Math.random() < 0.5;
                var maxRow = horizontal ? GRID_SIZE - 1 : GRID_SIZE - length;
                var maxCol = horizontal ? GRID_SIZE - length : GRID_SIZE - 1;
                var row = Math.floor(Math.random() * (maxRow + 1));
                var col = Math.floor(Math.random() * (maxCol + 1));
                var cells = cellsForShip(row, col, length, horizontal);
                var overlap = false;
                for (var s = 0; s < targetShips.length; s++) {
                    for (var a = 0; a < targetShips[s].cells.length; a++) {
                        for (var b = 0; b < cells.length; b++) {
                            if (targetShips[s].cells[a].row === cells[b].row && targetShips[s].cells[a].col === cells[b].col) { overlap = true; }
                        }
                    }
                }
                if (!overlap) {
                    targetShips.push({ cells: cells, hits: 0, length: length, sunk: false });
                    placed = true;
                }
            }
        }
    }

    function finishPlacementSolo() {
        aiShips = [];
        placeShipsRandom(aiShips);
        shotsAtEnemy = {};
        shotsAtMe = {};
        aiTargetQueue = [];
        cursor = { row: 0, col: 0 };
        phase = "battle";
        myTurn = true;
        statusText = "YOUR TURN";
    }

    // Both sides place independently and signal "shipsPlaced" - only once both have confirmed does battle start,
    // since there's no way to "hand off" a placement decision the other player hasn't made yet.
    function checkBothPlaced() {
        if (!myPlacementDone || !peerPlacementDone) { return; }
        shotsAtEnemy = {};
        shotsAtMe = {};
        cursor = { row: 0, col: 0 };
        phase = "battle";
        myTurn = (role === "host");
        statusText = myTurn ? "YOUR TURN" : "OPPONENT'S TURN";
    }

    function moveCursor(action) {
        if (action === "up") { cursor.row -= 1; }
        if (action === "down") { cursor.row += 1; }
        if (action === "left") { cursor.col -= 1; }
        if (action === "right") { cursor.col += 1; }
        cursor.row = Math.max(0, Math.min(GRID_SIZE - 1, cursor.row));
        cursor.col = Math.max(0, Math.min(GRID_SIZE - 1, cursor.col));
    }

    function resolveShot(targetShips, row, col) {
        for (var s = 0; s < targetShips.length; s++) {
            var ship = targetShips[s];
            for (var i = 0; i < ship.cells.length; i++) {
                if (ship.cells[i].row === row && ship.cells[i].col === col) {
                    ship.hits += 1;
                    if (ship.hits >= ship.length) { ship.sunk = true; }
                    return { hit: true, sunk: ship.sunk, allSunk: allSunk(targetShips) };
                }
            }
        }
        return { hit: false, sunk: false, allSunk: allSunk(targetShips) };
    }

    function allSunk(ships) {
        return ships.every(function (s) { return s.sunk; });
    }

    // Shared by both the solo (resolved locally against aiShips) and 2-player (resolved remotely, delivered via
    // a "fireResult" message) paths once a result for one of MY shots is known.
    function applyMyShotResult(key, result) {
        shotsAtEnemy[key] = result.sunk ? "sunk" : (result.hit ? "hit" : "miss");
        if (result.hit) { if (result.sunk) { sfxSunk(); } else { sfxHit(); } }
        if (result.allSunk) { endGame(true); return; }
        myTurn = false;
        if (vsAI) {
            statusText = "AI THINKING...";
            aiTurnTimer = 0.7 + Math.random() * 0.5;
        } else {
            statusText = "OPPONENT'S TURN";
        }
    }

    function fireAtCursor() {
        var key = cursor.row + "," + cursor.col;
        if (shotsAtEnemy[key]) { return; }
        sfxShoot();
        if (vsAI) {
            applyMyShotResult(key, resolveShot(aiShips, cursor.row, cursor.col));
        } else {
            window.fzaMinigame.netSend(GAME_ID, ["fire", cursor.row, cursor.col]);
            myTurn = false;
            statusText = "FIRING...";
        }
    }

    // Incoming "fire" from the peer - I'm the only one who knows my own ship layout, so I resolve it and reply.
    function handleIncomingFire(row, col) {
        var result = resolveShot(myShips, row, col);
        var key = row + "," + col;
        shotsAtMe[key] = result.sunk ? "sunk" : (result.hit ? "hit" : "miss");
        window.fzaMinigame.netSend(GAME_ID, ["fireResult", row, col, result.hit, result.sunk, result.allSunk]);
        if (result.allSunk) { endGame(false); return; }
        myTurn = true;
        statusText = "YOUR TURN";
    }

    function pushNeighbors(row, col) {
        var deltas = [[-1, 0], [1, 0], [0, -1], [0, 1]];
        for (var i = 0; i < deltas.length; i++) {
            var r = row + deltas[i][0], c = col + deltas[i][1];
            if (r >= 0 && r < GRID_SIZE && c >= 0 && c < GRID_SIZE) {
                aiTargetQueue.push({ row: r, col: c });
            }
        }
    }

    // Classic "hunt and target" AI: random shots until a hit, then chase adjacent cells until that ship sinks.
    function aiFire() {
        var target = null;
        while (aiTargetQueue.length) {
            var cand = aiTargetQueue.shift();
            var k = cand.row + "," + cand.col;
            if (!shotsAtMe[k]) { target = cand; break; }
        }
        if (!target) {
            var attempts = 0;
            while (attempts < 200 && !target) {
                attempts++;
                var r = Math.floor(Math.random() * GRID_SIZE);
                var c = Math.floor(Math.random() * GRID_SIZE);
                var k2 = r + "," + c;
                if (!shotsAtMe[k2]) { target = { row: r, col: c }; }
            }
        }
        if (!target) { myTurn = true; statusText = "YOUR TURN"; return; }

        sfxShoot();
        var result = resolveShot(myShips, target.row, target.col);
        var key = target.row + "," + target.col;
        shotsAtMe[key] = result.sunk ? "sunk" : (result.hit ? "hit" : "miss");
        if (result.hit) {
            if (result.sunk) { sfxSunk(); aiTargetQueue = []; } else { sfxHit(); pushNeighbors(target.row, target.col); }
        }
        if (result.allSunk) { endGame(false); return; }
        myTurn = true;
        statusText = "YOUR TURN";
    }

    // Callers are responsible for only invoking this when appropriate (handleDirectionPress/triggerConfirm gate on
    // !started/gameover; the "peer connection changed" handler above calls it directly to force a fresh match).
    function startGame() {
        started = true;
        myShips = [];
        aiShips = [];
        shipIndex = 0;
        ghost = { row: 0, col: 0, horizontal: true };
        clampGhost();
        myPlacementDone = false;
        peerPlacementDone = false;
        phase = "placement";
        statusText = "PLACE SHIPS";
        document.getElementById("overlay").classList.add("hidden");
    }

    function endGame(won) {
        phase = "gameover";
        lastWon = won;
        window.fzaMinigame.reportResult(GAME_ID, won);
        if (!won) { sfxDeath(); }
        document.getElementById("overlaySub").textContent = (won ? "VICTORY" : "DEFEAT") + " - press any key to restart";
        document.getElementById("overlay").classList.remove("hidden");
    }

    // Update
    function update(dt) {
        if (!started) { return; }
        if (phase === "battle" && !myTurn) {
            aiTurnTimer -= dt;
            if (aiTurnTimer <= 0) { aiFire(); }
        }
    }

    // Render
    function drawGridLines(originX, originY, cellSize) {
        ctx.strokeStyle = "#226622";
        ctx.lineWidth = LINE_WIDTH;
        for (var i = 0; i <= GRID_SIZE; i++) {
            ctx.beginPath();
            ctx.moveTo(originX + i * cellSize, originY);
            ctx.lineTo(originX + i * cellSize, originY + GRID_SIZE * cellSize);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(originX, originY + i * cellSize);
            ctx.lineTo(originX + GRID_SIZE * cellSize, originY + i * cellSize);
            ctx.stroke();
        }
    }

    // Classic Battleship coordinate notation - columns A-H, rows 1-8 for our 8x8 grid.
    function drawLabels(originX, originY, cellSize) {
        ctx.fillStyle = "#33ff33";
        ctx.font = Math.round(cellSize * 0.38) + "px 'Courier New', monospace";
        ctx.textBaseline = "middle";
        ctx.textAlign = "center";
        for (var c = 0; c < GRID_SIZE; c++) {
            ctx.fillText(String.fromCharCode(65 + c), originX + c * cellSize + cellSize / 2, originY - cellSize * 0.45);
        }
        ctx.textAlign = "right";
        for (var r = 0; r < GRID_SIZE; r++) {
            ctx.fillText(String(r + 1), originX - cellSize * 0.3, originY + r * cellSize + cellSize / 2);
        }
    }

    function drawGridTitle(text, originX, cellSize) {
        ctx.fillStyle = "#66cc66";
        ctx.font = Math.round(H * 0.032) + "px 'Courier New', monospace";
        ctx.textAlign = "center";
        ctx.textBaseline = "alphabetic";
        ctx.fillText(text, originX + GRID_SIZE * cellSize / 2, TOP_MARGIN * 0.7);
    }

    function drawPlacement() {
        drawLabels(soloGridX, soloGridY, CELL_SOLO);
        drawGridLines(soloGridX, soloGridY, CELL_SOLO);
        ctx.fillStyle = "#226622";
        for (var s = 0; s < myShips.length; s++) {
            var ship = myShips[s];
            for (var i = 0; i < ship.cells.length; i++) {
                var c = ship.cells[i];
                ctx.fillRect(soloGridX + c.col * CELL_SOLO + 2, soloGridY + c.row * CELL_SOLO + 2, CELL_SOLO - 4, CELL_SOLO - 4);
            }
        }
        if (phase !== "placement") { return; }
        var length = SHIP_LENGTHS[shipIndex];
        var cells = cellsForShip(ghost.row, ghost.col, length, ghost.horizontal);
        var valid = isValidPlacement(cells);
        ctx.fillStyle = valid ? "rgba(51,255,51,0.5)" : "rgba(255,51,51,0.5)";
        for (i = 0; i < cells.length; i++) {
            c = cells[i];
            ctx.fillRect(soloGridX + c.col * CELL_SOLO + 2, soloGridY + c.row * CELL_SOLO + 2, CELL_SOLO - 4, CELL_SOLO - 4);
        }
    }

    // My own fleet, fully visible - ship cells colored by status, plus any misses the opponent has fired at me.
    function drawMyGrid() {
        drawGridTitle("YOUR FLEET", myGridX, CELL);
        drawLabels(myGridX, gridY, CELL);
        drawGridLines(myGridX, gridY, CELL);
        var s, ship, i, c, key;
        for (s = 0; s < myShips.length; s++) {
            ship = myShips[s];
            for (i = 0; i < ship.cells.length; i++) {
                c = ship.cells[i];
                key = c.row + "," + c.col;
                ctx.fillStyle = ship.sunk ? "#552222" : (shotsAtMe[key] ? "#ff9933" : "#226622");
                ctx.fillRect(myGridX + c.col * CELL + 2, gridY + c.row * CELL + 2, CELL - 4, CELL - 4);
            }
        }
        for (key in shotsAtMe) {
            if (shotsAtMe[key] === "miss") {
                var parts = key.split(",");
                var r = parseInt(parts[0], 10), col = parseInt(parts[1], 10);
                ctx.fillStyle = "#666666";
                ctx.beginPath();
                ctx.arc(myGridX + col * CELL + CELL / 2, gridY + r * CELL + CELL / 2, CELL * 0.12, 0, Math.PI * 2);
                ctx.fill();
            }
        }
    }

    // Fog of war over the target's grid - only my own hits/misses, plus the firing cursor when it's my turn.
    function drawEnemyGrid() {
        drawGridTitle("TARGET", enemyGridX, CELL);
        drawLabels(enemyGridX, gridY, CELL);
        drawGridLines(enemyGridX, gridY, CELL);
        var key, parts, r, c, state, pad;
        for (key in shotsAtEnemy) {
            parts = key.split(",");
            r = parseInt(parts[0], 10);
            c = parseInt(parts[1], 10);
            state = shotsAtEnemy[key];
            if (state === "miss") {
                ctx.fillStyle = "#666666";
                ctx.beginPath();
                ctx.arc(enemyGridX + c * CELL + CELL / 2, gridY + r * CELL + CELL / 2, CELL * 0.12, 0, Math.PI * 2);
                ctx.fill();
            } else {
                ctx.strokeStyle = state === "sunk" ? "#ff3333" : "#ff9933";
                ctx.lineWidth = LINE_WIDTH;
                pad = CELL * 0.25;
                ctx.beginPath();
                ctx.moveTo(enemyGridX + c * CELL + pad, gridY + r * CELL + pad);
                ctx.lineTo(enemyGridX + (c + 1) * CELL - pad, gridY + (r + 1) * CELL - pad);
                ctx.moveTo(enemyGridX + (c + 1) * CELL - pad, gridY + r * CELL + pad);
                ctx.lineTo(enemyGridX + c * CELL + pad, gridY + (r + 1) * CELL - pad);
                ctx.stroke();
            }
        }
        if (myTurn) {
            ctx.strokeStyle = "#ffcc33";
            ctx.lineWidth = LINE_WIDTH * 1.5;
            ctx.strokeRect(enemyGridX + cursor.col * CELL + 2, gridY + cursor.row * CELL + 2, CELL - 4, CELL - 4);
        }
    }

    function drawBattle() {
        drawMyGrid();
        drawEnemyGrid();
    }

    function updateButtonLabels() {
        var rb = document.getElementById("restartBtn"); // b4
        if (rb) { rb.textContent = phase === "placement" ? "CONFIRM" : "FIRE"; }
    }

    function updateHud() {
        var recordEl = document.getElementById("record");
        if (recordEl) { recordEl.textContent = "W-L " + wins + "-" + losses; }
        var statusEl = document.getElementById("status");
        if (statusEl) { statusEl.textContent = statusText || "BATTLESHIP"; }
        var shipsEl = document.getElementById("shipsRemaining");
        if (shipsEl && myShips) {
            shipsEl.textContent = "SHIPS " + (myShips.length - myShips.filter(function (s) { return s.sunk; }).length);
        }
        updateButtonLabels();
    }

    function render() {
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, W, H);
        if (started) {
            if (phase === "placement" || phase === "waitingForPeer") { drawPlacement(); }
            if (phase === "battle" || phase === "gameover") { drawBattle(); }
        }
        updateHud();
    }

    // Main loop
    started = false;
    phase = "menu";
    statusText = "BATTLESHIP";
    myShips = []; aiShips = [];

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
