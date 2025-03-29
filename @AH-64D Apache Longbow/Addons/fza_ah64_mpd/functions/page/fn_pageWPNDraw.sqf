#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_mpdIndex", "_state"];

private _armed      = _heli getVariable "fza_ah64_armSafeArmed";
private _chaffState = BOOLTONUM(_heli getVariable "fza_ah64_ase_chaffState" == ASE_CHAFF_STATE_ARM);

[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_MASTER_ARM), BOOLTONUM(_armed)] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_CHAFF_ARM), _chaffState] call fza_mpd_fnc_updateMfdValue;

[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_HF), 0] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_RKT), 0] call fza_mpd_fnc_updateMfdValue;

//Set the weapon state
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_WAS), 0] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_WPN), 0] call fza_mpd_fnc_updateMfdValue;

//Chaff + Flares
private _chaffCount = 0;
private _flareCount= 0;
{
    _x params ["_className", "_turretPath", "_ammoCount"];
    if (_className == "fza_chaff_30_mag" && _turretPath isEqualTo [-1]) then {
        _chaffCount = _chaffCount + _ammoCount;
    };
    if (_className == "fza_flare_30_mag" && _turretPath isEqualTo [-1]) then {
        _flareCount= _flareCount+ _ammoCount;
    };
} forEach magazinesAllTurrets _heli;

if (_heli animationPhase "msn_equip_british" == 1) then {
    [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_CMS_QTY), (str (_chaffCount/2)) + "/" + str _FlareCount] call fza_mpd_fnc_updateMfdText;
} else {
    [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_CMS_QTY), (str (_chaffCount/2))] call fza_mpd_fnc_updateMfdText;
};

//Mission equipment 
_msn_equip_British = _heli animationPhase "msn_equip_british";
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_CMS_MODE_TYPE), _msn_equip_British] call fza_mpd_fnc_updateMfdValue;

//GUN AMMO
private _gunAmmo = _heli ammo "fza_m230";
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_GUN_ROUNDS), _gunAmmo toFixed 0] call fza_mpd_fnc_updateMfdText;

//GUN FAILED
private _gunDamage     = (_heli getHitPointDamage "hit_msnEquip_gun_turret" > SYS_WPN_DMG_THRESH);
private _magDamage     = (_heli getHitPointDamage "hit_msnEquip_magandrobbie" > SYS_WPN_DMG_THRESH && _heli animationPhase "magazine_set_1200" == 1);
private _utilLevelMin  = (_heli getVariable "fza_systems_utilLevel_pct" < SYS_HYD_MIN_LVL);
private _utilHydFailed = (_heli getVariable "fza_systems_utilHydPSI" < SYS_MIN_HYD_PSI);
private _acBusOn       = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn       = _heli getVariable "fza_systems_dcBusOn";
private _gunFailed     = (_utilHydFailed || _utilLevelMin || _gunDamage || !_acBusOn || !_dcBusOn || _magDamage);
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_CANNON_FAILURE), BOOLTONUM(_gunFailed)] call fza_mpd_fnc_updateMfdValue;

//pylon SERVO Failure
private _pylonFailure = [];
/*
for "_i" from 1 to 4 do {
    private _pylonDamage = _heli getHitPointDamage ("hit_msnEquip_pylon" + str _i);
    if (_pylonDamage >= SYS_WPN_DMG_THRESH || _utilHydFailed || _utilLevelMin) then {
        _pylonFailure pushback _i;
    };
};*/
if (_utilHydFailed || _utilLevelMin) then {
    _pylonFailure = [1,2,3,4];
};

[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_PYLON_1_4_FAILURE), ([0, 1] select (1 in _pylonFailure))+([0, 2] select (4 in _pylonFailure))] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_PYLON_2_3_FAILURE), ([0, 1] select (2 in _pylonFailure))+([0, 2] select (3 in _pylonFailure))] call fza_mpd_fnc_updateMfdValue;

// SIGHT AND ACQ SOURCES
private _sight = "TADS";

switch ([_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable) do {
    case 0: {
        _sight = "FCR"
    };
    case 1: {
        _sight = "HMD";
    };
    case 2: {
        _sight = "TADS";
    };
    case 3: {
        _sight = "FXD";
    };
};
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_SIGHT), _sight] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_LRFD_CODE), _heli getVariable "fza_ah64_laserLRFDCode"] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_LST_CODE), _heli getVariable "fza_ah64_laserLSTCode"] call fza_mpd_fnc_updateMfdText;

