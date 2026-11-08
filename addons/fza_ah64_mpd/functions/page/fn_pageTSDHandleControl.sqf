params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

#include "\fza_ah64_mpd\headers\tsd.hpp"

private _subPage = _state get "subPageVarPage" select 0;
// The ACQ list opens from the root page
if ([_heli, _mpdIndex, _control, _subPage == 0] call fza_mpd_fnc_acqHandleControl) exitWith {};
if ((_state get "subPageVarPage") isEqualTo TSD_RTE_RTM) exitWith {_this call fza_mpd_fnc_tsdRTMHandleControl};

if (_this call fza_mpd_fnc_tsdScaleHandleControl) exitWith {};
// CTR, on the pages that draw it: the top level, WPT, THRT and PAN
if (_control == "r3" && {_subPage in [0, 2, 4, 5]}) exitWith {
    _persistState set ["ctr", 1 - (_persistState get "ctr")];
};

// ZOOM, on the same pages as CTR: the map 20 percent larger about the ownship (fza_mpd_fnc_tsdScale), or back
if (_control == "r1" && {_subPage in [0, 2, 4, 5]}) exitWith {
    _persistState set ["zoom", 1 - (_persistState getOrDefault ["zoom", 0])];
};

// The map frozen where it is now (fza_mpd_fnc_tsdFrame), unless it already is
private _freeze = {
    if ((_persistState getOrDefault ["frozen", []]) isEqualTo []) then {
        _persistState set ["frozen", [getPosASL _heli, direction _heli]];
    };
};

// FRZ, on the same pages as CTR: freeze the map, or back to the live map
if (_control == "r5" && {_subPage in [0, 2, 4, 5]} && {_state get "showScale" == 0}) exitWith {
    if ((_persistState getOrDefault ["frozen", []]) isEqualTo []) then {
        call _freeze;
    } else {
        _persistState set ["frozen", []];
        _state set ["caq", 0];
    };
};

// PAN, from the pages that draw it: the PAN page, the map frozen to pan it with the cursor
if (_control == "t3" && {_subPage in [0, 2, 3, 4] || {_subPage == 6 && {(_state get "subPageVarPage") # 1 < 2}}}) exitWith {
    call _freeze;
    _state set ["caq", 0];
    _state set ["znDraft", []];
    _state set ["subPageVarPage", TSD_PAN];
};

// ZN, from the pages that draw it: the zones drawn with the cursor on the frozen map
if (_control == "b3" && {_subPage in [0, 2, 3, 4, 5]}) exitWith {
    call _freeze;
    _state set ["caq", 0];
    _state set ["znDraft", []];
    _state set ["subPageVarPage", TSD_ZN];
};

// CAQ ends when the top level is left, for a subpage or another page
if (_subPage == 0 && {_control in ["l6", "b1", "b4", "b5", "b6", "t2", "t5"]}) then {
    _state set ["caq", 0];
};

// ZN's own buttons, where the other pages have ASE, PHASE (while a zone is drawn) and COORD
private _znOwns = _subPage == 6 && {_control in ["t2", "t5"] || {_control == "b2" && {(_state getOrDefault ["znDraft", []]) isNotEqualTo []}}};

if (!_znOwns) then {switch (_control) do {
    case "t2": {
        // LAST PAN on the PAN page
        if (_subPage != 5) then {
            [_heli, _mpdIndex, "ase"] call fza_mpd_fnc_setCurrentPage;
        };
    };
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b2": {
        private _newMode = ["atk", "nav"] select (_persistState get "mode" == "atk");
        _persistState set ["mode", _newMode];
    };
    case "t5": {
        if !(_subPage in [1, 5]) then {
            [_heli, _mpdIndex, "coord", ["tsdState"] createHashMapFromArray [_state]] call fza_mpd_fnc_setCurrentPage;
        };
    };
}};

switch _subPage do {
    case 0: { // Root
        switch (_control) do {
            case "l6": {
                _state set ["subPageVarPage", TSD_SHOW]; //SHOW subpage
            };
            case "b4": {
                _state set ["subPageVarPage", TSD_WPT]; //WPT subpage
            };
            case "b5": {
                _state set ["subPageVarPage", TSD_RTE]; //RTE subpage
            };
            case "b6": {
                _state set ["subPageVarPage", TSD_THRT]; //THRT subpage
            };
            case "r4": {
                // CAQ: choose a point or FCR target with the cursor as the crew station's acquisition source
                // (fza_mpd_fnc_cursorEnter); the map freezes
                if (_state getOrDefault ["caq", 0] == 1) exitWith {_state set ["caq", 0]};
                call _freeze;
                _state set ["caq", 1];
            };
        };
    };
    case 1: { // SHOW
        _this call fza_mpd_fnc_tsdShowHandleControl;
    };
    case 2: { // WPT
        _this call fza_mpd_fnc_tsdWptHandleControl;
    };
    case 3: { //RTE
        _this call fza_mpd_fnc_tsdRteHandleControl;
    };
    case 4: { // THRT
        _this call fza_mpd_fnc_tsdThrtHandleControl;
    };
    case 6: { // ZN
        _this call fza_mpd_fnc_tsdZNHandleControl;
    };
    case 5: { // PAN
        switch (_control) do {
            case "t3": {
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "t2": {
                // LAST PAN: back to where the map was last panned to
                private _last = _persistState getOrDefault ["lastPan", []];
                if (_last isNotEqualTo []) then {
                    _persistState set ["frozen", +_last];
                    _persistState set ["panRte", -1];
                };
            };
            case "b4": {
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "b5": {
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b6": {
                _state set ["subPageVarPage", TSD_THRT];
            };
            default {
                _this call fza_mpd_fnc_tsdPanHandleControl;
            };
        };
    };
};
