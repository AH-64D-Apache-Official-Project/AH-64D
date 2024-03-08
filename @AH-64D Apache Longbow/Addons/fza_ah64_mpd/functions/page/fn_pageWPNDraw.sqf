#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex", "_state"];

private _armed      = _heli getVariable "fza_ah64_armSafeArmed";
private _chaffState = BOOLTONUM(_heli getVariable "fza_ah64_ase_chaffState" == "arm");

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_MASTER_ARM), BOOLTONUM(_armed)];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_CHAFF_ARM), _chaffState];

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_HF), 0];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_RKT), 0];

//Set the weapon state
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_WAS), 0];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_WPN), 0];

//Chaff + Flares
private _chaffCount = 0;
private _flareCount= 0;
{
    _x params ["_className", "_turretPath", "_ammoCount"];
    if (_className == "30Rnd_CMChaffMagazine" && _turretPath isEqualTo [-1]) then {
        _chaffCount = _chaffCount + _ammoCount;
    };
    if (_className == "60Rnd_CMFlareMagazine" && _turretPath isEqualTo [-1]) then {
        _flareCount= _flareCount+ _ammoCount;
    };
} forEach magazinesAllTurrets _heli;

if (_heli animationPhase "msn_equip_british" == 1) then {
    _heli setUserMfdText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_CMS_QTY), (str (_chaffCount/2)) + "/" + str _FlareCount];
} else {
    _heli setUserMfdText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_CMS_QTY), (str (_chaffCount/2))];
};

//Mission equipment 
_msn_equip_British = _heli animationPhase "msn_equip_british";
_heli setUserMfdValue  [MFD_INDEX_OFFSET(MFD_IND_WPN_CMS_MODE_TYPE), _msn_equip_British];

//GUN AMMO
private _gunAmmo = _heli ammo "fza_m230";
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_GUN_ROUNDS), _gunAmmo toFixed 0];

//GUN FAILED
private _GunFailed = (_heli getHitPointDamage "hit_msnEquip_gun_turret" > SYS_WPN_DMG_THRESH);
_heli setUserMfdValue  [MFD_INDEX_OFFSET(MFD_IND_WPN_CANNON_FAILURE), BOOLTONUM(_GunFailed)];

// SIGHT AND ACQ SOURCES
private _sight = "TADS";

switch ([_heli] call fza_fnc_targetingGetSightSelect) do {
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
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_SIGHT), _sight];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_LRFD_CODE), _heli getVariable "fza_ah64_laserLRFDCode"];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_LST_CODE), _heli getVariable "fza_ah64_laserLSTCode"];

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

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_WAS), _was];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_WPN), _selectedWeapon];

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

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_ROCKET_POD_1_4_STATE), ([0, 1] select (0 in _pylonsWithRockets))+([0, 2] select (12 in _pylonsWithRockets))];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_ROCKET_POD_2_3_STATE), ([0, 1] select (4 in _pylonsWithRockets))+([0, 2] select (8 in _pylonsWithRockets))];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_1_4_TEXT), ""];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_2_3_TEXT), ""];

if (_rocketInvIndex != -1) then { 
    for "_invCount" from 0 to ((count _rocketInventory) - 1) do {
        (_rocketInventory # _invCount) params ["", "_selectedRktQty", "_selectedRktPylons", "_selectedRktText", "_selectedRktZones"]; 
        if ((0 in _selectedRktPylons || 12 in _selectedRktPylons) && 0 in _selectedRktZones) then { 
            _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_1_4_TEXT), _selectedRktText]; 
        }; 
        if ((4 in _selectedRktPylons || 8 in _selectedRktPylons) && 0 in _selectedRktZones) then { 
            _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_2_3_TEXT), _selectedRktText]; 
        }; 
    };
    (_rocketInventory # _rocketInvIndex) params ["", "_selectedRktQty", "_selectedRktPylons", "_selectedRktText"]; 
    private _rktSel = 0; 
    if (0 in _selectedRktPylons || 12 in _selectedRktPylons) then { 
        _rktSel = _rktSel + 1; 
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_1_4_TEXT), _selectedRktText]; 
    }; 
    if (4 in _selectedRktPylons || 8 in _selectedRktPylons) then { 
        _rktSel = _rktSel + 2; 
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_ROCKET_POD_2_3_TEXT), _selectedRktText]; 
    }; 
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_RKT), _rktSel];
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
};q 