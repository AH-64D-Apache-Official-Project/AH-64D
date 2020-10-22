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
    _ammotype = "fza_agm114a_4_4";
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

        if (_system == "pylon1") exitwith {

            if ("fza_agm114a_14_8" in _mags) then {
                _ammotype = "fza_agm114a_4_4";
            };

            if ("fza_agm114c_14_8" in _mags) then {
                _ammotype = "fza_agm114c_4_4";
            };

            if ("fza_agm114l_14_8" in _mags) then {
                _ammotype = "fza_agm114l_4_4";
            };

            if ("fza_agm114k_14_8" in _mags) then {
                _ammotype = "fza_agm114k_4_4";
            };

            if ("fza_agm114m_14_8" in _mags) then {
                _ammotype = "fza_agm114m_4_4";
            };

            if ("fza_agm114n_14_8" in _mags) then {
                _ammotype = "fza_agm114n_4_4";
            };

            if (_heli hasweapon "fza_agm114_14_8") then {
                [_heli, (_heli ammo "fza_agm114_14_8"), _ammotype, "fza_agm114_4_4", "fza_agm114_14_8", "left"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_14_38" in _mags) then {
                _ammotype = "fza_m261_m151_4_19";
            };

            if ("fza_m261_m229_14_38" in _mags) then {
                _ammotype = "fza_m261_m229_4_19";
            };

            if ("fza_m261_m261_14_38" in _mags) then {
                _ammotype = "fza_m261_m261_4_19";
            };

            if ("fza_m261_m255_14_38" in _mags) then {
                _ammotype = "fza_m261_m255_4_19";
            };

            if ("fza_m261_m257_14_38" in _mags) then {
                _ammotype = "fza_m261_m257_4_19";
            };

            if (_heli hasweapon "fza_m261_14") then {
                [_heli, (_heli ammo "fza_m261_14"), _ammotype, "fza_m261_4", "fza_m261_14", "rocketsleft"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m151_4_zone1_12";
            };

            if ("fza_m261_m229_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m229_4_zone1_12";
            };

            if ("fza_m261_m261_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m261_4_zone1_12";
            };

            if ("fza_m261_m255_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m255_4_zone1_12";
            };

            if ("fza_m261_m257_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m257_4_zone1_12";
            };

            if (_heli hasweapon "fza_m261_14_zoneA") then {
                [_heli, (_heli ammo "fza_m261_14_zoneA"), _ammotype, "fza_m261_4_zone1", "fza_m261_14_zoneA", "rocketsleft"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m151_4_zone2_4";
            };

            if ("fza_m261_m229_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m229_4_zone2_4";
            };

            if ("fza_m261_m261_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m261_4_zone2_4";
            };

            if ("fza_m261_m255_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m255_4_zone2_4";
            };

            if ("fza_m261_m257_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m257_4_zone2_4";
            };

            if (_heli hasweapon "fza_m261_14_zoneB") then {
                [_heli, (_heli ammo "fza_m261_14_zoneB"), _ammotype, "fza_m261_4_zone2", "fza_m261_14_zoneB", "rocketsleft"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m151_4_zone3_3";
            };

            if ("fza_m261_m229_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m229_4_zone3_3";
            };

            if ("fza_m261_m261_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m261_4_zone3_3";
            };

            if ("fza_m261_m255_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m255_4_zone3_3";
            };

            if ("fza_m261_m257_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m257_4_zone3_3";
            };

            if (_heli hasweapon "fza_m261_14_zoneE") then {
                [_heli, (_heli ammo "fza_m261_14_zoneE"), _ammotype, "fza_m261_4_zone3", "fza_m261_14_zoneE", "rocketsleft"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            _heli removemagazines "fza_agm114a_14_8";
            _heli removemagazines "fza_agm114c_14_8";
            _heli removemagazines "fza_agm114l_14_8";
            _heli removemagazines "fza_agm114k_14_8";
            _heli removemagazines "fza_agm114m_14_8";
            _heli removemagazines "fza_agm114n_14_8";
            //
            _heli removemagazines "fza_agm114a_1_4";
            _heli removemagazines "fza_agm114a_1_ul";
            _heli removemagazines "fza_agm114a_1_ur";
            _heli removemagazines "fza_agm114a_1_ll";
            _heli removemagazines "fza_agm114a_1_lr";
            //
            _heli removemagazines "fza_agm114c_1_4";
            _heli removemagazines "fza_agm114c_1_ul";
            _heli removemagazines "fza_agm114c_1_ur";
            _heli removemagazines "fza_agm114c_1_ll";
            _heli removemagazines "fza_agm114c_1_lr";
            //
            _heli removemagazines "fza_agm114k_1_4";
            _heli removemagazines "fza_agm114k_1_ul";
            _heli removemagazines "fza_agm114k_1_ur";
            _heli removemagazines "fza_agm114k_1_ll";
            _heli removemagazines "fza_agm114k_1_lr";
            //
            _heli removemagazines "fza_agm114l_1_4";
            _heli removemagazines "fza_agm114l_1_ul";
            _heli removemagazines "fza_agm114l_1_ur";
            _heli removemagazines "fza_agm114l_1_ll";
            _heli removemagazines "fza_agm114l_1_lr";
            //
            _heli removemagazines "fza_agm114m_1_4";
            _heli removemagazines "fza_agm114m_1_ul";
            _heli removemagazines "fza_agm114m_1_ur";
            _heli removemagazines "fza_agm114m_1_ll";
            _heli removemagazines "fza_agm114m_1_lr";
            //
            _heli removemagazines "fza_agm114n_1_4";
            _heli removemagazines "fza_agm114n_1_ul";
            _heli removemagazines "fza_agm114n_1_ur";
            _heli removemagazines "fza_agm114n_1_ll";
            _heli removemagazines "fza_agm114n_1_lr";
            //
            _heli removemagazines "fza_m261_m151_14_38";
            _heli removemagazines "fza_m261_m151_14_zoneA";
            _heli removemagazines "fza_m261_m151_14_zoneB";
            _heli removemagazines "fza_m261_m151_14_zoneE";
            _heli removemagazines "fza_m261_m151_14_zone1_12";
            _heli removemagazines "fza_m261_m151_14_zone2_4";
            _heli removemagazines "fza_m261_m151_14_zone3_3";
            _heli removemagazines "fza_m261_m151_1_19";
            _heli removemagazines "fza_m261_m151_1_zone1_12";
            _heli removemagazines "fza_m261_m151_1_zone2_4";
            _heli removemagazines "fza_m261_m151_1_zone3_3";
            //
            _heli removemagazines "fza_m261_m229_14_38";
            _heli removemagazines "fza_m261_m229_14_zoneA";
            _heli removemagazines "fza_m261_m229_14_zoneB";
            _heli removemagazines "fza_m261_m229_14_zoneE";
            _heli removemagazines "fza_m261_m229_14_zone1_12";
            _heli removemagazines "fza_m261_m229_14_zone2_4";
            _heli removemagazines "fza_m261_m229_14_zone3_3";
            _heli removemagazines "fza_m261_m229_1_19";
            _heli removemagazines "fza_m261_m229_1_zone1_12";
            _heli removemagazines "fza_m261_m229_1_zone2_4";
            _heli removemagazines "fza_m261_m229_1_zone3_3";
            //
            _heli removemagazines "fza_m261_m255_14_38";
            _heli removemagazines "fza_m261_m255_14_zoneA";
            _heli removemagazines "fza_m261_m255_14_zoneB";
            _heli removemagazines "fza_m261_m255_14_zoneE";
            _heli removemagazines "fza_m261_m255_14_zone1_12";
            _heli removemagazines "fza_m261_m255_14_zone2_4";
            _heli removemagazines "fza_m261_m255_14_zone3_3";
            _heli removemagazines "fza_m261_m255_1_19";
            _heli removemagazines "fza_m261_m255_1_zone1_12";
            _heli removemagazines "fza_m261_m255_1_zone2_4";
            _heli removemagazines "fza_m261_m255_1_zone3_3";
            //
            _heli removemagazines "fza_m261_m261_14_38";
            _heli removemagazines "fza_m261_m261_14_zoneA";
            _heli removemagazines "fza_m261_m261_14_zoneB";
            _heli removemagazines "fza_m261_m261_14_zoneE";
            _heli removemagazines "fza_m261_m261_14_zone1_12";
            _heli removemagazines "fza_m261_m261_14_zone2_4";
            _heli removemagazines "fza_m261_m261_14_zone3_3";
            _heli removemagazines "fza_m261_m261_1_19";
            _heli removemagazines "fza_m261_m261_1_zone1_12";
            _heli removemagazines "fza_m261_m261_1_zone2_4";
            _heli removemagazines "fza_m261_m261_1_zone3_3";
            //
            _heli removemagazines "fza_m261_m257_14_38";
            _heli removemagazines "fza_m261_m257_14_zoneA";
            _heli removemagazines "fza_m261_m257_14_zoneB";
            _heli removemagazines "fza_m261_m257_14_zoneE";
            _heli removemagazines "fza_m261_m257_14_zone1_12";
            _heli removemagazines "fza_m261_m257_14_zone2_4";
            _heli removemagazines "fza_m261_m257_14_zone3_3";
            _heli removemagazines "fza_m261_m257_1_19";
            _heli removemagazines "fza_m261_m257_1_zone1_12";
            _heli removemagazines "fza_m261_m257_1_zone2_4";
            _heli removemagazines "fza_m261_m257_1_zone3_3";
        };

        if (_system == "pylon2") exitwith {

            if ("fza_agm114a_23_8" in _mags) then {
                _ammotype = "fza_agm114a_3_4";
            };

            if ("fza_agm114c_23_8" in _mags) then {
                _ammotype = "fza_agm114c_3_4";
            };

            if ("fza_agm114l_23_8" in _mags) then {
                _ammotype = "fza_agm114l_3_4";
            };

            if ("fza_agm114k_23_8" in _mags) then {
                _ammotype = "fza_agm114k_3_4";
            };

            if ("fza_agm114m_23_8" in _mags) then {
                _ammotype = "fza_agm114m_3_4";
            };

            if ("fza_agm114n_23_8" in _mags) then {
                _ammotype = "fza_agm114n_3_4";
            };

            if (_heli hasweapon "fza_agm114_23_8") then {
                [_heli, (_heli ammo "fza_agm114_23_8"), _ammotype, "fza_agm114_3_4", "fza_agm114_23_8", "left"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_23_38" in _mags) then {
                _ammotype = "fza_m261_m151_3_19";
            };

            if ("fza_m261_m229_23_38" in _mags) then {
                _ammotype = "fza_m261_m229_3_19";
            };

            if ("fza_m261_m261_23_38" in _mags) then {
                _ammotype = "fza_m261_m261_3_19";
            };

            if ("fza_m261_m255_23_38" in _mags) then {
                _ammotype = "fza_m261_m255_3_19";
            };

            if ("fza_m261_m257_23_38" in _mags) then {
                _ammotype = "fza_m261_m257_3_19";
            };

            if (_heli hasweapon "fza_m261_23") then {
                [_heli, (_heli ammo "fza_m261_23"), _ammotype, "fza_m261_4", "fza_m261_23", "rocketsleft"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m151_3_zone1_12";
            };

            if ("fza_m261_m229_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m229_3_zone1_12";
            };

            if ("fza_m261_m261_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m261_3_zone1_12";
            };

            if ("fza_m261_m255_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m255_3_zone1_12";
            };

            if ("fza_m261_m257_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m257_3_zone1_12";
            };

            if (_heli hasweapon "fza_m261_23_zoneC") then {
                [_heli, (_heli ammo "fza_m261_23_zoneC"), _ammotype, "fza_m261_3_zone1", "fza_m261_23_zoneC", "rocketsleft"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m151_3_zone2_4";
            };

            if ("fza_m261_m229_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m229_3_zone2_4";
            };

            if ("fza_m261_m261_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m261_3_zone2_4";
            };

            if ("fza_m261_m255_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m255_3_zone2_4";
            };

            if ("fza_m261_m257_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m257_3_zone2_4";
            };

            if (_heli hasweapon "fza_m261_23_zoneD") then {
                [_heli, (_heli ammo "fza_m261_23_zoneD"), _ammotype, "fza_m261_3_zone2", "fza_m261_23_zoneD", "rocketsleft"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m151_3_zone3_3";
            };

            if ("fza_m261_m229_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m229_3_zone3_3";
            };

            if ("fza_m261_m261_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m261_3_zone3_3";
            };

            if ("fza_m261_m255_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m255_3_zone3_3";
            };

            if ("fza_m261_m257_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m257_3_zone3_3";
            };

            if (_heli hasweapon "fza_m261_23_zoneE") then {
                [_heli, (_heli ammo "fza_m261_23_zoneE"), _ammotype, "fza_m261_3_zone3", "fza_m261_23_zoneE", "rocketsleft"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            _heli removemagazines "fza_agm114a_23_8";
            _heli removemagazines "fza_agm114c_23_8";
            _heli removemagazines "fza_agm114l_23_8";
            _heli removemagazines "fza_agm114k_23_8";
            _heli removemagazines "fza_agm114m_23_8";
            _heli removemagazines "fza_agm114n_23_8";
            //
            _heli removemagazines "fza_agm114a_2_4";
            _heli removemagazines "fza_agm114a_2_ul";
            _heli removemagazines "fza_agm114a_2_ur";
            _heli removemagazines "fza_agm114a_2_ll";
            _heli removemagazines "fza_agm114a_2_lr";
            //
            _heli removemagazines "fza_agm114c_2_4";
            _heli removemagazines "fza_agm114c_2_ul";
            _heli removemagazines "fza_agm114c_2_ur";
            _heli removemagazines "fza_agm114c_2_ll";
            _heli removemagazines "fza_agm114c_2_lr";
            //
            _heli removemagazines "fza_agm114k_2_4";
            _heli removemagazines "fza_agm114k_2_ul";
            _heli removemagazines "fza_agm114k_2_ur";
            _heli removemagazines "fza_agm114k_2_ll";
            _heli removemagazines "fza_agm114k_2_lr";
            //
            _heli removemagazines "fza_agm114l_2_4";
            _heli removemagazines "fza_agm114l_2_ul";
            _heli removemagazines "fza_agm114l_2_ur";
            _heli removemagazines "fza_agm114l_2_ll";
            _heli removemagazines "fza_agm114l_2_lr";
            //
            _heli removemagazines "fza_agm114m_2_4";
            _heli removemagazines "fza_agm114m_2_ul";
            _heli removemagazines "fza_agm114m_2_ur";
            _heli removemagazines "fza_agm114m_2_ll";
            _heli removemagazines "fza_agm114m_2_lr";
            //
            _heli removemagazines "fza_agm114n_2_4";
            _heli removemagazines "fza_agm114n_2_ul";
            _heli removemagazines "fza_agm114n_2_ur";
            _heli removemagazines "fza_agm114n_2_ll";
            _heli removemagazines "fza_agm114n_2_lr";
            //
            _heli removemagazines "fza_m261_m151_23_38";
            _heli removemagazines "fza_m261_m151_23_zoneA";
            _heli removemagazines "fza_m261_m151_23_zoneB";
            _heli removemagazines "fza_m261_m151_23_zoneE";
            _heli removemagazines "fza_m261_m151_23_zone1_12";
            _heli removemagazines "fza_m261_m151_23_zone2_4";
            _heli removemagazines "fza_m261_m151_23_zone3_3";
            _heli removemagazines "fza_m261_m151_2_19";
            _heli removemagazines "fza_m261_m151_2_zone1_12";
            _heli removemagazines "fza_m261_m151_2_zone2_4";
            _heli removemagazines "fza_m261_m151_2_zone3_3";
            //
            _heli removemagazines "fza_m261_m229_23_38";
            _heli removemagazines "fza_m261_m229_23_zoneA";
            _heli removemagazines "fza_m261_m229_23_zoneB";
            _heli removemagazines "fza_m261_m229_23_zoneE";
            _heli removemagazines "fza_m261_m229_23_zone1_12";
            _heli removemagazines "fza_m261_m229_23_zone2_4";
            _heli removemagazines "fza_m261_m229_23_zone3_3";
            _heli removemagazines "fza_m261_m229_2_19";
            _heli removemagazines "fza_m261_m229_2_zone1_12";
            _heli removemagazines "fza_m261_m229_2_zone2_4";
            _heli removemagazines "fza_m261_m229_2_zone3_3";
            //
            _heli removemagazines "fza_m261_m255_23_38";
            _heli removemagazines "fza_m261_m255_23_zoneA";
            _heli removemagazines "fza_m261_m255_23_zoneB";
            _heli removemagazines "fza_m261_m255_23_zoneE";
            _heli removemagazines "fza_m261_m255_23_zone1_12";
            _heli removemagazines "fza_m261_m255_23_zone2_4";
            _heli removemagazines "fza_m261_m255_23_zone3_3";
            _heli removemagazines "fza_m261_m255_2_19";
            _heli removemagazines "fza_m261_m255_2_zone1_12";
            _heli removemagazines "fza_m261_m255_2_zone2_4";
            _heli removemagazines "fza_m261_m255_2_zone3_3";
            //
            _heli removemagazines "fza_m261_m261_23_38";
            _heli removemagazines "fza_m261_m261_23_zoneA";
            _heli removemagazines "fza_m261_m261_23_zoneB";
            _heli removemagazines "fza_m261_m261_23_zoneE";
            _heli removemagazines "fza_m261_m261_23_zone1_12";
            _heli removemagazines "fza_m261_m261_23_zone2_4";
            _heli removemagazines "fza_m261_m261_23_zone3_3";
            _heli removemagazines "fza_m261_m261_2_19";
            _heli removemagazines "fza_m261_m261_2_zone1_12";
            _heli removemagazines "fza_m261_m261_2_zone2_4";
            _heli removemagazines "fza_m261_m261_2_zone3_3";
            //
            _heli removemagazines "fza_m261_m257_23_38";
            _heli removemagazines "fza_m261_m257_23_zoneA";
            _heli removemagazines "fza_m261_m257_23_zoneB";
            _heli removemagazines "fza_m261_m257_23_zoneE";
            _heli removemagazines "fza_m261_m257_23_zone1_12";
            _heli removemagazines "fza_m261_m257_23_zone2_4";
            _heli removemagazines "fza_m261_m257_23_zone3_3";
            _heli removemagazines "fza_m261_m257_2_19";
            _heli removemagazines "fza_m261_m257_2_zone1_12";
            _heli removemagazines "fza_m261_m257_2_zone2_4";
            _heli removemagazines "fza_m261_m257_2_zone3_3";
        };

        if (_system == "pylon3") exitwith {

            if ("fza_agm114a_23_8" in _mags) then {
                _ammotype = "fza_agm114a_2_4";
            };

            if ("fza_agm114c_23_8" in _mags) then {
                _ammotype = "fza_agm114c_2_4";
            };

            if ("fza_agm114l_23_8" in _mags) then {
                _ammotype = "fza_agm114l_2_4";
            };

            if ("fza_agm114k_23_8" in _mags) then {
                _ammotype = "fza_agm114k_2_4";
            };

            if ("fza_agm114m_23_8" in _mags) then {
                _ammotype = "fza_agm114m_2_4";
            };

            if ("fza_agm114n_23_8" in _mags) then {
                _ammotype = "fza_agm114n_2_4";
            };

            if (_heli hasweapon "fza_agm114_23_8") then {
                [_heli, (_heli ammo "fza_agm114_23_8"), _ammotype, "fza_agm114_2_4", "fza_agm114_23_8", "right"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_23_38" in _mags) then {
                _ammotype = "fza_m261_m151_2_19";
            };

            if ("fza_m261_m229_23_38" in _mags) then {
                _ammotype = "fza_m261_m229_2_19";
            };

            if ("fza_m261_m261_23_38" in _mags) then {
                _ammotype = "fza_m261_m261_2_19";
            };

            if ("fza_m261_m255_23_38" in _mags) then {
                _ammotype = "fza_m261_m255_2_19";
            };

            if ("fza_m261_m257_23_38" in _mags) then {
                _ammotype = "fza_m261_m257_2_19";
            };

            if (_heli hasweapon "fza_m261_23") then {
                [_heli, (_heli ammo "fza_m261_23"), _ammotype, "fza_m261_4", "fza_m261_23", "rocketsright"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m151_2_zone1_12";
            };

            if ("fza_m261_m229_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m229_2_zone1_12";
            };

            if ("fza_m261_m261_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m261_2_zone1_12";
            };

            if ("fza_m261_m255_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m255_2_zone1_12";
            };

            if ("fza_m261_m257_23_zoneC" in _mags) then {
                _ammotype = "fza_m261_m257_2_zone1_12";
            };

            if (_heli hasweapon "fza_m261_23_zoneC") then {
                [_heli, (_heli ammo "fza_m261_23_zoneC"), _ammotype, "fza_m261_2_zone1", "fza_m261_23_zoneC", "rocketsright"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m151_2_zone2_4";
            };

            if ("fza_m261_m229_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m229_2_zone2_4";
            };

            if ("fza_m261_m261_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m261_2_zone2_4";
            };

            if ("fza_m261_m255_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m255_2_zone2_4";
            };

            if ("fza_m261_m257_23_zoneD" in _mags) then {
                _ammotype = "fza_m261_m257_2_zone2_4";
            };

            if (_heli hasweapon "fza_m261_23_zoneD") then {
                [_heli, (_heli ammo "fza_m261_23_zoneD"), _ammotype, "fza_m261_2_zone2", "fza_m261_23_zoneD", "rocketsright"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m151_2_zone3_3";
            };

            if ("fza_m261_m229_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m229_2_zone3_3";
            };

            if ("fza_m261_m261_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m261_2_zone3_3";
            };

            if ("fza_m261_m255_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m255_2_zone3_3";
            };

            if ("fza_m261_m257_23_zoneE" in _mags) then {
                _ammotype = "fza_m261_m257_2_zone3_3";
            };

            if (_heli hasweapon "fza_m261_23_zoneE") then {
                [_heli, (_heli ammo "fza_m261_23_zoneE"), _ammotype, "fza_m261_2_zone3", "fza_m261_23_zoneE", "rocketsright"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            _heli removemagazines "fza_agm114a_23_8";
            _heli removemagazines "fza_agm114c_23_8";
            _heli removemagazines "fza_agm114l_23_8";
            _heli removemagazines "fza_agm114k_23_8";
            _heli removemagazines "fza_agm114m_23_8";
            _heli removemagazines "fza_agm114n_23_8";
            //
            _heli removemagazines "fza_agm114a_3_4";
            _heli removemagazines "fza_agm114a_3_ul";
            _heli removemagazines "fza_agm114a_3_ur";
            _heli removemagazines "fza_agm114a_3_ll";
            _heli removemagazines "fza_agm114a_3_lr";
            //
            _heli removemagazines "fza_agm114c_3_4";
            _heli removemagazines "fza_agm114c_3_ul";
            _heli removemagazines "fza_agm114c_3_ur";
            _heli removemagazines "fza_agm114c_3_ll";
            _heli removemagazines "fza_agm114c_3_lr";
            //
            _heli removemagazines "fza_agm114k_3_4";
            _heli removemagazines "fza_agm114k_3_ul";
            _heli removemagazines "fza_agm114k_3_ur";
            _heli removemagazines "fza_agm114k_3_ll";
            _heli removemagazines "fza_agm114k_3_lr";
            //
            _heli removemagazines "fza_agm114l_3_4";
            _heli removemagazines "fza_agm114l_3_ul";
            _heli removemagazines "fza_agm114l_3_ur";
            _heli removemagazines "fza_agm114l_3_ll";
            _heli removemagazines "fza_agm114l_3_lr";
            //
            _heli removemagazines "fza_agm114m_3_4";
            _heli removemagazines "fza_agm114m_3_ul";
            _heli removemagazines "fza_agm114m_3_ur";
            _heli removemagazines "fza_agm114m_3_ll";
            _heli removemagazines "fza_agm114m_3_lr";
            //
            _heli removemagazines "fza_agm114n_3_4";
            _heli removemagazines "fza_agm114n_3_ul";
            _heli removemagazines "fza_agm114n_3_ur";
            _heli removemagazines "fza_agm114n_3_ll";
            _heli removemagazines "fza_agm114n_3_lr";
            //
            _heli removemagazines "fza_m261_m151_23_38";
            _heli removemagazines "fza_m261_m151_23_zoneA";
            _heli removemagazines "fza_m261_m151_23_zoneB";
            _heli removemagazines "fza_m261_m151_23_zoneE";
            _heli removemagazines "fza_m261_m151_23_zone1_12";
            _heli removemagazines "fza_m261_m151_23_zone2_4";
            _heli removemagazines "fza_m261_m151_23_zone3_3";
            _heli removemagazines "fza_m261_m151_3_19";
            _heli removemagazines "fza_m261_m151_3_zone1_12";
            _heli removemagazines "fza_m261_m151_3_zone2_4";
            _heli removemagazines "fza_m261_m151_3_zone3_3";
            //
            _heli removemagazines "fza_m261_m229_23_38";
            _heli removemagazines "fza_m261_m229_23_zoneA";
            _heli removemagazines "fza_m261_m229_23_zoneB";
            _heli removemagazines "fza_m261_m229_23_zoneE";
            _heli removemagazines "fza_m261_m229_23_zone1_12";
            _heli removemagazines "fza_m261_m229_23_zone2_4";
            _heli removemagazines "fza_m261_m229_23_zone3_3";
            _heli removemagazines "fza_m261_m229_3_19";
            _heli removemagazines "fza_m261_m229_3_zone1_12";
            _heli removemagazines "fza_m261_m229_3_zone2_4";
            _heli removemagazines "fza_m261_m229_3_zone3_3";
            //
            _heli removemagazines "fza_m261_m255_23_38";
            _heli removemagazines "fza_m261_m255_23_zoneA";
            _heli removemagazines "fza_m261_m255_23_zoneB";
            _heli removemagazines "fza_m261_m255_23_zoneE";
            _heli removemagazines "fza_m261_m255_23_zone1_12";
            _heli removemagazines "fza_m261_m255_23_zone2_4";
            _heli removemagazines "fza_m261_m255_23_zone3_3";
            _heli removemagazines "fza_m261_m255_3_19";
            _heli removemagazines "fza_m261_m255_3_zone1_12";
            _heli removemagazines "fza_m261_m255_3_zone2_4";
            _heli removemagazines "fza_m261_m255_3_zone3_3";
            //
            _heli removemagazines "fza_m261_m261_23_38";
            _heli removemagazines "fza_m261_m261_23_zoneA";
            _heli removemagazines "fza_m261_m261_23_zoneB";
            _heli removemagazines "fza_m261_m261_23_zoneE";
            _heli removemagazines "fza_m261_m261_23_zone1_12";
            _heli removemagazines "fza_m261_m261_23_zone2_4";
            _heli removemagazines "fza_m261_m261_23_zone3_3";
            _heli removemagazines "fza_m261_m261_3_19";
            _heli removemagazines "fza_m261_m261_3_zone1_12";
            _heli removemagazines "fza_m261_m261_3_zone2_4";
            _heli removemagazines "fza_m261_m261_3_zone3_3";
            //
            _heli removemagazines "fza_m261_m257_23_38";
            _heli removemagazines "fza_m261_m257_23_zoneA";
            _heli removemagazines "fza_m261_m257_23_zoneB";
            _heli removemagazines "fza_m261_m257_23_zoneE";
            _heli removemagazines "fza_m261_m257_23_zone1_12";
            _heli removemagazines "fza_m261_m257_23_zone2_4";
            _heli removemagazines "fza_m261_m257_23_zone3_3";
            _heli removemagazines "fza_m261_m257_3_19";
            _heli removemagazines "fza_m261_m257_3_zone1_12";
            _heli removemagazines "fza_m261_m257_3_zone2_4";
            _heli removemagazines "fza_m261_m257_3_zone3_3";
        };

        if (_system == "pylon4") exitwith {

            if ("fza_agm114a_14_8" in _mags) then {
                _ammotype = "fza_agm114a_1_4";
            };

            if ("fza_agm114c_14_8" in _mags) then {
                _ammotype = "fza_agm114c_1_4";
            };

            if ("fza_agm114l_14_8" in _mags) then {
                _ammotype = "fza_agm114l_1_4";
            };

            if ("fza_agm114k_14_8" in _mags) then {
                _ammotype = "fza_agm114k_1_4";
            };

            if ("fza_agm114m_14_8" in _mags) then {
                _ammotype = "fza_agm114m_1_4";
            };

            if ("fza_agm114n_14_8" in _mags) then {
                _ammotype = "fza_agm114n_1_4";
            };

            if (_heli hasweapon "fza_agm114_14_8") then {
                [_heli, (_heli ammo "fza_agm114_14_8"), _ammotype, "fza_agm114_1_4", "fza_agm114_14_8", "right"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_14_38" in _mags) then {
                _ammotype = "fza_m261_m151_1_19";
            };

            if ("fza_m261_m229_14_38" in _mags) then {
                _ammotype = "fza_m261_m229_1_19";
            };

            if ("fza_m261_m261_14_38" in _mags) then {
                _ammotype = "fza_m261_m261_1_19";
            };

            if ("fza_m261_m255_14_38" in _mags) then {
                _ammotype = "fza_m261_m255_1_19";
            };

            if ("fza_m261_m257_14_38" in _mags) then {
                _ammotype = "fza_m261_m257_1_19";
            };

            if (_heli hasweapon "fza_m261_14") then {
                [_heli, (_heli ammo "fza_m261_14"), _ammotype, "fza_m261_1", "fza_m261_14", "rocketsright"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m151_1_zone1_12";
            };

            if ("fza_m261_m229_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m229_1_zone1_12";
            };

            if ("fza_m261_m261_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m261_1_zone1_12";
            };

            if ("fza_m261_m255_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m255_1_zone1_12";
            };

            if ("fza_m261_m257_14_zoneA" in _mags) then {
                _ammotype = "fza_m261_m257_1_zone1_12";
            };

            if (_heli hasweapon "fza_m261_14_zoneA") then {
                [_heli, (_heli ammo "fza_m261_14_zoneA"), _ammotype, "fza_m261_1_zone1", "fza_m261_14_zoneA", "rocketsright"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m151_1_zone2_4";
            };

            if ("fza_m261_m229_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m229_1_zone2_4";
            };

            if ("fza_m261_m261_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m261_1_zone2_4";
            };

            if ("fza_m261_m255_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m255_1_zone2_4";
            };

            if ("fza_m261_m257_14_zoneB" in _mags) then {
                _ammotype = "fza_m261_m257_1_zone2_4";
            };

            if (_heli hasweapon "fza_m261_14_zoneB") then {
                [_heli, (_heli ammo "fza_m261_14_zoneB"), _ammotype, "fza_m261_1_zone2", "fza_m261_14_zoneB", "rocketsright"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            if ("fza_m261_m151_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m151_1_zone3_3";
            };

            if ("fza_m261_m229_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m229_1_zone3_3";
            };

            if ("fza_m261_m261_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m261_1_zone3_3";
            };

            if ("fza_m261_m255_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m255_1_zone3_3";
            };

            if ("fza_m261_m257_14_zoneE" in _mags) then {
                _ammotype = "fza_m261_m257_1_zone3_3";
            };

            if (_heli hasweapon "fza_m261_14_zoneE") then {
                [_heli, (_heli ammo "fza_m261_14_zoneE"), _ammotype, "fza_m261_1_zone3", "fza_m261_14_zoneE", "rocketsright"] execvm "\fza_ah64_controls\scripting\damage\add_weps.sqf";
            };

            _heli removemagazines "fza_agm114a_14_8";
            _heli removemagazines "fza_agm114c_14_8";
            _heli removemagazines "fza_agm114l_14_8";
            _heli removemagazines "fza_agm114k_14_8";
            _heli removemagazines "fza_agm114m_14_8";
            _heli removemagazines "fza_agm114n_14_8";
            //
            _heli removemagazines "fza_agm114a_4_4";
            _heli removemagazines "fza_agm114a_4_ul";
            _heli removemagazines "fza_agm114a_4_ur";
            _heli removemagazines "fza_agm114a_4_ll";
            _heli removemagazines "fza_agm114a_4_lr";
            //
            _heli removemagazines "fza_agm114c_4_4";
            _heli removemagazines "fza_agm114c_4_ul";
            _heli removemagazines "fza_agm114c_4_ur";
            _heli removemagazines "fza_agm114c_4_ll";
            _heli removemagazines "fza_agm114c_4_lr";
            //
            _heli removemagazines "fza_agm114k_4_4";
            _heli removemagazines "fza_agm114k_4_ul";
            _heli removemagazines "fza_agm114k_4_ur";
            _heli removemagazines "fza_agm114k_4_ll";
            _heli removemagazines "fza_agm114k_4_lr";
            //
            _heli removemagazines "fza_agm114l_4_4";
            _heli removemagazines "fza_agm114l_4_ul";
            _heli removemagazines "fza_agm114l_4_ur";
            _heli removemagazines "fza_agm114l_4_ll";
            _heli removemagazines "fza_agm114l_4_lr";
            //
            _heli removemagazines "fza_agm114m_4_4";
            _heli removemagazines "fza_agm114m_4_ul";
            _heli removemagazines "fza_agm114m_4_ur";
            _heli removemagazines "fza_agm114m_4_ll";
            _heli removemagazines "fza_agm114m_4_lr";
            //
            _heli removemagazines "fza_agm114n_4_4";
            _heli removemagazines "fza_agm114n_4_ul";
            _heli removemagazines "fza_agm114n_4_ur";
            _heli removemagazines "fza_agm114n_4_ll";
            _heli removemagazines "fza_agm114n_4_lr";
            //
            _heli removemagazines "fza_m261_m151_14_38";
            _heli removemagazines "fza_m261_m151_14_zoneA";
            _heli removemagazines "fza_m261_m151_14_zoneB";
            _heli removemagazines "fza_m261_m151_14_zoneE";
            _heli removemagazines "fza_m261_m151_14_zone1_12";
            _heli removemagazines "fza_m261_m151_14_zone2_4";
            _heli removemagazines "fza_m261_m151_14_zone3_3";
            _heli removemagazines "fza_m261_m151_4_19";
            _heli removemagazines "fza_m261_m151_4_zone1_12";
            _heli removemagazines "fza_m261_m151_4_zone2_4";
            _heli removemagazines "fza_m261_m151_4_zone3_3";
            //
            _heli removemagazines "fza_m261_m229_14_38";
            _heli removemagazines "fza_m261_m229_14_zoneA";
            _heli removemagazines "fza_m261_m229_14_zoneB";
            _heli removemagazines "fza_m261_m229_14_zoneE";
            _heli removemagazines "fza_m261_m229_14_zone1_12";
            _heli removemagazines "fza_m261_m229_14_zone2_4";
            _heli removemagazines "fza_m261_m229_14_zone3_3";
            _heli removemagazines "fza_m261_m229_4_19";
            _heli removemagazines "fza_m261_m229_4_zone1_12";
            _heli removemagazines "fza_m261_m229_4_zone2_4";
            _heli removemagazines "fza_m261_m229_4_zone3_3";
            //
            _heli removemagazines "fza_m261_m255_14_38";
            _heli removemagazines "fza_m261_m255_14_zoneA";
            _heli removemagazines "fza_m261_m255_14_zoneB";
            _heli removemagazines "fza_m261_m255_14_zoneE";
            _heli removemagazines "fza_m261_m255_14_zone1_12";
            _heli removemagazines "fza_m261_m255_14_zone2_4";
            _heli removemagazines "fza_m261_m255_14_zone3_3";
            _heli removemagazines "fza_m261_m255_4_19";
            _heli removemagazines "fza_m261_m255_4_zone1_12";
            _heli removemagazines "fza_m261_m255_4_zone2_4";
            _heli removemagazines "fza_m261_m255_4_zone3_3";
            //
            _heli removemagazines "fza_m261_m261_14_38";
            _heli removemagazines "fza_m261_m261_14_zoneA";
            _heli removemagazines "fza_m261_m261_14_zoneB";
            _heli removemagazines "fza_m261_m261_14_zoneE";
            _heli removemagazines "fza_m261_m261_14_zone1_12";
            _heli removemagazines "fza_m261_m261_14_zone2_4";
            _heli removemagazines "fza_m261_m261_14_zone3_3";
            _heli removemagazines "fza_m261_m261_4_19";
            _heli removemagazines "fza_m261_m261_4_zone1_12";
            _heli removemagazines "fza_m261_m261_4_zone2_4";
            _heli removemagazines "fza_m261_m261_4_zone3_3";
            //
            _heli removemagazines "fza_m261_m257_14_38";
            _heli removemagazines "fza_m261_m257_14_zoneA";
            _heli removemagazines "fza_m261_m257_14_zoneB";
            _heli removemagazines "fza_m261_m257_14_zoneE";
            _heli removemagazines "fza_m261_m257_14_zone1_12";
            _heli removemagazines "fza_m261_m257_14_zone2_4";
            _heli removemagazines "fza_m261_m257_14_zone3_3";
            _heli removemagazines "fza_m261_m257_4_19";
            _heli removemagazines "fza_m261_m257_4_zone1_12";
            _heli removemagazines "fza_m261_m257_4_zone2_4";
            _heli removemagazines "fza_m261_m257_4_zone3_3";
        };

    };
};