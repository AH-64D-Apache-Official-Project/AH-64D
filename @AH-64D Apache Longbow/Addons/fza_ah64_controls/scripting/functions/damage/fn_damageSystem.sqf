/* ----------------------------------------------------------------------------
Function: fza_fnc_damageSystem

Description:
    Handles general damage to the aircraft. Determines whether a failure should be simulated and if so, sets it up.

Parameters:
    _heli - The helicopter to modify
    _system - The *HitPoint* that was damaged
    _damage - The damage amount of the *HitPoint* (0-1)

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_damageSystem
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params["_heli", "_system", "_damage"];
if(!alive _heli) exitwith {};
if (surfaceiswater getPos _heli && getposatl _heli # 2 < 0) exitWith {};
_oldDam = _heli getHit _system;
_usesound = false;

if (player == driver _heli || player == gunner _heli) then {
    _usesound = true;
};

if (!(alive _heli)) exitwith {
    false
};
//set damage so event init dosent reset
_damheli= 0.001 + damage _heli;
_heli setDamage _damheli;

if (_system == "mala vrtule") then {
    if (_usesound && _oldDam < 0.4 && _damage >= 0.4) then {
        ["fza_ah64_tail_rotor_damaged_1", 3] spawn fza_fnc_playAudio;
    };
};

if (_system == "velka vrtule") then {
    if (_usesound && _oldDam < 0.4 && _damage >= 0.4) then {
        ["fza_ah64_main_rotor_damaged_1", 4] spawn fza_fnc_playAudio;
    };
    if (_usesound && _oldDam < 0.8 && _damage >= 0.8) then {
        ["fza_ah64_main_rotor_failure_1", 4] spawn fza_fnc_playAudio;
    };
};

if (_system == "pnvs") then {
    if (_usesound && _oldDam < 0.8 && _damage >= 0.8) then {
        ["fza_ah64_pnvs_fail_1", 3] spawn fza_fnc_playAudio;
    };
};

if (_system == "otocvez") then {
    if (_usesound && _oldDam < 0.8 && _damage >= 0.8) then {
        ["fza_ah64_bt_gun", 0.5, "fza_ah64_bt_actuator", 1, "fza_ah64_bt_failure", 1] spawn fza_fnc_playAudio;
        _heli removemagazine "fza_m230_1200";
        _heli removemagazine "fza_m230_300";
    };
};

if (_system == "trans") then {
    if (_damage == 0 && _oldDam != 0) then {
        _heli setVariable ["fza_ah64_apu_fire", false, true];
    };
    if (_oldDam < 0.4 && _damage >= 0.4 && _heli animationphase "plt_apu" == 1) then {
        [_heli, "apu"] execvm "\fza_ah64_controls\scripting\damage\enginefire.sqf";
    };
};
/*
if (_system == "lfuel") then {
    if (_damage >= 0.5) then {
        _rand = round(random 5);
        if (_rand == 5) then {
            [_heli, "fwd"] spawn fza_fnc_DamageFuelLeak;
        };
    };
};
if (_system == "rfuel") then {
    if (_damage >= 0.5) then {
        _rand = round(random 5);
        if (_rand > 6) then {
            [_heli, "aft"] spawn fza_fnc_DamageFuelLeak;
        };
    };
};
*/
if (_system == "leng") then {
    if (_damage == 0 && _oldDam != 0) then {
        _heli setVariable ["fza_ah64_firepdisch", false, true];
        _heli setVariable ["fza_ah64_e1_fire", false, true];
    };
    if (_damage >= 0.4) then {
        [_heli, "left"] execvm "\fza_ah64_controls\scripting\damage\enginefire.sqf";
    };
};

if (_system == "reng") then {
    if (_damage == 0 && _oldDam != 0) then {
        _heli setVariable ["fza_ah64_firerdisch", false, true];
        _heli setVariable ["fza_ah64_e2_fire", false, true];
    };
    if (_damage >= 0.4) then {
        [_heli, "right"] execvm "\fza_ah64_controls\scripting\damage\enginefire.sqf";
    };
};