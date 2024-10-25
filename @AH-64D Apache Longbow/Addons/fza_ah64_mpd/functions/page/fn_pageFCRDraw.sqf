#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli", "_mpdIndex", "_state", "_persistState"];

Private _fcrMode = _heli Getvariable "fza_ah64_fcrMode";
private _cScope  = _heli getVariable "fza_ah64_fcrcscope";

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CSCOPE), BOOLTONUM(_cScope)];
switch _fcrMode do {
    case 1: { //Gtm
        _this call fza_mpd_fnc_fcrGTMDraw;
        _heli setUserMfdvalue [MFD_INDEX_OFFSET(MFD_IND_FCR_MODE), 1];
    };
    case 2: {  //ATM
        _this call fza_mpd_fnc_fcrATMDraw;
        _heli setUserMfdvalue [MFD_INDEX_OFFSET(MFD_IND_FCR_MODE), 2];
    };
};

//Sight Select Status
private _sight        = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _sightSelStat = "HMD";
switch (_sight) do {
    case 0: {
        _sightSelStat = "FCR ";
    };
    case 1: {
        _sightSelStat = "HMD ";
    };
    case 2: {
        _sightSelStat = "TADS";
    };
    case 3: {
        _sightSelStat = "FXD ";
    };
};
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_SSS), _sightSelStat];

//Range and Range Source
private _nts     = _heli getVariable "fza_ah64_fcrNts";
private _nts     = _nts # 0;
private _rngSrce = format["R%1", ((_heli distance _nts) / 1000) toFixed 1];
if (isNull _nts) then {
    if (driver _heli isEqualTo player) then {
        _rngSrce = "1.5";
    } else { _rngSrce = "3.0"};
};
if (!isNull laserTarget _heli) then {
    _rngSrce = format["*%1", round(_heli distance laserTarget _heli)];
};
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_RRS), _rngSrce];

//Sight Status
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_SS), ""];

//Weapon Control
private _wasState = _heli getVariable "fza_ah64_was";
private _mslTraj  = _heli getVariable "fza_ah64_hellfireTrajectory";
private _wpnCtrl  = "";
private _wpnStat  = "";
switch (_wasState) do {
    case WAS_WEAPON_NONE: {
        _wpnCtrl = "";
    };
    case WAS_WEAPON_GUN: {
        if (isManualFire _heli) then {
            _wpnCtrl = "";
            _wpnStat = format["ROUNDS %1", _heli ammo "fza_m230"];
        } else {
            _wpnCtrl = "CGUN";
        };
    };
    case WAS_WEAPON_MSL: {
        if (isManualFire _heli) then {
            _wpnCtrl = "";
            switch (_mslTraj) do {
                case "DIR": {
                    _wpnStat = "DIR MAN";
                };
                case "LO": {
                    _wpnStat = "LO MAN";
                };
                case "HI": {
                    _wpnStat = "HI MAN";
                };
            };
        } else {
            _wpnCtrl = "CMSL";
        };
    };
    case WAS_WEAPON_RKT: {
        if (isManualFire _heli) then {
            _wpnCtrl = "";
            private _rktAmmo = getText (configFile >> "CfgWeapons" >> (_heli getVariable "fza_ah64_selectedRocket") >> "fza_ammoType");
            private _rktCode = getText (configFile >> "CfgAmmo" >> _rktAmmo >> "fza_shortCode");
            _wpnStat              = format["%1 NORM %2", _rktCode, _heli ammo(_heli getVariable "fza_ah64_selectedRocket")];            
        } else {
            _wpnCtrl = "CRKT";
        };
    };
};
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_WC), _wpnCtrl];

//Weapon Status
_heli setUserMfdText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_WS), _wpnStat];