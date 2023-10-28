/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_getTadsAimPosASL

Description:
    
Parameters:

Returns:

Examples:
    _return = [_heli] call fza_weapons_fnc_getTadsAimPosASL;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

_camPosASL = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
_flirDir   = _camPosASL vectorFromTo (_heli modelToWorldVisualWorld (_heli selectionPosition "laserBegin"));
_tgtPosASL = _camPosASL vectorAdd (_flirDir vectorMultiply 50000);
_newPosASL = terrainIntersectAtASL [_camPosASL, _tgtPosASL];
_newPosASL; 