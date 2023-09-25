/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_ihadssDraw

Description:
    Draws the IHADSS overlay for the player.

Parameters:
    _heli - The heli object to draw the IHADSS for

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_ihadssDraw
    ---

Author:
    unknown
---------------------------------------------------------------------------- */
params ["_heli"];

#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

#define SCALE_METERS_FEET 3.28084
#define SCALE_MPS_KNOTS 1.94
private _targhead    = 0;
private _sensor      = "";
private _sensxm      = "";
private _weapon      = "";
private _weaponstate = "";
private _rcd         = "RCD      TADS";
private _lsrcode     = "A 1688";
private _safemessage = "";
private _rocketcode  = "???";
private _targrange   = "0";
private _waypointcode = "";
private _gspdcode    = "";
private _curwpdir    = -1000;
private _chevmark    = 0;
private _fcrantennafor = -100;
private _fcrhdg      = -1000;
private _showFcrLastScan = false;   
private _fcrdir      = 0.5;
private _headsdown   = false;
private _hduColour    = [0.1, 1, 0, 1];

if (vehicle player != _heli && !(vehicle player isKindOf "fza_ah64base") || !(alive _heli) && !(vehicle player isKindOf "fza_ah64base") || !(alive player) || !(isNull curatorCamera)) exitWith {
    1 cuttext["", "PLAIN"];
    2 cuttext["", "PLAIN"];
    3 cuttext["", "PLAIN"];
    4 cuttext["", "PLAIN"];
    fza_ah64_bweff ppEffectEnable false;
};

if (isNil "fza_ah64_helperinit") then {
    2 cutrsc["fza_ah64_click_helper", "PLAIN", 0.01, false];
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 602) ctrlSetTextColor[0, 1, 1, 1];
    if (isNil "fza_ah64_mousetracker") then {
        fza_ah64_mousetracker = (findDisplay 46) displayAddEventHandler["MouseMoving", "_this call fza_fnc_uiMouseMove"];
    };
    fza_ah64_helperinit = true;
};

if (isNull(uiNameSpace getVariable "fza_ah64_click_helper")) then {
    2 cutrsc["fza_ah64_click_helper", "PLAIN", 0.01, false];
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 602) ctrlSetTextColor[0, 1, 1, 1];
};

