#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

_rgbracket = "";

weaponState [_heli, [0]] params ["_curWpn", "_curMuzzle", "_curFiremode", "_curMagazine", "_curAmmoCount"];
_curAmmo = getText (configFile >> "CfgMagazines" >> _curMagazine >> "ammo");

if (currentweapon _heli == "fza_ma_safe") then {
	_heli setobjecttexture [SEL_PL_MPD_BACK, "\fza_ah64_us\tex\WPN_SAFE.paa"];
} else {
	_heli setobjecttexture [SEL_PL_MPD_BACK, "\fza_ah64_us\tex\WPN.paa"];
};

//FLARES
_flareCount = 0;
{
	_x params ["_className", "_turretPath", "_ammoCount"];
	if (_className == "60Rnd_CMFlareMagazine" && _turretPath isEqualTo [-1]) then {
		_flareCount = _flareCount + _ammoCount;
	};
} forEach magazinesAllTurrets _heli;

[_heli, 0, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_CHAFF_QTY] call fza_fnc_drawNumberSelections;
//Floor and ceil used to ensure count is accurate even when odd number of flares present
[_heli, floor (_flareCount/2), "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLARE1_QTY] call fza_fnc_drawNumberSelections;
[_heli, ceil (_flareCount/2), "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_FLARE2_QTY] call fza_fnc_drawNumberSelections;

//GUN AMMO - ALWAYS DISPLAYED

_gunAmmo = _heli ammo "fza_m230";
_gunAmmoFont = ["\fza_ah64_us\tex\CHAR\G", "\fza_ah64_us\tex\CHAR\B"] select (currentweapon _heli == "fza_m230" || currentweapon _heli == "fza_burstlimiter");
[_heli, _gunAmmo, _gunAmmoFont, SEL_DIGITS_MPD_PL_GUN_AMMO] call fza_fnc_drawNumberSelections;

// SIGHT AND ACQ SOURCES

_sight = "\fza_ah64_us\tex\icons\tads.paa";
_acq = "\fza_ah64_us\tex\icons\tads.paa";

if (_heli getVariable "fza_ah64_agmode" < 2) then {
	_sight = "\fza_ah64_us\tex\icons\fcr.paa";
	_acq = "\fza_ah64_us\tex\icons\fcr.paa";
};

switch ([_heli] call fza_fnc_targetingGetAcquisitionSource) do {
	case 1: {
		_acq = "\fza_ah64_us\tex\icons\HMD.paa";
	};
	case 2: {
		_acq = "\fza_ah64_us\tex\icons\AUTO.paa";
	};
	case 3: {
		_acq = "\fza_ah64_us\tex\icons\FXD.paa";
	}
};
_heli setobjecttexture [SEL_MPD_PL_SIGHT_ACQ, _sight];
_heli setobjecttexture [SEL_MPD_PL_WPN_ACQ, _acq];

// GUN SELECTED

if (_curWpn == "fza_m230" || _curWpn == "fza_burstlimiter") then {
	_rgbracket = "\fza_ah64_us\tex\icons\gunxtra.paa";
	_heli setobjecttexture [SEL_MPD_PL_GUN_SEL, "\fza_ah64_us\tex\icons\gun-sel_ca.paa"];
	_burst10 = "";
	_burst20 = "";
	_burst50 = "";
	_burst100 = "";
	switch (_heli getVariable "fza_ah64_burst_limit") do {
		case 10: {
			_burst10 = "\fza_ah64_us\tex\icons\box_ca.paa";
		};
		case 20: {
			_burst20 = "\fza_ah64_us\tex\icons\box_ca.paa";
		};
		case 50: {
			_burst50 = "\fza_ah64_us\tex\icons\box_ca.paa";
		};
		case 100: {
			_burst100 = "\fza_ah64_us\tex\icons\box_ca.paa";
		};
	};
	_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_1, _burst10];
	_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_2, _burst20];
	_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_3, _burst50];
	_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_4, _burst100];
} else {
	_heli setobjecttexture [SEL_MPD_PL_GUN_SEL, ""];
	_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_1, ""];
	_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_2, ""];
	_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_3, ""];
	_heli setobjecttexture [SEL_MPD_PL_GUN_BURST_4, ""];
};

