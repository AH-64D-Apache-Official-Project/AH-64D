/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_handleHold

Description:
    Run each frame an MPD button is held (the Hatchet button's buttonHold). After
    half a second the page's held action repeats it; the PAN page's arrows and
    route buttons are the ones that do (fza_mpd_fnc_tsdPanHold). The button's
    press is its own action (fza_mpd_fnc_handleControl), and its release clears
    fza_mpd_hold.

Parameters:
    _heli      - The helicopter
    _system    - "lmpd" or "rmpd"
    _control   - The button held
    _frameTime - The frame's length in seconds

Returns:
    Nothing

Examples:
    --- Code
    [_heli, "rmpd", "t4", 0.016] call fza_mpd_fnc_handleHold
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_system", "_control", "_frameTime"];

// [button, held for, time since the last repeat]
private _hold = _heli getVariable ["fza_mpd_hold", []];
if ((_hold param [0, ""]) != _system + _control) then {_hold = [_system + _control, 0, 0]};
_hold set [1, (_hold # 1) + _frameTime];
_heli setVariable ["fza_mpd_hold", _hold];
if ((_hold # 1) < 0.5) exitWith {};

private _mpdIndex = parseNumber (_system == "rmpd");
((_heli getVariable "fza_mpd_mpdState") # _mpdIndex) params ["_page", "", "", "", "_state", "_persistState"];
if (toLower _page == "tsd" && {(_state get "subPageVarPage") # 0 == 5}) then {
    [_heli, _mpdIndex, _control, _state, _persistState get _page, _frameTime, _hold] call fza_mpd_fnc_tsdPanHold;
};
