/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_update

Description:
    Updates the MPDs inside the apache to show the correct visuals. Should be run regularly.

Parameters:
    _heli - the apache to show the correct values for.

Returns:
    Nothing.

Examples:
    --- Code
    [_heli] call fza_mpd_fnc_update
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _acBusOn = _heli getVariable "fza_systems_acBusOn";

private _lmpdCurr = [_heli, 0] call fza_mpd_fnc_currentPage;
private _rmpdCurr = [_heli, 1] call fza_mpd_fnc_currentPage;

if (_acBusOn && _lmpdCurr == "off") then {
    [_heli, 0, "eng"] call fza_mpd_fnc_setCurrentPage;
};
if (!_acBusOn && _lmpdCurr != "off") then {
    [_heli, 0, "off"] call fza_mpd_fnc_setCurrentPage;
};

if (_acBusOn && _rmpdCurr == "off") then {
    [_heli, 1, "dtu"] call fza_mpd_fnc_setCurrentPage;
};
if (!_acBusOn && _rmpdCurr != "off") then {
    [_heli, 1, "off"] call fza_mpd_fnc_setCurrentPage;
};

(_heli getVariable "fza_mpd_mpdState") # 0 params ["_lpage", "", "_ldrawFunc", "_lState", "_lPersistState"];
(_heli getVariable "fza_mpd_mpdState") # 1 params ["_rpage", "", "_rdrawFunc", "_rState", "_rPersistState"];

[_heli,0,_lState, _lPersistState get _lpage] call _ldrawFunc;
[_heli,1,_rState, _rPersistState get _rpage] call _rdrawFunc;