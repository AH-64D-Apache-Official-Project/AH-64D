/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqPoint

Description:
    The point a sight slaved to an acquisition source aims at: the NTS for FCR,
    otherwise far out along the acquisition LOS from the TADS.

Parameters:
    _heli - The helicopter
    _acq  - Acquisition source name

Returns:
    PositionASL, or [] when the source gives no LOS to slave to (FCR without an NTS)

Examples:
    [_heli, "PHS"] call fza_fnc_targetingAcqPoint

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_acq"];

if (_acq == "FCR") exitWith {
    (_heli getVariable ["fza_ah64_fcrNts", [objNull, [0, 0, 0]]]) params [["_nts", objNull], ["_ntsPos", [0, 0, 0]]];
    [_ntsPos, []] select (isNull _nts || {_ntsPos isEqualTo [0, 0, 0]})
};

(_heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd")) vectorAdd (([_heli, _acq] call fza_fnc_targetingAcqVec) vectorMultiply 2000)
