#include "\fza_ah64_sfmplus\functions\rotor\rotor.hpp"

params ["_heli"];

if (!local _heli) exitWith {};

private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";

private _numRotor	   = 2;
private _pivot         = [ [ 0.00,  2.06,  0.000]
                         , [ 0.00, -6.98, -0.075]];
private _rot           = [ [0.0,   0.0, 0.0]
                         , [0.0, 90.0, 0.0]];
private _type          = [ MAIN
                         , TAIL];
private _dir           = [ CCW
                         , CCW];
private _numBlades     = [ 4
                         , 4];
private _numElements   = [ 4.0
                         , 4.0];
private _mastLength    = [ 0.70
                         ,-0.87];
private _gearRatio     = [ 72.291
                         , 14.90];
private _flapTimeConst = [ 2.0
                         , 0.5];
private _delta3        = [ 0.5
                         , 0.5];
private _airfoilTable  = [ getArray (_sfmPlusConfig >> "airfoilTable02")
                         , getArray (_sfmPlusConfig >> "airfoilTable02")];
private _bladeCutout   = [ 1.15
                         , 0.15];
private _bladeLength   = [ 7.315
                         , 1.402];
private _bladeChord    = [ 0.533
                         , 0.253];
private _bladeTwist    = [ -9
                         , -8];
private _bladeMass     = [ 72.108
                         , 5.131];

private _pitchMin      = [ -10
                         ,   0];
private _pitchMid      = [  0
                         ,  0];
private _pitchMax      = [ 20
                         ,  0];
private _rollMin       = [ -10.5
                         ,    0];
private _rollMid       = [  0
                         ,  0];
private _rollMax       = [  7
                         ,  0];
private _collMin       = [  1
                         , -15];
private _collMid       = [  0
                         ,  0];
private _collMax       = [ 19
                         , 27];
private _animSource    = [ "rotorH"
                         , "rotorV"];

for "_rotorIndex" from 0 to (_numRotor - 1) do {
    [ _heli
    , _rotorIndex
    , _pivot         select _rotorIndex
    , _rot           select _rotorIndex
    , _type          select _rotorIndex
    , _dir           select _rotorIndex
    , _numBlades     select _rotorIndex
    , _numElements   select _rotorIndex
    , _mastLength    select _rotorIndex
    , _gearRatio     select _rotorIndex
    , _flapTimeConst select _rotorIndex
    , _delta3        select _rotorIndex
    , _airfoilTable  select _rotorIndex
    , _bladeCutout   select _rotorIndex
    , _bladeLength   select _rotorIndex
    , _bladeChord    select _rotorIndex
    , _bladeTwist    select _rotorIndex
    , _bladeMass     select _rotorIndex
    , _pitchMin      select _rotorIndex
    , _pitchMid      select _rotorIndex
    , _pitchMax      select _rotorIndex
    , _rollMin       select _rotorIndex
    , _rollMid       select _rotorIndex
    , _rollMax       select _rotorIndex
    , _collMin       select _rotorIndex
    , _collMid       select _rotorIndex
    , _collMax       select _rotorIndex
    , _animSource    select _rotorIndex
    ] call fza_sfmplus_fnc_rotor;
};
