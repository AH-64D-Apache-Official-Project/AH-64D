/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_draw

Description:
    Draws the IHADSS overlay for the player.

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
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];

#define SCALE_METERS_FEET 3.28084
#define SCALE_MPS_KNOTS 1.94

private _acBusOn        = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn        = _heli getVariable "fza_systems_dcBusOn";
private _powerOnState   = (_acBusOn && _dcBusOn);
private _weaponWas      = _heli getVariable "fza_ah64_was";
private _ntsPosition    = (_heli getVariable "fza_ah64_fcrNts")#1;
private _headsdown      = (cameraView == "GUNNER" && player == gunner _heli);
private _a3ti_vis       = call A3TI_fnc_getA3TIVision;
private _a3ti_brt       = call A3TI_fnc_getA3TIBrightnessContrast;
private _Visionmode     = [_heli] call fza_ihadss_fnc_getVisionMode;
private _pnvsSensor     = _heli getHitPointDamage "hit_msnEquip_pnvs_flir";
private _dtvDamage      = _heli getHitPointDamage "hit_msnEquip_tads_dtv";
private _flirDamage     = _heli getHitPointDamage "hit_msnEquip_tads_flir";
private _channel        = _heli getVariable "fza_ah64_laserLRFDCode";
private _hash           = _heli getVariable "fza_ah64_laserChannelIndex";
private _lsrcode        = _hash get _channel;
private _hduColour      = [0.1, 1, 0, 1];
private _setDeadOptics  = false;

private _targhead    = 0;
private _sensor      = "";
private _sensxm      = "";
private _weapon      = "";
private _weaponstate = "";
private _safemessage = "";
private _rocketcode  = "???";
private _waypointcode = "";
private _gspdcode    = "";
private _curwpdir    = -1000;
private _fcrantennafor = -100;
private _fcrhdg      = -360;

//layers
private _raddisp = "fza_ah64_raddisp" call BIS_fnc_rscLayer;
private _monocle = "fza_ah64_monocleinbox" call BIS_fnc_rscLayer;
private _laseit = "fza_ah64_laseit" call BIS_fnc_rscLayer;

if (isNull laserTarget _heli) then {
    _laseit cuttext["", "PLAIN", 0.1, false];
};
if !(_heli getvariable "fza_ah64_LmcActive") then {
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 703) ctrlSetText "";
};

//PNVS HDU
if ((_heli getVariable "fza_ah64_ihadss_pnvs_cam" != 0) && cameraView == "INTERNAL" && alive player && _powerOnState && !(_heli getVariable "fza_ah64_monocleinbox")) then {
    private _aspect = getResolution#4;
    private _pnvsTexture = format ["#(argb,512,512,1)r2t(fza_ah64_pnvscam2,%1)", _aspect];
    if (ctrlText ((uiNameSpace getVariable "fza_ah64_nvsoverlay") displayCtrl 120) != _pnvsTexture) then {
        ((uiNameSpace getVariable "fza_ah64_nvsoverlay") displayCtrl 120) ctrlSetText _pnvsTexture;
    };
    if (_pnvsSensor >= SYS_SIGHT_DMG_THRESH) exitwith {
        ((uiNameSpace getVariable "fza_ah64_nvsoverlay") displayCtrl 120) ctrlSetTextColor [0,0,0,0];
    };
    ((uiNameSpace getVariable "fza_ah64_nvsoverlay") displayCtrl 120) ctrlSetTextColor [0.1, 1, 0, 0.7];
} else {
    ((uiNameSpace getVariable "fza_ah64_nvsoverlay") displayCtrl 120) ctrlSetText "";
    cutrsc["fza_ah64_nvsoverlay", "PLAIN", 0, false];
};

//IHADSS INIT
private _initialized = missionNamespace getVariable "fza_ah64_raddisp";
if (isNil "_initialized") then {
    _raddisp cutrsc["fza_ah64_raddisp", "PLAIN", 0, false];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetText "\fza_ah64_model\tex\HDU\ihadss.paa";

    for "_i" from 121 to 209 do {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _i) ctrlSetTextColor _hduColour;
    };
    missionNamespace setVariable ["fza_ah64_raddisp", true];
};

