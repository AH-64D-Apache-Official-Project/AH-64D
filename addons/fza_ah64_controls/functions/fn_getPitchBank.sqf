/* ----------------------------------------------------------------------------
Function: fza_fnc_getPitchBank

Description:
    Gets pitch bank of an object

Parameters:
    _obj - obj to get the pitch and bank of

Returns:
    [_pitch, _bank]

Examples:
    --- Code
    _ret = [_heli] call fza_fnc_weaponTurretAim
    //_ret => [30, -20]
    ---

Author:
    general barron
---------------------------------------------------------------------------- */
comment "script by general barron";

private ["_pitch", "_bank", "_sign"];

private _obj = _this;

private _yaw = getDir _obj;


private _rotate = {


    private _v = +(_this select 0);
    private _d = _this select 1;

    private _x = _v select 0;
    private _y = _v select 1;

    _v set [0, (cos _d) * _x - (sin _d) * _y];
    _v set [1, (sin _d) * _x + (cos _d) * _y];


    _v
};


private _vdir = vectorDir _obj;

_vdir = [_vdir, _yaw] call _rotate;

if ((_vdir select 1) != 0) then {
    _pitch = atan((_vdir select 2) / (_vdir select 1));
}
else {
    if ((_vdir select 2) >= 0) then {
        _pitch = 90
    } else {
        _pitch = -90
    };
};

private _vup = vectorUp _obj;


_vup = [_vup, _yaw] call _rotate;

_vup = [_vup select 0] + ([
    [_vup select 1, _vup select 2], 360 - _pitch
] call _rotate);

if ((_vup select 2) != 0) then {
    _bank = atan((_vup select 0) / (_vup select 2));
}
else {
    if ((_vdir select 2) >= 0) then {
        _bank = 90
    } else {
        _bank = -90
    };
};

if ((_vup select 2) < 0) then {
    _sign = [1, -1] select(_bank < 0);
    _bank = _bank - _sign * 180;
};

[_pitch, _bank];
