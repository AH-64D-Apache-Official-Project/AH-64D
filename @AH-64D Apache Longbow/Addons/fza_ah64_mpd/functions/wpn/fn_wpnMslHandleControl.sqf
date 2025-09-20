params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

if (_this call fza_mpd_fnc_WpnTrajHandleControl) exitwith {};

switch (_control) do {
    case "l1": {
        //Switch missile lase
        [_heli] call fza_fnc_controlHandlelaserchange;
    };
    case "r1": {
        [_heli] call fza_weapons_fnc_MissileCycle
    };
};

switch (_state get "variant") do {
    case 0: { // Root variant
        switch (_control) do {
            case "l1": {
                //Set primary channel
                _state set ["variant", 1];
            };
            case "l2": {
                //Set alternate channel
                if (_heli getVariable "fza_ah64_laserMissilePrimaryCode" != -1) then {
                    _state set ["variant", 2];
                }
            };
        };
    };
    case 1: { // Primary channel set
        private _keyMapping = createHashMapFromArray [["l1", 0], ["l2", 1], ["l3", 2], ["l4", 3], ["l5", -1]];
        private _chanSelected = _keyMapping get _control;

        if !(isNil "_chanSelected") then {
            if (_chanSelected == -1) then {
                    [_heli, "fza_ah64_laserMissilePrimaryCode", -1] call fza_fnc_updateNetworkGlobal;
                    [_heli, "fza_ah64_laserMissileAlternateCode", -1] call fza_fnc_updateNetworkGlobal;
            } else {
                private _alt = _heli getVariable "fza_ah64_laserMissileAlternateCode";
                if (_chanSelected == _alt) then {
                    private _pri = _heli getVariable "fza_ah64_laserMissilePrimaryCode";
                    [_heli, "fza_ah64_laserMissileAlternateCode", _pri] call fza_fnc_updateNetworkGlobal;
                };
                [_heli, "fza_ah64_laserMissilePrimaryCode", _chanSelected] call fza_fnc_updateNetworkGlobal;
            };
            _state set ["variant", 0];
        };
    };
    case 2: { // Alternate channel set
        private _keyMapping = createHashMapFromArray [["l1", 0], ["l2", 1], ["l3", 2], ["l4", 3], ["l5", -1]];
        private _chanSelected = _keyMapping get _control;

        if !(isNil "_chanSelected") then {
            if (_chanSelected == -1) then {
                [_heli, "fza_ah64_laserMissileAlternateCode", -1] call fza_fnc_updateNetworkGlobal;
            } else {
                private _pri = _heli getVariable "fza_ah64_laserMissilePrimaryCode";
                if (_chanSelected == _pri) then {
                    private _alt = _heli getVariable "fza_ah64_laserMissileAlternateCode";
                    private _newPri = [0,1] select (_chanSelected == 0);
                    [_heli, "fza_ah64_laserMissilePrimaryCode", _newPri] call fza_fnc_updateNetworkGlobal;
                };
                [_heli, "fza_ah64_laserMissileAlternateCode", _chanSelected] call fza_fnc_updateNetworkGlobal;
            };
            _state set ["variant", 0];
        };
    };
};