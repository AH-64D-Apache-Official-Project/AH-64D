/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_supply

Description:
    The planner's only use of ACE rearm and refuel. ACE's are used when the
    module is loaded, its functions exist and its Enabled setting is on;
    otherwise vanilla ammunition and fuel cargo. Every value ACE returns is
    checked before use, so a missing or changed ACE function gives "no
    source" rather than a script error.

Parameters:
    _action - "mode"      supply mode: 0 unlimited, 1 supply points, 2 magazines
              "isAmmo"    [source] -> is an ammunition source
              "points"    [source] -> its supply points, -1 when points aren't used
              "addPoints" [source, points] -> adds (negative takes) supply points
              "fuel"      [source] -> litres it holds, -1 unlimited, 0 none
              "drawFuel"  [source, litres] -> takes litres from it
    _args   - The action's arguments

Returns:
    As the action says

Examples:
    ["fuel", [_truck]] call fza_mplanner_fnc_supply

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params [["_action", "", [""]], ["_args", [], [[]]]];

private _aceAmmo = (missionNamespace getVariable ["ace_rearm_enabled", true]) isEqualTo true
    && {!isNil "ace_rearm_fnc_isSource"};
private _aceFuel = (missionNamespace getVariable ["ace_refuel_enabled", true]) isEqualTo true
    && {!isNil "ace_refuel_fnc_getCapacity"}
    && {!isNil "ace_refuel_fnc_getFuel"};

private _number = {
    params ["_value", "_default"];
    if (isNil "_value" || {!(_value isEqualType 0)} || {!finite _value}) exitWith {_default};
    _value
};
private _mode = {
    if (!_aceAmmo) exitWith {0};
    private _m = missionNamespace getVariable ["ace_rearm_supply", 0];
    [0, _m] select (_m in [0, 1, 2])
};
private _pointsOf = {
    params ["_src"];
    if ((call _mode) != 1 || {isNil "ace_rearm_fnc_getSupplyCount"}) exitWith {-1};
    ([[_src] call ace_rearm_fnc_getSupplyCount, 0] call _number) max 0
};
private _fuelOf = {
    params ["_src"];
    private _litres = 0;
    if (_aceFuel) then {
        private _cap = [[_src] call ace_refuel_fnc_getCapacity, 0] call _number;
        if (_cap == -10) then {_litres = -1};
        if (_cap > 0) then {_litres = ([[_src] call ace_refuel_fnc_getFuel, 0] call _number) max 0};
    } else {
        private _cap = getNumber (configOf _src >> "transportFuel");
        if (_cap > 0) then {_litres = _cap * ((getFuelCargo _src) max 0)};
    };
    _litres
};

_args params [["_src", objNull, [objNull]], ["_amount", 0, [0]]];

switch (_action) do {
    case "mode": {
        call _mode
    };
    case "isAmmo": {
        if (isNull _src || {!alive _src}) then {
            false
        } else {
            if (_aceAmmo) then {
                private _is = [_src] call ace_rearm_fnc_isSource;
                !isNil "_is" && {_is isEqualTo true}
            } else {
                getNumber (configOf _src >> "transportAmmo") > 0 && {getAmmoCargo _src > 0}
            }
        }
    };
    case "points": {
        if (isNull _src) then {-1} else {[_src] call _pointsOf}
    };
    case "addPoints": {
        if (!isNull _src && {_amount != 0} && {!isNil "ace_rearm_fnc_setSupplyCount"}) then {
            private _points = [_src] call _pointsOf;
            if (_points >= 0) then {
                [_src, (_points + _amount) max 0] call ace_rearm_fnc_setSupplyCount;
            };
        };
    };
    case "fuel": {
        if (isNull _src || {!alive _src}) then {0} else {[_src] call _fuelOf}
    };
    case "drawFuel": {
        if (!isNull _src && {_amount > 0}) then {
            private _held = [_src] call _fuelOf;
            if (_held > 0) then {
                if (_aceFuel) then {
                    if (!isNil "ace_refuel_fnc_setFuel") then {
                        [_src, (_held - _amount) max 0] call ace_refuel_fnc_setFuel;
                    };
                } else {
                    private _cap = getNumber (configOf _src >> "transportFuel");
                    if (_cap > 0) then {
                        [_src, ((_held - _amount) / _cap) max 0] remoteExecCall ["setFuelCargo", _src];
                    };
                };
            };
        };
    };
    default {nil};
};
