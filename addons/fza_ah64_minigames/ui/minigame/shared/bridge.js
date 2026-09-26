// Generic JS<->SQF bridge for MFD minigames - new games just load this alongside their own game.js.
(function () {
    "use strict";

    function escapeForSqf(str) {
        return String(str).replace(/\\/g, "\\\\").replace(/"/g, '\\"');
    }

    // A3API.SendAlert is Arma's native binding for this (used by fza_ah64_missionplanner) - NOT window.confirm(), which gets rejected by fn_minigameUiInit.sqf's _isConfirmDialog guard.
    function sqf(code) {
        if (typeof A3API !== "undefined" && A3API && typeof A3API.SendAlert === "function") {
            A3API.SendAlert("sqf:" + code);
        }
    }

    window.fzaMinigame = {
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
        // Generic 2-player session handshake/relay, for net-aware games (e.g. Pong) - host/guest role assignment happens server-side.
        netJoin: function (gameId) {
            sqf("[\"" + escapeForSqf(gameId) + "\"] call fza_mg_fnc_minigameNetJoin;");
        },
        netLeave: function (gameId) {
            sqf("[\"" + escapeForSqf(gameId) + "\"] call fza_mg_fnc_minigameNetLeave;");
        },
        // payload is a flat array of primitives - JSON.stringify produces text that's also valid SQF array-literal syntax.
        netSend: function (gameId, payload) {
            sqf("[\"" + escapeForSqf(gameId) + "\", " + JSON.stringify(payload) + "] call fza_mg_fnc_minigameNetSend;");
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
    window.fza_minigame_netRecv = function () {}; // (payload) - relayed from the other party in a 2-player session, payload[0] is a free-form type tag
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
