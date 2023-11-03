/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_ihadssControler

Description:
    Controls the varius elements of the Ihadss 

Parameters:
    _heli - The heli object to draw the IHADSS for

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_ihadssControler
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(isNil "fza_ah64_notargeting")) exitwith {};
if (currentVisionMode player != 0 && cameraView != "GUNNER") then {
    _heli setVariable ["fza_ah64_monocleinbox", true];
};

//Current Ihadss
[_heli] call fza_ihadss_fnc_ihadssDraw;


[_heli] call fza_ihadss_fnc_CscopeDraw;
[_heli] call fza_ihadss_fnc_constraintBoxDraw;
[_heli] call fza_ihadss_fnc_steeringCursorDraw;


if !(player != vehicle player || alive player || alive _heli || local _heli) exitwith {};
private _acBusOn            = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn            = _heli getVariable "fza_systems_dcBusOn";
private _tadsShouldBeStowed = true;

if (_acBusOn && _dcBusOn) then {
    _tadsShouldBeStowed = false;
};

if (_tadsShouldBeStowed != _heli getVariable "fza_ah64_tadsStow") then {
    [_heli, "fza_ah64_tadsStow", _tadsShouldBeStowed] call fza_fnc_animSetValue;
};