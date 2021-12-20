params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _phase = BOOLTONUM(_heli getVariable "fza_mpd_tsdMode" == "atk");
private _variant = _state get "subPageVarPage" select 1;

if (_control == "l1" && _variant != 1) exitWith {    //Temporary, will allow user to input point via KU, will return you to the WPT page
    private _callBack = {
        params ["_input", "", "_heli"];
        _heli setVariable ["fza_mpd_tsdWptCurrentSel", _input];
    };
    private _checker = {
        params ["_input", "", "_heli"];
        private _ret = [_heli, _input] call fza_dms_fnc_pointParse;

        if (_id isEqualTo []) exitWith {false};
        _id params ["_type"];
        if (_type == POINT_TYPE_TG) exitWith {false};

        private _databaseType = [_heli, _id, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue;

        if (isNil "_databaseType") exitWith {false;};

        [true, _id];
    };
    private _currentValue = _heli getVariable "fza_mpd_tsdWptCurrentSel";
    private _startValue = ["", _currentValue call fza_dms_fnc_pointToString] select (_currentValue isNotEqualTo []);
    [_heli, "POINT", _callback, _checker, _state, _startValue, "point select"] call fza_ku_fnc_addPrompt;
};
/*
1. TSD - Select
2. WPT - Select
3. Add - Select
4. Choose type - WP (def), HZ, CM
5. L1 Point select & input data via KU
*/
switch (_variant) do {
    case 0: {   //Top level TSD page
        switch (_control) do {
            case "b4": {    //WPT
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "l2": {    //WPT > ADD
                _state set ["subPageVarPage", TSD_WPT_ADD];
                _state set ["wptAddType", POINT_TYPE_WP];
            };
            case "l3": {    //WPT > DEL
                private _current = _heli getVariable "fza_mpd_tsdWptCurrentSel";
                if (_current isEqualTo []) exitWith {_state set ["subPageVarPage", TSD_WPT_DEL_NOPOINTSEL];};
                private _ret = [_heli, _current, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue;
                if (isNil "_ret") then {
                    _state set ["subPageVarPage", TSD_WPT_DEL_NOPOINTSEL];
                } else {
                    _state set ["subPageVarPage", TSD_WPT_DEL_POINTSEL];
                }
            };
            case "l4": {    //WPT > EDT
                private _current = _heli getVariable "fza_mpd_tsdWptCurrentSel";
                if (_current isNotEqualTo []) then {_state set ["subPageVarPage", TSD_WPT_EDT_NOPOINTSEL];};
                private _ret = [_heli, _current, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue;
                if (isNil "_ret") then {
                    _state set ["subPageVarPage", TSD_WPT_EDT_NOPOINTSEL];
                } else {
                    _state set ["subPageVarPage", TSD_WPT_EDT_POINTSEL];
                    private _dbRow = [_heli, _current, POINT_GET_FULL] call fza_dms_fnc_pointGetValue;
                    _state set ["wptDefaultFree", _dbRow # POINT_GET_FREE_TEXT];
                    _state set ["wptDefaultGrid", _dbRow # POINT_GET_GRID_COORD];
                    _state set ["wptDefaultHeight", _dbRow # POINT_GET_ALT_MSL];
                    _state set ["wptEnterCallback", {
                        params ["_heli", "_state", "_free", "_pos", "_alt"];
                        private _selection = _heli getVariable "fza_mpd_tsdWptCurrentSel";
                        [_heli, _selection, POINT_SET_FREE_TEXT, _free] call fza_dms_fnc_pointEditValue;
                        [_heli, _selection, POINT_SET_ARMA_POS, _pos] call fza_dms_fnc_pointEditValue;
                        [_heli, _selection, POINT_SET_ALT_MSL, _alt] call fza_dms_fnc_pointEditValue;
                        _state set ["subPageVarPage", TSD_WPT];
                    }];
                    [_heli, _state] call fza_mpd_fnc_tsdWptEnterDetails;
                };
            };
            case "l5": {    //WPT > STO
                _state set ["subPageVarPage", TSD_WPT_STO];
            };
            case "l6": {    //WPT > XMIT
                _state set ["subPageVarPage", TSD_WPT_XMIT];
            };
        };
    };
    case 1: {   //WPT > ADD
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l1": {    //Add wpt
                private _checker = {
                    params ["_input", "_state"];
                    [_state get "wptAddType", _input] call fza_dms_fnc_pointIsValidIdent;
                };
                private _callback = {
                    params ["_input", "_state"];
                    _state set ["wptAddIdent", _input];
                    _state set ["wptDefaultFree", ""];
                    _state set ["wptDefaultGrid", [getPos player] call fza_dms_fnc_posToGrid];
                    _state deleteAt "wptDefaultHeight";
                    _state set ["wptEnterCallback", {
                        params ["_heli", "_state", "_free", "_pos", "_alt"];
                        private _nextIndex = [_heli, _state get "wptAddType"] call fza_dms_fnc_pointNextFree;
                        [_heli, _nextIndex
                            , _state get "wptAddIdent"
                            , _free
                            , _pos
                            ,_alt] call fza_dms_fnc_pointCreate;
                        _heli setVariable ["fza_mpd_tsdWptCurrentSel", _nextIndex];
                        _state set ["subPageVarPage", TSD_WPT];
                    }];
                    [_heli, _state] call fza_mpd_fnc_tsdWptEnterDetails;
                };
                [_heli, "IDENT", _callback, _checker, _state, "", "point add"] call fza_ku_fnc_addPrompt;
            };
            case "l2": {    //Return to WPT > ADD
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "l3": {    //Set add type to WP
                _state set ["wptAddType", POINT_TYPE_WP];
            };
            case "l4": {    //Set add type to HZ
                _state set ["wptAddType", POINT_TYPE_HZ];
            };
            case "l5": {    //Set add type to CM
                _state set ["wptAddType", POINT_TYPE_CM];
            };
        }
    };
    case 2: {   //WPT > DEL no point selected
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l3": {    //Do not delete - "No", return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
    case 3: {   //WPT > DEL point selected
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT]; //TSD_ROOT  TSD_WPT_ROOT  
            };
            case "l3": {    //Do not delete - "No", return to WPT page
                private _current = _heli getVariable "fza_mpd_tsdWptCurrentSel";
                [_heli, _current] call fza_dms_fnc_pointDelete;
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "l4": {    //Do not delete - "No", return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
    case 4: {   //WPT > EDT page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l4": {    //Return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
    case 5: {   //WPT > EDT page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l4": {    //Return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
    case 6: {   //WPT > STO page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l5": {    //Return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
    case 7: {   //WPT > XMIT page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "r6": {    //Temporary, will allow user to input point via KU, will return you to the WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "l6": {    //Return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
};