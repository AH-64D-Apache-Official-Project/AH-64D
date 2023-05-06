/* ----------------------------------------------------------------------------
Function: fza_fnc_cycle

Description:
    Generic cycling implementation meant to be used by other functions that must cycle through modes.

Parameters:
    _modes - Array of modes to be cycled between
    _current - Current value
    _default - Default value if the current one isn't in modes. Returns mode at index 0 if not.

Returns:
    Next mode from list of modes

Examples:
    (start code)
    _ret = ["hi", "lo", "dir"], "hi"] call fza_fnc_cycle
    //_ret => "lo"

    _ret = ["hi", "lo", "dir"], "dir"] call fza_fnc_cycle
    //_ret => "hi"

    _ret = ["hi", "lo", "dir"], "error"] call fza_fnc_cycle
    //_ret => "hi"

    _ret = ["hi", "lo", "dir"], "error", "dir"] call fza_fnc_cycle
    //_ret => "dir"
    (end)

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params["_modes", "_current", "_default"];

private _currentIndex = _modes find _current;

if (_currentIndex == -1) exitWith {
    if (isNil "_default") then {
        _modes # 0;
    } else {
        _default
    };
};

if (_currentIndex == count _modes - 1) exitWith {
    _modes # 0
};

_modes # (_currentIndex + 1);