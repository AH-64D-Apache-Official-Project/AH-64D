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

private _hideMonocle = !(vehicle player isKindOf "fza_ah64base")
    || !(alive _heli)
    || !(alive player)
    || !(isNull curatorCamera)
    || is3DEN
    || !(cameraView in ["INTERNAL", "GUNNER"])
    || (isRemoteControlling player && !(getConnectedUAV player isKindOf "fza_ah64base"));

if _hideMonocle exitWith {
    ((uiNameSpace getVariable "fza_ah64_nvsoverlay") displayCtrl 120) ctrlSetText "";
    ("fza_ah64_click_helper" call BIS_fnc_rscLayer) cuttext["", "PLAIN"];
    ("fza_ah64_monocleinbox" call BIS_fnc_rscLayer) cuttext["", "PLAIN"];
    ("fza_ah64_nvsoverlay" call BIS_fnc_rscLayer) cuttext["", "PLAIN"];
    ("fza_ah64_raddisp" call BIS_fnc_rscLayer) cuttext["", "PLAIN"];
    ("fza_ah64_laseit" call BIS_fnc_rscLayer) cuttext["", "PLAIN"];
    ("fza_ah64_symbology" call BIS_fnc_rscLayer) cuttext["", "PLAIN"];
    fza_ah64_monoChromeEffect ppEffectEnable false;
    fza_ah64_blackScreenEffect ppEffectEnable false;
    fza_ah64_flirResolutionEffect ppEffectEnable false;
    fza_ah64_chromAberrationEffect ppEffectEnable false;
    fza_ah64_dvoEffect ppEffectEnable false;
};

if (!(isNil "fza_ah64_notargeting")) exitwith {};
if (currentVisionMode player != 0 && cameraView != "GUNNER") then {
    _heli setVariable ["fza_ah64_monocleinbox", true];
};

private _deltaTime  = ["ihadss_deltaTime"] call BIS_fnc_deltaTime;

//Current Ihadss
[_heli] call fza_ihadss_fnc_fovControl;
[_heli] call fza_ihadss_fnc_CscopeDraw;
[_heli] call fza_ihadss_fnc_constraintBoxDraw;
[_heli] call fza_ihadss_fnc_steeringCursorDraw;
[_heli] call fza_ihadss_fnc_pnvsControl;
[_heli] call fza_ihadss_fnc_draw;
[_heli, _deltaTime] call fza_ihadss_fnc_linearMotionCompensator;


if !(player != vehicle player || alive _heli || local _heli) exitwith {};
private _acBusOn            = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn            = _heli getVariable "fza_systems_dcBusOn";
private _tadsShouldBeStowed = true;

if (_acBusOn && _dcBusOn) then {
    _tadsShouldBeStowed = false;
};

if (_tadsShouldBeStowed != _heli getVariable "fza_ah64_tadsStow") then {
    [_heli, "fza_ah64_tadsStow", _tadsShouldBeStowed] call fza_fnc_animSetValue;
};