if (!(_heli getVariable "fza_ah64_monocleinbox") && cameraView == "INTERNAL" && (gunner _heli == player || driver _heli == player)) then {
    _monocle cutrsc["fza_ah64_monocleinbox", "PLAIN", 0, false];
    ((uiNameSpace getVariable "fza_ah64_monocleinbox") displayCtrl 501) ctrlSetText "\fza_ah64_model\tex\HDU\monocle_solid.paa";
} else {
    _monocle cuttext["", "PLAIN", -1, false];
};

//1ST PERSON VIEW IHADSS BASIC FLIGHT INFO SETUP

    if ((gunner _heli == player || driver _heli == player) && ((!(_heli getVariable "fza_ah64_monocleinbox") && cameraView == "INTERNAL") || cameraView == "GUNNER") && _powerOnState) then {
    if (isNull(uiNameSpace getVariable "fza_ah64_raddisp")) then {
        _raddisp cutrsc["fza_ah64_raddisp", "PLAIN", 0, false];

        for "_i" from 121 to 129 do {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _i) ctrlSetTextColor[0.1, 1, 0, 1];
        };
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 184) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 188) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 189) ctrlSetTextColor[0.1, 1, 0, 1];
        _rocketcode = "???";
    };
} else {
    if (cameraView != "INTERNAL") then {
        _monocle cuttext["", "PLAIN", 0, false];
    };
    _raddisp cuttext["", "PLAIN", 0, false];
    _laseit cuttext["", "PLAIN", 0, false];
};

if !_powerOnState then {
    _raddisp cuttext["", "PLAIN", 0, false];
    _laseit cuttext["", "PLAIN", 0, false];
};

