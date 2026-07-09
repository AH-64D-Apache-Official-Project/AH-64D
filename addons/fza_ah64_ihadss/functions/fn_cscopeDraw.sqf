#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];


private _wasState    = _heli getVariable "fza_ah64_was";
private _fcrTargets  = _heli getVariable "fza_ah64_fcrDisplayTargets";
private _cScopeCount = 0;
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_scanPos"];

// TPM: C-scope shows the obstacle snapshot at structure tops (nearest-first), no NTS/ANTS
private _isTpm = (_heli getVariable "fza_ah64_fcrMode") == FCR_DISP_MODE_TPM;
if (_isTpm) then {
    _fcrTargets = (_heli getVariable ["fza_ah64_fcrTPMObsDisplay", []]) apply { [_x] };
};

{
    if (_cScopeCount > 15) exitWith {};
    if !(_heli getVariable "fza_ah64_fcrcscope") exitWith {
        _guiPos = [-100, -100];
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlSetPosition _guiPos;
        ((uiNamespace getVariable "fza_ah64_raddisp") displayCtrl (_cScopeCount + 190)) ctrlCommit 0;
    };

    _x params ["_pos", "_type", "_moving"];
    if (count _pos < 3) then { continue; };
    private _guiPos = worldToScreen ASLToAGL _pos;

    private _tex = "\fza_ah64_mpd\tex\fcrIcons\fcrObstacle_ca.paa";
    if (!_isTpm) then {
        private _distance_m = _scanPos distance2D _pos;
        private _ident = [_type, _distance_m, _moving] call fza_mpd_fnc_buildFCRIdent;
        if (_ident == "") then {
            _tex = "";
        } else {
            private _identParts = _ident splitString "_";
            private _texSuffix = if (_identParts # 1 == "FLYER") then {""} else {_identParts # 2};
            _tex = format ["\fza_ah64_mpd\tex\fcrIcons\%1%2_ca.paa",
                toLower (_identParts # 1),
                _texSuffix
            ];
        };
    };
    if (_tex == "") exitWith {};


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
private _ntsIndex  = if (_isTpm) then { -1 } else { _fcrTargets findIf {_x # 3 == _nts} };
private _fcrcount = count _fcrTargets;
private _antsIndex = -1;
if (!_isTpm && _fcrcount > 1 && _ntsIndex != -1) then {
    _antsIndex = (_ntsIndex + 1) mod (_fcrcount min 16);
};

if (_heli getVariable "fza_ah64_fcrcscope") then {
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
