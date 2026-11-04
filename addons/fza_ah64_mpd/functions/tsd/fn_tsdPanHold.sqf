/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_tsdPanHold

Description:
    The PAN page's buttons held (fza_mpd_fnc_handleHold): the heading arrows turn
    the pan heading at 40 degrees a second, the next and last waypoint buttons
    step at 2 Hz, the route arrows at 20 Hz (fza_mpd_fnc_tsdPanHandleControl).

Parameters:
    _heli         - The helicopter
    _mpdIndex     - 0 left MPD, 1 right
    _control      - The button held
    _state        - The TSD page's state
    _persistState - The TSD's persistent state on that MPD
    _frameTime    - The frame's length in seconds
    _hold         - The hold: [button, held for, time since the last repeat], the last updated here

Returns:
    Nothing

Examples:
    --- Code
    [_heli, 1, "t4", _state, _persistState, 0.016, _hold] call fza_mpd_fnc_tsdPanHold
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_mpdIndex", "_control", "_state", "_persistState", "_frameTime", "_hold"];

if (_control in ["t4", "t6"]) exitWith {
    ([_heli, _persistState] call fza_mpd_fnc_tsdFrame) params ["_framePos", "_frameHeading"];
    private _frame = [_framePos, (_frameHeading + ([-40, 40] select (_control == "t6")) * _frameTime + 360) mod 360];
    _persistState set ["frozen", _frame];
    _persistState set ["lastPan", +_frame];
};

private _period = switch (_control) do {
    case "l2";
    case "l5": {0.5};
    case "l3";
    case "l4": {0.05};
    default {-1};
};
if (_period < 0) exitWith {};
_hold set [2, (_hold # 2) + _frameTime];
while {(_hold # 2) >= _period} do {
    _hold set [2, (_hold # 2) - _period];
    [_heli, _mpdIndex, _control, _state, _persistState] call fza_mpd_fnc_tsdPanHandleControl;
};
