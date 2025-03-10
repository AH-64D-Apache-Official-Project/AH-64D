/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_fovControl

Description:
    Controlls the zoom of the tads camera

Parameters:
    _heli - The apache

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_fovControl
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _inputindex = _heli getVariable "fza_ah64_tadsZoom";
private _thermalM   = _heli getVariable "fza_ah64_tadsVision";
private _a3tiM      = _heli getVariable "fza_ah64_tadsA3ti";
private _Visionmode = [_heli] call fza_ihadss_fnc_getVisionMode;
private _flirIndex  = [0,1,2,3];
private _a3tiIndex  = [4,5,6,7];
private _dtvIndex   = [8,9,10,11];
private _dvoIndex   = [12,13,99,99]; //99 = dummy value
private _zoomindex  = _inputindex;

if (_thermalM == "DTV") then { //DTV Index
    _zoomindex = _dtvIndex select _inputindex;
};

if (_thermalM == "DVO") then { //DTV Index
    _zoomindex = _dvoIndex select _inputindex;
};

if (_Visionmode == 1) then { //A3TI Index
    _zoomindex = _a3tiIndex select _inputindex;
    _heli setVariable ["fza_ah64_tadsA3ti", true];
};
if (_Visionmode == 0 && _a3tiM) then {  //A3TI to DTV
    if (_inputindex == 1) then {
        _inputindex = 0;
    };
    _heli setVariable ["fza_ah64_tadsA3ti", false];
};

_heli setTurretOpticsMode [[0], _zoomindex];
_heli setVariable ["fza_ah64_tadsZoom", _inputindex];