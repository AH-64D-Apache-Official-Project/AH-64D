/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqSet

Description:
    Selects the local crew station's acquisition source. For the CPG a new
    selection turns slave off. For the pilot slaving is in effect on selection:
    with FCR as the sight the FCR centerline is slaved to the new source.
    A coordinate point (from the COORD page) also becomes the crew station's
    point on the ACQ list (B5); the pilot, slaved on selection, gets the nav
    range to it, the CPG when slaving (fza_fnc_targetingSlave).

Parameters:
    _heli - The helicopter
    _acq  - Acquisition source name, one of fza_fnc_targetingAcqOptions, or a point name

Returns:
    Nothing

Examples:
    [_heli, "GHS"] call fza_fnc_targetingAcqSet
    [_heli, "T01"] call fza_fnc_targetingAcqSet

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_acq"];

private _seat = [_heli] call fza_fnc_getSeat;
if (isNil "_seat") exitWith {};
if (ACQ_IS_POINT(_acq)) then {_heli setVariable ["fza_ah64_acqPoint_" + _seat, _acq, true]};
if !(_acq in ([_heli, _seat] call fza_fnc_targetingAcqOptions)) exitWith {};

_heli setVariable ["fza_ah64_acq_" + _seat, _acq, true];

if (_seat == "cpg") then {
    _heli setVariable ["fza_ah64_cpgSlaved", false, true];
} else {
    if (([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) == SIGHT_FCR) then {
        [_heli, _acq] call fza_fcr_fnc_slaveCenterline;
    };
    [_heli, _seat, _acq] call fza_fnc_targetingAcqNavRange;
};
