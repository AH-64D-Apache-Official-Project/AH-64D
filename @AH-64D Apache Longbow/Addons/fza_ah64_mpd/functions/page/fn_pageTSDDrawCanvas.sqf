#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_canvas", "_mpdIndex", "_state", "_persistState"];

/*
// Fixed positioning
[_heli, _canvas, [0.5,0.4], [0.5,0.6], [1,0,0,1], MPD_POSMODE_SCREEN] call fza_mpd_fnc_canvasDrawLine;
[_heli, _canvas, [0.4,0.5], [0.6,0.5], [1,0,0,1], MPD_POSMODE_SCREEN] call fza_mpd_fnc_canvasDrawLine;

// Dynamic positioning
private _tsdScale = 0.125 * 5 / (_persistState get "tsdScale");
private _pos = getPosASL _heli;

[_heli, _canvas, _pos vectorAdd [-5000,0,0], _pos vectorAdd [5000,0,0], [0,1,1,1], MPD_POSMODE_WORLD, _tsdScale, [0.5,0.5]] call fza_mpd_fnc_canvasDrawLine;
[_heli, _canvas, _pos vectorAdd [0,5000,0], _pos vectorAdd [0,-5000,0], [0,1,1,1], MPD_POSMODE_WORLD, _tsdScale, [0.5,0.5]] call fza_mpd_fnc_canvasDrawLine;
*/