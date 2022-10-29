/* ----------------------------------------------------------------------------
Function: fza_fnc_hellfireLimaPrelaunch

Description:
    Defines what the radar can see. Can either be given a 

Parameters:
	_seeker - The object who is seeking
    _targ - The target array

Returns:
    [canFire, startLobl]

Examples:
	--- Code
    [_heli, [[0, 0, 0], FCR_TYPE_UNKNOWN, 60, targ]] call fza_fnc_hellfireLimaPrelaunch
	---

---------------------------------------------------------------------------- */
params ["_seeker", "_targ"];

_targ params ["_targPos", "", "_targSpeed", "_targObj"]

private _dist = _seeker distance _targPos;
private _inConstraints = [_seeker, _targObj, _seekerAngle] call ace_missileguidance_checkSeekerAngle

if (_dist < 500) exitWith {[false, false]};
if (!_inConstraints) exitWith {[false, false]};

private _canSee = [_seeker, _targObj, false] call ace_missileguidance_fnc_checkLos
    || [_seeker, _targObj, true] call ace_missileguidance_fnc_checkLos;

if (_targSpeed > FCR_LIMIT_MOVING_MIN_SPEED_KMH) then {
    if (_dist > FCR_LIMIT_MOVING_RANGE || !_canSee) then {[false, false]} else {[true, true]};
} else {
    if (_dist < FCR_LIMIT_STATIONARY_FORCE_LOBL_RANGE) then  {
        [_canSee, _canSee];
    } else {
        if (_dist < FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) then {
            [true, _canSee];
        } else {
            if (_dist < FCR_LIMIT_STATIONARY_RANGE) then {
                [true, false];
            } else {
                [false, false];
            };
        };
    };
};