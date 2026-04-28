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
            // TADS camera angles are already stored by fn_pylonController
            _cannonAzimuth   = _heli getVariable "fza_ah64_tadsAzimuth";
            _cannonElevation = _heli getVariable "fza_ah64_tadsElevation";
        };
        case SIGHT_HMD: {
            // Published per-seat by fn_controller from the local player's machine.
            // worldToModel returns SQF-space: [right, forward, up].
            // Compute azimuth/elevation directly — do NOT use CBA_fnc_vect2Polar because
            // it calls CBA_fnc_vectDir which returns a 0-360 bearing; anything left of
            // the nose would read ~350° and lock the cannon hard-right at the AZ limit.
            private _tPos = (_heli getVariable ["fza_ah64_sightData_" + _authSeat, [[0,0,0],[0,0,0],0,""]]) # 0;
            if !(_tPos isEqualTo [0,0,0]) then {
                private _b = _heli worldToModel (ASLToAGL _tPos); // [right, fwd, up]
                private _mag = vectorMagnitude _b;
                if (_mag > 0.001) then {
                    _cannonAzimuth   = (_b # 0) atan2 (_b # 1); // -180..+180, positive = right
                    _cannonElevation = asin ((_b # 2) / _mag);   // positive = above horizon
                };
            };
        };
        case SIGHT_FCR: {
            private _ntsPos = (_heli getVariable "fza_ah64_fcrNts") # 1;
            if !(_ntsPos isEqualTo [0,0,0]) then {
                private _b = _heli worldToModel (ASLToAGL _ntsPos);
                private _mag = vectorMagnitude _b;
                if (_mag > 0.001) then {
                    _cannonAzimuth   = (_b # 0) atan2 (_b # 1);
                    _cannonElevation = asin ((_b # 2) / _mag);
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

#ifdef __A3_DEBUG__
private _targPos = ((_heli call fza_weapons_fnc_sightData) # 0);
drawIcon3d ["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [1, 0, 0, 1], ASLToAGL _targPos, 0.5, 0.5, 0, "Weapon target"];

// Barrel mem-point debug: draw a line from Usti hlavne (muzzle) through Konec hlavne
// (barrel end) extended 50 m. If the line follows the cannon, the mem points are
// correctly weighted to the otochlaven bone. Red dot = muzzle, line = barrel direction.
private _dbgMuzzle = _heli modelToWorldVisualWorld (_heli selectionPosition "Usti hlavne");
private _dbgKonec  = _heli modelToWorldVisualWorld (_heli selectionPosition "Konec hlavne");
private _dbgDir    = vectorNormalized (_dbgMuzzle vectorDiff _dbgKonec); // Usti - Konec = forward along barrel
private _dbgEnd    = _dbgMuzzle vectorAdd (_dbgDir vectorMultiply 50);
drawLine3D [ASLToAGL _dbgMuzzle, ASLToAGL _dbgEnd, [1, 0, 0, 1]]; // red barrel line
drawIcon3d ["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [1, 1, 0, 1], ASLToAGL _dbgMuzzle, 0.3, 0.3, 0, "Usti hlavne"];
drawIcon3d ["\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa", [0, 1, 1, 1], ASLToAGL _dbgKonec,  0.3, 0.3, 0, "Konec hlavne"];
#endif
