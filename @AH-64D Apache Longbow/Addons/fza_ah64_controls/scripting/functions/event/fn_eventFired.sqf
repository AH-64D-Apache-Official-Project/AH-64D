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

if (player == gunner _heli|| local gunner _heli|| isNull gunner _heli) then {
    _this spawn {
        params["_heli", "_weapon", "_muzzle", "_mode", "_ammotype", "_missobj"];
        sleep 0.14;
        if ((_heli getVariable "fza_ah64_rocketsalvo") > 0 && fza_ah64_salvofired < (_heli getVariable "fza_ah64_rocketsalvo") && (_weapon isKindOf ["fza_hydra70", configFile >> "CfgWeapons"])) then {
            if (_heli ammo _weapon <= 0) then {
                fza_ah64_salvofired = 0;
            };
            _weaponindex = 0;
            _wpncounter = 0;
            {
                if (_x == _weapon) then {
                    _weaponindex = _wpncounter;
                };
                _wpncounter = _wpncounter + 1;
            } foreach (weapons _heli);
            _heli setWeaponReloadingTime[gunner _heli, _weapon, 0];
            vehicle player action["useWeapon", vehicle player, gunner vehicle player, _weaponindex];
        };
        if (fza_ah64_salvofired >= (_heli getVariable "fza_ah64_rocketsalvo")) then {
            fza_ah64_salvofired = 0;
        };
    };
};