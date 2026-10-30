/* ----------------------------------------------------------------------------
Function: fza_ah64_helisim_fnc_rotorMatch

Description:
    Keeps Arma's own rotor loosely in step with HeliSim's rotor RPM, so the
    engine features that read it, dust and rotor wash, follow the simulation.

    Arma's rotor only knows on and off. It is held back by setting the main
    rotor hitpoint to 0.9, which stops it spinning up but is below the damage
    HeliSim treats as a failed rotor, and released by clearing it again.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing

Examples:
    [_heli] call fza_ah64_helisim_fnc_rotorMatch

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#define MATCH_INTERVAL 0.3
#define MATCH_BAND     0.02
#define MATCH_MAX_RPM  0.9
#define HOLD_DAMAGE    0.9

params ["_heli"];

if (CBA_missionTime < (_heli getVariable ["fza_ah64_helisim_rotorMatchNext", 0])) exitWith {};
_heli setVariable ["fza_ah64_helisim_rotorMatchNext", CBA_missionTime + MATCH_INTERVAL];

//Core holds the rotor stopped itself while everything is off
if (_heli getVariable ["bmkhs_shiftLocked", false]) exitWith {};

//Anything other than the two values set here is real damage, and is left alone
private _damage = [_heli, "mainRotor"] call bmkhs_fnc_damageGet;
if !(_damage in [0, HOLD_DAMAGE]) exitWith {};

private _simRpm  = _heli getVariable ["bmkhs_rtrRpm", 0];
private _armaRpm = (_heli animationPhase "mainRotorRPM") * 0.108;

private _hold = _damage == HOLD_DAMAGE;
if (_simRpm >= MATCH_MAX_RPM) then {
    _hold = false;
} else {
    if (_armaRpm > _simRpm + MATCH_BAND) then {_hold = true};
    if (_armaRpm < _simRpm - MATCH_BAND) then {_hold = false};
};

private _want = [0, HOLD_DAMAGE] select _hold;
if (_want != _damage) then {
    [_heli, "mainRotor", _want] call bmkhs_fnc_damageSet;
};
