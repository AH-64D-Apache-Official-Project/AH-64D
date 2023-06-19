params ["_heli", "_mpdIndex", "_control", "_state", "_persistStage"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

#ifdef POINTMODE_THREAT
#define POINT_CURRENTSEL "fza_mpd_tsdThrtCurrentSel"
#define INVALID_TYPE(type) (type != POINT_TYPE_TG)
#define DEFAULT_ADD_TYPE POINT_TYPE_TG
#define POINT_PAGE_ROOT TSD_THRT
#define POINT_PAGE_ADD TSD_THRT_ADD
#define POINT_PAGE_DEL_NOPOINTSEL TSD_THRT_DEL_NOPOINTSEL
#define POINT_PAGE_DEL_POINTSEL TSD_THRT_DEL_POINTSEL
#define POINT_PAGE_EDT_NOPOINTSEL TSD_THRT_EDT_NOPOINTSEL
#define POINT_PAGE_EDT_POINTSEL TSD_THRT_EDT_POINTSEL
#define POINT_PAGE_STO TSD_THRT_STO
#define POINT_PAGE_XMIT TSD_THRT_XMIT

#else //Wpt
#define POINT_CURRENTSEL "fza_mpd_tsdWptCurrentSel"
#define INVALID_TYPE(type) (type == POINT_TYPE_TG)
#define DEFAULT_ADD_TYPE POINT_TYPE_WP
#define POINT_PAGE_ROOT TSD_WPT
#define POINT_PAGE_ADD TSD_WPT_ADD
#define POINT_PAGE_DEL_NOPOINTSEL TSD_WPT_DEL_NOPOINTSEL
#define POINT_PAGE_DEL_POINTSEL TSD_WPT_DEL_POINTSEL
#define POINT_PAGE_EDT_NOPOINTSEL TSD_WPT_EDT_NOPOINTSEL
#define POINT_PAGE_EDT_POINTSEL TSD_WPT_EDT_POINTSEL
#define POINT_PAGE_STO TSD_WPT_STO
#define POINT_PAGE_XMIT TSD_WPT_XMIT

#endif

private _phase   = BOOLTONUM(_persistState get "mode" == "atk");
private _variant = _state get "subPageVarPage" select 1;
private _isThrtPage = _state get "subPageVarPage" select 0 == TSD_THRT # 0;

if (_control == "l1" && _variant == 0) exitWith {
    private _callBack = {
        params ["_input", "", "_heli"];
        _heli setVariable [POINT_CURRENTSEL, _input];
    };
    private _checker = {
        params ["_input", "", "_heli"];
        private _id = [_heli, _input] call fza_dms_fnc_pointParse;

        if (_id isEqualTo []) exitWith {false};
        _id params ["_type"];
        if (INVALID_TYPE(_type)) exitWith {false};

        private _databaseType = [_heli, _id, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue;

        if (isNil "_databaseType") exitWith {false;};

        [true, _id];
    };
    private _currentValue = _heli getVariable POINT_CURRENTSEL;
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

switch (_control) do {
    case "r1": {
        if (_showScale == -1) then {
        } else {
            _heli setVariable ["fza_ah64_rangesetting", 50000];
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), -1];
        };
    };
    case "r2": {
        if (_showScale == -1) then {
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), 1];
        } else {
            _heli setVariable ["fza_ah64_rangesetting", 25000];
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), -1];
        };
    };
    case "r3": {
        if (_showScale == -1) then {
            _persistState set ["ctr", 1 - (_persistState get "ctr")];
        } else {
            _heli setVariable ["fza_ah64_rangesetting", 10000];
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), -1];
        };
    };
    case "r4": {
        if (_showScale == -1) then {
        } else {
            _heli setVariable ["fza_ah64_rangesetting", 5000];
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), -1];
        };
    }; 
};

