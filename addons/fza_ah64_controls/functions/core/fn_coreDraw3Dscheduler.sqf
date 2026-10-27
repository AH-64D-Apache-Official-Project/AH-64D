/* ----------------------------------------------------------------------------
Function: fza_fnc_coreDraw3Dscheduler

Description:
    Schedules updates to all tasks in *fza_ah64_schedarray*

Parameters:
    _heli - The helicopter to modify

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_coreDraw3Dscheduler
    ---

Author:
    mattysmith22, Snow(Dryden)
---------------------------------------------------------------------------- */
if (!(isNil "fza_ah64_nopfsched")) exitWith {};
params["", "_heli", "_ticker"];
_heli = (vehicle player);
_ticker = 2;

if !(alive _heli && (player == driver _heli || player == gunner _heli) && (vehicle player) isKindOf "fza_ah64base" && _heli getVariable ["fza_ah64_aircraftInitialised",false]) exitWith {};

// Draw3D also fires for each render-to-texture pass (PNVS, TADS), where the camera commands describe that camera, not the
// player's view. Skipped by the camera points in the RenderTargets config, except heads down where the player's camera is at the TADS
private _rtPass = false;
if (cameraView != "GUNNER") then {
    private _rtPoints = missionNamespace getVariable ("fza_ah64_rtPoints_" + typeOf _heli);
    if (isNil "_rtPoints") then {
        _rtPoints = (("true" configClasses (configOf _heli >> "RenderTargets")) apply {getText (_x >> "View01" >> "pointPosition")}) select {_x != ""};
        missionNamespace setVariable ["fza_ah64_rtPoints_" + typeOf _heli, _rtPoints];
    };
    private _camPos = positionCameraToWorld [0, 0, 0];
    _rtPass = _rtPoints findIf {_camPos distance (_heli modelToWorldVisual (_heli selectionPosition [_x, "Memory"])) < 0.25} != -1;
};
if _rtPass exitWith {};

{
    [_heli] call _x;
}
forEach fza_ah64_draw3Darray;

if ((diag_tickTime - fza_ah64_overallticker) > _ticker) then {
    fza_ah64_overallticker = diag_tickTime; 
    {
        [_heli] call _x;
    }
    forEach fza_ah64_draw3DarraySlow;
    [_heli] spawn fza_fnc_targetingSensorUpdate;
};