[_heli, _mpdIndex, MFD_IND_WPN_ACQ_BOX, MFD_TEXT_IND_WPN_ACQ_SRC] call fza_mpd_fnc_acqDraw;
private _was = _heli getVariable "fza_ah64_was";
private _selectedWeapon = _state get "selectedWeapon";
private _wasOverride = _state get "wasOverride";

if (_was != WAS_WEAPON_NONE && _selectedWeapon != _was) then {
    _wasOverride = 1;
    _selectedWeapon = _was;
    _state set ["selectedWeapon", _selectedWeapon];
    _state set ["wasOverride", _wasOverride];
    _state set ["variant", 0];
};
if (_was == WAS_WEAPON_NONE && _wasOverride == 1 && _selectedWeapon != _was) then {
    _wasOverride = 0;
    _selectedWeapon = WAS_WEAPON_NONE;
    _state set ["selectedWeapon", _selectedWeapon];
    _state set ["wasOverride", _wasOverride];
    _state set ["variant", 0];
};

[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_WAS), _was] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_WPN), _selectedWeapon] call fza_mpd_fnc_updateMfdValue;

//Rocket pods draw

private _rocketInventory = [_heli] call fza_fnc_weaponRocketInventory;
private _curAmmo = getText (configFile >> "CfgWeapons" >> _heli getVariable "fza_ah64_selectedRocket" >> "fza_ammoType"); 
private _rocketInvIndex  = _rocketInventory findIf {if (_x isEqualTo []) then {false} else {_x # 0 == _curAmmo}}; 
private _pylonsWithRockets = [];

{
    if !(_x isEqualTo []) then {
        _pylonsWithRockets append (_x # 2);
    };
} forEach (_rocketInventory);

[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_ROCKET_POD_1_4_STATE), ([0, 1] select (0 in _pylonsWithRockets))+([0, 2] select (12 in _pylonsWithRockets))] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_ROCKET_POD_2_3_STATE), ([0, 1] select (4 in _pylonsWithRockets))+([0, 2] select (8 in _pylonsWithRockets))] call fza_mpd_fnc_updateMfdValue;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_1_4_TEXT), ""] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_2_3_TEXT), ""] call fza_mpd_fnc_updateMfdText;

if (_rocketInvIndex != -1) then { 
    for "_invCount" from 0 to ((count _rocketInventory) - 1) do {
        (_rocketInventory # _invCount) params ["", "_selectedRktQty", "_selectedRktPylons", "_selectedRktText", "_selectedRktZones"]; 
        if ((0 in _selectedRktPylons || 12 in _selectedRktPylons) && 0 in _selectedRktZones) then { 
            [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_1_4_TEXT), _selectedRktText] call fza_mpd_fnc_updateMfdText; 
        }; 
        if ((4 in _selectedRktPylons || 8 in _selectedRktPylons) && 0 in _selectedRktZones) then { 
            [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_2_3_TEXT), _selectedRktText] call fza_mpd_fnc_updateMfdText; 
        }; 
    };
    (_rocketInventory # _rocketInvIndex) params ["", "_selectedRktQty", "_selectedRktPylons", "_selectedRktText"]; 
    private _rktSel = 0; 
    if (0 in _selectedRktPylons || 12 in _selectedRktPylons) then { 
        _rktSel = _rktSel + 1; 
        [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_1_4_TEXT), _selectedRktText] call fza_mpd_fnc_updateMfdText; 
    }; 
    if (4 in _selectedRktPylons || 8 in _selectedRktPylons) then { 
        _rktSel = _rktSel + 2; 
        [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_2_3_TEXT), _selectedRktText] call fza_mpd_fnc_updateMfdText; 
    }; 
    [_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_RKT), _rktSel] call fza_mpd_fnc_updateMfdValue;
};

//Page draw
switch (_selectedWeapon) do {
    case WAS_WEAPON_GUN: {
        _this call fza_mpd_fnc_WpnGunDraw;
    };
    case WAS_WEAPON_RKT: {
        _this call fza_mpd_fnc_WpnRktDraw;
    };
    case WAS_WEAPON_MSL: {
        _this call fza_mpd_fnc_WpnMslDraw;
    };
};