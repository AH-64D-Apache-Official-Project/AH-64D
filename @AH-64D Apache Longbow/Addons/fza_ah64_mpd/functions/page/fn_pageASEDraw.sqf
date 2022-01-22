#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

//Chaff
private _chaffState = BOOLTONUM(_heli getVariable "fza_ah64_ase_chaffState" == "safe");
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_CHAFF_STATE), _chaffState];
private _chaffCount = 0; //<-- this is duplicated in the WPN page!!
{
	_x params ["_className", "_turretPath", "_ammoCount"];
	if (_className == "60Rnd_CMFlareMagazine" && _turretPath isEqualTo [-1]) then {
		_chaffCount = _chaffCount + _ammoCount;
	};
} forEach magazinesAllTurrets _heli;
_heli setUserMfdText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_CHAFF_QTY), _chaffCount toFixed 0];

//IR Jammer
private _irJamPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_irjamPwr" == "off");
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_IRJAM_PWR), _irJamPwr];
_heli setUserMfdValue  [MFD_INDEX_OFFSET(MFD_IND_ASE_IRJAM_STATE), ASE_IRJAM_STATE_OPER];

//RF Jammer
private _rfJamState = _heli getVariable "fza_ah64_ase_rfJamState";
systemChat format ["RF Jam State = %1", _rfJamState];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_RFJAM_STATE), _rfJamState];

//Autopage
private _autopage = _heli getVariable "fza_ah64_ase_autopage";
systemChat format ["Autopage State = %1", _autopage];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_AUTOPAGE), _autopage];

//RLWR

private _rlwrPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_rlwrPwr" == "off");
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_RLWR_PWR), _rlwrPwr];
private _rwlrObjects = _heli getVariable "fza_ah64_ase_rlwrObjects";
for "_i" from 0 to 6 do {
	if (_i >= count _rwlrObjects) then {
		_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_OBJECT_01_MD + _i), -1];
		_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_OBJECT_01_AZ + _i), -1];
	} else {
		(_rwlrObjects select _i) params ["_mode", "_azimuth"];
		_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_OBJECT_01_MD + _i), _mode];
		_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_OBJECT_01_AZ + _i), _azimuth];
	};
};
private _rlwrCount = _heli getVariable "fza_ah64_ase_rlwrCount";
_heli setUserMfdText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_RLWR_COUNT), _rlwrCount toFixed 0];

//Test
hintsilent format ["Ase Objs = %1", _rwlrObjects];
