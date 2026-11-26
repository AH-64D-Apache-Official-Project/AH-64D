/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_cmdsFire

Description:
    Fires one countermeasure cartridge where the aircraft is local, as BIS_fnc_fire would on
    the turret's owner, without its trip through the server. Needs DC power and a round left,
    and the US chaff armed. A side with no flares left hands the cartridge to the other side.

Parameters:
    _heli     - The helicopter
    _weapon   - Dispenser weapon
    _magazine - Its magazine
    _hidas    - Whether the UK HIDAS is fitted
    _other    - [weapon, magazine] of the other side's flares, or []

Returns:
    Nothing

Examples:
    [_heli, "fza_CMFlareLauncherL", "fza_flare_32L_mag", true, ["fza_CMFlareLauncherR", "fza_flare_32R_mag"]] call fza_ase_fnc_cmdsFire;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_weapon", "_magazine", "_hidas", ["_other", []]];

if (!alive _heli || {!(_heli getVariable ["bmkhs_dcBusOn", false])}) exitWith {};
// HIDAS arming is a UTIL page item, not built: power alone dispenses
if (!_hidas && {_heli getVariable ["fza_ah64_ase_chaffState", ASE_CHAFF_STATE_SAFE] != ASE_CHAFF_STATE_ARM}) exitWith {};

if (_heli magazineTurretAmmo [_magazine, [-1]] < 1) exitWith {
    // Between the other side's own cartridges
    if (_other isNotEqualTo []) then {
        [fza_ase_fnc_cmdsFire, [_heli, _other # 0, _other # 1, _hidas], ASE_CMDS_SHOT_GAP / 2] call CBA_fnc_waitAndExecute;
    };
};

private _firer = _heli turretUnit [-1];
if (isNull _firer) exitWith {};
if !(local _firer) exitWith {[_heli, _weapon, [-1]] call BIS_fnc_fire;};
(weaponState [_heli, [-1], _weapon]) params ["", "", "", ["_loaded", ""], ["_ammo", 0]];
if (_loaded == "" || {_ammo < 1}) exitWith {};
private _mags  = magazinesAllTurrets _heli;
private _index = _mags findIf {_x # 0 == _loaded && {_x # 1 isEqualTo [-1]} && {_x # 2 == _ammo}};
if (_index < 0) exitWith {};
(_mags # _index) params ["", "", "", "_id", "_owner"];
_heli action ["UseMagazine", _heli, _firer, _owner, _id];
