/* ----------------------------------------------------------------------------
Function: fza_fnc_damageWeapon

Description:
    Destroys (removes) weapons from a pylon if it is hit.

Parameters:
    _heli - The helicopter to modify
    _system - The *HitPoint* that was damaged

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "lwing"] call fza_fnc_damageWeapon
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params ["_heli", "_system"];

if (player in _heli || local _heli) then {

    _weps = weapons _heli;
    _mags = magazines _heli;
    _rand = round(random 10);

    if (_rand > 5) then {

        if (_system == "lwing") exitwith {
            if ("fza_atas_2" in _weps) then {
                _heli removemagazines "fza_atas_2";
            };
        };

        if (_system == "rwing") exitwith {
            if ("fza_atas_2" in _weps) then {
                _heli removemagazines "fza_atas_2";
            };
        };

        //Todo : Reimplement weapons loss
    };
};