private _clickHint = (uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 602;
if (fza_ah64_enableClickHelper) then {
    private _controls = [_heli] call fza_fnc_coreGetObjectsLookedAt;
    if (_controls isEqualTo []) then {
        _clickHint ctrlSetText "";
    } else {
        //If there are multiple controls in the range, make sure we use the closest one
        if(count _controls > 1) then {
            _controls = [_controls, [], {_x # 6}, "ASCEND"] call BIS_fnc_sortBy;
        };
        _clickHint ctrlSetText (_controls # 0 # 5);
    };
} else {
     _clickHint ctrlSetText "";
};
_clickHint ctrlCommit 0.001;


private _acBusOn = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn = _heli getVariable "fza_systems_dcBusOn";
private _powerOnState = (_acBusOn && _dcBusOn);

if !_powerOnState then {
    1 cuttext["", "PLAIN", 0.1];
};
if (_powerOnState && _heli getVariable "fza_ah64_monocleinbox") then {
    1 cuttext["", "PLAIN", 0.1];
};
if (isNull laserTarget _heli) then {
    4 cuttext["", "PLAIN", 0.1];
};



_targPos = [-100, -100];
private _nts = _heli getVariable "fza_ah64_fcrNts";
private _nts = _nts # 0;
if(!isNull _nts) then {
    _targPos = worldToScreen(getpos _nts);
    if (count _targPos < 1) then {
        _targPos = [-100, -100];
    } else {
        _targPos = [
            [_targPos # 0, 0, 1] call BIS_fnc_clamp,
            [_targPos # 1, 0, 1] call BIS_fnc_clamp];
    };
};

//PNVS HDU
if (_heli getVariable "fza_ah64_ihadss_pnvs_cam" && cameraView != "GUNNER" && alive player) then {
    if (ctrlText ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 120) != "#(argb,512,512,1)r2t(fza_ah64_pnvscam2,1)") then {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 120) ctrlSetText "#(argb,512,512,1)r2t(fza_ah64_pnvscam2,1)"; //DTV HDU
    };
} else {
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 120) ctrlSetText "";
};

//A3TI FUNCTIONS
private _a3ti_vis = call A3TI_fnc_getA3TIVision;
private _a3ti_brt = call A3TI_fnc_getA3TIBrightnessContrast;

//TADS DISABLE IF ENGINE OFF
if (cameraView == "GUNNER" && player == gunner _heli && !_powerOnState) then {
    fza_ah64_bweff ppEffectEnable true;
    _heli disableTIEquipment true;
} else {
    fza_ah64_bweff ppEffectEnable false;
    _heli disableTIEquipment false;
};

//IHADSS INIT

private _initialized = missionNamespace getVariable "fza_ah64_raddisp";
if (isNil "_initialized") then {
    1 cutrsc["fza_ah64_raddisp", "PLAIN", 0.01, false];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetText "\fza_ah64_US\tex\HDU\ihadss.paa";

    for "_i" from 121 to 206 do {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _i) ctrlSetTextColor _hduColour;
    };
    missionNamespace setVariable ["fza_ah64_raddisp", true];
};

if (!(_heli getVariable "fza_ah64_monocleinbox") && cameraView == "INTERNAL") then {
    3 cutrsc["fza_ah64_monocleinbox", "PLAIN", 0.01, false];
    ((uiNameSpace getVariable "fza_ah64_monocleinbox") displayCtrl 501) ctrlSetText "\fza_ah64_US\tex\HDU\monocle_solid.paa";
} else {
    3 cuttext["", "PLAIN"];
};

//1ST PERSON VIEW IHADSS BASIC FLIGHT INFO SETUP

if ((gunner _heli == player || driver _heli == player) && ((!(_heli getVariable "fza_ah64_monocleinbox") && cameraView == "INTERNAL") || cameraView == "GUNNER") && _powerOnState) then {
    if (isNull(uiNameSpace getVariable "fza_ah64_raddisp")) then {
        1 cutrsc["fza_ah64_raddisp", "PLAIN", 0.01, false];

        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 121) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 122) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 123) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 124) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 125) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 126) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 127) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 128) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 129) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 184) ctrlSetTextColor[0.1, 1, 0, 1];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 188) ctrlSetTextColor[0.1, 1, 0, 1];
        _rocketcode = "???";
    };
} else {
    if (cameraView == "EXTERNAL" || !(vehicle player isKindOf "fza_ah64base" || alive player)) then {
        1 cuttext["", "PLAIN"];
        2 cuttext["", "PLAIN"];
        3 cuttext["", "PLAIN"];
        4 cuttext["", "PLAIN"];
    };
};

if !_powerOnState then {
    1 cuttext["", "PLAIN"];
    4 cuttext["", "PLAIN"];
};

//IHADSS FOR GUNNER HEADSDOWN
if (cameraView == "GUNNER" && player == gunner _heli && _powerOnState) then {

    if !(isNil "_a3ti_vis") then {
        if !(isNil "fza_ah64_bweff") then {
            fza_ah64_bweff ppEffectEnable false;
        };
    } else {
        fza_ah64_bweff = ppEffectCreate["colorCorrections", 4000];
        fza_ah64_bweff ppEffectAdjust[1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0.33, 0.33, 0.33, 0], [0, 0, 0, 0, 0, 0, 4]]; //MONOCHROME TADS EXP
        fza_ah64_bweff ppEffectCommit 0;
        fza_ah64_bweff ppEffectEnable true;
    };

    _headsdown = true;

    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetText "\fza_ah64_US\tex\HDU\TADSmain_co.paa";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601) ctrlSetTextColor[1, 1, 1, 0];

    //ADD STATIC DATA TO TADS
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 802) ctrlSetText _rcd;
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 803) ctrlSetText _lsrcode;

    //COLOR WHITE TADS VIEW ACQ
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 804) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];

    //HIDE CLICK HELPER FOR HEADSDOWN GUNNER
    ((uiNameSpace getVariable "fza_ah64_click_helper") displayCtrl 601) ctrlSetTextColor[1, 1, 1, 0];

    //COLOR SET THESE
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 121) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 122) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 123) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 124) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 125) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 126) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 127) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 128) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 132) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 133) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 134) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 207) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];

    _ihadssidx = 146;
    while {
        (_ihadssidx < 207)
    }
    do {
        if (!(_ihadssidx == 135 || _ihadssidx == 136 || _ihadssidx == 182 || _ihadssidx == 186 || _ihadssidx == 123 || _ihadssidx == 124 || _ihadssidx == 125 || _ihadssidx == 120)) then {
            ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _ihadssidx) ctrlSetTextColor[(_hduColour select 1), (_hduColour select 1), (_hduColour select 1), 1];
        };
        _ihadssidx = _ihadssidx + 1;
    };

    //RELOCATE TEXTURES AS FOLLOWS
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 123)
    ctrlsetposition[0.31, 0.345, 0.5, 0.12];
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

} else {

    _headsdown = false;

    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 130) ctrlSetText "\fza_ah64_US\tex\HDU\ihadss.paa";
    ((uiNameSpace getVariable "fza_ah64_laseit") displayCtrl 701) ctrlSetText "";

    _ihadssidx = 121;

    while {
        (_ihadssidx < 208)
    }
    do {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _ihadssidx) ctrlSetTextColor _hduColour;
        _ihadssidx = _ihadssidx + 1;
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