if (cameraView == "GUNNER" && player == gunner _heli) then {
    if (([_heli] call fza_ihadss_fnc_getVisionMode) == 1) then {
        fza_ah64_flirResolutionEffect ppEffectEnable true;
        fza_ah64_monoChromeEffect ppEffectEnable false;
        fza_ah64_dvoEffect ppEffectEnable false;
        fza_ah64_chromAberrationEffect ppEffectEnable false;
        if ((_heli getVariable "fza_ah64_tadsZoom") == 3) then {
            fza_ah64_flirResolutionEffect ppEffectAdjust [180];
            fza_ah64_flirResolutionEffect ppEffectCommit 0;
        } else {
            fza_ah64_flirResolutionEffect ppEffectAdjust [360];
            fza_ah64_flirResolutionEffect ppEffectCommit 0;
        };
    } else {
        fza_ah64_flirResolutionEffect ppEffectEnable false;
        if ((_heli getVariable "fza_ah64_tadsVision") in ["DTV"]) then {
            fza_ah64_dvoEffect ppEffectEnable false;
            fza_ah64_monoChromeEffect ppEffectEnable true;
            fza_ah64_chromAberrationEffect ppEffectEnable true;
        };
        if ((_heli getVariable "fza_ah64_tadsVision") in ["DVO"]) then {
            fza_ah64_dvoEffect ppEffectEnable true;
            fza_ah64_monoChromeEffect ppEffectEnable false;
            fza_ah64_chromAberrationEffect ppEffectEnable true;
        };
    };

    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetText "\fza_ah64_model\tex\HDU\TADSmain_co.paa";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 802) ctrlSetText "RCD      TADS"; //static data
    
    //COLOR SET THESE
    for "_i" from 121 to 209 do {
        //if (_i in [129,135,136,137,138,139,140,141,142,143,144,145,146,182,186]) exitwith {};
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _i) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    };
    for "_i" from 802 to 804 do {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _i) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1]; //COLOR WHITE TADS VIEW ACQ
    };


    //RELOCATE TEXTURES AS FOLLOWS
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 123) ctrlsetposition[0.31, 0.345, 0.5, 0.12];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 123) ctrlCommit 0;
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 124) ctrlsetposition[0.4, 0.7, 0.5, 0.12];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 124) ctrlCommit 0;
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 125) ctrlsetposition[0.11, 0.7, 0.5, 0.12]; //TEST TADS RADAR ALTITUDE
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 125) ctrlCommit 0;

    //HIDE THESE AS FOLLOWS
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 135) ctrlSetTextColor[0, 0, 0, 0];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 136) ctrlSetTextColor[0, 0, 0, 0];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 182) ctrlSetTextColor[0, 0, 0, 0];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 186) ctrlSetTextColor[0, 0, 0, 0];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 129) ctrlSetTextColor[0, 0, 0, 0];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 188) ctrlSetTextColor[0, 0, 0, 0]; //HIDING BAROALT FT
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 300) ctrlSetTextColor[0, 0, 0, 0]; //Hide Acceleration Cue

    //LASER SYMBOLOGY FOR GUNNER
    if !(isNull laserTarget _heli) then {
        _laseit cutrsc["fza_ah64_laseit", "PLAIN", 0, false];
        ((uiNameSpace getVariable "fza_ah64_laseit") displayCtrl 701) ctrlSetText "\fza_ah64_model\tex\HDU\Apache_LaserOn.paa";
        ((uiNameSpace getVariable "fza_ah64_laseit") displayCtrl 701) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    };
    //LSC SYMBOLOGY FOR GUNNER
    if (_heli getvariable "fza_ah64_LmcActive") then {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 703) ctrlSetText "\fza_ah64_model\tex\HDU\TADSLMC_co.paa";
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 703) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    };

    //TADS DTV/FLIR Fail
    if (_Visionmode in [0,3] && _dtvDamage >= SYS_SIGHT_DMG_THRESH || !_acBusOn) then {
        _setDeadOptics = true;
    };
    if (_Visionmode in [1,2] && _flirDamage >= SYS_SIGHT_DMG_THRESH || !_acBusOn) then {
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

    for "_i" from 121 to 209 do {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _i) ctrlSetTextColor _hduColour;
    };

    //REMOVE AND/OR RECOLOR TEXTURES ONCE HEADSUP 
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetText "\fza_ah64_model\tex\HDU\ihadss.paa"; //TEST
    ((uiNameSpace getVariable "fza_ah64_laseit")  displayCtrl 701) ctrlSetText "";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 703) ctrlSetText "";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 802) ctrlSetText "";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 803) ctrlSetText "";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 804) ctrlSetText "";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 804) ctrlSetTextColor[0.1, 1, 0, 1]; //DOES SET GREEN COLOR FOR IHADSS

    //1ST PERSON VIEW, REPOSITION TEXTURES FROM TADS VIEW TO IHADSS VIEW
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 123) ctrlsetposition[0.31, 0.356, 0.5, 0.12];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 123) ctrlCommit 0;
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 124) ctrlsetposition[0.31, 0.5, 0.5, 0.12];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 124) ctrlCommit 0;
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 125) ctrlsetposition[0.18, 0.5, 0.5, 0.12];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 125) ctrlCommit 0;
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 206) ctrlSetTextColor[0, 0, 0, 0];
};

fza_ah64_blackScreenEffect ppEffectEnable _setDeadOptics;

if !_acBusOn then {
    [_heli] call fza_fnc_laserDisarm;
};

_autohide = {
    _partid  = _this select 0;
    _pitchid = _this select 1;
    _bankid  = _this select 2;

    if ((_pitchid < -25 || _pitchid > 25)) then {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _partid) ctrlSetPosition[100, 10, 100];
    } else {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _partid) ctrlSetPosition[0.5 + (((_pitchid) * 0.00556) * (sin _bankid)), 10, 0.5 + (((_pitchid) * 0.00556) * (cos _bankid))];
    };

};

_gspdcode = format["%1", round (_heli getVariable "fza_sfmplus_gndSpeed")] + "    " + format["%1:%2%3", fza_ah64_wptimhr, fza_ah64_wptimtm, fza_ah64_wptimsm];

private _nextPoint = (_heli getVariable "fza_dms_routeNext")#0;
private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
[_heli] call fza_mpd_fnc_tsdWaypointStatusText params ["_waypointId", "_groundspeed", "_waypointDist", "_waypointEta"];

