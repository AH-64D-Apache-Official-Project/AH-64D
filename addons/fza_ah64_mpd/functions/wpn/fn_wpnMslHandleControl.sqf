params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"

// The MODE pop-out open: R1-R3 select this crew station's NORM / MAN / RIPL and close it
if ((_state get "popOutMenu") == 2 && {_control in ["r1", "r2", "r3"]}) exitWith {
    private _seat = [_heli] call fza_fnc_getSeat;
    if (!isNil "_seat") then {
        _heli setVariable ["fza_ah64_mslMode_" + _seat, MSL_MODES select (["r1", "r2", "r3"] find _control), true];
    };
    _state set ["popOutMenu", 0];
};

if (_this call fza_mpd_fnc_WpnTrajHandleControl) exitWith {};

// RF: L1-L3 are the MSL PWR selection ALL / AUTO / NONE (fza_hellfire_fnc_rfPowerUpdate)
if ((_heli getVariable ["fza_ah64_selectedMissile", ""]) == "fza_agm114l_wep" && {_control in ["l1", "l2", "l3"]}) exitWith {
    [_heli, "fza_ah64_mslPwr", [MSL_PWR_ALL, MSL_PWR_AUTO, MSL_PWR_NONE] select (["l1", "l2", "l3"] find _control)] call fza_fnc_updateNetworkGlobal;
};

switch (_control) do {
    case "l1": {
        //Switch missile lase
        [_heli] call fza_fnc_controlHandlelaserchange;
    };
    case "r2": {
        // MODE opens the MODE pop-out (fza_fnc_weaponMissileAdvance)
        _state set ["popOutMenu", 2];
    };
    case "r1": {
        if (([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_FCR) then {
            [_heli] call fza_fnc_weaponMissileCycleType;
        };
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
            case "l3": {
                if (([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) != SIGHT_FCR) then {
                    [_heli] call fza_fnc_weaponMissileCycleTypeSal;
                };
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
                    private _newPri = BOOLTONUM(_chanSelected == 0);
                    [_heli, "fza_ah64_laserMissilePrimaryCode", _newPri] call fza_fnc_updateNetworkGlobal;
                };
                [_heli, "fza_ah64_laserMissileAlternateCode", _chanSelected] call fza_fnc_updateNetworkGlobal;
            };
            _state set ["variant", 0];
        };
    };
};
