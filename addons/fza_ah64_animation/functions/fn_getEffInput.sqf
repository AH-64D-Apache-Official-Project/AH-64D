/* ----------------------------------------------------------------------------
Function: fza_anim_fnc_getEffInput

Description:
    Replicates the fza_sfmplus_fnc_getInterpInput interpolation used by the
    flight model so animation visuals stay consistent with control positions.

    When input is 0 the model sits at the force-trim position.
    When input is ±1 the model sits at the hard stop.
    Intermediate values lerp between trim and the relevant limit.

Parameters:
    _input  - Raw axis input, normalised -1…+1 [Number]
    _ftTrim - Current force-trim position, normalised -1…+1 [Number]

Returns:
    Effective position, normalised -1…+1 [Number]

Author:
    FZA AH-64D Project
---------------------------------------------------------------------------- */
params ["_input", "_ftTrim"];

if (_input == 0) exitWith { _ftTrim };
_ftTrim + ((if (_input > 0) then { 1.0 } else { -1.0 }) - _ftTrim) * abs _input
