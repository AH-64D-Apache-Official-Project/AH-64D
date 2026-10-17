/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingSlave

Description:
    The CPG's sight SLAVE switch: toggles slaving the selected sight to the
    acquisition source. Slaved, a TADS sight follows the acquisition LOS, an FCR
    sight has its centerline set to it, and cueing is shown. Slaving turns LMC
    off. The pilot is slaved on selection of a source and has no switch.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_fnc_targetingSlave

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if (player != gunner _heli) exitWith {};

private _slaved = !(_heli getVariable ["fza_ah64_cpgSlaved", false]);
_heli setVariable ["fza_ah64_cpgSlaved", _slaved, true];
if !_slaved exitWith {};

_heli setVariable ["fza_ah64_LmcActive", false, true];
if (([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) == SIGHT_FCR) then {
    [_heli, [_heli, [0]] call fza_fnc_targetingCurAcq] call fza_fcr_fnc_slaveCenterline;
};
