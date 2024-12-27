#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli", "_mpdIndex", "_state", "_persistState"];

private _fcrMode = _heli getvariable "fza_ah64_fcrMode";
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

//Command Heading Chevron
private _nextPoint = (_heli getVariable "fza_dms_routeNext")#0;
private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
if (isNil "_nextPointPos") then {
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_COMMAND_HEADING), -360];
} else {
    private _waypointDirection = [(_heli getRelDir _nextPointPos)] call CBA_fnc_simplifyAngle180;
    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_COMMAND_HEADING), _waypointDirection];
};

//Alternate Sensor Bearing
private _alternatesensorpan = (if (player == gunner _heli) then {deg(_heli animationPhase "pnvs")} else {-deg (_heli animationSourcePhase "tads_tur")});
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ALTERNATE_SENSOR), _alternatesensorpan];

//FCR CenterLine
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_pos", "_time","_lastDir"]; 
private _fcrHeading = [(_dir - direction _heli) mod 360] call CBA_fnc_simplifyAngle180;
private _lastHeading = [(_lastDir - direction _heli) mod 360] call CBA_fnc_simplifyAngle180;
if !(_heli animationPhase "fcr_enable" == 1) then {
    _fcrHeading = -1000;
    _lastHeading = -1000;
};
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CENTERLINE), _fcrHeading];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_PREV_CENTER), _lastHeading];

//TADS POS
([_heli, [0], true] call CBA_fnc_turretDir) params ["_tadsX", "_tadsY"];
private _tadsX = _tadsX call CBA_fnc_simplifyAngle180;
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_FOV_X), _tadsX];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_FOV_Y), -_tadsY];

//Cued LOS
private _curTurret = [_heli] call fza_fnc_currentTurret;
private _currentAcq = [_heli, _curTurret] call fza_fnc_targetingCurAcq;
private _acqVector = [_heli, _currentAcq] call fza_fnc_targetingAcqModelVec;
_acqVector call CBA_fnc_vect2Polar params ["_magnitude", "_quedLosX", "_quedLosY"];
private _quedLosX = _quedLosX call CBA_fnc_simplifyAngle180;
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CUEDLOS_X), _quedLosX];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CUEDLOS_Y), -_quedLosY];

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