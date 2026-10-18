/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqCue

Description:
    The acquisition LOS a crew station is cued to: the cued LOS reticle and the
    cueing dots. The CPG is only cued while slaved, except to a stored point with
    TADS as the sight; the pilot whenever a source is selected. FCR without an
    NTS, ?01 and a point no longer stored give no cueing.

Parameters:
    _heli   - The helicopter
    _turret - [-1] pilot or [0] CPG

Returns:
    World space vector to the acquisition LOS, or nil when there is no cueing

Examples:
    private _cue = [_heli, [0]] call fza_fnc_targetingAcqCue;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_turret"];

private _acq = [_heli, _turret] call fza_fnc_targetingCurAcq;
if (_turret isEqualTo [0]
    && {!(_heli getVariable ["fza_ah64_cpgSlaved", false])}
    && {!(ACQ_IS_POINT(_acq) && {([_heli, "fza_ah64_sight", "cpg"] call fza_fnc_getSeatVariable) == SIGHT_TADS})}) exitWith {nil};
if ((_acq == "FCR" || {ACQ_IS_POINT(_acq)}) && {([_heli, _acq] call fza_fnc_targetingAcqPoint) isEqualTo []}) exitWith {nil};
[_heli, _acq] call fza_fnc_targetingAcqVec
