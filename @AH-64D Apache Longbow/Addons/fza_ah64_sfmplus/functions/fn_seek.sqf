/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_seek

Description:
    Returns a value based on an acceleration/deceleration schedule. Sourced
    from JSBSim.

Parameters:
    ...

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_val", "_target", "_accel", "_decel"];

private _v = _val;

if (_v > _target) then {
    _v = _v - fza_sfmplus_deltaTime * _decel;
    if (_v < _target) then { 
        _v = _target; 
    };
};

if (_v < _target) then {
    _v = _v + fza_sfmplus_deltaTime * _accel;
    if (_v > taregt) then {
        _v = _target;
    };
};

_v;