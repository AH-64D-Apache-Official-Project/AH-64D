/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_videoSource

Description:
    What an underlay selection presents: the sensor's render target and the
    symbology that goes with it. TADS is the CPG's, with weapon symbology; a
    sight is the crew station's selected sight; an HMD is the crew station's
    night vision sensor, PNVS or TADS FLIR, with its flight symbology. No
    video for the DVO, a failed sensor, NVS MODE OFF or the FCR imagery.

Parameters:
    _heli     - The helicopter
    _underlay - MPD_VIDEO_SRC_*

Returns:
    [render target or "", symbology "TADS", "C-FLT", "P-FLT", "C-FCR", "P-FCR" or ""]

Examples:
    --- Code
    ([_heli, MPD_VIDEO_SRC_TADS] call fza_mpd_fnc_videoSource) params ["_target", "_symbology"]
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli", "_underlay"];

private _sightOf = {
    private _sight = [_heli, "fza_ah64_sight", _this] call fza_fnc_getSeatVariable;
    if (isNil "_sight") then {SIGHT_HMD} else {_sight}
};
private _tads = {
    private _sensor = _heli getVariable ["fza_ah64_tadsSelectedSensor", "FLIR"];
    if (_sensor == "DVO") exitWith {""};
    private _dtv = _sensor == "DTV";
    if ((_heli getHitPointDamage (["hit_msnEquip_tads_flir", "hit_msnEquip_tads_dtv"] select _dtv)) >= SYS_SIGHT_DMG_THRESH) exitWith {""};
    ["fza_ah64_tadscam_flir", "fza_ah64_tadscam_dtv"] select _dtv
};
private _hmd = {
    ([_heli, _this] call fza_ihadss_fnc_nvsState) params ["_mode", "_sensor"];
    if (_mode == NVS_MODE_OFF) exitWith {""};
    private _tadsNvs = _sensor == "TADS";
    if ((_heli getHitPointDamage (["hit_msnEquip_pnvs_flir", "hit_msnEquip_tads_flir"] select _tadsNvs)) >= SYS_SIGHT_DMG_THRESH) exitWith {""};
    ["fza_ah64_pnvscam2", "fza_ah64_tadscam_nvs"] select _tadsNvs
};

switch (_underlay) do {
    case MPD_VIDEO_SRC_TADS: {[call _tads, "TADS"]};
    case MPD_VIDEO_SRC_CPG_SIGHT: {
        switch ("cpg" call _sightOf) do {
            case SIGHT_TADS: {[call _tads, "TADS"]};
            // The TADS linked to the FCR
            case SIGHT_FCR: {[call _tads, "C-FCR"]};
            default {["cpg" call _hmd, "C-FLT"]};
        }
    };
    case MPD_VIDEO_SRC_CPG_HMD: {["cpg" call _hmd, "C-FLT"]};
    case MPD_VIDEO_SRC_PLT_SIGHT: {
        if (("plt" call _sightOf) == SIGHT_FCR) then {["", "P-FCR"]} else {["plt" call _hmd, "P-FLT"]}
    };
    case MPD_VIDEO_SRC_PLT_HMD: {["plt" call _hmd, "P-FLT"]};
    default {["", ""]};
}
