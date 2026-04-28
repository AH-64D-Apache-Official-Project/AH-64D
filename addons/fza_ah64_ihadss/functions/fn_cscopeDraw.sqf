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
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];

private _wasState       = [_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable;
private _fcrTargets     = _heli getVariable "fza_ah64_fcrTargets";
private _cScopeCount    = 0;
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time"];

{
    if (_cScopeCount > 15) exitWith {};
    if !(_heli getVariable "fza_ah64_fcrcscope") exitWith {
        _guiPos = [-100, -100];
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlSetPosition _guiPos;
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlCommit 0;
    };

    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];
    private _distance_m          = _scanPos distance2D _pos;
    private _unitType            = ""; //adu, heli, tracked, unk, wheeled, flyer
    private _unitStatus          = ""; //loal, lobl, move
    private _guiPos              = worldToScreen ASLToAGL _pos;

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
    if (_unitType != "FLYER") then {
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

    if (_distance_m <= FCR_LIMIT_MIN_RANGE) exitWith {};

    private _tex = format ["\fza_ah64_mpd\tex\fcrIcons\%1%2_ca.paa", _unitType, _unitStatus];
    
    if (count _guiPos < 1) then {
        _guiPos = [-100, -100];
    };
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlSetText _tex;
    private _position = [(_GuiPos select 0)-0.03,(_GuiPos select 1)-0.05] call fza_fnc_compensateSafezone;
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlSetPosition ([_position#0, _position#1, 0.0576, 0.0768]);
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlCommit 0;

    _cScopeCount = _cScopeCount + 1;
} forEach _fcrTargets;

for "_i" from _cScopeCount to 15 do
{
    _guiPos = [-100, -100];
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_i + 190)) ctrlSetPosition (_guiPos call fza_fnc_compensateSafezone);
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_i + 190)) ctrlCommit 0;
};


private _nts  = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _ntsIndex  = _fcrTargets findIf {_x # 3 == _nts};
private _fcrcount = count _fcrTargets;
private _antsIndex = -1;
if (_fcrcount > 1 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (_fcrcount min 16);
};

if (_heli getVariable "fza_ah64_fcrcscope") then {
    if (_ntsIndex != -1) then {
        private _guiPos = [-100, -100];
        private _ntsPos = _fcrTargets # _ntsIndex # 0;
        if (!isNil "_ntsPos") then {_guiPos = worldToScreen ASLToAGL _ntsPos;};
        if (count _guiPos < 1) then {_guiPos = [-100, -100];};
        private _tex = format ["\fza_ah64_mpd\tex\fcrIcons\nts%1_ca.paa", (["", "_noMsl"] select ((_heli getVariable "fza_ah64_was") == WAS_WEAPON_NONE))];
        private _position = [(_GuiPos#0)-0.03,(_GuiPos#1)-0.05] call fza_fnc_compensateSafezone;

        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlSetText _tex;
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlSetPosition ([_position#0, _position#1, 0.0576, 0.0768]);
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlCommit 0;
    } else {
        private _guiPos = [-100, -100];
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlSetPosition (_guiPos call fza_fnc_compensateSafezone);
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlCommit 0;
    };

    if (_antsIndex != -1) then {
        private _guiPos = [-100, -100];
        private _antsPos = _fcrTargets # _antsIndex # 0;
        if (!isNil "_antsPos") then {_guiPos = worldToScreen ASLToAGL _antsPos;};
        if (count _guiPos < 1) then {_guiPos = [-100, -100];};
        private _position = [(_GuiPos#0)-0.03,(_GuiPos#1)-0.05] call fza_fnc_compensateSafezone;
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlSetPosition ([_position#0, _position#1, 0.0576, 0.0768]);
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlCommit 0;
    } else {
        private _guiPos = [-100, -100];
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlSetPosition (_guiPos call fza_fnc_compensateSafezone);
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlCommit 0;
    };
} else {
    private _guiPos = [-100, -100];
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlSetPosition (_guiPos call fza_fnc_compensateSafezone);
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlCommit 0;
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlSetPosition (_guiPos call fza_fnc_compensateSafezone);
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlCommit 0;
};
