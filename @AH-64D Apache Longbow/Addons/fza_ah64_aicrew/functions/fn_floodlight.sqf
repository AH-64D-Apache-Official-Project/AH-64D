/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_floodlight
Description:
    handles the floodlighting control for ai
Parameters:
    Heli: Object - The helicopter to modify
Returns:
    Nothing
Examples:
    [_this] call fza_AICrew_fnc_floodlight;
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if !fza_ah64_aiFloodlight exitWith {};
if (isplayer driver _heli && isplayer gunner _heli) exitWith {};
if !(_heli getVariable "fza_systems_battBusOn") exitWith {};

private _pltFloodOn   = _heli animationSourcePhase "plt_flood";
private _cpgFloodOn   = _heli animationSourcePhase "cpg_flood";
private _driver      = driver vehicle _heli;
private _gunner      = gunner vehicle _heli;
private _isNightTime = daytime > 20.0 || daytime < 4.20;

if ((alive _driver && !isPlayer _driver)) then {
    if (_pltFloodOn == 0 && _isNightTime) then {
        [_heli, [-1], true] call fza_light_fnc_setFloodLight;
    };
    if (_pltFloodOn == 1 && !_isNightTime) then {
        [_heli, [-1], false] call fza_light_fnc_setFloodLight;
    };
};
if ((alive _gunner && !isPlayer _gunner)) then {
    if (_cpgFloodOn == 0 && _isNightTime) then {
        [_heli, [0], true] call fza_light_fnc_setFloodLight;
    };
    if (_cpgFloodOn == 1 && !_isNightTime) then {
        [_heli, [0], false] call fza_light_fnc_setFloodLight;
    };
};