_autohide = {
    _partid = _this select 0;
    _pitchid = _this select 1;
    _bankid = _this select 2;

    if ((_pitchid < -20 || _pitchid > 20)) then {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _partid) ctrlSetPosition[100, 10, 100];
    } else {
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl _partid) ctrlSetPosition[0.5 + (((_pitchid) * 0.00556) * (sin _bankid)), 10, 0.5 + (((_pitchid) * 0.00556) * (cos _bankid))];
    };

};

_gspdcode = format["%1", round(0.53996 * (speed _heli))] + "    " + format["%1:%2%3", fza_ah64_wptimhr, fza_ah64_wptimtm, fza_ah64_wptimsm];

private _nextPoint = _heli getVariable "fza_dms_routeNext";
private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
[_heli] call fza_mpd_fnc_tsdWaypointStatusText params ["_waypointId", "_groundspeed", "_waypointDist", "_waypointEta"];

_waypointcode = format ["%1    %2", _waypointId, _waypointDist];
_gspdcode = format ["%1    %2", _groundSpeed, _waypointEta];
// Todo: Display current waypoint
if (!isNil "_nextPointPos") then {
    _curwpdir = [[_heli, getpos _heli # 0, getPos _heli # 1, _nextPointPos # 0, _nextPointPos # 1] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180;
};

/////////////////////////////////////////////////////////

_sight = [_heli] call fza_fnc_targetingGetSightSelect;
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

_targrange = format["%1", ((round((_heli distance _nts) * 0.01)) * 0.1)];
if (isNull _nts) then {
    _targrange = "0.0";
};
if (!isNull laserTarget _heli) then {
    _targrange = format["*%1", round(_heli distance laserTarget _heli)];
};

_thetatarg = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _nts select 0), (getposatl _nts select 1)] call fza_fnc_relativeDirection;

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
_speedkts = format["%1", round(1.94384 * vectorMagnitude((velocity _heli) vectorDiff wind))];

([_heli] call fza_sfmplus_fnc_getAltitude)
    params ["_barAlt", "_radAlt"];
_baraltft = format["%1",  _barAlt toFixed 0];
_radaltft = format["%1", [_radAlt toFixed 0, ""] select (_radAlt > 1428)];

private _fcrLastScan = _heli getVariable "fza_ah64_fcrLastScan";
if !isNil {_fcrLastScan # 0} then {
    _fcrhdg = _fcrLastScan # 0;
    _showFcrLastScan = true;
    _fcrDir = [_fcrhdg - direction _heli] call CBA_fnc_simplifyAngle180;
    _fcrantennafor = linearConversion [-120,120,_fcrDir,0.44,0.56,true];
};
_sensorposx = (_heli animationphase "tads_tur") * -0.025;
_sensorposy = (_heli animationphase "tads") * -0.015;
if (_sensorposy < 0) then {
    _sensorposy = (_heli animationphase "tads") * -0.026;
};
if !(_heli animationPhase "fcr_enable" == 1) then {
    _fcrantennafor = -100;
    _showFcrLastScan = false;
};
_slip = fza_ah64_sideslip * 0.1 + 0.492; //<-- 0.492 is the center for the trim ball <-- when slip = 0.15, it reaches the edge
if (_slip > 0.54) then {
    _slip = 0.54;
};
if (_slip < 0.44) then {
    _slip = 0.44;
};