_rocketInventory = [_heli] call fza_fnc_weaponRocketInventory;

_pylonsWithRockets = [];
{
	if !(_x isEqualTo []) then {
		_pylonsWithRockets append (_x # 2);
	};
} forEach (_rocketInventory);

for "_i" from 1 to 4 do {
	_heli setobjecttexture [SEL_MPD_PL_RKT1+(_i-1), ["", "\fza_ah64_us\tex\icons\PODINV.paa"] select ((_i - 1) * 7 in _pylonsWithRockets)];
};

if (_curWpn isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]) then {
	_rgbracket = switch (_heli getVariable "fza_ah64_rocketsalvo") do {
		case 1: {"\fza_ah64_us\tex\icons\RKTxtra_1.paa"};
		case 2: {"\fza_ah64_us\tex\icons\RKTxtra.paa"};
		case 4: {"\fza_ah64_us\tex\icons\RKTxtra_4.paa"};
		case 8: {"\fza_ah64_us\tex\icons\RKTxtra_8.paa"};
		case 12: {"\fza_ah64_us\tex\icons\RKTxtra_12.paa"};
		case 24: {"\fza_ah64_us\tex\icons\RKTxtra_24.paa"};
		case 38: {"\fza_ah64_us\tex\icons\RKTxtra_all.paa"};
	};
	_rocketInvIndex = _rocketInventory findIf {if (_x isEqualTo []) then {false} else {_x # 0 == _curAmmo}};
	if (_rocketInvIndex != -1) then {
		(_rocketInventory # _rocketInvIndex) params ["", "_selectedRktQty", "_selectedRktPylons", "_selectedRktTextureB"];
		for "_i" from 1 to 4 do {
			if ((_i - 1) * 7 in _selectedRktPylons) then {
				_heli setobjecttexture [SEL_MPD_PL_RKT1+(_i-1), "\fza_ah64_us\tex\icons\PODSEL.paa"];
				_heli setobjecttexture [SEL_MPD_PL_RKT_SEL_TYPE_1+(_i-1), _selectedRktTextureB];
			};
		};
		[_heli, _selectedRktQty, "\fza_ah64_us\tex\CHAR\G", SEL_DIGITS_MPD_PL_RKT_TOT] call fza_fnc_drawNumberSelections;
	};

	{
		_rktTypeSel = [SEL_MPD_PL_RKT1_TYPE, SEL_MPD_PL_RKT2_TYPE, SEL_MPD_PL_RKT3_TYPE, SEL_MPD_PL_RKT4_TYPE, SEL_MPD_PL_RKT5_TYPE] # _forEachIndex;
		_rktDigits = [SEL_DIGITS_MPD_PL_RKT1_TOT, SEL_DIGITS_MPD_PL_RKT2_TOT, SEL_DIGITS_MPD_PL_RKT3_TOT, SEL_DIGITS_MPD_PL_RKT4_TOT, SEL_DIGITS_MPD_PL_RKT5_TOT] # _forEachIndex;
		if !(_x isEqualTo []) then {
			_x params ["", "_rktQty", "", "", "_rktTextureG"];
			_heli setObjectTexture [_rktTypeSel, _rktTextureG];
			[_heli, _rktQty, "\fza_ah64_us\tex\CHAR\G", _rktDigits] call fza_fnc_drawNumberSelections;
		} else {
			_heli setObjectTexture [_rktTypeSel, ""];
			CLEAR_DIGITS(_heli, _rktDigits)
		};
	} forEach (_rocketInventory);
} else {
	_heli setobjecttexture [SEL_MPD_PL_RKT1_TYPE, ""];
	_heli setobjecttexture [SEL_MPD_PL_RKT2_TYPE, ""];
	_heli setobjecttexture [SEL_MPD_PL_RKT3_TYPE, ""];
	_heli setobjecttexture [SEL_MPD_PL_RKT4_TYPE, ""];
	_heli setobjecttexture [SEL_MPD_PL_RKT5_TYPE, ""];
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT1_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT2_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT3_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT4_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT5_TOT);
	CLEAR_DIGITS(_heli, SEL_DIGITS_MPD_PL_RKT_TOT);
};

_missileInventory = [_heli] call fza_fnc_weaponMissileInventory;

{
	if (_x isEqualTo -1) then { //If missile area is empty
		_heli setObjectTexture [SEL_MPD_PL_HF1_L1 + _forEachIndex, ""];
	} else {
		if (_x isEqualTo "") then {
			_heli setObjectTexture [SEL_MPD_PL_HF1_L1 + _forEachIndex, "\fza_ah64_us\tex\ICONS\rail.paa"];
		} else {
			_salType = getText (configFile >> "CfgAmmo" >> _x >> "fza_salType");
			_tex = switch (_salType) do {
				case "sal1": {"\fza_ah64_us\tex\ICONS\114LINV_ca.paa"};
				case "sal2": {"\fza_ah64_us\tex\ICONS\114LINV2_ca.paa"};
				case "rf": {"\fza_ah64_us\tex\ICONS\114RINV_ca.paa"};
				default {""};
			};
			_heli setObjectTexture [SEL_MPD_PL_HF1_L1 + _forEachIndex, _tex];
		};
	};
}forEach (_missileInventory);

if (_curWpn isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]) then {
	_selectedMsl = [_missileInventory, _curAmmo] call fza_fnc_weaponMissileGetSelected;
	if (_selectedMsl != -1) then {
		assert (0 <= _selectedMsl && _selectedMsl <= 15);
		_salType = getText (configFile >> "CfgAmmo" >> _curAmmo >> "fza_salType");
		_tex = switch (_salType) do {
			case "sal1": {"\fza_ah64_us\tex\ICONS\114LSEL_ca.paa"};
			case "sal2": {"\fza_ah64_us\tex\ICONS\114LSEL2_ca.paa"};
			case "rf": {"\fza_ah64_us\tex\ICONS\114RSEL_ca.paa"};
			default {""};
		};
		_heli setObjectTexture [SEL_MPD_PL_HF1_L1 + _selectedMsl, _tex];
		_tex = switch (_salType) do {
			case "sal1": {"\fza_ah64_us\tex\icons\sal1.paa"};
			case "sal2": {"\fza_ah64_us\tex\icons\sal2.paa"};
			case "rf": {""};
			default {""};
		};
		_heli setObjectTexture [SEL_MPD_PL_HF_SALT, _tex];
		_tex = switch (_salType) do {
			case "sal1": {"\fza_ah64_us\tex\icons\sal.paa"};
			case "sal2": {"\fza_ah64_us\tex\icons\sal.paa"};
			case "rf": {"\fza_ah64_us\tex\icons\salRF.paa"};
			default {""};
		};
		_heli setObjectTexture [SEL_MPD_PL_WPN_HF_TYPE, _tex];
	};
	_heli setObjectTexture [SEL_MPD_PL_HF_BRACKET, "\fza_ah64_us\tex\icons\mslxtra.paa"];
	if (laserTarget _heli == _heli getVariable "fza_ah64_currentLase") then {
		_heli setObjectTexture [SEL_MPD_PL_HF_DESIG, "\fza_ah64_us\tex\icons\self.paa"];
	} else {
		_heli setObjectTexture [SEL_MPD_PL_HF_DESIG, "\fza_ah64_us\tex\icons\remt.paa"];
	};

	_trajTex = switch ([_heli] call fza_fnc_weaponMissileTrajectory) do {
		case "dir": {"\fza_ah64_us\tex\icons\dir.paa"};
		case "lo": {"\fza_ah64_us\tex\icons\lo.paa"};
		case "hi": {"\fza_ah64_us\tex\icons\hi.paa"};
		default {""};
	};
	_heli setobjecttexture [SEL_MPD_PL_HF_TRAJ, _trajTex];
} else {
	_heli setObjectTexture [SEL_MPD_PL_HF_BRACKET, ""];
	_heli setObjectTexture [SEL_MPD_PL_HF_DESIG, ""];
	_heli setObjectTexture [SEL_MPD_PL_HF_SALT, ""];
	_heli setObjectTexture [SEL_MPD_PL_HF_TRAJ, ""];
};
_heli setobjecttexture [SEL_MPD_PL_RG_BASE, _rgbracket];
_heli setobjecttexture [SEL_MPD_PL_RG_BRACKET, _rgbracket];
_heli setobjecttexture [SEL_MPD_PL_RKT_BURST, _rgbracket];