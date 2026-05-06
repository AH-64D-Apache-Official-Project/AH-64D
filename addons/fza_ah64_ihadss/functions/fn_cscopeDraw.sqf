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

private _wasState       = _heli getVariable "fza_ah64_was";
private _fcrTargets     = _heli getVariable "fza_ah64_fcrTargets";
private _cScopeCount    = 0;
_heli getVariable "fza_ah64_fcrState"    params ["_fcrScanState", "_fcrScanStartTime"];
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos", "_time"];
private _fcrScanDeltaTime = CBA_missionTime - (_fcrScanStartTime max _time);

{
    if (_cScopeCount > 15) exitWith {};
    if !(_heli getVariable "fza_ah64_fcrcscope") exitWith {
        _guiPos = [-100, -100];
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlSetPosition _guiPos;
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlCommit 0;
    };

    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];

    // Sweep reveal: ghosts visible until sweep passes their position, then cleared; non-ghosts hidden until bar passes
    private _isGhost = (_x # 8 > 0);
    private _beforeReveal = (_fcrScanState != FCR_MODE_OFF && _fcrScanDeltaTime < (_x # 7));
    if (_isGhost && (_x # 8 >= 2) && !_beforeReveal) then { continue; }; // Age-2 ghost cleared when sweep reaches its last-known position
    if (!_isGhost && _beforeReveal) then {
        if (count _x > 9) then {
            _pos = _x # 11; // Frozen at previous scan world position
        } else {
            continue; // Fresh: hidden until bar sweeps past
        };
    };

    private _distance_m = _scanPos distance2D _pos;
    private _guiPos     = worldToScreen ASLToAGL _pos;

    private _ident = [_type, _distance_m, _moving] call fza_mpd_fnc_buildFCRIdent;
    if (_ident == "") exitWith {};

    // ident format is "FCR_TYPE_STATUS"; extract parts for the texture path
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
    // Resolve effective display position using same reveal logic as target loop
    private _fnEffectivePos = {
        params ["_rec"];
        private _recBeforeReveal = (_fcrScanState != FCR_MODE_OFF && _fcrScanDeltaTime < (_rec # 7));
        if ((_rec # 8 >= 2) && !_recBeforeReveal) exitWith { [] }; // age-2 ghost erased by sweep
        if ((_rec # 8 == 0) && _recBeforeReveal && count _rec > 9) exitWith { _rec # 11 }; // tracked frozen
        if ((_rec # 8 == 0) && _recBeforeReveal) exitWith { [] }; // fresh hidden
        _rec # 0 // live or ghost-before-sweep pos
    };

    if (_ntsIndex != -1) then {
        private _ntsPos = [_fcrTargets # _ntsIndex] call _fnEffectivePos;
        if (count _ntsPos > 0) then {
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
    } else {
        private _guiPos = [-100, -100];
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlSetPosition (_guiPos call fza_fnc_compensateSafezone);
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl 208) ctrlCommit 0;
    };

    if (_antsIndex != -1) then {
        private _antsPos = [_fcrTargets # _antsIndex] call _fnEffectivePos;
        if (count _antsPos > 0) then {
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
