#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#define SALVO_ALL 99
params ["_heli", "_mpdIndex", "_state"];

private _armed = _heli getVariable "fza_ah64_armSafeArmed";

//Set the arm/safe status of the aircraft
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_MASTER_ARM), BOOLTONUM(_armed)];
//Set the arm/safe status of the chaff dispenser
private _chaffState = BOOLTONUM(_heli getVariable "fza_ah64_ase_chaffState" == "arm");
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
//Gun actioned
if (_selectedWeapon == WAS_WEAPON_GUN) then {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_WPN), 1];
    switch (_heli getVariable "fza_ah64_burst_limit") do {
        case 10: {
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_BURST_LIMIT), 0];
        };
        case 20: {
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_BURST_LIMIT), 1];
        };
        case 50: {
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_BURST_LIMIT), 2];
        };
        case 100: {
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_BURST_LIMIT), 3];
        };
        case -1: {
            _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_BURST_LIMIT), 4];
        };
    };
};

//Rocket initialization
_rocketInventory = [_heli] call fza_fnc_weaponRocketInventory;
_pylonsWithRockets = [];
{
    if !(_x isEqualTo []) then {
        _pylonsWithRockets append (_x # 2);
    };
} forEach (_rocketInventory);

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_RKT_1_4_STATE), ([0, 1] select (0 in _pylonsWithRockets))+([0, 2] select (12 in _pylonsWithRockets))];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_RKT_2_3_STATE), ([0, 1] select (4 in _pylonsWithRockets))+([0, 2] select (8 in _pylonsWithRockets))];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_1_4_TEXT), ""];
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_1_4_TEXT), ""];

//Rockets actioned
if (_selectedWeapon == WAS_WEAPON_RKT) then {
    private _curAmmo = getText (configFile >> "CfgWeapons" >> _heli getVariable "fza_ah64_selectedRocket" >> "fza_ammoType");
    if (_heli getVariable "fza_ah64_rocketsalvo" == SALVO_ALL) then {
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_SALVO), "ALL"]
    } else {
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_SALVO), (_heli getVariable "fza_ah64_rocketsalvo") toFixed 0];
    };

    private _rocketInvIndex = _rocketInventory findIf {if (_x isEqualTo []) then {false} else {_x # 0 == _curAmmo}};
    if (_rocketInvIndex != -1) then {
        (_rocketInventory # _rocketInvIndex) params ["", "_selectedRktQty", "_selectedRktPylons", "_selectedRktText"];
        private _rktSel = 0;
        if (0 in _selectedRktPylons || 12 in _selectedRktPylons) then {
            _rktSel = _rktSel + 1;
            _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_1_4_TEXT), _selectedRktText];
        };
        if (4 in _selectedRktPylons || 8 in _selectedRktPylons) then {
            _rktSel = _rktSel + 2;
            _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_2_3_TEXT), _selectedRktText];
        };

        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_RKT), _rktSel];
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_TOT_QTY), _selectedRktQty toFixed 0];
    };
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_RKT_INV), _rocketInvIndex];
    
    //Rkt inventory options (left side of WPN page)
    {
        if !(_x isEqualTo []) then {
            _x params ["", "_rktQty", "", "_rktText"];
            _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_INV_1_NAME + _forEachIndex), _rktText];
            _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_INV_1_QTY + _forEachIndex), _rktQty toFixed 0];
        } else {
            _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_INV_1_NAME + _forEachIndex), ""];
            _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_INV_1_QTY + _forEachIndex), ""];
        };
    } forEach (_rocketInventory);
};

//Missiles actioned
private _missileInventory = [_heli] call fza_fnc_weaponMissileInventory;
if (_selectedWeapon == WAS_WEAPON_MSL) then {
    private _curAmmo = getText (configFile >> "CfgWeapons" >> _heli getVariable "fza_ah64_selectedMissile" >> "fza_ammoType");
    private _selectedMsl = [_missileInventory, _curAmmo] call fza_fnc_weaponMissileGetSelected;
    
    private _seekerType = getText (configFile >> "CfgAmmo" >> _curAmmo >> "fza_salType");

    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_HF), _selectedMsl + 1];
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_MSL_TYPE), [0,1] select (_seekerType == "rf")];

    _heli setUserMfdValue[MFD_INDEX_OFFSET(MFD_IND_WPN_MSL_MENU), _state get "variant"];
    if (_seekerType != "rf") then { //Sal1, sal2
        private _pri = _heli getVariable "fza_ah64_laserMissilePrimaryCode";
        private _alt = _heli getVariable "fza_ah64_laserMissileAlternateCode";
        private _chanCodes = _heli getVariable "fza_ah64_laserChannelCodes";
        private _priCode = "";
        private _altCode = "";

        if !(_pri == -1) then {
            _priCode = _chanCodes # _pri;
        };
        if !(_alt == -1) then {
            _altCode = _chanCodes # _alt;
        };
        
        _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_MSL_PRI_CODE), _priCode + " PRF"];
        _heli setUserMfdText[MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_MSL_ALT_CODE), _altCode + " PRF"];
        _heli setUserMfdValue[MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_PRI_CH), _pri + 1];
        _heli setUserMfdValue[MFD_INDEX_OFFSET(MFD_IND_WPN_SELECTED_ALT_CH), _alt + 1];
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_MSL_CHAN_1_CODE), _chanCodes # 0];
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_MSL_CHAN_2_CODE), _chanCodes # 1];
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_MSL_CHAN_3_CODE), _chanCodes # 2];
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_MSL_CHAN_4_CODE), _chanCodes # 3];
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_MSL_SAL_SEL), toUpper _seekerType];
        _heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_MSL_TRAJ), toUpper (_heli getVariable "fza_ah64_hellfireTrajectory")];
    };
};