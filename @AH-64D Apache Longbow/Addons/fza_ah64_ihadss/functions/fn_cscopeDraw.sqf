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
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"

private _wasState           = _heli getVariable "fza_ah64_was";
private _fcrTargets         = _heli getVariable "fza_ah64_fcrDisplayTargets";
private _lastScanInfo       = _heli getVariable "fza_ah64_fcrLastScan";
private _CscopeCount        = 0;

{
    if (_CscopeCount > 15) exitwith {};
    if !(_heli getVariable "fza_ah64_fcrcscope") exitwith {
        _GuiPos = [-100, -100];
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlSetPosition _GuiPos;
        ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlCommit 0;
    };

    _x params ["_pos", "_type", "_moving", "_obj"];
    private _distance_m          = _lastScanInfo #1 distance2d _pos;
    private _unitType            = ""; //adu, heli, tracked, unk, wheeled, flyer
    private _unitStatus          = ""; //loal, lobl, move
    private _GuiPos              = worldtoscreen asltoagl _pos;

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
    if !(_unitType == "FLYER") then {
        if (_moving && (_distance_m >= FCR_LIMIT_MIN_RANGE && _distance_m <= FCR_LIMIT_MOVING_RANGE)) then {
            _unitStatus = "MOVE";
        } else {
            if (_distance_m >= FCR_LIMIT_MIN_RANGE && _distance_m <= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) then {
                _unitStatus = "LOBL";
            };
            if (_distance_m > FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE && _distance_m <= FCR_LIMIT_STATIONARY_RANGE) then {
                _unitStatus = "LOAL";
            };
            if (_distance_m > FCR_LIMIT_STATIONARY_RANGE) then {
                continue;
            };
        };
    };

    if (_distance_m <= FCR_LIMIT_MIN_RANGE) exitwith {};

    private _tex = format ["\fza_ah64_mpd\tex\fcrIcons\%1%2_ca.paa", _unitType, _unitStatus];
    
    if (count _GuiPos < 1) then {
        _GuiPos = [-100, -100];
    };
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlSetText _tex;
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlSetPosition ([(_GuiPos select 0)-0.036,(_GuiPos select 1)-0.054] call fza_fnc_compensateSafezone);
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_CscopeCount + 190)) ctrlCommit 0;

    _CscopeCount = _CscopeCount + 1;
} forEach (_heli getVariable "fza_ah64_fcrTargets");

for "_i" from _CscopeCount to 15 do
{
    _GuiPos = [-100, -100];
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_i + 190)) ctrlSetPosition (_GuiPos call fza_fnc_compensateSafezone);
    ((uiNameSpace getVariable "fza_ah64_raddisp") displayCtrl (_i + 190)) ctrlCommit 0;
};