_vvect = [_heli] call fza_fnc_velocityVector;
_vertvect = ((_vvect select 0) * -1) + 0.5;
_horvect = (_vvect select 1) + 0.485;

if (_vertvect > 0.65) then {
    _vertvect = 0.65;
};
if (_vertvect < 0.35) then {
    _vertvect = 0.35;
};
if (_horvect > 0.65) then {
    _horvect = 0.65;
};
if (_horvect < 0.35) then {
    _horvect = 0.35;
};

if (speed _heli < 5) then {
    _vertvect = -100;
    _horvect = -100;
};
private _was = _heli getVariable "fza_ah64_was";
if (_was == WAS_WEAPON_MSL) then {
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

if (_was == WAS_WEAPON_RKT) then {
    _weapon = (["RKT", "PRKT"] select (isManualFire _heli));
    _ammo = getText (configFile >> "CfgWeapons" >> (_heli getVariable "fza_ah64_selectedRocket") >> "fza_ammoType");
    _rocketcode = getText (configFile >> "CfgAmmo" >> _ammo >> "fza_shortCode");
    _weaponstate = format["%1 NORM %2", _rocketcode, _heli ammo(_heli getVariable "fza_ah64_selectedRocket")];
};

if (_was == WAS_WEAPON_NONE) then {
    _weapon = "";
    _weaponstate = "";
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetText "";
};

if (_was == WAS_WEAPON_GUN) then {
    _weapon = (["GUN", "PGUN"] select (isManualFire _heli));
    _weaponstate = format["ROUNDS %1", _heli ammo "fza_m230"];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 131) ctrlSetText "";
};

//IHADSS FLIGHT MODES

if (((_heli getVariable "fza_ah64_hmdfsmode") != "trans" && (_heli getVariable "fza_ah64_hmdfsmode") != "cruise") || (_headsdown)) then {
    _waypointcode = "";
    _gspdcode = "";
    _horvect = -100;
    _vertvect = -100;
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
    private _visionTxt = "";

    if (isNil "_a3ti_vis") then {
        if (currentVisionMode player == 0) then {
            _visionTxt = "DTV";
        } else {
            _visionTxt = "FLIR";
        };
    } else {
        //_visionTxt = _a3ti_vis;
        _visionTxt = "FLIR";
    };

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

((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 182) ctrlSetPosition (_headTrackerPos);
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 182) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 183) ctrlSetPosition[_fcrantennafor, 0.72];
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 183) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 185) ctrlSetPosition[_horvect, _vertvect];
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 185) ctrlCommit 0;
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
_fpm = (velocity _heli select 2) * 0.0255;
_fpm = [_fpm, -0.13, 0.13] call BIS_fnc_clamp;

((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 135) ctrlSetPosition[0.678, 0.49 - _fpm];
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 135) ctrlCommit 0;
_pbvar = _heli call fza_fnc_getPitchBank;

_pbvar set [0, _pbvar # 0 + 5];

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
    _tadsdir = (deg(_heli animationphase "tads_tur") * -1);
    _curwpdir = _tadsdir;
};
private _alternatesensorpan = (if (player == gunner _heli) then {(_heli animationPhase "pnvs")*120} else {-deg (_heli animationSourcePhase "tads_tur")}); 
private _alternatesensortilt = if (player == gunner _heli) then {linearConversion [-1, 1, (_heli animationPhase "pnvs_vert"), -45, 20]} else {deg (_heli animationSourcePhase "tads")}; 

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

if (_showFcrLastScan) then {
    [(uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137, _fcrhdg, -0.0096, 0.31, true] call _drawHeading;
} else {
    (uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137 ctrlSetPosition [-100, -100];
    (uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137 ctrlCommit 0;
};

if (_curwpdir < -360 || _curwpdir > 360) then {
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 134) ctrlSetPosition[-100, 0];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 134) ctrlCommit 0;
} else {
     [(uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137, _curwpdir + _heliDir, -0.025, 0.31, true] call _drawHeading;
};

((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 207) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 134) ctrlCommit 0;
((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl 137) ctrlCommit 0;