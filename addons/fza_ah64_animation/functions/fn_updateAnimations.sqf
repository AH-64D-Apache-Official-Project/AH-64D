/* ----------------------------------------------------------------------------
Function: fza_anim_fnc_updateAnimations

Description:
    helps to reduce the network impact of using animations
    by checking if there already of equal value and only sending
    the difference

Parameters:
    _heli      - helicopter object
    _animation - animation source name
    _value     - target value
    _speed     - (optional) animation speed [default: false]

Returns:
    Nothing

Examples:
    [_heli, "animation", 1, 0.1] call fza_anim_fnc_updateAnimations;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_animation", "_value", ["_speed", false]];

private _value = [_value, 3] call BIS_fnc_cutDecimals;
private _currentVal = _heli animationPhase _animation;

if (_currentVal == _value) exitWith {};
_heli animateSource [_animation, _value, _speed];
