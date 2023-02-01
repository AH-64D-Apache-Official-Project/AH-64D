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

if (_system == "pnvs") then {
    if (_usesound && _oldDam < 0.8 && _damage >= 0.8) then {
        //Mastercaution here
    };
};

if (_system == "otocvez") then {
    if (_usesound && _oldDam < 0.8 && _damage >= 0.8) then {
        //Mastercaution here
        _heli setAmmo ["fza_m230", 0];
    };
};

if (_system == "trans") then {
    if (_damage >= 0.4) then {
        [_heli, "apu"] spawn fza_fnc_damageEngineFire;
    };
};
if (_system == "leng") then {
    if (_damage >= 0.4) then {
        [_heli, "left"] spawn fza_fnc_damageEngineFire;
    };
};

if (_system == "reng") then {
    if (_damage >= 0.4) then {
        [_heli, "right"] spawn fza_fnc_damageEngineFire;
    };
};