switch (_variant) do {
    case 0: {   //Top level TSD page
        switch (_control) do {
            case "b4": {    //WPT
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b5": {    //To RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "l2": {    //WPT > ADD
                _state set ["subPageVarPage", POINT_PAGE_ADD];
                _state set ["addType",     DEFAULT_ADD_TYPE];
            };
            case "l3": {    //WPT > DEL
                private _current = _heli getVariable POINT_CURRENTSEL;
                if (_current isEqualTo []) exitWith {_state set ["subPageVarPage", POINT_PAGE_DEL_NOPOINTSEL];};
                private _ret = [_heli, _current, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue;
                if (isNil "_ret") then {
                    _state set ["subPageVarPage", POINT_PAGE_DEL_NOPOINTSEL];
                } else {
                    _state set ["subPageVarPage", POINT_PAGE_DEL_POINTSEL];
                }
            };
            case "l4": {    //WPT > EDT
                private _current = _heli getVariable POINT_CURRENTSEL;
                if (_current isEqualTo []) then {
                    _state set ["subPageVarPage", POINT_PAGE_EDT_NOPOINTSEL];
                } else {
                    _state set ["subPageVarPage", POINT_PAGE_EDT_POINTSEL];
                };
            };
            case "l5": {    //WPT > ST
                _state set ["subPageVarPage", POINT_PAGE_STO];
            };
            /*case "l6": {    //WPT > XMIT
                _state set ["subPageVarPage", TSD_WPT_XMIT];
            };*/
        };
    };
    case 1: {   //WPT > ADD
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b5": {    //To RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "l1": {    //Add wpt
                private _checker = {
                    params ["_input", "_state"];
                    [_state get "addType", _input] call fza_dms_fnc_pointIsValidIdent;
                };
                private _callback = {
                    params ["_input", "_state"];
                    _state set ["addIdent", _input];
                    _state set ["defaultFree", ""];
                    _state set ["defaultGrid", [getPos player] call fza_dms_fnc_posToGrid];
                    _state deleteAt "defaultHeight";
                    _state set ["enterCallback", {
                        params ["_heli", "_state", "_free", "_pos", "_alt"];
                        private _nextIndex = [_heli, _state get "addType"] call fza_dms_fnc_pointNextFree;
                        copyToClipboard format ["_this %1, _nextIndex %2", _this, _nextIndex];
                        [_heli, _nextIndex
                            , _state get "addIdent"
                            , _free
                            , _pos
                            ,_alt] call fza_dms_fnc_pointCreate;
                        _heli setVariable [POINT_CURRENTSEL, _nextIndex];
                        _state set ["subPageVarPage", POINT_PAGE_ROOT];
                    }];
                    [_heli, _state] call fza_mpd_fnc_tsdWptEnterDetails;
                };
                [_heli, "IDENT", _callback, _checker, _state, "", "point add"] call fza_ku_fnc_addPrompt;
            };
            case "l2": {    //Return to WPT > ADD
                _state set ["subPageVarPage", POINT_PAGE_ROOT];
            };
            #ifndef POINTMODE_THREAT
            case "l4": {    //Set add type to WP
                _state set ["addType", POINT_TYPE_WP];
            };
            case "l5": {    //Set add type to HZ
                _state set ["addType", POINT_TYPE_HZ];
            };
            case "l6": {    //Set add type to CM
                _state set ["addType", POINT_TYPE_CM];
            };
            #endif
        };
    };
    case 2: {   //WPT > DEL no point selected
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b5": {    //To RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "l3": {    //Do not delete - "No", return to WPT page
                _state set ["subPageVarPage", POINT_PAGE_ROOT];
            };
        };
    };
    case 3: {   //WPT > DEL point selected
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT]; //TSD_ROOT  TSD_WPT_ROOT  
            };
            case "b5": {    //To RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "l2": {    //Delete - "Yes", return to WPT page
                private _current = _heli getVariable POINT_CURRENTSEL;
                [_heli, _current] call fza_dms_fnc_pointDelete;
                _state set ["subPageVarPage", POINT_PAGE_ROOT];
            };
            case "l3": {    //Do not delete - "No", return to WPT page
                _state set ["subPageVarPage", POINT_PAGE_ROOT];
            };
        };
    };
    case 4: {   //WPT > EDT no point selected
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b5": {    //To RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "l4": {    //Return to WPT page
                _state set ["subPageVarPage", POINT_PAGE_ROOT];
            };
        };
    };
    case 5: {   //WPT > EDT point selected
        switch (_control) do {
            case "l1": {
                private _current = _heli getVariable POINT_CURRENTSEL;
                private _dbRow = [_heli, _current, POINT_GET_FULL] call fza_dms_fnc_pointGetValue;
                _state set ["defaultFree", _dbRow # POINT_GET_FREE_TEXT];
                _state set ["defaultGrid", _dbRow # POINT_GET_GRID_COORD];
                _state set ["defaultHeight", _dbRow # POINT_GET_ALT_MSL];
                _state set ["enterCallback", {
                    params ["_heli", "_state", "_free", "_pos", "_alt"];
                    private _selection = _heli getVariable POINT_CURRENTSEL;
                    [_heli, _selection, POINT_SET_FREE_TEXT, _free] call fza_dms_fnc_pointEditValue;
                    [_heli, _selection, POINT_SET_ARMA_POS, _pos] call fza_dms_fnc_pointEditValue;
                    [_heli, _selection, POINT_SET_ALT_MSL, _alt] call fza_dms_fnc_pointEditValue;
                    _state set ["subPageVarPage", POINT_PAGE_ROOT];
                }];
                [_heli, _state] call fza_mpd_fnc_tsdWptEnterDetails;
            };
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b5": {    //To RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "l4": {    //Return to WPT page
                _state set ["subPageVarPage", POINT_PAGE_ROOT];
            };
        };
    };
    case 6: {   //WPT > STO page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b5": {    //To RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "l1": {    //Store current flown-over position
                private _storeTypeIsTarget = _isThrtPage && _persistState get "mode" == "atk";
                private _storeType = [POINT_TYPE_WP, POINT_TYPE_TG] select _storeTypeIsTarget;
                private _storeIdent = ["WP", "TG"] select _storeTypeIsTarget;

                private _nextIndex = [_heli, _storeType] call fza_dms_fnc_pointNextFree;
                [_heli, _nextIndex, _storeIdent, _storeIdent, getPos _heli, getTerrainHeightASL getPos _heli max 0] call fza_dms_fnc_pointCreate;
                _heli setVariable [POINT_CURRENTSEL, _nextIndex];
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l5": {    //Return to WPT page
                _state set ["subPageVarPage", POINT_PAGE_ROOT];
            };
        };
    };
    case 7: {   //WPT > XMIT page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b5": {    //To RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
            case "r6": {    //Temporary, will allow user to input point via KU, will return you to the WPT page
                _state set ["subPageVarPage", POINT_PAGE_ROOT];
            };
            case "l6": {    //Return to WPT page
                _state set ["subPageVarPage", POINT_PAGE_ROOT];
            };
        };
    };
};