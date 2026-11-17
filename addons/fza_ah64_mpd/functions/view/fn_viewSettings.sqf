/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_viewSettings

Description:
    How an MPD is to be shown on this machine, from the local crew station's
    knobs (the pilot's when not crew), or a given crew station's. The level is
    BRT within the range the DAY/NIGHT/MONO knob selects; MONO on either crew
    station's MPD on that side makes both green only.

Parameters:
    _heli - The helicopter
    _side - The MPD, 0 left or 1 right
    _seat - "plt" or "cpg", the local crew station when omitted

Returns:
    [level 0-1, mono]

Examples:
    --- Code
    ([_heli, 0] call fza_mpd_fnc_viewSettings) params ["_level", "_mono"]
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_side", ["_seat", ""]];

if (_seat == "") then {
    _seat = [_heli] call fza_fnc_getSeat;
    if (isNil "_seat") then {_seat = "plt"};
};

([_heli, _seat, _side] call fza_mpd_fnc_viewState) params ["_brt", "_mode"];
(([MPD_LEVEL_DAY, MPD_LEVEL_NIGHT] select (_mode != MPD_MODE_DAY))) params ["_min", "_max"];
private _other = ([_heli, ["cpg", "plt"] select (_seat == "cpg"), _side] call fza_mpd_fnc_viewState) # MPD_VIEW_MODE;

[_min + (_max - _min) * _brt, _mode == MPD_MODE_MONO || {_other == MPD_MODE_MONO}]
