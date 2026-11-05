/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_iatGates

Description:
    The IAT gates as a world point and size, for each display to project
    through its own camera as it does its other world symbols: about the
    target while tracking, and in stop mode about a point out along the TADS
    LOS at the size they had. None with the IAT off or failed, or in the DVO.

Parameters:
    _heli - The helicopter

Returns:
    [ASL position, half size [across, up] m], [] for none

Examples:
    --- Code
    ([_heli] call fza_ihadss_fnc_iatGates) params ["_pos", "_half"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

(_heli getVariable ["fza_ah64_iat", IAT_IDLE]) params ["_state", "", "", "", "", "", "", "_half", "", "_stopGate"];
if !(_state in [IAT_TRACK, IAT_COAST, IAT_STOP]) exitWith {[]};
if (([_heli] call fza_ihadss_fnc_getVisionMode) == 3) exitWith {[]};

if (_state == IAT_STOP) exitWith {
    ([_heli] call fza_ihadss_fnc_tadsLos) params ["_losPos", "_losDir"];
    private _fov = fza_ah64_tadsFOVs select (_heli getVariable ["fza_ihadss_tadsOpticsMode", _heli getTurretOpticsMode [0]]);
    if (_stopGate isEqualTo []) then {_stopGate = [IAT_GATE_MAX, IAT_GATE_MAX]};
    [
        _heli modelToWorldVisualWorld (_losPos vectorAdd (_losDir vectorMultiply 1000)),
        _stopGate apply {_x * _fov * 1000}
    ]
};

private _pos = [_heli] call fza_ihadss_fnc_iatTargetPos;
if (_pos isEqualTo []) exitWith {[]};
[_pos, _half]
