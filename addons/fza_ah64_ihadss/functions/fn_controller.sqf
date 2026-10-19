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

// Layers stack in the order they are first used: PNVS picture under the monocle, symbology on top
if (isNil "fza_ihadss_layersOrdered") then {
    fza_ihadss_layersOrdered = true;
    {_x call BIS_fnc_rscLayer} forEach ["fza_ah64_nvsoverlay", "fza_ah64_monocleinbox", "fza_ah64_ihadssHtml", "fza_ah64_ihadssHtmlDown", "fza_ah64_ihadssIcons"];
};

private _hideMonocle = !(vehicle player isKindOf "fza_ah64base")
    || !(alive _heli)
    || !(alive player)
    || !(isNull curatorCamera)
    || is3DEN
    || !(cameraView in ["INTERNAL", "GUNNER"])
    || (isRemoteControlling player && !(getConnectedUAV player isKindOf "fza_ah64base"));

if _hideMonocle exitWith {
    fza_ihadss_tadsVideo = false;
    ("fza_ah64_monocleinbox" call BIS_fnc_rscLayer) cutText["", "PLAIN"];
    ("fza_ah64_nvsoverlay" call BIS_fnc_rscLayer) cutText["", "PLAIN"];
    ("fza_ah64_ihadssHtml" call BIS_fnc_rscLayer) cutText["", "PLAIN"];
    ("fza_ah64_ihadssHtmlDown" call BIS_fnc_rscLayer) cutText["", "PLAIN"];
    ("fza_ah64_ihadssIcons" call BIS_fnc_rscLayer) cutText["", "PLAIN"];
    fza_ah64_monoChromeEffect ppEffectEnable false;
    fza_ah64_blackScreenEffect ppEffectEnable false;
    fza_ah64_flirResolutionEffect ppEffectEnable false;
    fza_ah64_chromAberrationEffect ppEffectEnable false;
    fza_ah64_dvoEffect ppEffectEnable false;
};

if (!(isNil "fza_ah64_notargeting")) exitWith {};
if (currentVisionMode player != 0 && cameraView != "GUNNER") then {
    _heli setVariable ["fza_ah64_monocleinbox", true];
};

private _deltaTime  = ["ihadss_deltaTime"] call BIS_fnc_deltaTime;

[_heli] call fza_ihadss_fnc_fovControl;
[_heli] call fza_ihadss_fnc_pnvsControl;
[_heli] call fza_ihadss_fnc_tadsNvsControl;
[_heli] call fza_ihadss_fnc_draw;
[_heli] call fza_ihadss_fnc_htmlDraw;
[_heli, _deltaTime] call fza_ihadss_fnc_linearMotionCompensator;


if !(objectParent player isNotEqualTo objNull || alive _heli || local _heli) exitWith {};
private _acBusOn            = _heli getVariable "bmkhs_acBusOn";
private _dcBusOn            = _heli getVariable "bmkhs_dcBusOn";
private _tadsShouldBeStowed = true;

if (_acBusOn && _dcBusOn) then {
    _tadsShouldBeStowed = false;
};

if (_tadsShouldBeStowed != _heli getVariable "fza_ah64_tadsStow") then {
    [_heli, "fza_ah64_tadsStow", _tadsShouldBeStowed] call fza_fnc_animSetValue;
};
