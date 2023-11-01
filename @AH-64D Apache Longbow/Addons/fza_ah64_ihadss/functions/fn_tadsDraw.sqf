/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsDraw

Description:
    Draws the IHADSS overlay for the player.

Parameters:
    _heli - The heli object to draw the IHADSS for

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_tadsDraw
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];

//A3TI FUNCTIONS
private _monocleinbox   = _heli getVariable "fza_ah64_monocleinbox";
private _acBusOn        = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn        = _heli getVariable "fza_systems_dcBusOn";
private _powerOnState   = (_acBusOn && _dcBusOn);
private _a3ti_vis       = call A3TI_fnc_getA3TIVision;
private _a3ti_brt       = call A3TI_fnc_getA3TIBrightnessContrast;
private _Visionmode     = [_heli] call fza_ihadss_fnc_getVisionMode;
private _pnvsDamage     = _heli getHitPointDamage "hit_msnEquip_pnvs_turret";
private _dtvDamage      = _heli getHitPointDamage "hit_msnEquip_tads_dtv";
private _flirDamage     = _heli getHitPointDamage "hit_msnEquip_tads_flir";
private _channel        = _heli getVariable "fza_ah64_laserLRFDCode";
private _hash           = _heli getVariable "fza_ah64_laserChannelIndex";
private _lsrcode        = _hash get _channel;
private _hduColour      = [0.1, 1, 0, 1];
private _setDeadOptics  = false;

if (cameraView == "GUNNER" && player == gunner _heli) then {
    if !(isNil "_a3ti_vis") then {
        if !(isNil "fza_ah64_bweff") then {
            fza_ah64_bweff ppEffectEnable false;
        };
    } else {
        if !(isNil "fza_ah64_bweff") exitwith {
            fza_ah64_bweff ppEffectEnable true;
        };
        fza_ah64_bweff = ppEffectCreate["colorCorrections", 4000];
        fza_ah64_bweff ppEffectAdjust[1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0.33, 0.33, 0.33, 0], [0, 0, 0, 0, 0, 0, 4]]; //MONOCHROME TADS EXP
        fza_ah64_bweff ppEffectCommit 0;
        fza_ah64_bweff ppEffectEnable true;
    };

    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetText "\fza_ah64_US\tex\HDU\TADSmain_co.paa";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 802) ctrlSetText "RCD      TADS"; //static data
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 803) ctrlSetText (_channel + " " + str _lsrcode) ; // LRFD code
    
    //COLOR SET THESE
    for "_i" from 121 to 207 do {
        //if (_i in [129,135,136,137,138,139,140,141,142,143,144,145,146,182,186]) exitwith {};
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _i) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    };
    for "_i" from 802 to 804 do {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _i) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1]; //COLOR WHITE TADS VIEW ACQ
    };

    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601) ctrlSetTextColor[1, 1, 1, 0]; // Hide interact action

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

    //LASER SYMBOLOGY FOR GUNNER
    if !(isNull laserTarget _heli) then {
        4 cutrsc["fza_ah64_laseit", "PLAIN", 0.01, false];
        ((uiNameSpace getVariable "fza_ah64_laseit") displayCtrl 701) ctrlSetText "\fza_ah64_US\tex\HDU\Apache_LaserOn.paa";
        ((uiNameSpace getVariable "fza_ah64_laseit") displayCtrl 701) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    };

    //TADS DTV/FLIR Fail
    if (_Visionmode == 0 && _dtvDamage >= SYS_SIGHT_DMG_THRESH) then {
        _setDeadOptics = true;
    };
    if (_Visionmode != 0 && _flirDamage >= SYS_SIGHT_DMG_THRESH) then {
        _setDeadOptics = true;
        _heli disableTIEquipment true;
    } else {
        _heli disableTIEquipment false;
    };
    if !_powerOnState then {
        _setDeadOptics = true;
    };
} else {

    fza_ah64_bweff ppEffectEnable false;
    fza_ah64_gweff ppEffectEnable false;
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetText "\fza_ah64_US\tex\HDU\ihadss.paa";
    ((uiNameSpace getVariable "fza_ah64_laseit") displayCtrl 701) ctrlSetText "";

    for "_i" from 121 to 207 do {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _i) ctrlSetTextColor _hduColour;
    };

    //REMOVE AND/OR RECOLOR TEXTURES ONCE HEADSUP
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601)
    ctrlSetTextColor[1, 1, 1, 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetText "\fza_ah64_US\tex\HDU\ihadss.paa"; //TEST
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

if _setDeadOptics then {
    if !(isNil "fza_ah64_gweff") exitwith {
        fza_ah64_gweff ppEffectEnable true;
    };
    fza_ah64_gweff = ppEffectCreate ["colorCorrections",1498];
    fza_ah64_gweff ppEffectAdjust [0, 0, 0, [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]];
    fza_ah64_gweff ppEffectCommit 0;
    fza_ah64_gweff ppEffectEnable true;
} else {
    fza_ah64_gweff ppEffectEnable false;
};