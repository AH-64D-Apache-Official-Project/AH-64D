/* ----------------------------------------------------------------------------
Function: fza_fnc_updateAnimations

Description:
    helps to reduce the network impact of using animations
    by checking if there already of equal value and only sending
    the difference

Parameters:
    ...

Returns:
    ...

Examples:
    [_heli, "animation", 1, 0.1] call fza_fnc_updateAnimations;
    
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_animation", "_value", ["_speed", false]];

private _value = [_value, 3] call BIS_fnc_cutDecimals;
private _currentVal = _heli animationPhase _animation;

if (_currentVal == _value) exitwith {};
_heli animateSource [_animation, _value, _speed];