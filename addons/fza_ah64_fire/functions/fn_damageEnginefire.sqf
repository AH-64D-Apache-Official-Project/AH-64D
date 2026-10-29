/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_damageEngineFire

Description:
    damageEngineFire

Parameters:
    _heli - The helicopter to modify
    _eng - the engine that has been assigned to burn

Returns:
    Nothing

Examples:
    --- Code
    [_heli, "right"] spawn fza_fire_fnc_damageEngineFire
    ---

Author:
    Snow(dryden), Mattysmith22
---------------------------------------------------------------------------- */
#define FIRE_BOTTLE_FAIL_CHANCE 0.25
params ["_heli","_eng", ["_rolled", false]];

_rand = floor random 100;
if (!_rolled && {_rand > 1}) exitWith {};

private _componentId = "";
switch _eng do {
    case "right": {
        _componentId = "fza_ah64_e2_fire";
    };
    case "left": {
        _componentId = "fza_ah64_e1_fire";
    };
    case "apu": {
        _componentId = "fza_ah64_apu_fire";
    };
};

if (_heli getVariable _componentId) exitWith {};

_heli setVariable[_componentId, true, true];
["fza_engineFire", [_heli, _eng]] call CBA_fnc_globalEvent;

private _armVar             = ["fza_ah64_fireArmed1", "fza_ah64_fireArmed2", "fza_ah64_fireArmedApu"] select (["left", "right", "apu"] find _eng);
private _primaryFBAvailable = !(_heli getVariable "fza_ah64_firepdisch");
private _reserveFBAvailable = !(_heli getVariable "fza_ah64_firerdisch");
private _primaryFBActioned  = false;
private _reserveFBActioned  = false;

while {
    (alive _heli)
}
do {
	scopeName "fza_fireHandleScope";
    private _rand = random 10;
    private _primaryFBState = _heli getVariable "fza_ah64_firepdisch";
    private _reserveFBState = _heli getVariable "fza_ah64_firerdisch";
    private _engState  = _heli getVariable "bmkhs_engState";
    private _heliDamage = damage _heli;
    // A bottle only reaches this fire if its handle is armed when the bottle discharges, and then fails one time in four
    private _armed = (_heli getVariable _armVar) # 0;
    if (_primaryFBAvailable && _primaryFBState) then {
        _primaryFBAvailable = false;
        _primaryFBActioned  = _armed && {random 1 >= FIRE_BOTTLE_FAIL_CHANCE};
    };
    if (_reserveFBAvailable && _reserveFBState) then {
        _reserveFBAvailable = false;
        _reserveFBActioned  = _armed && {random 1 >= FIRE_BOTTLE_FAIL_CHANCE};
    };
    if (_primaryFBActioned || _reserveFBActioned) then {breakOut  "fza_fireHandleScope"};
    switch (_eng) do {
        case "left": {
            private _engineDamage  = _heli getHitPointDamage "hitengine1";
            private _eng1State = _engState select 0;
            if ((_eng1State == "off") && _rand >= 9.96) then {breakOut  "fza_fireHandleScope"};
            _heli setHitPointDamage ["hitengine1", _engineDamage + 0.001];
        };
        case "right": {
            private _engineDamage  = _heli getHitPointDamage "hitengine2";
            private _eng2State = _engState select 1;
            if ((_eng2State == "off") && _rand >= 9.96) then {breakOut  "fza_fireHandleScope"};
            _heli setHitPointDamage ["hitengine2", _engineDamage + 0.001];
        };
        case "apu": {
            private _apuOn        = _heli getVariable "bmkhs_apuOn";
            private _apuDamage    = _heli getHitPointDamage "hit_apu";
            if (!_apuOn && _rand >= 9.96) then {breakOut  "fza_fireHandleScope"};
            _heli setHitPointDamage ["hit_apu", _apuDamage + 0.001];
        };
    };
    sleep 0.1;
};

["fza_engineFireOut", [_heli, _eng]] call CBA_fnc_globalEvent;
_heli setVariable[_componentId, false, true];
