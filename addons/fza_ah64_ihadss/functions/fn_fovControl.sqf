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
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

// The TADS as an NVS sensor is the FLIR in wide
if ((([_heli] call fza_ihadss_fnc_tadsNvs) # 0) != NVS_MODE_OFF) then {
    if ((_heli getVariable ["fza_ah64_tadsSelectedSensor", "FLIR"]) != "FLIR") then {_heli setVariable ["fza_ah64_tadsSelectedSensor", "FLIR", true]};
    if ((_heli getVariable ["fza_ah64_tadsSelectedFov", 0]) != 0) then {_heli setVariable ["fza_ah64_tadsSelectedFov", 0, player == gunner _heli]};
};

// Selected FOV W/M/N/Z (0-3) to the turret optics mode. DTV has no M, so M is W; DVO has only W and N.
// The selection is corrected to one the sensor has, and the optics mode is only set when it differs.
private _sensor     = _heli getVariable ["fza_ah64_tadsSelectedSensor", "FLIR"];
private _index      = ((_heli getVariable ["fza_ah64_tadsSelectedFov", 0]) max 0) min 3;
private _visionMode = [_heli] call fza_ihadss_fnc_getVisionMode;

// A3TI keeps its own vision mode, changed only by the vision key, and its thermal effects and hot textures stay with it:
// with the DTV or DVO selected it is set to its DTV
if (_sensor in ["DTV", "DVO"] && {player == gunner _heli} && {!isNil "A3TI_fnc_ppEffects"} && {(missionNamespace getVariable ["A3TI_FLIR_VisionMode", -1]) isNotEqualTo -1}) then {
    missionNamespace setVariable ["A3TI_FLIR_VisionMode", -1];
    call A3TI_fnc_ppEffects;
};

private _mode = switch (true) do {
    case (_sensor == "DTV"): {
        if (_index == 1) then {_index = 0};
        [8, 9, 10, 11] select _index
    };
    case (_sensor == "DVO"): {
        _index = _index min 1;
        [12, 13] select _index
    };
    case (_visionMode == 1): {[4, 5, 6, 7] select _index};
    default {_index};
};

// The optics mode as selected, for the symbology, the video and the slew: the game's own zoom input can step the turret
// into the next sensor's modes for a frame before this sets it back
if ((_heli getVariable ["fza_ihadss_tadsOpticsMode", -1]) != _mode) then {_heli setVariable ["fza_ihadss_tadsOpticsMode", _mode]};
if (_heli getTurretOpticsMode [0] != _mode) then {_heli setTurretOpticsMode [[0], _mode]};
if ((_heli getVariable ["fza_ah64_tadsSelectedFov", 0]) != _index) then {_heli setVariable ["fza_ah64_tadsSelectedFov", _index, player == gunner _heli]};