_waypointcode = format ["%1    %2", _waypointId, _waypointDist];
_gspdcode = format ["%1    %2", _groundSpeed, _waypointEta];
// Todo: Display current waypoint
if (!isNil "_nextPointPos") then {
    _curwpdir = [[_heli, getpos _heli # 0, getPos _heli # 1, _nextPointPos # 0, _nextPointPos # 1] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180;
};

/////////////////////////////////////////////////////////

_sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (_heli iskindof "fza_ah64base") then {
    switch (_sight) do {
        case 0: {
            _sensxm = "FCR ";
        };
        case 1: {
            _sensxm = "HMD ";
        };
        case 2: {
            _sensxm  = "TADS";
        };
        case 3: {
            _sensxm = "FXD ";
        };
    };
};

_targrange = format["%1", ((round((_heli distance _ntsPosition) * 0.01)) * 0.1)];
if (_ntsPosition isEqualTo [0,0,0]) then {
    _targrange = "0.0";
};
if (!isNull laserTarget _heli) then {
    _targrange = format["*%1", round(_heli distance laserTarget _heli)];
};

_thetatarg = [_heli, getposatl _heli#0, getposatl _heli#1, _ntsPosition#0, _ntsPosition#1] call fza_fnc_relativeDirection;

_aimpos = worldtoscreen(_heli modelToWorldVisual[0, +20, 0]);
if (count _aimpos < 1) then {
    _aimpos = [-3, -3];
};
_scPos = [-100, -100];
_heading = format["%1", round(_thetatarg)];
if (_heading == "scalar") then {
    _heading = "0";
};
if (_thetatarg >= 315) then {
    _targhead = _thetatarg - 360;
} else {
    _targhead = _thetatarg;
};
if (_thetatarg < 315 && _thetatarg >= 180) then {
    _targhead = -45;
};
if (_thetatarg > 45 && _thetatarg < 180) then {
    _targhead = 45;
};

//Use the perfGetData method to update the TQ in the HDU
_TQVal = (_heli getVariable "fza_sfmplus_engPctTQ" select 0) max (_heli getVariable "fza_sfmplus_engPctTQ" select 1);
_collective = format["%1", round(100 * _TQVal)];
if (_collective == "scalar") then {
    _collective = "0";
};
_speedkts = format["%1", (_heli getVariable "fza_sfmplus_vel2D")];

([_heli] call fza_sfmplus_fnc_getAltitude)
    params ["_barAlt", "_radAlt"];
_baraltft = format["%1",  _barAlt toFixed 0];
_radaltft = format["%1", [_radAlt toFixed 0, ""] select (_radAlt == 1420)];

//FCR CenterLine
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_pos", "_time"]; 
if !isNil "_dir" then {
    _fcrhdg = _dir;
    _fcrDir = [_fcrhdg - direction _heli] call CBA_fnc_simplifyAngle180;
    _fcrantennafor = linearConversion [-120,120,_fcrDir,0.44,0.56,true];
};
private _tadsElevation = _heli getVariable "fza_ah64_tadsElevation";
private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
_sensorposx = rad(_tadsAzimuth * 0.025);
_sensorposy = rad(_tadsElevation * -0.015);
if (_sensorposy < 0) then {
    _sensorposy = (_heli animationphase "tads") * -0.026;
};
if !(_heli animationPhase "fcr_enable" == 1) then {
    _fcrantennafor = -1000;
    _fcrhdg = -360
};

//Flight Path Vector
private _fpv = [-100,-100];
if ((_heli getVariable "fza_sfmplus_vel3D") > 5) then {
    _fpv = worldToScreen aslToAgl(aglToAsl positionCameraToWorld[0,0,0] vectorAdd (_heli getVariable "fza_sfmplus_velWorldSpaceNoWind"));
    if (_fpv isEqualTo []) then {
        _fpv = [-100,-100];
    }
};
if (_weaponWas == WAS_WEAPON_MSL) then {
    private _tofList        = _heli getVariable "fza_ah64_tofCountDown";
    _weapon = (["MSL", "PMSL"] select (isManualFire _heli));

    switch (_heli getVariable "fza_ah64_hellfireTrajectory") do {
        case "DIR": {
            _weaponstate = "DIR-MAN";
        };
        case "LO": {
            _weaponstate = "LO-MAN";
        };
        case "HI": {
            _weaponstate = "HI-MAN";
        };
    };
    
    if (_tofList isNotEqualTo []) then {
        _tofNum = ceil (_tofList#0 - cba_missiontime);
        _tofStr = [str (round _tofNum), "00"] call fza_fnc_padString;
        _weaponstate = "HF TOF=" + _tofStr;
        if (_tofNum < 1) then {
            _tofList deleteAt 0;
            _heli setVariable ["fza_ah64_tofCountDown", _tofList];
        };
    };
};

if (_weaponWas == WAS_WEAPON_RKT) then {
    private _weapon = (["RKT", "PRKT"] select (isManualFire _heli));
    private _rocketcode = getText (configFile >> "CfgAmmo" >> _ammo >> "fza_shortCode");
    private _rocketInventory = [_heli] call fza_fnc_weaponRocketInventory;
    private _curAmmo = getText (configFile >> "CfgWeapons" >> _heli getVariable "fza_ah64_selectedRocket" >> "fza_ammoType");
    private _rocketInvIndex = _rocketInventory findIf {if (_x isEqualTo []) then {false} else {_x # 0 == _curAmmo}};
    if (_rocketInvIndex != -1) then {
        (_rocketInventory # _rocketInvIndex) params ["", "_selectedRktQty", "_selectedRktPylons", "_selectedRktText"];
        _weaponstate = format["%1 NORM %2", _rocketcode, _selectedRktQty];
    } else {
        _weaponstate = format["%1 NORM %2", _rocketcode, 0];
    };
};

if (_weaponWas == WAS_WEAPON_NONE) then {
    _weapon = "";
    _weaponstate = "";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetText "";
};

if (_weaponWas == WAS_WEAPON_GUN) then {
    _weapon = (["GUN", "PGUN"] select (isManualFire _heli));
    _weaponstate = format["ROUNDS %1", _heli ammo "fza_m230"];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetText "";
};

//IHADSS FLIGHT MODES

if (((_heli getVariable "fza_ah64_hmdfsmode") != "trans" && (_heli getVariable "fza_ah64_hmdfsmode") != "cruise") || (_headsdown)) then {
    _waypointcode = "";
    _gspdcode = "";
    _fpv = [-100, -100];
};

if (_heli getVariable "fza_ah64_hmdfsmode" != "cruise") then {
    _baraltft = "";
};

#define BOBUP_EDGE_DISPLAY 0.17
#define BOBUP_EDGE_FEET 40

_bobcoords = [-100, -100];
if (_heli getVariable "fza_ah64_hmdfsmode" == "bobup") then {
    private _thetabob = (_heli getdir (_heli getVariable "fza_ah64_bobpos")) - direction _heli;
    private _heliBobDist = (_heli distance2d (_heli getVariable "fza_ah64_bobpos")) / BOBUP_EDGE_FEET * SCALE_METERS_FEET * BOBUP_EDGE_DISPLAY;
    private _coordX = sin _thetabob;
    private _coordY = cos _thetabob;
    private _offsetX = 0.480;
    private _offsetY = 0.475;

    _bobcoordsX = _offsetX + ([((_coordX * _heliBobDist)), -BOBUP_EDGE_DISPLAY, BOBUP_EDGE_DISPLAY] call BIS_fnc_clamp)/4*3;
    _bobcoordsY = _offsetY + ([((_coordY * -_heliBobDist)), -BOBUP_EDGE_DISPLAY, BOBUP_EDGE_DISPLAY] call BIS_fnc_clamp);
    _bobcoords  = [_bobcoordsx, _bobcoordsy];
};

///HAD INHIBIT MESSAGES
if (_heli getVariable "fza_ah64_weaponInhibited" != "") then {
    _safemessage = _heli getVariable "fza_ah64_weaponInhibited";
};

//SET NUMBERS AND IDC
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 121) ctrlSetText _sensor + _targrange;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 122) ctrlSetText _sensxm;

//VISION MODE CPG HEADSDOWN
if (cameraView == "GUNNER" && player == gunner _heli) then {
    private _visionTxt = "FLIR";
    if (_Visionmode == 0) then {_visionTxt = "DTV";};
    if (_Visionmode == 3) then {_visionTxt = "DVO";};

    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 123) ctrlSetText _visionTxt
} else {
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 123) ctrlSetText _collective + "%";
};

private _curTurret = [_heli] call fza_fnc_currentTurret;
private _curAcq = [_heli, _curTurret] call fza_fnc_targetingCurAcq;

((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 124) ctrlSetText _speedkts;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 125) ctrlSetText _radaltft;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 126) ctrlSetText _weapon;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 127) ctrlSetText _weaponstate;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 128) ctrlSetText _safemessage;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 129) ctrlSetText _waypointcode;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 184) ctrlSetText _gspdcode;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 188) ctrlSetText _baraltft;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 804) ctrlSetText _curAcq;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 133) ctrlSetPosition[(_sensorposx) + 0.4875, (_sensorposy) + 0.735];
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 133) ctrlCommit 0;

