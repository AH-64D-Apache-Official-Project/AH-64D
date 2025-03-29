#include "\fza_ah64_ase\headers\ase.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

//Chaff + Flares
private _chaffState = BOOLTONUM(_heli getVariable "fza_ah64_ase_chaffState" == ASE_CHAFF_STATE_ARM);
[_heli, MFD_INDEX_OFFSET(MFD_IND_ASE_CHAFF_STATE), _chaffState] call fza_mpd_fnc_updateMfdValue;
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

//IR Jammer
private _irJamPwr   = BOOLTONUM(_heli getVariable "fza_ah64_ase_msnEquipPwr" == ASE_MSNEQUIP_STATE_OFF);
[_heli, MFD_INDEX_OFFSET(MFD_IND_ASE_IRJAM_PWR), _irJamPwr] call fza_mpd_fnc_updateMfdValue;
_heli getVariable "fza_ah64_ase_irJamState" params ["_irJamState"];
[_heli, MFD_INDEX_OFFSET(MFD_IND_ASE_IRJAM_STATE), _irJamState] call fza_mpd_fnc_updateMfdValue;

//Autopage
private _autopage = _heli getVariable "fza_ah64_ase_autopage";
[_heli, MFD_INDEX_OFFSET(MFD_IND_ASE_AUTOPAGE), _autopage] call fza_mpd_fnc_updateMfdValue;

//RLWR
private _rlwrPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_rlwrPwr" == ASE_RLWR_STATE_OFF);
[_heli, MFD_INDEX_OFFSET(MFD_IND_ASE_RLWR_PWR), _rlwrPwr] call fza_mpd_fnc_updateMfdValue;
private _rlwrCount = _heli getVariable "fza_ah64_ase_rlwrcount";
[_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_RLWR_COUNT), _rlwrCount toFixed 0] call fza_mpd_fnc_updateMfdText;

//Mission equipment 
_msn_equip_British = _heli animationPhase "msn_equip_british";
[_heli, MFD_INDEX_OFFSET(MFD_IND_ASE_BRITISH), _msn_equip_British] call fza_mpd_fnc_updateMfdValue;

_msn_equip_american = _heli animationPhase "msn_equip_American";
[_heli, MFD_INDEX_OFFSET(MFD_IND_ASE_AMERICAN), _msn_equip_american] call fza_mpd_fnc_updateMfdValue;

//ASE Points
private _pointsArray = [];
private _linesArray  = [];
private _aseObjects  = _heli getVariable "fza_ah64_ase_objects";
private _radius      = 0.27;
{
    _x params ["_state", "_object","_iconClass"];
    private _bearing = _heli getRelDir _object;
    if (([] call fza_mpd_fnc_iconBlink) && (_state >= ASE_LNC && _state != ASE_LSR)) then {continue;};
    _pointsArray pushBack [MPD_POSMODE_SCREEN, [_radius * sin _bearing + 0.5, -_radius * cos _bearing + 0.5, 0.0], "", POINT_TYPE_ASE, _forEachIndex, _iconClass];
    if (_state <= ASE_ACQ) then {continue;};
    _linesArray pushBack [_bearing];
} forEach _aseObjects;

for "_i" from 0 to 6 do {
    if (_i >= count _linesArray) then {
        [_heli, MFD_INDEX_OFFSET(MFD_IND_ASE_01_AZ + _i), -1] call fza_mpd_fnc_updateMfdValue;
    } else {
        (_linesArray select _i) params ["_azimuth"];
        [_heli, MFD_INDEX_OFFSET(MFD_IND_ASE_01_AZ + _i), _azimuth] call fza_mpd_fnc_updateMfdValue;
    };
};

[_heli, _pointsArray, _mpdIndex, 1, [0.5, 0.5]] call fza_mpd_fnc_drawIcons;