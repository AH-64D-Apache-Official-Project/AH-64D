/* ----------------------------------------------------------------------------
Function: fza_ah64_helisim_fnc_cyclicFade

Description:
    Fades the cyclic lift coefficients with collective, down to a floor. The
    coefficients are separate from the collective so the aircraft keeps authority
    in an autorotation, and the floor is what preserves that. Without the fade,
    full authority at taxi power lifts the tail wheel off the ground at about 0.3
    forward cyclic.

    Core reads these from its rotor hashmaps every frame and has no collective
    term of its own, so this sets them ahead of it. Configured by cyclicFade[] in
    helisim_simpleRotor.hpp.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _fade = _heli getVariable ["fza_ah64_helisim_cyclicFade", []];
if (_fade isEqualTo []) then {
    _fade = getArray (configOf _heli >> "BMKHS_HeliSim" >> "cyclicFade");
    _heli setVariable ["fza_ah64_helisim_cyclicFade", _fade];
};
_fade params ["_floorScale", "_collAtFloor", "_collAtFull"];

private _collective = _heli getVariable ["bmkhs_collectiveOutput", 0.0];
private _scale      = linearConversion [_collAtFloor, _collAtFull, _collective, _floorScale, 1.0, true];

{
    //The config's values, kept on the rotor itself: if Core rebuilds its hashmaps, these go
    //with them and are read again from the fresh values.
    private _base = _x getOrDefault ["fza_cyclicLiftCoefs", []];
    if (_base isEqualTo []) then {
        _base = [_x get "pitchLiftCoef", _x get "rollLiftCoef"];
        _x set ["fza_cyclicLiftCoefs", _base];
    };
    _x set ["pitchLiftCoef", (_base select 0) * _scale];
    _x set ["rollLiftCoef",  (_base select 1) * _scale];
} forEach (_heli getVariable ["bmkhs_simpleRotors", []]);
