/* ----------------------------------------------------------------------------
Function: fza_sights_fnc_targetingCurAcq

Description:
    Get the currently selected acquisition source for a seat in the aircraft

Parameters:
    _heli - The helicopter to read
    _tur - The turret of the seat to read - either [0] or [-1]

Returns:
    The name of the currently selected acquisition source, valid for use in
    fza_sights_fnc_targetingAcqVec

Examples:
    [_heli, [0]] call fza_sights_fnc_targetingCurAcq

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_tur"];

if (_tur isEqualTo [0]) exitWith {"PHS"};

if (_tur isEqualTo [-1] && isManualFire _heli) exitWith {"FXD"};
"TADS";
