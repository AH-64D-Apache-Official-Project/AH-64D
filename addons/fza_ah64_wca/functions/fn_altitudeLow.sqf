/* ----------------------------------------------------------------------------
Function: fza_wca_fnc_altitudeLow

Description:
    Plays the "altitude low" audio message below the radar altitude LO
    setting: at LO when it is 10 ft or less, 10% below LO up to 999 ft and
    100 ft below LO from 1000 ft. It is armed once the aircraft has been
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

// Lowest priority, so any warning message takes over and it resumes once that clears
if (_armed && {_radAlt <= _trigger}) then {
    [_heli, -1, "fza_ah64_altitude_low", 3] call fza_audio_fnc_addWarning;
} else {
    if ("fza_ah64_altitude_low" in (_heli getVariable ["fza_audio_warning_message", ""])) then {
        [_heli] call fza_audio_fnc_delWarning;
    };
};
