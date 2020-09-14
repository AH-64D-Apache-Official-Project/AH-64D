_heli = _this select 0;

if ("fza_ah64_rotor_dam" in (_heli magazinesturret[-1]) && alive _heli && (getpos _heli select 2) > 1 && player == driver _heli) then {
    _dir = direction _heli;
    _helipb = _heli call fza_fnc_getPitchBank;
    _pitch = _helipb select 0;
    _bank = _helipb select 1;

    _random1 = (random 10) * 0.1;
    _random2 = (random 10) * -0.1;
    _randomnum = _random1 + _random2;

    _bank = _bank + _randomnum;
    _pitch = _pitch + _randomnum;

    [_heli, _pitch, _bank] call fza_fnc_setPitchBank;

};

/*
if("fza_ah64_rotor_fail" in (_heli magazinesturret [-1]) && alive _heli && (getpos _heli select 2) > 3 && player == driver _heli) then
{
_dir = direction _heli;
_helipb = _heli call fza_fnc_getPitchBank;
_pitch = _helipb select 0;
_bank = _helipb select 1;

_bank = _bank;
_pitch = _pitch - 0.5;

[_heli,_pitch,_bank] call fza_fnc_setPitchBank;

_vel = velocity _heli;

if((_vel select 2) > -10) then
{
_heli setvelocity [(_vel select 0),(_vel select 1),(_vel select 2)-0.5];
};

};
*/

if ("fza_ah64_cdam_tailboom" in (_heli magazinesturret[-1]) && alive _heli && (getpos _heli select 2) > 3 && player == driver _heli) then {
    _dir = direction _heli;
    _helipb = _heli call fza_fnc_getPitchBank;
    _pitch = _helipb select 0;
    _bank = _helipb select 1;

    _random1 = (random 25) * 0.1;

    if (_pitch > 60) then {
        _pitch = _pitch + _random1;
    } else {
        _pitch = _pitch - _random1;
    };

    if (_pitch > 89 || _pitch < -89) exitwith {};

    [_heli, _pitch, _bank] call fza_fnc_setPitchBank;

};