private _cuedLosCtrl = (uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 132;

private _cuedLosPos = worldToScreen aslToAgl (aglToAsl positionCameraToWorld [0,0,0] vectorAdd ([_heli, _curAcq] call fza_fnc_targetingAcqVec));
if (_cuedLosPos isEqualTo []) then {
    _cuedLosPos = [-100, -100];
};

_cuedLosCtrl ctrlSetPosition ([(_cuedLosPos select 0)-0.036,(_cuedLosPos select 1)-0.05] call fza_fnc_compensateSafezone);
_cuedLosCtrl ctrlCommit 0;

private _headTrackerPos = worldToScreen (_heli modelToWorldVisual [0, 1000000, 0]);
if (_headTrackerPos isEqualTo []) then {
    _headTrackerPos = [-100, -100];
} else {
    _headTrackerPos = ([-0.019225, -0.025] vectorAdd _headTrackerPos) call fza_fnc_compensateSafezone;
};

//Acceleration Cue
private _accelCueX       = 0.0; 
private _accelCueY       = 0.0; 
private _accelCueScalar  = 1.0;
private _accelCueXOrigin = 0.481; 
private _accelCueYOrigin = 0.476;
private _accelCueWidth   = 0.336 * 0.86; 
private _accelCueHeight  = 0.336 * 1.10;
private _velX   = 0.0; 
private _velY   = 0.0;
private _accelX = 0.0; 
private _accelY = 0.0;

if (_heli getVariable "fza_ah64_hmdfsmode" == "hover" || _heli getVariable "fza_ah64_hmdfsmode" == "bobup") then {
    _velX = ((_heli getVariable "fza_sfmplus_velModelSpaceNoWind") select 0) / 3.08667;
    _velY = ((_heli getVariable "fza_sfmplus_velModelSpaceNoWind") select 1) / 3.08667;
};

if (_heli getVariable "fza_ah64_hmdfsmode" == "trans") then {
    _velX = ((_heli getVariable "fza_sfmplus_velModelSpaceNoWind") select 0) / 30.8667;
    _velY = ((_heli getVariable "fza_sfmplus_velModelSpaceNoWind") select 1) / 30.8667;
};
_velX = [_velX, -1.0, 1.0] call BIS_fnc_clamp;
_velY = [_velY, -1.0, 1.0] call BIS_fnc_clamp;

if (_heli getVariable "fza_ah64_hmdfsmode" != "cruise") then {
    _accelX    = (_heli getVariable "fza_sfmplus_accelX") / 12.0;
    _accelX    = [_accelX, -1.0, 1.0] call BIS_fnc_clamp;

    _accelY    = (_heli getVariable "fza_sfmplus_accelY") / 12.0;
    _accelY    = [_accelY, -1.0, 1.0] call BIS_fnc_clamp;

    private _accelScaling = 0.168;
    if (_heli getVariable "fza_ah64_hmdfsmode" == "hover" || _heli getVariable "fza_ah64_hmdfsmode" == "bobup") then {
        if ((_heli getVariable "fza_sfmplus_gndSpeed") <= 6) then {
            _accelCueX =  _velX + _accelX;
            _accelCueY = -_velY - _accelY;
        } else {
            _accelCueX = _accelX;
            _accelCueY = _accelY;
        };
    } else {
        _accelCueX =  _velX + _accelX;
        _accelCueY = -_velY - _accelY;
    };
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 300) ctrlSetPosition
        [ [_accelCueXOrigin + _accelCueX * _accelScaling, _accelCueXOrigin - (_accelCueWidth / 2.0), _accelCueYOrigin + (_accelCueWidth / 2.0)] call BIS_fnc_clamp
        , [_accelCueYOrigin + _accelCueY * _accelScaling, _accelCueYOrigin - (_accelCueHeight / 2.0), _accelCueYOrigin + (_accelCueHeight / 2.0)] call BIS_fnc_clamp];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 300) ctrlCommit 0;
};
//End Acceleration Cue
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 182) ctrlSetPosition (_headTrackerPos);
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 182) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 183) ctrlSetPosition[_fcrantennafor, 0.72];
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 183) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 185) ctrlSetPosition _fpv;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 185) ctrlCommit 0;
_slip = [fza_ah64_sideslip * 0.1 + 0.492, 0.44, 0.54] call BIS_fnc_clamp;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 186) ctrlSetPosition[_slip, 0.695];
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 186) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 187) ctrlSetPosition _bobcoords;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 187) ctrlCommit 0;
_radalt = (getpos _heli select 2) * 0.0042;
if (_radalt > 0.26) then {
    _radalt = 0;
};
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 136) ctrlSetPosition[0.709, (0.6321 - _radalt), 0.01, _radalt];
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 136) ctrlCommit 0;
_fpm = ((_heli getVariable "fza_sfmplus_velWorldSpace") select 2) * 0.0255;
_fpm = [_fpm, -0.13, 0.13] call BIS_fnc_clamp;

