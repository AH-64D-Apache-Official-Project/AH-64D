/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_fcrStatusDraw

Description:
    Drives the symbology shared by every FCR format (GTM, ATM, RMAP, TPM): the
    high action display (sight select, range source, weapon control/status),
    the centerline slew arrows, the heading tape cues, the TADS field of view,
    the cued LOS and the acquisition source.

Parameters:
    _heli     - The helicopter
    _mpdIndex - 0 left MPD, 1 right MPD
    _hadOnly  - (optional, default false) only drive the high action display,
                for formats that draw none of the other cues (TPM)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", ["_hadOnly", false]];

private _sight        = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _sightSelStat = "HMD";
switch (_sight) do {
    case SIGHT_FCR:  { _sightSelStat = "FCR "; };
    case SIGHT_HMD:  { _sightSelStat = "HMD "; };
    case SIGHT_TADS: { _sightSelStat = "TADS"; };
};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_SSS), _sightSelStat];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_RRS), ([_heli, player] call fza_fnc_targetingRange) # 1];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_SS), ""];

private _wasState = _heli getVariable "fza_ah64_was";
private _mslTraj  = _heli getVariable "fza_ah64_hellfireTrajectory";
private _wpnCtrl  = "";
private _wpnStat  = "";
switch (_wasState) do {
    case WAS_WEAPON_GUN: {
        if (isManualFire _heli) then {
            _wpnStat = format["ROUNDS %1", _heli ammo "fza_m230"];
        } else {
            _wpnCtrl = "CGUN";
        };
    };
    case WAS_WEAPON_MSL: {
        if (isManualFire _heli) then {
            switch (_mslTraj) do {
                case "DIR": { _wpnStat = "DIR MAN"; };
                case "LO":  { _wpnStat = "LO MAN"; };
                case "HI":  { _wpnStat = "HI MAN"; };
            };
        } else {
            _wpnCtrl = "CMSL";
        };
    };
    case WAS_WEAPON_RKT: {
        if (isManualFire _heli) then {
            private _rktAmmo = getText (configFile >> "CfgWeapons" >> (_heli getVariable "fza_ah64_selectedRocket") >> "fza_ammoType");
            private _rktCode = getText (configFile >> "CfgAmmo" >> _rktAmmo >> "fza_shortCode");
            _wpnStat = format["%1 NORM %2", _rktCode, _heli ammo(_heli getVariable "fza_ah64_selectedRocket")];
        } else {
            _wpnCtrl = "CRKT";
        };
    };
};
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_WC), _wpnCtrl];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_FCR_WS), _wpnStat];

if (_hadOnly) exitWith {};

// Centerline arrows only while FCR is the selected sight; an arrow fills for a moment when pressed (fza_fcr_fnc_slewCenterline)
private _arrowL = 0;
private _arrowR = 0;
if (_sight == SIGHT_FCR) then {
    (_heli getVariable ["fza_fcr_arrowPressed", [0, -10]]) params ["_pressDir", "_pressTime"];
    private _pressed = diag_tickTime - _pressTime < 0.2;
    _arrowL = [1, 2] select (_pressed && _pressDir < 0);
    _arrowR = [1, 2] select (_pressed && _pressDir > 0);
};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ARROW_L), _arrowL];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ARROW_R), _arrowR];

private _nextPoint = (_heli getVariable "fza_dms_routeNext")#0;
private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
if (isNil "_nextPointPos") then {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_COMMAND_HEADING), -360];
} else {
    private _waypointDirection = [(_heli getRelDir _nextPointPos)] call CBA_fnc_simplifyAngle180;
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_COMMAND_HEADING), _waypointDirection];
};

private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
private _tadsElevation = _heli getVariable "fza_ah64_tadsElevation";
private _alternatesensorpan = (if (player == gunner _heli) then {deg(_heli animationPhase "pnvs")} else {_tadsAzimuth});
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_ALTERNATE_SENSOR), _alternatesensorpan];

_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_pos", "_time","_lastDir"];
private _fcrHeading = [(_dir - direction _heli) mod 360] call CBA_fnc_simplifyAngle180;
private _lastHeading = [(_lastDir - direction _heli) mod 360] call CBA_fnc_simplifyAngle180;
if (_heli animationPhase "fcr_enable" != 1) then {
    _fcrHeading = -1000;
    _lastHeading = -1000;
};
// Carets present only within the displayed portion of the heading scale (+-90)
if (abs _fcrHeading > 95)  then { _fcrHeading  = -1000; };
if (abs _lastHeading > 95) then { _lastHeading = -1000; };
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CENTERLINE), _fcrHeading];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_PREV_CENTER), _lastHeading];

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_FOV_X), _tadsAzimuth];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_FOV_Y), -_tadsElevation];

private _curTurret = [_heli] call fza_fnc_currentTurret;
private _currentAcq = [_heli, _curTurret] call fza_fnc_targetingCurAcq;
private _acqVector = [_heli, _currentAcq] call fza_fnc_targetingAcqVec;
_acqVector = _heli vectorWorldToModelVisual _acqVector;
_acqVector call CBA_fnc_vect2Polar params ["_magnitude", "_cuedLosX", "_cuedLosY"];
_cuedLosX = _cuedLosX call CBA_fnc_simplifyAngle180;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CUEDLOS_X), _cuedLosX];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CUEDLOS_Y), -_cuedLosY];

[_heli, _mpdIndex, MFD_IND_FCR_ACQ_BOX, MFD_TEXT_IND_FCR_ACQ_SRC] call fza_mpd_fnc_acqDraw;
