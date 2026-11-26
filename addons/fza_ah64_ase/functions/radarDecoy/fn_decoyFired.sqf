/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_decoyFired

Description:
    Chaff fired by a helicopter: each engine-guided radar missile homing on it, and local
    here, gets one roll to turn onto the chaff. Scaled by the helicopter's speed along the
    missile's line of sight, and doubled while its radar jammer transmits.

Parameters:
    Schema of the "firedBIS" event handler.

Returns:
    Nothing

Examples:
    _this call fza_ase_fnc_decoyFired;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\radarDecoy.h"
params ["_heli", "", "", "", ["_ammo", "", [""]], "", ["_projectile", objNull, [objNull]]];

// Every round any helicopter fires comes through here
if (isNil "fza_ase_radarChaffTypes") then {fza_ase_radarChaffTypes = createHashMap;};
private _isChaff = fza_ase_radarChaffTypes get _ammo;
if (isNil "_isChaff") then {
    private _config = configFile >> "CfgAmmo" >> _ammo;
    _isChaff = isClass _config && {getText (_config >> "simulation") == "shotCM"}
        && {([getNumber (_config >> "weaponLockSystem"), 8] call BIS_fnc_bitwiseAND) != 0};
    fza_ase_radarChaffTypes set [_ammo, _isChaff];
};
if (!_isChaff || {isNull _projectile}) exitWith {};

private _log    = missionNamespace getVariable ["fza_ase_radarDebug", false];
if (_log) then {
    diag_log format ["fza_ase radar | chaff fired by %1 (%2) at %3 m/s", typeOf _heli, _ammo, (vectorMagnitude velocity _projectile) toFixed 0];
};
private _chance = ASE_DECOY_CHAFF_CHANCE;
if (CBA_missionTime - (_heli getVariable ["fza_ah64_ase_rJamXmitStamp", -1e9]) < ASE_DECOY_RJAM_STALE) then {
    _chance = _chance * ASE_DECOY_RJAM_MULT;
};
{
    private _missile = configOf _x;
    private _ace     = getNumber (_missile >> "ace_missileguidance" >> "enabled") == 1;
    private _radar   = ([getNumber (_missile >> "weaponLockSystem"), 8] call BIS_fnc_bitwiseAND) != 0;
    if (_log && {_radar}) then {
        diag_log format ["fza_ase radar | chaff from %1: %2 %3 m away, %4, local %5, engine target %6",
            typeOf _heli, typeOf _x, (_x distance _heli) toFixed 0, ["engine-guided", "ACE-guided"] select _ace, local _x, typeOf missileTarget _x];
    };
    if (!local _x || {_ace} || {!_radar} || {missileTarget _x != _heli}) then {continue;};
    private _radial = abs ((velocity _heli) vectorDotProduct ((getPosASLVisual _x) vectorFromTo (getPosASLVisual _heli)));
    private _scale  = linearConversion [ASE_DECOY_CHAFF_SLOW, ASE_DECOY_CHAFF_FAST, _radial, ASE_DECOY_CHAFF_SLOW_MULT, ASE_DECOY_CHAFF_FAST_MULT, true];
    private _taken  = random 1 < _chance * _scale;
    if (_taken) then {_x setMissileTarget _projectile;};
    if (_log) then {
        format ["%1 (engine-guided) %2 by chaff, chance %3", typeOf _x, ["not decoyed", "DECOYED"] select _taken, (_chance * _scale) toFixed 2] call {
            diag_log ("fza_ase radar | " + _this); systemChat ("Radar: " + _this);
        };
    };
} forEach nearestObjects [_heli, ["missilebase"], ASE_DECOY_MISSILE_RANGE];