((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 135) ctrlSetPosition[0.678, 0.49 - _fpm];
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 135) ctrlCommit 0;
_pbvar = _heli call fza_fnc_getPitchBank;

_pbvar set [0, [_pbvar # 0 + 5, -25, 25] call BIS_fnc_clamp];

//HUD HORIZON OBJECTS

if ((_heli getVariable "fza_ah64_hmdfsmode" != "trans" && _heli getVariable "fza_ah64_hmdfsmode" != "cruise") || (_headsdown)) then {
    {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _x) ctrlSetPosition[100, 10, 100];
    }
    foreach[250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269];
} else {
    if (_heli getVariable "fza_ah64_hmdfsmode" == "trans") then {
        [269, (_pbvar select 0), (_pbvar select 1)] call _autohide;
    } else {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 269) ctrlSetPosition[100, 10, 100];
    };

    if (_heli getVariable "fza_ah64_hmdfsmode" == "cruise") then {
        [250, (_pbvar select 0), (_pbvar select 1)] call _autohide;
        [251, (_pbvar select 0) - 10, (_pbvar select 1)] call _autohide;
        [252, (_pbvar select 0) - 20, (_pbvar select 1)] call _autohide;
        [253, (_pbvar select 0) - 30, (_pbvar select 1)] call _autohide;
        [254, (_pbvar select 0) - 40, (_pbvar select 1)] call _autohide;
        [255, (_pbvar select 0) - 50, (_pbvar select 1)] call _autohide;
        [256, (_pbvar select 0) - 60, (_pbvar select 1)] call _autohide;
        [257, (_pbvar select 0) - 70, (_pbvar select 1)] call _autohide;
        [258, (_pbvar select 0) - 80, (_pbvar select 1)] call _autohide;
        [259, (_pbvar select 0) - 90, (_pbvar select 1)] call _autohide;
        [260, (_pbvar select 0) + 10, (_pbvar select 1)] call _autohide;
        [261, (_pbvar select 0) + 20, (_pbvar select 1)] call _autohide;
        [262, (_pbvar select 0) + 30, (_pbvar select 1)] call _autohide;
        [263, (_pbvar select 0) + 40, (_pbvar select 1)] call _autohide;
        [264, (_pbvar select 0) + 50, (_pbvar select 1)] call _autohide;
        [265, (_pbvar select 0) + 60, (_pbvar select 1)] call _autohide;
        [266, (_pbvar select 0) + 70, (_pbvar select 1)] call _autohide;
        [267, (_pbvar select 0) + 80, (_pbvar select 1)] call _autohide;
        [268, (_pbvar select 0) + 90, (_pbvar select 1)] call _autohide;
    } else {
        {
            ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _x) ctrlSetPosition[100, 10, 100];
        }
        foreach[250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268];
    };

    _pitch = 0;
    _bank = (_pbvar select 1) * -1;

    _dir = 0;
    _vecdx = sin(_dir) * cos(_pitch);
    _vecdy = cos(_dir) * cos(_pitch);
    _vecdz = sin(_pitch);

    _vecux = cos(_dir) * cos(_pitch) * sin(_bank);
    _vecuy = sin(_dir) * cos(_pitch) * sin(_bank);
    _vecuz = cos(_pitch) * cos(_bank); {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _x) ctrlSetModelDirAndUp[[_vecdx, _vecdy, _vecdz], [_vecux, _vecuy, _vecuz]];
    }
    foreach[250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269];
};

