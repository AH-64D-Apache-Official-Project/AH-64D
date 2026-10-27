/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_dtvCamera

Description:
    Renders the TADS DTV picture (fza_ah64_tadscam_dtv) from a script camera on
    the TADS, along its line of sight and at its field of view, monochrome. No
    render target can be given a picture effect, so the DTV is not one; it must
    not be one in the aircraft's config either, as both would draw to the same
    surface.

    Started while something shows the DTV (fza_ihadss_fnc_r2tTexture marks it
    shown), at most one camera on the machine. The camera then runs on its own
    each frame and ends itself as soon as it is not wanted, whatever stops it:
    the DTV no longer shown, the aircraft or the player gone or dead, the
    player out of the aircraft, the view outside the cockpit and sight, the
    camera deleted elsewhere or by a loaded save, or the screen's aspect
    changed (its texture changes with it; a new camera follows).

    Its position follows the TADS's sight memory point (attachTo); its line of
    sight is set each frame from the same memory points as the FLIR render
    target (fza_ihadss_fnc_tadsLos), so the DTV and FLIR look the same way, and
    the camera turns smoothly on every machine. Timed on mission time, so a
    paused game does not end it.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_dtvCamera
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#define DTV_TARGET "fza_ah64_tadscam_dtv"
#define DTV_SHOWN_FOR 0.5
params [["_heli", objNull, [objNull]]];

// A loaded save can bring the camera back without its tie to the picture, leaving it black: one is started afresh
if (isNil "fza_ihadss_dtvLoadedEh") then {
    fza_ihadss_dtvLoadedEh = addMissionEventHandler ["Loaded", {
        private _old = missionNamespace getVariable ["fza_ihadss_dtvCamera", objNull];
        if (!isNull _old) then {
            _old cameraEffect ["terminate", "back", DTV_TARGET];
            camDestroy _old;
        };
        fza_ihadss_dtvCamera = objNull;
    }];
};

if (isNull _heli || {!alive _heli}) exitWith {};
if (!isNull (missionNamespace getVariable ["fza_ihadss_dtvCamera", objNull])) exitWith {};
if (time - (missionNamespace getVariable ["fza_ihadss_dtvShownAt", -1e6]) >= DTV_SHOWN_FOR) exitWith {};
// The MPDs and HDU are only seen from the cockpit or the sight; no scene is rendered for a picture nobody can see
if !(cameraView in ["INTERNAL", "GUNNER"]) exitWith {};

private _camera = "camera" camCreate (getPosATL _heli);
if (isNull _camera) exitWith {};
fza_ihadss_dtvCamera = _camera;
_camera cameraEffect ["internal", "back", DTV_TARGET];
DTV_TARGET setPiPEffect [0];
// On the TADS's sight point, the same as the FLIR render target's: Draw3D skips a render pass whose camera is at a render
// target's point (fza_fnc_coreDraw3Dscheduler), so the camera must stay on it
_camera attachTo [_heli, [0, 0, 0], "laserEnd"];

// Its picture effect, re-applied now and then as a new surface can take its first frames without it; its line of sight;
// its zoom when it changes. Each takes a default for anything missing.
private _update = {
    params ["_heli", "_camera"];
    if (time > (_camera getVariable ["fza_ihadss_effectAt", -1e6])) then {
        _camera setVariable ["fza_ihadss_effectAt", time + 0.5];
        DTV_TARGET setPiPEffect [3, 1, 1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0.299, 0.587, 0.114, 0]];
    };

    ([_heli] call fza_ihadss_fnc_tadsLos) params ["", "_dir"];
    private _right = _dir vectorCrossProduct [0, 0, 1];
    // Looking straight up or down, any right will do
    _right = if (vectorMagnitude _right < 1e-6) then {[1, 0, 0]} else {vectorNormalized _right};
    _camera setVectorDirAndUp [_dir, _right vectorCrossProduct _dir];

    private _mode = _heli getVariable ["fza_ihadss_tadsOpticsMode", _heli getTurretOpticsMode [0]];
    private _fov  = (missionNamespace getVariable ["fza_ah64_tadsFOVs", []]) param [_mode, 0.4];
    if (_fov != (_camera getVariable ["fza_ihadss_fov", -1])) then {
        _camera setVariable ["fza_ihadss_fov", _fov];
        _camera camSetFov _fov;
        _camera camCommit 0;
    };
};
[_heli, _camera] call _update;

[{
    params ["_args", "_handle"];
    _args params ["_heli", "_camera", "_aspect", "_update"];
    if (isNull _camera
        || {isNull _heli}
        || {!alive _heli}
        || {!alive player}
        || {vehicle player != _heli}
        || {!(cameraView in ["INTERNAL", "GUNNER"])}
        || {(missionNamespace getVariable ["fza_ihadss_dtvCamera", objNull]) isNotEqualTo _camera}
        || {abs ((missionNamespace getVariable ["fza_ihadss_screenAspect", _aspect]) - _aspect) > 1e-3}
        || {time - (missionNamespace getVariable ["fza_ihadss_dtvShownAt", -1e6]) >= DTV_SHOWN_FOR}
    ) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        if (!isNull _camera) then {
            _camera cameraEffect ["terminate", "back", DTV_TARGET];
            detach _camera;
            camDestroy _camera;
        };
        if ((missionNamespace getVariable ["fza_ihadss_dtvCamera", objNull]) isEqualTo _camera) then {fza_ihadss_dtvCamera = objNull};
    };
    [_heli, _camera] call _update;
}, 0, [_heli, _camera, missionNamespace getVariable ["fza_ihadss_screenAspect", 0], _update]] call CBA_fnc_addPerFrameHandler;
