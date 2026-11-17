/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_viewState

Description:
    One MPD's BRT and DAY/NIGHT/MONO knobs. Each crew station has its own
    MPDs, so each has its own knobs. [brt 0-1, mode] (MPD_VIEW_* indices)

Parameters:
    _heli - The helicopter
    _seat - "plt" or "cpg"
    _side - The MPD, 0 left or 1 right

Returns:
    The settings, a copy

Examples:
    --- Code
    ([_heli, "plt", 0] call fza_mpd_fnc_viewState) # MPD_VIEW_MODE
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_seat", "_side"];

private _view = _heli getVariable [format ["fza_mpd_view_%1_%2", _seat, _side], []];
if !(_view isEqualTypeArray [0, 0]) exitWith {[1, MPD_MODE_DAY]};
+_view