// CAMERA HEADINGS FOR GUNNER
if (cameraView == "GUNNER" && player == gunner _heli) then {
    _tadsdir = _tadsAzimuth;
    _curwpdir = _tadsdir;
};
private _alternatesensorpan = if (player == gunner _heli) then {deg(_heli animationPhase "pnvs")} else {_tadsAzimuth}; 
private _alternatesensortilt = if (player == gunner _heli) then {linearConversion [-1, 1, (deg(_heli animationPhase "pnvs_vert")), -45, 20]} else {_tadsElevation}; 

private _modelAlternateSensorVect = [sin _alternatesensorpan, cos _alternatesensorpan, sin _alternatesensortilt];
private _worldAlternateSensorVect = (_heli modelToWorld _modelAlternateSensorVect) vectorDiff (_heli modelToWorld [0,0,0]);
private _alternatesensordir = (_worldAlternateSensorvect # 0) atan2(_worldAlternateSensorvect # 1);

#define HEADING_TAPE_W 0.4

private _heliDir = direction _heli;
private _drawHeading = {
    params ["_ctrl", "_hdg", "_xOffset", "_yOffset", "_clamp"];
    private _xHdg = ([_hdg - _heliDir] call CBA_fnc_simplifyAngle180) / 203 * HEADING_TAPE_W; // -0.5 0.5
    if (_clamp) then {
        _xHdg = [_xHdg, -HEADING_TAPE_W/2, HEADING_TAPE_W/2] call BIS_fnc_clamp;
    } else {
        private _range = HEADING_TAPE_W/2;
        if (_xHdg < -_range || _xHdg > _range) then {
            _xHdg = -100;
        };
    };
    _ctrl ctrlSetPosition [0.5+_xHdg+_xOffset, _yOffset];
    _ctrl ctrlCommit 0;
};

for "_i" from 0 to 35 do {
    private _ctrl = (uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (146+_i);
    private _hdg = _i * 10;
    private _major = _i mod 3 == 0;
    private _xOffset = [-0.0015, -0.024] select _major;
    private _yOffset = [0.29, 0.27] select _major;
    [_ctrl, _hdg, _xOffset, _yOffset, false] call _drawHeading
};

[(uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 207, _alternatesensordir, -0.0075, 0.31, true] call _drawHeading;

if (_fcrhdg > 360) then {
    (uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137 ctrlSetPosition [-100, -100];
    (uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137 ctrlCommit 0;
} else {
    [(uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137, _fcrhdg, -0.0096, 0.31, true] call _drawHeading;
};

if (_curwpdir < -180 || _curwpdir > 180) then {
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 134) ctrlSetPosition[-100, 0];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 134) ctrlCommit 0;
} else {
     [(uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 134, _curwpdir + _heliDir, -0.025, 0.31, true] call _drawHeading;
};

((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 207) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 134) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137) ctrlCommit 0;