params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _variant      = _state get "subPageVarPage" select 1;
private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
private _routeInfo    = _routeData # _routeCurrent;

private _addRoutePoint = {
    params ["_heli", "_btnIndex"];
    private _routePoint = _heli getVariable "fza_mpd_tsdRteCurrentSel";
    if (isNil "_routePoint") exitWith {};
    private _rteIndex = _heli getVariable "fza_ah64_routeCurPnt";
    private _index    = ((_state get "routeScroll") + _btnIndex);
    private _dataType = [_heli, _routePoint, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue;
    private _dmsNext  = (_heli getVariable "fza_dms_routeNext")#0;
    if ((count _routeInfo) < _index) exitWith {};
    if (isNil "_dataType") exitWith {};
    _routeInfo insert [_index, [_routePoint]];
    _routeData set [_routeCurrent, _routeInfo];
    if (_dmsNext isEqualTo []) then {
        [_heli, _routePoint] call fza_dms_fnc_routeSetDir;
        _heli setVariable ["fza_ah64_routeCurPnt", _index, true];
    };
    if (_index <= _rteIndex && _rteIndex != -1) then {
        _heli setVariable ["fza_ah64_routeCurPnt", (_rteIndex + 1), true];
    };
};

private _delRoutePoint = {
    params ["_heli", "_btnIndex"];
    private _rteIndex = _heli getVariable "fza_ah64_routeCurPnt";
    private _index = ((_state get "routeScroll") + _btnIndex);
    private _routePoint = _routeInfo#_index;
    if ((count _routeInfo) <= _index) exitWith {};
    _routeInfo deleteAt _index;
    _routeData set [_routeCurrent, _routeInfo];
    if (_rteIndex == _index) then {
        _heli setVariable ["fza_ah64_routeCurPnt", -1, true];
    };
    if (_index < _rteIndex && _rteIndex != -1) then {
        _heli setVariable ["fza_ah64_routeCurPnt", (_rteIndex - 1), true];
    };
    private _wptAprch = _heli getvariable "fza_ah64_wptAprch";
    if (_routePoint isEqualTo _wptAprch#0) then {
        [_heli, "fza_ah64_wptAprch", [-1, false]] call fza_fnc_updateNetworkGlobal;
    };
};

private _setRouteDir = {
    params ["_heli", "_btnIndex"];
    private _index = ((_state get "routeScroll") + _btnIndex);
    if ((count _routeInfo) <= _index) exitWith {};
    private _routePoint = _routeInfo#_index;
    [_heli, _routePoint, true] call fza_dms_fnc_routeSetDir;
    _heli setVariable ["fza_ah64_routeCurPnt", _index, true];
};


private _selRvwPnt = {
    params ["_heli", "_btnIndex"];
    private _rvwIndex = _heli getVariable "fza_mpd_tsdRteCurrentRvw";
    private _index = ((_state get "routeScroll") + _btnIndex);
    if ((count _routeInfo) <= _index) exitWith {};
    if (_rvwIndex == _index) exitwith {
        _heli setVariable ["fza_mpd_tsdRteCurrentRvw", -1, true];
    };
    _heli setVariable ["fza_mpd_tsdRteCurrentRvw", _index, true];
};

switch (_variant) do {
    case 0: {   //RTE page
        switch (_control) do {
            case "l2": {     //RTE ADD sub-page
                private _currentPoint = (_heli getVariable "fza_dms_routeNext")#0;
                if (_currentPoint isEqualTo []) then {
                    _state set ["subPageVarPage", TSD_RTE_ADD_NOPOINTSEL];
                } else {
                    _state set ["subPageVarPage", TSD_RTE_ADD_POINTSEL];
                };
            };
            case "l3": {     //RTE DEL sub-page
                _state set ["subPageVarPage", TSD_RTE_DEL];
            };
            case "l4": {     //RTE DIR sub-page
                private _currentDir = (_heli getVariable "fza_dms_routeNext")#0;
                if (_currentDir isEqualTo []) then {
                    _state set ["subPageVarPage", TSD_RTE_DIR_NOPOINTSEL];
                } else {
                    _state set ["subPageVarPage", TSD_RTE_DIR_POINTSEL];
                }
            };
            case "l5": {     //RVW sub-page
                _state set ["subPageVarPage", TSD_RTE_RVW];
            };
            case "b4": {    //To WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "b5": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "r1": {    //Scroll up
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") + 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
            case "r6": {    //Scroll down
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") - 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
        };
    };
    case 1;
    case 2: {   //ADD  point selected sub-page
        switch (_control) do {
            case "l1": {    //Select Point
                private _callBack = {
                    params ["_input", "_state", "_heli"];
                    _heli setVariable ["fza_mpd_tsdRteCurrentSel", _input];
                    _state set ["subPageVarPage", TSD_RTE_ADD_POINTSEL];
                };
                private _checker = {
                    params ["_input", "", "_heli"];
                    private _id = [_heli, _input] call fza_dms_fnc_pointParse;
                    if (_id isEqualTo []) exitWith {false};
                    private _databaseType = [_heli, _id, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue;
                    if (isNil "_databaseType") exitWith {false;};
                    if (_databaseType > 2) exitWith {false;};
                    [true, _id];
                };
                private _currentValue = _heli getVariable "fza_mpd_tsdRteCurrentSel";
                private _startValue = ["", _currentValue call fza_dms_fnc_pointToString] select (_currentValue isNotEqualTo []);
                [_heli, "POINT", _callback, _checker, _state, _startValue] call fza_ku_fnc_addPrompt;
            };
            case "l2": {     //Return to RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b4": {    //To WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "b5": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "r2": {
                [_heli, 3] call _addRoutePoint;
            };
            case "r3": {
                [_heli, 2] call _addRoutePoint;
            };
            case "r4": {
                [_heli, 1] call _addRoutePoint;
            };
            case "r5": {
                [_heli, 0] call _addRoutePoint;
            };
            case "r1": {    //Scroll up
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") + 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
            case "r6": {    //Scroll down
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") - 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
        };
    };
    case 3: {   //DEL sub-page
        switch (_control) do {
            case "l3": {     //Return to RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b4": {    //To WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "b5": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "r2": {
                [_heli, 3] call _delRoutePoint;
            };
            case "r3": {
                [_heli, 2] call _delRoutePoint;
            };
            case "r4": {
                [_heli, 1] call _delRoutePoint;
            };
            case "r5": {
                [_heli, 0] call _delRoutePoint;
            };
            case "r1": {    //Scroll up
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") + 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
            case "r6": {    //Scroll down
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") - 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
        };
    };
    case 4;   //DIR no point selected sub-page
    case 5: {   //DIR point selected sub-page
        switch (_control) do {
            case "l1": {    //Select Point
                private _callBack = {
                    params ["_input", "_state", "_heli"];
                    [_heli, _input, true] call fza_dms_fnc_routeSetDir;
                    _heli setVariable ["fza_ah64_routeCurPnt", -1, true];
                    _state set ["subPageVarPage", TSD_RTE];
                };
                private _checker = {
                    params ["_input", "", "_heli"];
                    private _id = [_heli, _input] call fza_dms_fnc_pointParse;
                    if (_id isEqualTo []) exitWith {false};
                    private _databaseType = [_heli, _id, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue;
                    if (isNil "_databaseType") exitWith {false;};
                    if (_databaseType > 2) exitWith {false;};
                    [true, _id];
                };
                private _currentValue = (_heli getVariable "fza_dms_routeNext")#0;
                private _startValue = ["", _currentValue call fza_dms_fnc_pointToString] select (_currentValue isNotEqualTo []);
                [_heli, "POINT", _callback, _checker, _state, _startValue] call fza_ku_fnc_addPrompt;
            };
            case "l4": {     //Return to RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b4": {    //To WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "b5": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "r2": {
                [_heli, 3] call _setRouteDir;
            };
            case "r3": {
                [_heli, 2] call _setRouteDir;
            };
            case "r4": {
                [_heli, 1] call _setRouteDir;
            };
            case "r5": {
                [_heli, 0] call _setRouteDir;
            };
            case "r1": {    //Scroll up
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") + 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
            case "r6": {    //Scroll down
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") - 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
        };
    };
    case 6: {   //RVW sub-page
        switch (_control) do {
            case "l5": {     //RVW sub-page
                _state set ["subPageVarPage", TSD_RTE];
                _heli setVariable ["fza_mpd_tsdRteCurrentRvw", -1];
            };
            case "r2": {
                [_heli, 3] call _selRvwPnt;
            };
            case "r3": {
                [_heli, 2] call _selRvwPnt;
            };
            case "r4": {
                [_heli, 1] call _selRvwPnt;
            };
            case "r5": {
                [_heli, 0] call _selRvwPnt;
            };
            case "r1": {    //Scroll up
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") + 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
            case "r6": {    //Scroll down
                private _upper = if (count _routeInfo > 3) then {(count _routeInfo - 3);} else {0;};
                private _scrollV = [(_state get "routeScroll") - 1, 0, _upper] call BIS_fnc_clamp;
                _state set ["routeScroll", _scrollV];
            };
        };
    };
    case 7: {   //RTM sub-page
        switch (_control) do {
            //Not implemented
        };
    };
};