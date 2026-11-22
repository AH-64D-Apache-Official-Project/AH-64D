/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rfiCandidates

Description:
    Every vehicle carrying an active radar, rebuilt every ASE_RFI_REFRESH seconds. The rebuild walks the mission's
    vehicles ASE_RFI_WALK_PER_FRAME a call, so it is called every frame; the last complete list is returned meanwhile.

Parameters:
    _heli - the helicopter

Returns:
    [[vehicle, radar range m], ...]

Examples:
    [_heli] call fza_ase_fnc_rfiCandidates

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

(_heli getVariable ["fza_ah64_ase_rfiCandidates", [-1e9, []]]) params ["_builtAt", "_list"];
private _walk = _heli getVariable ["fza_ah64_ase_rfiWalk", []];
if (_walk isEqualTo [] && {CBA_missionTime - _builtAt >= ASE_RFI_REFRESH}) then {_walk = [vehicles, 0, []];};
if (_walk isEqualTo []) exitWith {_list};

_walk params ["_vehicles", "_index", "_building"];
if (isNil "fza_ase_rfiRadarRange") then {fza_ase_rfiRadarRange = createHashMap;};
private _end = (_index + ASE_RFI_WALK_PER_FRAME) min count _vehicles;
for "_i" from _index to _end - 1 do {
    private _veh = _vehicles # _i;
    if (isNull _veh || {_veh == _heli}) then {continue;};
    private _range = fza_ase_rfiRadarRange getOrDefaultCall [typeOf _veh, {
        private _max = 0;
        {
            if (getText (_x >> "componentType") == "ActiveRadarSensorComponent") then {
                _max = _max max getNumber (_x >> "AirTarget" >> "maxRange") max getNumber (_x >> "GroundTarget" >> "maxRange");
            };
        } forEach ("true" configClasses (configOf _veh >> "Components" >> "SensorsManagerComponent" >> "Components"));
        _max
    }, true];
    if (_range > 0) then {_building pushBack [_veh, _range];};
};

if (_end < count _vehicles) exitWith {
    _heli setVariable ["fza_ah64_ase_rfiWalk", [_vehicles, _end, _building]];
    _list
};
_heli setVariable ["fza_ah64_ase_rfiWalk", []];
_heli setVariable ["fza_ah64_ase_rfiCandidates", [CBA_missionTime, _building]];
_building
