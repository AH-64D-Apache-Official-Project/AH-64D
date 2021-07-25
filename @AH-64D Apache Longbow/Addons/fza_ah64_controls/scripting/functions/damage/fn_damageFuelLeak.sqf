/* ----------------------------------------------------------------------------
Function: fza_fnc_DamageFuelLeak

Description:
    handles the damage of individual fuel tanks

Parameters:
    _heli - The helicopter to modify
    _tank - the *HitPoint* that was damaged.

Returns:
    nothing

Examples:
    [vehicle player, "fwd"] spawn fza_fnc_DamageFuelLeak;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli", "_tank"];
_fuelLossPerUnitTime = 0.0003;

_hitpoint = "HitFuel";
if (_tank == "aft") then {
    _hitpoint = "HitFuel2";
};

//only 1 fuel leak
if (_heli getVariable "fza_ah64_Fuelleak" == true) exitwith {};
_heli setVariable ["fza_ah64_Fuelleak", true, true];

while {((alive _heli) && (_heli getHitPointDamage _hitpoint > 0.2) && (_heli getVariable "fza_ah64_Fuelleak"))}
do {
    private _deltaTime = "fza_ah64_deltaTime";
    _leak = _fuelLossPerUnitTime * _deltaTime;
    _heli setfuel((fuel _heli) - _fuelLossPerUnitTime);
};

_heli setVariable ["fza_ah64_Fuelleak", false, true];

/*
_dam = vehicle player getHitPointDamage "HitFuel";
hint str _dam;