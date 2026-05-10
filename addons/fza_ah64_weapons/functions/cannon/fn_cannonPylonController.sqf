/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_cannonPylonController

Description:
    Manages M230 turret azimuth and elevation based on the active sight and
    acquisition source. Writes gun inhibit conditions and updates the
    mainTurret / mainGun animations. CPG is always authoritative when present;
    PLT drives the gun when flying alone.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
params ["_heli"];

// Only the machine that owns the vehicle drives the turret
if !(local _heli) exitWith {};

// The seat with WAS_WEAPON_GUN drives the turret; CPG takes precedence.
// When neither seat has GUN selected, _was = NONE so the turret holds its stow position.
private _authSeat = [_heli, WAS_WEAPON_GUN] call fza_weapons_fnc_getWasSeat;
private _was      = [WAS_WEAPON_NONE, WAS_WEAPON_GUN] select (_authSeat != "");
private _sight    = if (_authSeat != "") then { [_heli, "fza_ah64_sight", _authSeat] call fza_fnc_getSeatVariable } else { SIGHT_HMD };

private _gunDamage     = (_heli getHitPointDamage "hit_msnEquip_gun_turret"    > SYS_WPN_DMG_THRESH);
private _magDamage     = (_heli getHitPointDamage "hit_msnEquip_magandrobbie"  > SYS_WPN_DMG_THRESH && _heli animationPhase "magazine_set_1200" == 1);
private _utilLevelMin  = (_heli getVariable "fza_systems_utilLevel_pct"  < SYS_HYD_MIN_LVL);
private _utilHydFailed = (_heli getVariable "fza_systems_utilHydPSI"     < SYS_MIN_HYD_PSI);
private _acBusOn       = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn       = _heli getVariable "fza_systems_dcBusOn";
private _gunFailed     = (_utilHydFailed || _utilLevelMin || _gunDamage || !_acBusOn || !_dcBusOn || _magDamage);

private _mainturret = 0;
private _maingun    = 0.298; // stow position
private _inhibit    = "";

if (_was == WAS_WEAPON_GUN && !_gunFailed) then {
    private _cannonAzimuth   = 0;
    private _cannonElevation = 0;

    switch _sight do {
        case SIGHT_TADS: {
            _cannonAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
            (_heli getVariable ["fza_ah64_sightData_" + _authSeat, [[0,0,0],[0,0,0],0,""]]) params
                [["_tPosTads", [0,0,0]], ["_tVelTads", [0,0,0]]];
            if !(_tPosTads isEqualTo [0,0,0]) then {
                _cannonElevation = [_heli, _tPosTads, 805, -0.00036, _tVelTads] call fza_weapons_fnc_ballisticComputer;
            } else {
                _cannonElevation = _heli getVariable "fza_ah64_tadsElevation";
            };
        };
        case SIGHT_HMD: {
            (_heli getVariable ["fza_ah64_sightData_" + _authSeat, [[0,0,0],[0,0,0],0,""]]) params
                [["_tPos", [0,0,0]], ["_tVel", [0,0,0]]];
            if !(_tPos isEqualTo [0,0,0]) then {
                private _b = _heli worldToModel (ASLToAGL _tPos);
                private _mag = vectorMagnitude _b;
                if (_mag > 0.001) then {
                    _cannonAzimuth   = (_b # 0) atan2 (_b # 1);
                    _cannonElevation = [_heli, _tPos, 805, -0.00036, _tVel] call fza_weapons_fnc_ballisticComputer;
                };
            };
        };
        case SIGHT_FCR: {
            (_heli getVariable "fza_ah64_fcrNts") params ["_nts", ["_ntsPos", [0,0,0]]];
            if !(_ntsPos isEqualTo [0,0,0]) then {
                private _b = _heli worldToModel (ASLToAGL _ntsPos);
                private _mag = vectorMagnitude _b;
                if (_mag > 0.001) then {
                    // FCR NTS velocity: use velocity of tracked object if valid, else stationary
                    private _ntsVel = if (isNull _nts) then { [0,0,0] } else { velocity _nts };
                    _cannonAzimuth   = (_b # 0) atan2 (_b # 1);
                    _cannonElevation = [_heli, _ntsPos, 805, -0.00036, _ntsVel] call fza_weapons_fnc_ballisticComputer;
                };
            };
        };
        // SIGHT_FXD handled below
    };

    if !(-86 < _cannonAzimuth   && _cannonAzimuth   < 86) then { _inhibit = "AZ LIMIT"; };
    if !(-60 < _cannonElevation && _cannonElevation  < 11) then { _inhibit = "EL LIMIT"; };

    if (_sight == SIGHT_FXD) then {
        _mainturret = 0;
        _maingun    = 0;
    } else {
        _mainturret = -rad ([_cannonAzimuth,   -86, 86] call BIS_fnc_clamp);
        _maingun    =  rad ([_cannonElevation, -60, 11] call BIS_fnc_clamp);
    };
};

if (_gunFailed) then {
    _mainturret = _heli animationPhase "mainTurret";
    _maingun    = 0.298;
    _inhibit    = "GUN FAILED";
};

if (abs ((_heli animationPhase "mainTurret") - _mainturret) > 0.00001) then { _heli animateSource ["mainTurret", _mainturret, false] };
if (abs ((_heli animationPhase "mainGun")    - _maingun)    > 0.00001) then { _heli animateSource ["mainGun",    _maingun,    false] };
[_heli, "fza_ah64_gunInhibited", _inhibit] call fza_fnc_updateNetworkGlobal;

// Cache barrel world positions for FiredEH redirect (visual LOD is correct here in draw3D)
_heli setVariable ["fza_ah64_cannonMuzzleASL", _heli modelToWorldVisualWorld (_heli selectionPosition "Usti hlavne")];
_heli setVariable ["fza_ah64_cannonKonecASL",  _heli modelToWorldVisualWorld (_heli selectionPosition "Konec hlavne")];

#ifdef __A3_DEBUG__
private _targPos = ((_heli call fza_weapons_fnc_sightData) # 0);
drawIcon3d ["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [1, 0, 0, 1], ASLToAGL _targPos, 0.5, 0.5, 0, "Weapon target"];
private _dbgMuzzle = _heli modelToWorldVisualWorld (_heli selectionPosition "Usti hlavne");
private _dbgKonec  = _heli modelToWorldVisualWorld (_heli selectionPosition "Konec hlavne");
private _dbgDir    = vectorNormalized (_dbgMuzzle vectorDiff _dbgKonec);
private _dbgEnd    = _dbgMuzzle vectorAdd (_dbgDir vectorMultiply 50);
drawLine3D [ASLToAGL _dbgMuzzle, ASLToAGL _dbgEnd, [1, 0, 0, 1]];
drawIcon3d ["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [1, 1, 0, 1], ASLToAGL _dbgMuzzle, 0.3, 0.3, 0, "Usti hlavne"];
drawIcon3d ["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [0, 1, 1, 1], ASLToAGL _dbgKonec,  0.3, 0.3, 0, "Konec hlavne"];
#endif
