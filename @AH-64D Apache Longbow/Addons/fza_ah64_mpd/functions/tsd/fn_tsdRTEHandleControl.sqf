params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _variant = _state get "subPageVarPage" select 1;

switch (_variant) do {
    case 0: {   //RTE page
        switch (_control) do {
            case "l4": {     //RTE DIR sub-page
                private _currentDir = _heli getVariable "fza_dms_routeNext";
                if (_currentDir isEqualTo []) then {
                    _state set ["subPageVarPage", TSD_RTE_DIR_NOPOINTSEL];
                } else {
                    _state set ["subPageVarPage", TSD_RTE_DIR_POINTSEL];
                }
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
        };
    };
    case 1: {   //ADD sub-page
        switch (_control) do {
            //Not implemented
        };
    };
    case 2: {   //DEL sub-page
        switch (_control) do {
            //Not implemented
        };
    };
    case 3;   //DIR no point selected sub-page
    case 4: {   //DIR point selected sub-page
        switch (_control) do {
            case "l1": {    //Select Point
                private _callBack = {
                    params ["_input", "_state", "_heli"];
                    [_heli, _input] call fza_dms_fnc_routeSetDir;
                    _state set ["subPageVarPage", TSD_RTE];
                };
                private _checker = {
                    params ["_input", "", "_heli"];
                    private _id = [_heli, _input] call fza_dms_fnc_pointParse;
                    if (_id isEqualTo []) exitWith {false};
                    private _databaseType = [_heli, _id, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue;
                    if (isNil "_databaseType") exitWith {false;};
                    [true, _id];
                };
                private _currentValue = _heli getVariable "fza_dms_routeNext";
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
        };
    };
    case 5: {   //RVW sub-page
        switch (_control) do {
            //Not implemented
        };
    };
    case 6: {   //RTM sub-page
        switch (_control) do {
            //Not implemented
        };
    };
};