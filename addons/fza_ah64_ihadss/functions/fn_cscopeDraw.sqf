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


private _wasState    = _heli getVariable "fza_ah64_was";
private _fcrTargets  = _heli getVariable "fza_ah64_fcrDisplayTargets";
private _cScopeCount = 0;
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];

{
    if (_cScopeCount > 15) exitWith {};
    if !(_heli getVariable "fza_ah64_fcrcscope") exitWith {
        _guiPos = [-100, -100];
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlSetPosition _guiPos;
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlCommit 0;
    };

    _x params ["_pos", "_type", "_moving"];
    private _distance_m = _scanPos distance2D _pos;
    private _guiPos     = worldToScreen ASLToAGL _pos;

    private _ident = [_type, _distance_m, _moving] call fza_mpd_fnc_buildFCRIdent;
    if (_ident == "") exitWith {};

    private _identParts = _ident splitString "_";
    private _tex = format ["\fza_ah64_mpd\tex\fcrIcons\%1%2_ca.paa",
        toLower (_identParts # 1),
        _identParts # 2
    ];
    
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
    // Position is already resolved by fn_resolveDisplay — just use index 0 directly
    private _fnGetPos = { params ["_rec"]; _rec # 0 };

    if (_ntsIndex != -1) then {
        private _ntsPos = [_fcrTargets # _ntsIndex] call _fnGetPos;
        private _guiPos = worldToScreen ASLToAGL _ntsPos;
        if (count _guiPos < 1) then {_guiPos = [-100, -100];};
        private _tex = format ["\fza_ah64_mpd\tex\fcrIcons\nts%1_ca.paa", (["", "_noMsl"] select ((_heli getVariable "fza_ah64_was") == WAS_WEAPON_NONE))];
        private _position = [(_guiPos#0)-0.03,(_guiPos#1)-0.05] call fza_fnc_compensateSafezone;
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlSetText _tex;
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlSetPosition ([_position#0, _position#1, 0.0576, 0.0768]);
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlCommit 0;
    } else {
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlSetPosition ([-100,-100] call fza_fnc_compensateSafezone);
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlCommit 0;
    };

    if (_antsIndex != -1) then {
        private _antsPos = [_fcrTargets # _antsIndex] call _fnGetPos;
        private _guiPos = worldToScreen ASLToAGL _antsPos;
        if (count _guiPos < 1) then {_guiPos = [-100, -100];};
        private _position = [(_guiPos#0)-0.03,(_guiPos#1)-0.05] call fza_fnc_compensateSafezone;
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlSetPosition ([_position#0, _position#1, 0.0576, 0.0768]);
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlCommit 0;
    } else {
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlSetPosition ([-100,-100] call fza_fnc_compensateSafezone);
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlCommit 0;
    };
} else {
    private _guiPos = [-100, -100];
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlSetPosition (_guiPos call fza_fnc_compensateSafezone);
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlCommit 0;
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlSetPosition (_guiPos call fza_fnc_compensateSafezone);
    ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 209) ctrlCommit 0;
};
