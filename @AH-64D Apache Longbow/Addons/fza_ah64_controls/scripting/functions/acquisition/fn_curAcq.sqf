/* ----------------------------------------------------------------------------
Function: fza_fnc_curAcq

Description:
    Get the currently selected acquisition source for a seat in the aircraft

Parameters:
    _heli - The helicopter to read
    _tur - The turret of the seat to read - either [0] or [-1]

Returns:
    The name of the currently selected acquisition source, valid for use in 

Examples:
    [_heli] call fza_fnc_acqVec

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_tur"];

if (_tur isEqualTo [0]) exitWith {"PHS"};

if (_tur isEqualTo [-1] && isManualFire _heli) exitWith {"FXD"};
"TADS";