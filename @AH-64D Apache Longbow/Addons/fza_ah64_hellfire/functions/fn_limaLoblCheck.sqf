/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_limaLoblCheck

Description:
    A logic path for returning if the Lima hellfire can see the intended target within the given parameters and if it can fire
    
Parameters:
    _seeker - The object who is seeking
    _targ - The target array

Returns:
    [canFire, startLobl]

Examples:
    --- Code
    _results = [_heli, [[0, 0, 0], speed, targ]] call fza_hellfire_fnc_limaLoblCheck;
    ---

---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_seeker", "_targ",["_inFlight", false]];
_targ params ["_targPos", "_targSpeed", "_targObj"];

private _dist = _seeker distance _targPos;
private _seekerConfig = configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance";
private _seekerAngle = getNumber (_seekerConfig >> "seekerAngle");
private _inConstraints = [_seeker, _targPos, _seekerAngle] call fza_hellfire_fnc_checkSeekerAngle;
private _canSee = [_seeker, _targObj, false] call ace_missileguidance_fnc_checkLos || [_seeker, _targObj, true] call ace_missileguidance_fnc_checkLos;

if (_dist <= 500 && _inFlight == false) exitWith {[false, false]};
if (!_inConstraints) exitWith {[false, false]};

if (_targSpeed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH && !_inFlight) exitwith {
    if (_dist >= FCR_LIMIT_MOVING_RANGE || !_canSee) exitwith {
        [false, false]
    };
    [true, true];
};

if (_dist <= FCR_LIMIT_FORCE_LOBL_RANGE) exitwith {
    [_canSee, _canSee];
};

if (_dist <= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) exitwith {
    [true, _canSee];
};

if (_dist <= FCR_LIMIT_STATIONARY_RANGE) exitwith {
    [true, false];
};

[false, false];