/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rfiMergedChars

Description:
    The type characters an FCR target carries once the FCR has merged it with an RFI emitter (fza_fcr_fnc_update)

Parameters:
    _heli   - the helicopter
    _target - the target's object

Returns:
    [left, right] (fza_ase_fnc_rfiChars), or [] when it isn't merged

Examples:
    [_heli, _target] call fza_ase_fnc_rfiMergedChars

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", ["_target", objNull, [objNull]]];

if (isNull _target || {!(_target in (_heli getVariable ["fza_ah64_fcrRfiMerged", []]))}) exitWith {[]};
private _emitters = _heli getVariable ["fza_ah64_ase_rfiEmitters", []];
private _i = _emitters findIf {(_x # ASE_RFI_OBJ) isEqualTo _target};
if (_i < 0) exitWith {[]};
[(_emitters # _i) # ASE_RFI_CODE] call fza_ase_fnc_rfiChars
