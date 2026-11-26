/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rfiBearing

Description:
    The bearing the RFI gives for an emitter, with its bearing error

Parameters:
    _heli   - the helicopter
    _record - fza_ah64_ase_rfiEmitters record

Returns:
    [world bearing 0-360, bearing from the nose -180-180], or [] with no position

Examples:
    [_heli, _record] call fza_ase_fnc_rfiBearing params ["_world", "_rel"];

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_record"];

private _obj = _record # ASE_RFI_OBJ;
private _pos = _record # ASE_RFI_POS;
if (_pos isEqualTo [] && {!isNull _obj}) then {_pos = getPosASL _obj};
if (_pos isEqualTo []) exitWith {[]};

private _world = ((_heli getDir _pos) + (_record # ASE_RFI_ERR) + 360) mod 360;
[_world, [_world - getDir _heli] call CBA_fnc_simplifyAngle180]
