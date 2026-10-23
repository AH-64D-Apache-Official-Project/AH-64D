/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingCurAcq

Description:
    Get the currently selected acquisition source for a seat in the aircraft.
    The pilot starts on TADS and the CPG on PHS. A selection the seat cannot
    use with its present sight (fza_fnc_targetingAcqOptions) falls back to FXD.

Parameters:
    _heli - The helicopter to read
    _tur - The turret of the seat to read - either [0] or [-1]

Returns:
    The name of the currently selected acquisition source, valid for use in fza_fnc_targetingAcqVec

Examples:
    [_heli, [0]] call fza_fnc_targetingCurAcq

Author:
    mattysmith22, Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_tur"];

private _seat = ["plt", "cpg"] select (_tur isEqualTo [0]);
private _acq  = _heli getVariable ["fza_ah64_acq_" + _seat, ["TADS", "PHS"] select (_seat == "cpg")];

if !(_acq in ([_heli, _seat] call fza_fnc_targetingAcqOptions)) exitWith {"FXD"};
_acq
