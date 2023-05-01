/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_cscopeDraw

Description:
    Controlls and draws the Cscope of the Ihadss

Parameters:
	_heli - The apache

Returns:
    Nothing

Examples:
	--- Code
    [_heli] call fza_ihadss_fnc_cscopeDraw
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

private _wasState           = _heli getVariable "fza_ah64_was";
private _nts                = _heli getVariable "fza_ah64_fcrNts";
private _fcrTargets         = _heli getVariable "fza_ah64_fcrTargets";
private _nts                = _nts # 0;
private _ntsIndex           = _fcrTargets findIf {_x # 3 == _nts};
private _antsIndex          = 0;
private _CscopeCount        = 0;

if (count _fcrTargets > 0) then {
    _antsIndex = (_ntsIndex + 1) mod (count _fcrTargets);
};
{
    if (_CscopeCount > 15) exitwith {};
    if !(_heli getVariable "fza_ah64_fcrcscope") exitwith {
        _GuiPos = [-100, -100];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlSetPosition _GuiPos;
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlCommit 0;
    };

    _x params ["_pos", "_type", "_speed", "_obj"];
    private _distance_m          = _heli distance2d _pos;
    private _unitType            = ""; //adu, heli, tracked, unk, wheeled, flyer
    private _unitStatus          = ""; //loal, lobl, move
    private _unitSelAndWpnStatus = ""; //nts, ants
    private _armaRadarOn         = isVehicleRadarOn _heli;
    private _GuiPos              = [-100, -100];

    if (_armaRadarOn) then {
        _GuiPos = worldtoscreen (getpos _obj);
    } else {
        _GuiPos = worldtoscreen asltoagl _pos;
    };

    //Unit type
    switch (_type) do {
        case FCR_TYPE_UNKNOWN: {
            _unitType = "unk";
        };
        case FCR_TYPE_WHEELED: {
            _unitType = "wheel";
        };
        case FCR_TYPE_HELICOPTER: {
            _unitType = "heli";
        };
        case FCR_TYPE_FLYER: {
            _unitType = "flyer";
        };
        case FCR_TYPE_TRACKED: {
            _unitType = "track";
        };
        case FCR_TYPE_ADU: {
            _unitType = "adu";
        };
    };

    //Unit status
    if ((_speed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH) && (_distance_m >= FCR_LIMIT_MIN_RANGE && _distance_m <= FCR_LIMIT_MOVING_RANGE)) then {
        _unitStatus = "MOVE";
    } else {
        If (_unitType == "flyer") then {
            _unitType = "unk";
        };
        if (_distance_m >= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE && _distance_m <= FCR_LIMIT_STATIONARY_RANGE) then {
            _unitStatus = "LOAL";
        } else {
            _unitStatus = "LOBL";
        };
    };
    //Unit select status
    if (_forEachIndex == _ntsIndex) then {
        if (_wasState == WAS_WEAPON_NONE) then {
            _unitSelAndWpnStatus = "_NTS_NoMSL";
        } else {
            _unitSelAndWpnStatus = "_NTS";
        };
    };
    if (_forEachIndex == _antsIndex) then {
        _unitSelAndWpnStatus = "_ANTS";
    };

    private _tex = format ["\fza_ah64_mpd\tex\tsdIcons\%1%2%3_ca.paa", _unitType, _unitStatus, _unitSelAndWpnStatus];
    
	if (count _GuiPos < 1) then {
		_GuiPos = [-100, -100];
	};
	((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlSetText _tex;
	((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlSetPosition ([(_GuiPos select 0)-0.036,(_GuiPos select 1)-0.054] call fza_fnc_compensateSafezone);
	((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlCommit 0;

    _CscopeCount = _CscopeCount + 1;

    _ntsc = _heli getVariable "fza_ah64_fcrNts";
    if (_obj == _ntsc # 0) then {
        if (_was == WAS_WEAPON_MSL) then {
            _targpos = _guipos;
            _scPos = _guipos;
        };
    };
} forEach (_heli getVariable "fza_ah64_fcrTargets");

private _UnusedCount = (count (_heli getVariable "fza_ah64_fcrTargets"));
for "_i" from _UnusedCount to 15 do
{
	_GuiPos = [-100, -100];
	((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_i + 190)) ctrlSetPosition (_GuiPos call fza_fnc_compensateSafezone);
	((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_i + 190)) ctrlCommit 0;
};