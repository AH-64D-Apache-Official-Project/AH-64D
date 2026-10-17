/* ----------------------------------------------------------------------------
Function: fza_wca_fnc_altitudeLow

Description:
    Plays the "altitude low" audio message below the radar altitude LO
    setting: at LO when it is 10 ft or less, 10% below LO up to 999 ft and
    100 ft below LO from 1000 ft, twice and then not again until the aircraft
    is back above LO. It is armed once the aircraft has been
    above LO since leaving the ground, so it does not sound on the ground or
    while lifting off.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_wca_fnc_altitudeLow
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\bmkhs_helisim\functions\core\core.hpp"
params ["_heli"];

private _lo      = _heli getVariable ["fza_ah64_radAltLo", 33];
private _radAlt  = (_heli getVariable ["bmkhs_radAlt", 0]) * METERS_TO_FEET;
private _powered = (_heli getVariable ["bmkhs_acBusOn", false]) && (_heli getVariable ["bmkhs_dcBusOn", false]);

private _armed = _heli getVariable ["fza_ah64_altLowArmed", false];
if (!_powered || _lo <= 0 || {[_heli] call bmkhs_fnc_stateOnGround}) then {
    _armed = false;
} else {
    if (_radAlt > _lo) then {_armed = true};
};
_heli setVariable ["fza_ah64_altLowArmed", _armed];

private _trigger = switch (true) do {
    case (_lo <= 10):  {_lo};
    case (_lo < 1000): {_lo * 0.9};
    default            {_lo - 100};
};

// Said twice, 2 s apart, then not again until the aircraft is back above LO. Lowest priority, so any warning message takes over.
private _playing = "fza_ah64_altitude_low" in (_heli getVariable ["fza_audio_warning_message", ""]);
private _start   = _heli getVariable ["fza_ah64_altLowStart", -1];
if (_radAlt > _lo) then {_start = -1};
if (_armed && {_radAlt <= _trigger}) then {
    if (_start < 0) then {_start = CBA_missionTime};
    if (CBA_missionTime - _start < 3) then {
        [_heli, -1, "fza_ah64_altitude_low", 2] call fza_audio_fnc_addWarning;
    } else {
        if (_playing) then {[_heli] call fza_audio_fnc_delWarning};
    };
} else {
    if (_playing) then {[_heli] call fza_audio_fnc_delWarning};
};
_heli setVariable ["fza_ah64_altLowStart", _start];
