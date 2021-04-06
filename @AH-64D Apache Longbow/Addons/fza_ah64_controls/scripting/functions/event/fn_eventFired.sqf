/* ----------------------------------------------------------------------------
Function: fza_fnc_eventFired

Description:
    Event handler that handles any ammunition fired by the apache

    - Starts custom missile guidance
    - Ensures correct number of rockets fired in salvo
    - Damages people holding on external stores if pylons fired
    - Checks for gun overheat

Parameters:
    Schema of the "fired" event handler.

Returns:
	Nothing

Examples:

Author:
	unknown
---------------------------------------------------------------------------- */
params["_heli", "_weapon", "_muzzle", "_mode", "_ammotype", "_missobj"];
_mags = magazines _heli;

if (!(player == driver _heli || player == gunner _heli)) exitwith {};
//MSL GUIDANCE STARTS HERE !

//COUNTERMEASURES

if (_weapon == "fza_CMFlareLauncher") then {
    fza_ah64_curflrln = fza_ah64_curflrln + 2;
    [] spawn {
        sleep 3;
        fza_ah64_curflrln = fza_ah64_curflrln - 2;
    }
};

//SPECIAL SCRIPTS

//Damages any outside occupants if wing stores used

if (!(_weapon == "fza_m230")) then {
    {
        _x setdamage((damage _x) + 0.05);
    }
    foreach(crew _heli - [gunner _heli, driver _heli]);
};

//OVERHEAT GUN FAULT

if (_weapon == "fza_m230" && (player == gunner _heli || local gunner _heli || isNull gunner _heli)) then {
    if (time - fza_ah64_firekeypressed > 1) then {
        fza_ah64_burst = 0;
    };
    if (fza_ah64_gunheat > 105) then {
        [_heli] call fza_fnc_damageM230;
    };
    fza_ah64_burst = fza_ah64_burst + 1;
    fza_ah64_gunheat = fza_ah64_gunheat + 1;
    fza_ah64_firekeypressed = time;
};

//ROCKETS SALVOS
/*
if (player == gunner _ah64 || local gunner _ah64 || isNull gunner _ah64) then {
    _this spawn {
        params["_ah64", "_weapon", "_muzzle", "_mode", "_ammotype", "_missobj"];
        sleep 0.011;
        if ((_ah64 getVariable "fza_ah64_rocketsalvo") > 0 
            && fza_ah64_salvofired < (_ah64 getVariable "fza_ah64_rocketsalvo")
            && (_weapon isKindOf ["fza_hydra70", configFile >> "CfgWeapons"])) then {
            if (_ah64 ammo _weapon <= 0) then {
                fza_ah64_salvofired = 0;
            };
            _weaponindex = 1;
            _wpncounter = 0; {
                if (_x == _weapon) then {
                    _weaponindex = _wpncounter;
                };
                _wpncounter = _wpncounter + 1;
            }
            foreach(weapons _ah64);
            _ah64 setWeaponReloadingTime[gunner _ah64, _weapon, 0];
            _ah64 action["useWeapon", _ah64, gunner _ah64, _weaponindex];
        };

        if (fza_ah64_salvofired >= (_ah64 getVariable "fza_ah64_rocketsalvo")) then {
            sleep 0.1;
            fza_ah64_salvofired = 0;
        };
    };
};*/