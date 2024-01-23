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
[_heli] call fza_ihadss_fnc_routeCycle