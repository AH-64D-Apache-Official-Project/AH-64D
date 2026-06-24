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
        // Plays a real Arma sound for an SFX cue - CT_WEBBROWSER can't play Web Audio at all.
        playSfx: function (sfxName) {
            sqf("[\"" + escapeForSqf(sfxName) + "\"] call fza_mg_fnc_minigamePlaySfx;");
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
        }
    };

    // SQF calls these directly via ExecJS - games override them to react; defaults are no-ops.
    window.fza_minigame_setMuted = function () {};
    window.fza_minigame_setPaused = function () {};
    window.fza_minigame_restart = function () {}; // b4 bezel button - games override to force a fresh start regardless of current state
    window.fza_minigame_setScores = function () {}; // (myHighScore, scores) - scores is [name, score] pairs, sorted descending
    window.fza_minigame_setRecord = function () {}; // (wins, losses) - personal win/loss record for games that use reportResult
    window.fza_minigame_input = function () {}; // keybind input forwarded from SQF, since CEF keyboard focus isn't reliable
    window.fza_minigame_netRecv = function () {}; // (payload) - relayed from the other party in a 2-player session, payload[0] is a free-form type tag
}());
