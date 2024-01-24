/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_controller

Description:
    Controls the varius elements of the Ihadss 

Parameters:
    _heli - The heli object to draw the IHADSS for

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_controller
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (vehicle player != _heli && !(vehicle player isKindOf "fza_ah64base") || !(alive _heli) && !(vehicle player isKindOf "fza_ah64base") || !(alive player) || !(isNull curatorCamera)) exitWith {
    1 cuttext["", "PLAIN"];
    2 cuttext["", "PLAIN"];
    3 cuttext["", "PLAIN"];
    4 cuttext["", "PLAIN"];
    fza_ah64_bweff ppEffectEnable false;
    fza_ah64_gweff ppEffectEnable false;
    _heli setVariable ["fza_ah64_monocleinbox", true];
    ((uiNameSpace getVariable "fza_ah64_nvsoverlay") displayCtrl 120) ctrlSetText "";
    0 cutrsc["fza_ah64_nvsoverlay", "PLAIN", 0.01, false];
};

if (!(isNil "fza_ah64_notargeting")) exitwith {};
if (currentVisionMode player != 0 && cameraView != "GUNNER") then {
    _heli setVariable ["fza_ah64_monocleinbox", true];
};

//Current Ihadss
[_heli] call fza_ihadss_fnc_CscopeDraw;
[_heli] call fza_ihadss_fnc_constraintBoxDraw;
[_heli] call fza_ihadss_fnc_steeringCursorDraw;
[_heli] call fza_ihadss_fnc_pnvsControl;
[_heli] call fza_ihadss_fnc_draw;