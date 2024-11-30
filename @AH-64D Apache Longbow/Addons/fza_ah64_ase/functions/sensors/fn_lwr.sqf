/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_lwr


Description:
    Proccessor function for the LASER WARNING RECIEVER

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_lwr

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

[] params [["_lwrObjects",[]],["_LwrAudio",[]]];

nearestObjects [_heli, ["lasertarget"], 15, false, true] apply {
    private _modelPos = vectorDir _x vectorMultiply -99999999; 
    private _Worldpos = (getpos _heli) vectoradd _modelPos;
    private _vHeli = _heli modelToWorldVisual _modelPos;
    _vHeli call CBA_fnc_vect2Polar params ["_magnitude", "_azimuth", "_elevation"]; 
    if (abs(_elevation) < 45) then {
        _lwrObjects pushBack [ASE_LSR, _Worldpos, "RLWR_LSR_DES"];
        _LwrAudio pushback [_x, "designating", "laser", _Worldpos];
    };
};

[_lwrObjects, _LwrAudio]