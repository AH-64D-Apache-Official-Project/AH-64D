/* ----------------------------------------------------------------------------
Function: fza_fnc_hellfireLimaLoblCheck

Description:
    A logic path for returning if the Lima hellfire can see the intended target within the given parameters and if it can fire
    
Parameters:
	_seeker - The object who is seeking
    _targ - The target array

Returns:
    [canFire, startLobl]

Examples:
	--- Code
    _results = [_heli, [[0, 0, 0], FCR_TYPE_UNKNOWN, speed, targ]] call fza_fnc_hellfireLimaLoblCheck;
	---

---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_seeker", "_targ",["_inFlight", false]];
_targ params ["_targPos", "_targType", "_targSpeed", "_targObj"];

private _dist = _seeker distance _targPos;
private _seekerConfig = configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance";
private _seekerAngle = getNumber (_seekerConfig >> "seekerAngle");
private _inConstraints = [_seeker, _targPos, _seekerAngle] call fza_fnc_hellfireCheckSeekerAngle;

if (_dist <= 500 && _inFlight == false) exitWith {[false, false]};
if (!_inConstraints) exitWith {[false, false]};

private _canSee = [_seeker, _targObj, false] call ace_missileguidance_fnc_checkLos
    || [_seeker, _targObj, true] call ace_missileguidance_fnc_checkLos;

if (_targSpeed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH) then {
    if (_dist >= FCR_LIMIT_MOVING_RANGE || !_canSee) then {[false, false]} else {[true, true]};
} else {
    if (_dist <= FCR_LIMIT_FORCE_LOBL_RANGE) then  {
        [_canSee, _canSee];
    } else {
        if (_dist <= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) then {
            [true, _canSee];
        } else {
            if (_dist <= FCR_LIMIT_STATIONARY_RANGE) then {
                [true, false];
            } else {
                [false, false];
            };
        };
    };
};
