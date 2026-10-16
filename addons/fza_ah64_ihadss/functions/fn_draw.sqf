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
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli"];

private _acBusOn       = _heli getVariable "bmkhs_acBusOn";
private _dcBusOn       = _heli getVariable "bmkhs_dcBusOn";
private _powerOnState  = (_acBusOn && _dcBusOn);
private _visionMode    = [_heli] call fza_ihadss_fnc_getVisionMode;
private _pnvsSensor    = _heli getHitPointDamage "hit_msnEquip_pnvs_flir";
private _dtvDamage     = _heli getHitPointDamage "hit_msnEquip_tads_dtv";
private _flirDamage    = _heli getHitPointDamage "hit_msnEquip_tads_flir";
private _setDeadOptics = false;

//PNVS HDU
private _pnvsShown = (_heli getVariable "fza_ah64_ihadss_pnvs_cam" != 0) && cameraView == "INTERNAL" && alive player && _powerOnState && !(_heli getVariable "fza_ah64_monocleinbox");
private _pnvsDisplay = uiNamespace getVariable ["fza_ah64_nvsoverlay", displayNull];
if (_pnvsShown) then {
    if (isNull _pnvsDisplay) then {
        ("fza_ah64_nvsoverlay" call BIS_fnc_rscLayer) cutRsc ["fza_ah64_nvsoverlay", "PLAIN", 0, false];
        _pnvsDisplay = uiNamespace getVariable "fza_ah64_nvsoverlay";
    };
    // The picture always covers the whole screen at the screen's aspect and is clipped down to the HDU
    private _aspect      = (safeZoneW / pixelW) / (safeZoneH / pixelH);
    private _pnvsTexture = format ["#(argb,1024,1024,1)r2t(fza_ah64_pnvscam2,%1)", _aspect];
    private _pnvsColour  = [[0.1, 1, 0, 0.7], [0, 0, 0, 0]] select (_pnvsSensor >= SYS_SIGHT_DMG_THRESH);
    {(_x # 0) ctrlShow true} forEach (_pnvsDisplay getVariable ["fza_ihadss_strips", []]);
    [_pnvsDisplay, [_heli, false] call fza_ihadss_fnc_formatRect, _pnvsTexture, _pnvsColour] call fza_ihadss_fnc_hduPnvsMask;
} else {
    {(_x # 0) ctrlShow false} forEach (_pnvsDisplay getVariable ["fza_ihadss_strips", []]);
};

private _monocle = "fza_ah64_monocleinbox" call BIS_fnc_rscLayer;
if (!(_heli getVariable "fza_ah64_monocleinbox") && cameraView == "INTERNAL" && (gunner _heli == player || driver _heli == player)) then {
    if (isNull (uiNamespace getVariable ["fza_ah64_monocleinbox", displayNull])) then {
        _monocle cutRsc ["fza_ah64_monocleinbox", "PLAIN", 0, false];
    };
    [_heli, (uiNamespace getVariable "fza_ah64_monocleinbox") displayCtrl 501, _pnvsShown] call fza_ihadss_fnc_hduMonocle;
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
        fza_ah64_flirBlurEffect ppEffectEnable true;
        //The zoom FOV is a digital zoom that doubles the resolution
        if ((_heli getVariable "fza_ah64_tadsZoom") == 3) then {
            fza_ah64_flirResolutionEffect ppEffectAdjust [180];
            fza_ah64_flirResolutionEffect ppEffectCommit 0;
        } else {
            fza_ah64_flirResolutionEffect ppEffectAdjust [360];
            fza_ah64_flirResolutionEffect ppEffectCommit 0;
        };
        //Progressive blur w/ zoom
        if ((_heli getVariable "fza_ah64_tadsZoom") == 0) then {
            fza_ah64_flirBlurEffect ppEffectAdjust [0.15];
            fza_ah64_flirBlurEffect ppEffectCommit 0;
        };
        if ((_heli getVariable "fza_ah64_tadsZoom") == 1) then {
            fza_ah64_flirBlurEffect ppEffectAdjust [0.20];
            fza_ah64_flirBlurEffect ppEffectCommit 0;
        };
        if ((_heli getVariable "fza_ah64_tadsZoom") == 2) then {
            fza_ah64_flirBlurEffect ppEffectAdjust [0.30];
            fza_ah64_flirBlurEffect ppEffectCommit 0;
        };
        if ((_heli getVariable "fza_ah64_tadsZoom") == 3) then {
            fza_ah64_flirBlurEffect ppEffectAdjust [0.40];
            fza_ah64_flirBlurEffect ppEffectCommit 0;
        };
    } else {
        if ((_heli getVariable "fza_ah64_tadsVision") in ["DTV"]) then {
            fza_ah64_flirResolutionEffect ppEffectEnable false;
            fza_ah64_dvoEffect ppEffectEnable false;
            fza_ah64_monoChromeEffect ppEffectEnable true;
            fza_ah64_chromAberrationEffect ppEffectEnable true;
            fza_ah64_flirBlurEffect ppEffectEnable false;
        };
        if ((_heli getVariable "fza_ah64_tadsVision") in ["DVO"]) then {
            fza_ah64_flirResolutionEffect ppEffectEnable false;
            fza_ah64_dvoEffect ppEffectEnable true;
            fza_ah64_monoChromeEffect ppEffectEnable false;
            fza_ah64_chromAberrationEffect ppEffectEnable true;
            fza_ah64_flirBlurEffect ppEffectEnable false;
        };
        //"Vanilla" FLIR
        if ((_heli getVariable "fza_ah64_tadsVision") in ["FLIR"]) then {
            fza_ah64_flirResolutionEffect ppEffectEnable true;
            fza_ah64_dvoEffect ppEffectEnable false;
            fza_ah64_monoChromeEffect ppEffectEnable false;
            fza_ah64_chromAberrationEffect ppEffectEnable false;
            fza_ah64_flirBlurEffect ppEffectEnable true;
            //The zoom FOV is a digital zoom that doubles the resolution
            if ((_heli getVariable "fza_ah64_tadsZoom") == 3) then {
                fza_ah64_flirResolutionEffect ppEffectAdjust [270];
                fza_ah64_flirResolutionEffect ppEffectCommit 0;
            } else {
                fza_ah64_flirResolutionEffect ppEffectAdjust [540];
                fza_ah64_flirResolutionEffect ppEffectCommit 0;
            };
            //Progressive blur w/ zoom
            if ((_heli getVariable "fza_ah64_tadsZoom") == 0) then {
                fza_ah64_flirBlurEffect ppEffectAdjust [0.15];
                fza_ah64_flirBlurEffect ppEffectCommit 0;
            };
            if ((_heli getVariable "fza_ah64_tadsZoom") == 1) then {
                fza_ah64_flirBlurEffect ppEffectAdjust [0.20];
                fza_ah64_flirBlurEffect ppEffectCommit 0;
            };
            if ((_heli getVariable "fza_ah64_tadsZoom") == 2) then {
                fza_ah64_flirBlurEffect ppEffectAdjust [0.30];
                fza_ah64_flirBlurEffect ppEffectCommit 0;
            };
            if ((_heli getVariable "fza_ah64_tadsZoom") == 3) then {
                fza_ah64_flirBlurEffect ppEffectAdjust [0.40];
                fza_ah64_flirBlurEffect ppEffectCommit 0;
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
    fza_ah64_flirBlurEffect ppEffectEnable false;
};

fza_ah64_blackScreenEffect ppEffectEnable _setDeadOptics;

if !_acBusOn then {
    [_heli] call fza_fnc_laserDisarm;
};
