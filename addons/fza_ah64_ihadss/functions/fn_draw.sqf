/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_draw

Description:
    Draws the PNVS picture and HDU monocle, and sets the TADS video effects.

Parameters:
    _heli - The heli object to draw the IHADSS for

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_draw
    ---

Author:
    unknown
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
#include "\fza_ah64_ihadss\headers\hdu.h"
params ["_heli"];

private _acBusOn       = _heli getVariable "bmkhs_acBusOn";
private _dcBusOn       = _heli getVariable "bmkhs_dcBusOn";
private _powerOnState  = (_acBusOn && _dcBusOn);
private _visionMode    = [_heli] call fza_ihadss_fnc_getVisionMode;
private _pnvsSensor    = _heli getHitPointDamage "hit_msnEquip_pnvs_flir";
private _dtvDamage     = _heli getHitPointDamage "hit_msnEquip_tads_dtv";
private _flirDamage    = _heli getHitPointDamage "hit_msnEquip_tads_flir";
private _setDeadOptics = false;

//HDU picture: the PNVS, or the TADS for the CPG with TADS selected
private _monocleUp = cameraView == "INTERNAL" && alive player && _powerOnState && !(_heli getVariable "fza_ah64_monocleinbox");
private _pnvsShown = _monocleUp && (_heli getVariable "fza_ah64_nvsModeSwitchNorm" != 0);
private _sight     = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (isNil "_sight") then {_sight = SIGHT_HMD};
// The TADS on the CPG's HDU, with TADS or FCR as the sight (the TADS linked to the FCR): the format referenced to it and
// its picture, except for the DVO, a direct view optic. Scaled slewing is with TADS as the sight only.
private _tadsHdu   = _monocleUp && !_pnvsShown && player == gunner _heli && _sight in [SIGHT_TADS, SIGHT_FCR];
private _tadsShown = _tadsHdu && _visionMode != 3;
fza_ihadss_tadsVideo   = _tadsHdu;
fza_ihadss_tadsPicture = [];
private _pnvsDisplay = uiNamespace getVariable ["fza_ah64_nvsoverlay", displayNull];
if (_pnvsShown || _tadsShown) then {
    if (isNull _pnvsDisplay) then {
        ("fza_ah64_nvsoverlay" call BIS_fnc_rscLayer) cutRsc ["fza_ah64_nvsoverlay", "PLAIN", 0, false];
        _pnvsDisplay = uiNamespace getVariable "fza_ah64_nvsoverlay";
    };
    // The picture keeps the screen's aspect, any other stretches it as the aircraft banks. The TADS field of view fills
    // the lens height. The PNVS picture is conformal: its camera only covers the lens, so it is drawn at the view's scale.
    private _rect   = [_heli, false] call fza_ihadss_fnc_formatRect;
    private _aspect = (safeZoneW / pixelW) / (safeZoneH / pixelH);
    private _offset = [0, 0];
    private _h      = 2 * HDU_MASK_EXTENT_Y * (_rect # 3) / 480;
    if !_tadsShown then {
        // Live tunes in the debug console: fza_ihadss_pnvsScale scales the picture about the LOS,
        // fza_ihadss_pnvsOffset = [right, up] moves it in degrees (16 format units each)
        private _scale = missionNamespace getVariable ["fza_ihadss_pnvsScale", 1];
        if !(_scale isEqualType 0 && {_scale > 0}) then {_scale = 1};
        _offset = missionNamespace getVariable ["fza_ihadss_pnvsOffset", [0, 0]];
        if !(_offset isEqualTypeArray [0, 0]) then {_offset = [0, 0]};
        private _cfg = configOf _heli;
        _h = _scale * safeZoneH * getNumber (_cfg >> "RenderTargets" >> "driverpnvs2" >> "View01" >> "fov") / getNumber (_cfg >> "ViewPilot" >> "initFov");
    };
    private _w = _h * safeZoneW / safeZoneH;
    private _pictureRect = [
        safeZoneX + (safeZoneW - _w) / 2 + (_offset # 0) * 16 * (_rect # 2) / 640,
        safeZoneY + (safeZoneH - _h) / 2 - (_offset # 1) * 16 * (_rect # 3) / 480,
        _w, _h
    ];
    // A render target ignores a non-square size, so the TADS texture is square and larger by the power of two nearest
    // the screen's aspect, which shrinks its stretched texels; fza_ihadss_tadsSize overrides the size (a power of two)
    private _size = 1024;
    if _tadsShown then {
        _size = missionNamespace getVariable ["fza_ihadss_tadsSize", 1024 * 2 ^ (round (ln _aspect / ln 2) max 0)];
        if !(_size isEqualType 0 && {_size >= 256}) then {_size = 1024};
    };
    // One TADS target per sensor, each following the turret's zoom with its own vision mode
    private _target = "fza_ah64_pnvscam2";
    if _tadsShown then {
        _target = ["fza_ah64_tadscam_flir", "fza_ah64_tadscam_dtv"] select (_visionMode == 0);
        fza_ihadss_tadsPicture = [_pictureRect, fza_ah64_tadsFOVs select (_heli getTurretOpticsMode [0])];
    };
    private _texture = format ["#(argb,%1,%1,1)r2t(%2,%3)", round _size, _target, _aspect];
    private _failed  = if (_tadsShown) then {
        [_dtvDamage, _flirDamage] select (_visionMode in [1, 2]) >= SYS_SIGHT_DMG_THRESH
    } else {
        _pnvsSensor >= SYS_SIGHT_DMG_THRESH
    };
    private _colour  = [[0.1, 1, 0, 0.7], [0, 0, 0, 0]] select _failed;
    {(_x # 0) ctrlShow true} forEach (_pnvsDisplay getVariable ["fza_ihadss_strips", []]);
    [_pnvsDisplay, _rect, _texture, _colour, _pictureRect] call fza_ihadss_fnc_hduPnvsMask;
} else {
    {(_x # 0) ctrlShow false} forEach (_pnvsDisplay getVariable ["fza_ihadss_strips", []]);
};

private _monocle = "fza_ah64_monocleinbox" call BIS_fnc_rscLayer;
if (!(_heli getVariable "fza_ah64_monocleinbox") && cameraView == "INTERNAL" && (gunner _heli == player || driver _heli == player)) then {
    if (isNull (uiNamespace getVariable ["fza_ah64_monocleinbox", displayNull])) then {
        _monocle cutRsc ["fza_ah64_monocleinbox", "PLAIN", 0, false];
    };
    [_heli, (uiNamespace getVariable "fza_ah64_monocleinbox") displayCtrl 501, _pnvsShown || _tadsShown] call fza_ihadss_fnc_hduMonocle;
} else {
    _monocle cutText ["", "PLAIN", -1, false];
};

if (cameraView == "GUNNER" && player == gunner _heli) then {
    if (_visionMode == 1) then {
        //A3TI FLIR
        fza_ah64_flirResolutionEffect ppEffectEnable true;
        fza_ah64_dvoEffect ppEffectEnable false;
        fza_ah64_monoChromeEffect ppEffectEnable false;
        fza_ah64_chromAberrationEffect ppEffectEnable false;
        //The zoom FOV is a digital zoom that doubles the resolution
        if ((_heli getVariable "fza_ah64_tadsSelectedFov") == 3) then {
            fza_ah64_flirResolutionEffect ppEffectAdjust [FLIR_ZFOV_RES];
            fza_ah64_flirResolutionEffect ppEffectCommit 0;
        } else {
            fza_ah64_flirResolutionEffect ppEffectAdjust [FLIR_WFOV_RES];
            fza_ah64_flirResolutionEffect ppEffectCommit 0;
        };
    } else {
        if ((_heli getVariable "fza_ah64_tadsSelectedSensor") in ["DTV"]) then {
            fza_ah64_flirResolutionEffect ppEffectEnable false;
            fza_ah64_dvoEffect ppEffectEnable false;
            fza_ah64_monoChromeEffect ppEffectEnable true;
            fza_ah64_chromAberrationEffect ppEffectEnable true;
        };
        if ((_heli getVariable "fza_ah64_tadsSelectedSensor") in ["DVO"]) then {
            fza_ah64_flirResolutionEffect ppEffectEnable false;
            fza_ah64_dvoEffect ppEffectEnable true;
            fza_ah64_monoChromeEffect ppEffectEnable false;
            fza_ah64_chromAberrationEffect ppEffectEnable true;
        };
        //"Vanilla" FLIR
        if ((_heli getVariable "fza_ah64_tadsSelectedSensor") in ["FLIR"]) then {
            fza_ah64_flirResolutionEffect ppEffectEnable true;
            fza_ah64_dvoEffect ppEffectEnable false;
            fza_ah64_monoChromeEffect ppEffectEnable false;
            fza_ah64_chromAberrationEffect ppEffectEnable false;
            //The zoom FOV is a digital zoom that doubles the resolution
            if ((_heli getVariable "fza_ah64_tadsSelectedFov") == 3) then {
                fza_ah64_flirResolutionEffect ppEffectAdjust [FLIR_WFOV_RES];
                fza_ah64_flirResolutionEffect ppEffectCommit 0;
            } else {
                fza_ah64_flirResolutionEffect ppEffectAdjust [FLIR_WFOV_RES];
                fza_ah64_flirResolutionEffect ppEffectCommit 0;
            };
        };
    };

    //TADS DTV/FLIR Fail
    if (_visionMode in [0,3] && _dtvDamage >= SYS_SIGHT_DMG_THRESH || !_acBusOn) then {
        _setDeadOptics = true;
    };
    if (_visionMode in [1,2] && _flirDamage >= SYS_SIGHT_DMG_THRESH || !_acBusOn) then {
        _setDeadOptics = true;
        _heli disableTIEquipment true;
    } else {
        _heli disableTIEquipment false;
    };
} else {
    fza_ah64_monoChromeEffect ppEffectEnable false;
    fza_ah64_blackScreenEffect ppEffectEnable false;
    fza_ah64_dvoEffect ppEffectEnable false;
    fza_ah64_chromAberrationEffect ppEffectEnable false;
    fza_ah64_flirResolutionEffect ppEffectEnable false;
};

fza_ah64_blackScreenEffect ppEffectEnable _setDeadOptics;

// The laser stops without AC power or with the aircraft safe
if (!_acBusOn || {!isNull laserTarget _heli && !(_heli getVariable ["fza_ah64_armSafeArmed", false])}) then {
    [_heli] call fza_fnc_laserDisarm;
};
