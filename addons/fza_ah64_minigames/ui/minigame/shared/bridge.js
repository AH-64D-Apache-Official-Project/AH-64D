// Generic JS<->SQF bridge for MFD minigames - new games just load this alongside their own game.js.
(function () {
    "use strict";

    // SQF string literals escape a double quote by doubling it and have no backslash escapes
    function escapeForSqf(str) {
        return String(str).replace(/"/g, '""');
    }

    // JS value -> SQF literal for the argument array read by fza_mg_fnc_minigameBridgeCall (parseSimpleArray):
    // numbers in plain decimal (never exponent form), booleans, quoted strings and nested arrays.
    function toSqf(value) {
        if (Array.isArray(value)) { return "[" + value.map(toSqf).join(",") + "]"; }
        if (typeof value === "number") {
            if (!isFinite(value)) { return "0"; }
            var n = Math.round(value * 10000) / 10000;
            return (Math.abs(n) >= 1e15) ? "0" : String(n);
        }
        if (typeof value === "boolean") { return value ? "true" : "false"; }
        if (value === null || value === undefined) { return '""'; }
        return '"' + escapeForSqf(value) + '"';
    }

    // A3API.SendAlert is Arma's native binding for this (used by fza_ah64_missionplanner) - NOT window.confirm(), which gets rejected by fn_minigameUiInit.sqf's _isConfirmDialog guard.
    function sqf(code) {
        if (typeof A3API !== "undefined" && A3API && typeof A3API.SendAlert === "function") {
            A3API.SendAlert("sqf:" + code);
        }
    }

    var textEls = {};
    var sessionEpoch = null;

    window.fzaMinigame = {
        // Sets an element's text only when it differs, so HUD fields written every frame do not re-layout every frame
        setText: function (id, text) {
            var el = textEls[id] || (textEls[id] = document.getElementById(id));
            if (!el) { return; }
            var str = String(text);
            if (el.textContent !== str) { el.textContent = str; }
        },
        // Call once your game has finished loading and is ready to play.
        ready: function (gameId) {
            sqf("[\"" + escapeForSqf(gameId) + "\"] call fza_mg_fnc_minigameReady;");
        },
        // Call when a play session ends (game over / score finalized).
        reportScore: function (gameId, score) {
            sqf("[\"" + escapeForSqf(gameId) + "\", " + Number(score) + "] call fza_mg_fnc_minigameReportScore;");
        },
        // Call from an in-page mute control, if a game wants its own.
        setMuted: function (gameId, muted) {
            sqf("[\"" + escapeForSqf(gameId) + "\", " + (muted ? "true" : "false") + "] call fza_mg_fnc_minigameSetMuted;");
        },
        // Plays a real Arma sound for an SFX cue. volume is optional (playSoundUI's 0..5 multiplier, default 1).
        playSfx: function (sfxName, volume) {
            var args = "[\"" + escapeForSqf(sfxName) + "\"";
            if (volume !== undefined) { args += ", " + Number(volume); }
            sqf(args + "] call fza_mg_fnc_minigamePlaySfx;");
        },
        // Starts a looping background music track for gameId, stopping whatever was previously playing for it.
        playMusic: function (gameId, trackName, volume) {
            var args = "[\"" + escapeForSqf(gameId) + "\", \"" + escapeForSqf(trackName) + "\"";
            if (volume !== undefined) { args += ", " + Number(volume); }
            sqf(args + "] call fza_mg_fnc_minigamePlayMusic;");
        },
        stopMusic: function (gameId) {
            sqf("[\"" + escapeForSqf(gameId) + "\"] call fza_mg_fnc_minigameStopMusic;");
        },
        // Generic win/loss record (local only) for games with a clear win/lose outcome, e.g. Pong.
        reportResult: function (gameId, won) {
            sqf("[\"" + escapeForSqf(gameId) + "\", " + (won ? "true" : "false") + "] call fza_mg_fnc_minigameReportResult;");
        },
        // Generic 2-player session for net-aware games, run by the server: call netJoin once at load, and the page then
        // gets ["session", ...] whenever its role or opponent changes - see readSession.
        netJoin: function (gameId) {
            sqf("[\"" + escapeForSqf(gameId) + "\"] call fza_mg_fnc_minigameNetJoin;");
        },
        netLeave: function (gameId) {
            sqf("[\"" + escapeForSqf(gameId) + "\"] call fza_mg_fnc_minigameNetLeave;");
        },
        // payload is an array of primitives (numbers, booleans, strings), encoded as an SQF array literal.
        netSend: function (gameId, payload) {
            sqf("[\"" + escapeForSqf(gameId) + "\", " + toSqf(payload) + "] call fza_mg_fnc_minigameNetSend;");
        },
        // Decodes ["session", role, peer, myName, peerName, epoch]. role is "host" or "guest"; peer is "none" (play the
        // AI), "here" or "away" (paged away, ESC or out of the seat). reset is true when the pairing changed or the
        // other page was reloaded, so any match in progress is void and both sides go back to the start screen.
        readSession: function (payload) {
            var reset = payload[5] !== sessionEpoch;
            sessionEpoch = payload[5];
            return { role: payload[1], peer: payload[2], myName: payload[3] || "", peerName: payload[4] || "", reset: reset };
        },
        // Loads a text file via SQF's loadFile + ExecJS push, since CT_WEBBROWSER can't fetch()/XHR and LoadFile itself caps page size at ~24MB. pboPrefix is optional, for assets living outside fza_ah64_minigames's own PBO.
        requestLargeAsset: function (gameId, assetName, pboPrefix) {
            var args = "[\"" + escapeForSqf(gameId) + "\", \"" + escapeForSqf(assetName) + "\"";
            if (pboPrefix) { args += ", \"" + escapeForSqf(pboPrefix) + "\""; }
            sqf(args + "] call fza_mg_fnc_minigameRequestLargeAsset;");
        },
        // Generic profileNamespace-backed persistence. Chunked (A3API.SendAlert has a string-length limit) and paced with a delay between sends, since firing them back-to-back with no gap risks dropped calls.
        persistData: function (gameId, key, data) {
            var CHUNK = 1000; // conservative: enough room for surrounding SQF expression overhead
            var total = Math.ceil(data.length / CHUNK) || 1;
            var i = 0;
            function sendNext() {
                if (i >= total) { return; }
                var chunk = data.slice(i * CHUNK, (i + 1) * CHUNK);
                sqf("[\"" + escapeForSqf(gameId) + "\", \"" + escapeForSqf(key) + "\", " + i + ", " + total + ", \"" + escapeForSqf(chunk) + "\"] call fza_mg_fnc_minigamePersistDataChunk;");
                i++;
                setTimeout(sendNext, 60);
            }
            sendNext();
        },
        // Reply arrives via the same chunked onLargeAssetChunk path as requestLargeAsset, or onPersistedDataEmpty if nothing's been saved for this key yet.
        requestPersistedData: function (gameId, key) {
            sqf("[\"" + escapeForSqf(gameId) + "\", \"" + escapeForSqf(key) + "\"] call fza_mg_fnc_minigameRequestPersistedData;");
        }
    };

    // SQF calls these directly via ExecJS - games override them to react; defaults are no-ops.
    window.fza_minigame_setMuted = function () {};
    window.fza_minigame_setPaused = function () {};
    window.fza_minigame_restart = function () {}; // b4 bezel button - games override to force a fresh start regardless of current state
    window.fza_minigame_aux = function () {}; // b2 bezel button - free for games to repurpose (e.g. Battleship uses it to rotate the ghost ship)
    window.fza_minigame_setScores = function () {}; // (myHighScore, scores) - scores is [name, score] pairs, sorted descending
    window.fza_minigame_setRecord = function () {}; // (wins, losses) - personal win/loss record for games that use reportResult
    window.fza_minigame_input = function () {}; // keybind input forwarded from SQF, since CEF keyboard focus isn't reliable
    window.fza_minigame_netRecv = function () {}; // (payload) - payload[0] is "session" from the server (see readSession), else a free-form tag from the other party
    window.fza_minigame_onLargeAsset = function () {}; // (assetName, text) - response to requestLargeAsset, text is whatever the file contained verbatim
    window.fza_minigame_onPersistedDataEmpty = function () {}; // (key) - response to requestPersistedData when nothing's been saved for that key yet

    // requestLargeAsset's data arrives chunked (format()'s own size ceiling rules out one push) - reassemble here, only firing onLargeAsset once every chunk has arrived.
    var largeAssetBuffers = {};
    window.fza_minigame_onLargeAssetChunk = function (assetName, chunk, chunkIndex, totalChunks) {
        var buf = largeAssetBuffers[assetName];
        if (!buf) { buf = largeAssetBuffers[assetName] = { parts: new Array(totalChunks), received: 0, total: totalChunks }; }
        if (buf.parts[chunkIndex] === undefined) { buf.received++; }
        buf.parts[chunkIndex] = chunk;
        window.fza_minigame_onLargeAssetProgress(assetName, buf.received, buf.total);
        if (buf.received === buf.total) {
            delete largeAssetBuffers[assetName];
            window.fza_minigame_onLargeAsset(assetName, buf.parts.join(""));
        }
    };
    window.fza_minigame_onLargeAssetProgress = function () {}; // (assetName, receivedChunks, totalChunks) - games override for a progress bar
}());
