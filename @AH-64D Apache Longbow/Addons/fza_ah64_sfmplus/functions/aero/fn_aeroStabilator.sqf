/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_aeroStabilator

Description:
    Creates a stabilator object which automatically schedules as a function of
    collective position and airspeed.

Parameters:
    _heli      - The helicopter to get information from [Unit].
    _deltaTime - Passed delta time from core update.

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_systems\headers\systems.hpp"
params ["_heli", "_deltaTime", "_dryAirDensity"];

private _stabDamage    = _heli getHitPointDamage "hit_stabilator";
private _dcBusOn       = _heli getVariable "fza_systems_dcBusOn";
private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";
private _flightModel   = getText (_cfg >> "fza_flightModel");

if (!local _heli) exitWith {};

private _objCtr  = _heli selectionPosition ["modelCenter", "Memory"];
private _stabPos = _heli getVariable "fza_sfmplus_stabPos";
private _stabPvt = _objCtr vectorAdd _stabPos;

private _stabOutputTable = [[]];
if (_flightModel == "SFMPlus") then {
    private _intStabTable    = [getArray (_sfmPlusConfig >> "stabTable"), fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp;
    _stabOutputTable = [
                         [15.43, _intStabTable select 1]  //30kts
                        ,[36.01, _intStabTable select 2]  //70kts
                        ,[46.30, _intStabTable select 3]  //90kts
                        ,[56.59, _intStabTable select 4]  //110kts
                        ,[61.73, _intStabTable select 5]  //120kts
                        ,[77.17, _intStabTable select 6]  //150kts
                        ];
} else {
    private _intStabTable    = [getArray (_sfmPlusConfig >> "heliSimStabTable"), fza_sfmplus_collectiveOutput] call fza_fnc_linearInterp;
    _stabOutputTable = [
                        [15.43, _intStabTable select 1]   //30kts
                       ,[20.58, _intStabTable select 2]   //40kts
                       ,[25.72, _intStabTable select 3]   //50kts
                       ,[30.87, _intStabTable select 4]   //60kts
                       ,[36.01, _intStabTable select 5]   //70kts
                       ,[41.16, _intStabTable select 6]   //80kts
                       ,[46.30, _intStabTable select 7]   //90kts
                       ,[51.44, _intStabTable select 8]   //100kts
                       ,[56.59, _intStabTable select 9]   //110kts
                       ,[61.73, _intStabTable select 10]  //120kts
                       ,[66.88, _intStabTable select 11]  //130kts
                       ,[72.02, _intStabTable select 12]  //140kts
                       ,[77.17, _intStabTable select 13]  //150kts
                       ,[82.31, _intStabTable select 14]  //160kts
                       ,[87.46, _intStabTable select 15]  //170kts
                       ,[92.60, _intStabTable select 16]  //180kts
                       ,[97.74, _intStabTable select 17]  //190kts
                       ,[102.9, _intStabTable select 18]  //200kts
                       ];
};
    
private _V_mps = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
private _theta = 0.0;
if (_flightModel == "SFMPlus" && fza_ah64_sfmPlusKeyboardOnly) then {
    _theta = getNumber (_sfmPlusConfig >> "stabKeyTheta");
} else {
    _theta = [_stabOutputTable, _V_mps] call fza_fnc_linearInterp select 1;
};

if (_stabDamage >= SYS_STAB_DMG_THRESH || !_dcBusOn) then {
    _theta = _heli getvariable "fza_ah64_stabilatorPosition";
} else {
    _heli setVariable ["fza_ah64_stabilatorPosition",_theta];
};

//Animate the Horizontal stabilizer
_heli animate ["Hstab", _theta];

//Stab coords    |     |
//               |-----|
//    A-------------H-------------B
//    |             |             |
//    E-------------G-------------F
//    |             |             |
//    D-------------I-------------C
private _width  = _heli getVariable "fza_sfmplus_stabWidth";
private _length = _heli getVariable "fza_sfmplus_stabLength";

private _halfWidth = _width / 2;

private _A = _stabPvt vectorAdd [-_halfWidth, 0, 0];
private _B = _stabPvt vectorAdd [ _halfWidth, 0, 0];
private _C = _stabPvt vectorAdd [ _halfWidth, cos _theta * (-_length), sin _theta * _length];
private _D = _stabPvt vectorAdd [-_halfWidth, cos _theta * (-_length), sin _theta * _length];

private _E = (_A vectorAdd _D) vectorMultiply 0.5;
private _F = (_B vectorAdd _C) vectorMultiply 0.5;
private _G = (_E vectorAdd _F) vectorMultiply 0.5;

private _H = (_A vectorAdd _B) vectorMultiply 0.5;
private _I = (_D vectorAdd _C) vectorMultiply 0.5;

private _liftLine  = _E vectorDiff _F;
private _chordLine = _H vectorDiff _I;

private _liftVec = vectorNormalized (_chordLine vectorCrossProduct _liftLine);
_liftVec = _liftVec;

private _stabLine = vectorNormalized _chordLine;
_stabLine = _stabLine;

private _relWind = vectornormalized(_heli vectorWorldToModel (velocity _heli));
_relWind = _relWind;

private _dragVec = vectorNormalized _relWind;

private _AoA = (_relWind # 1 atan2 _relWind # 2) + _theta;
_AoA = [_AoA] call CBA_fnc_simplifyAngle180;

private _intAirfoilTable = [getArray (_sfmPlusConfig >> "stabAirfoilTable"), _AoA] call fza_fnc_linearInterp;
private _CL = _intAirfoilTable select 1;

private _area = [_A, _B, _C, _D] call fza_fnc_getArea;
private _liftForce = _CL * 0.5 * _dryAirDensity * _area * (_V_mps * _V_mps);

private _CD        = _intAirfoilTable select 2;
private _dragForce = _CD * 0.5 * _dryAirDensity * _area * (_V_mps * _V_mps);
private _drag      = _dragVec vectorMultiply (_dragForce * _deltaTime);

private _lift     = _liftVec vectorMultiply (_liftForce * _deltaTime);
private _deltaPos = _G vectorDiff (getCenterOfMass _heli);
private _moment   = _lift vectorCrossProduct _deltaPos;

_heli addForce[_heli vectorModelToWorld _lift, getCenterOfMass _heli];
_heli addForce[_heli vectorModelToWorld _drag, getCenterOfMass _heli];
_heli addTorque (_heli vectorModelToWorld _moment);

#ifdef __A3_DEBUG__
/*
hintsilent format ["Collective Out = %1
                   \nStab Pos = %2
                   \nCollective Low = %3
                   \nCollective High = %4", _collOut, _theta, inputAction "HeliCollectiveLowerCont", inputAction "HeliCollectiveRaiseCont"];
*/
[_heli, _objCtr, _stabPvt, "white"] call fza_fnc_debugDrawLine;

//Draw the stabilator
[_heli, _A, _B, "white"] call fza_fnc_debugDrawLine;
[_heli, _B, _C, "white"] call fza_fnc_debugDrawLine;
[_heli, _C, _D, "white"] call fza_fnc_debugDrawLine;
[_heli, _D, _A, "white"] call fza_fnc_debugDrawLine;
//Draw the fwd chord line originating from the pivot
[_heli, _H, _H vectorAdd _stabLine, "white"] call fza_fnc_debugDrawLine;
//Draw the lift line
[_heli, _E, _F, "green"] call fza_fnc_debugDrawLine;
//Draw the lift vector
[_heli, _G, _G vectorAdd _liftVec, "blue"] call fza_fnc_debugDrawLine;
//Draw the velocity vector
[_heli, _H, _H vectorAdd _relWind, "red"] call fza_fnc_debugDrawLine;
#endif