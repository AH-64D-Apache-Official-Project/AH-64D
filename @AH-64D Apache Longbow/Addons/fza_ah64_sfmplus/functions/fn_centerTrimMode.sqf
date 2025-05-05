#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (!(currentPilot _heli == player) || !(local _heli)) exitWith {};

private _cyclicFwdAft    = _heli getVariable "fza_sfmplus_cyclicFwdAft";
private _cyclicLeftRight = _heli getVariable "fza_sfmplus_cyclicLeftRight";
private _pedalLeftRight  = _heli getVariable "fza_sfmplus_pedalLeftRight";

if (fza_sfmplus_cyclicCenterTrimMode) then {
    while {_cyclicFwdAft > CENTER_TRIM_VAL || _cyclicFwdAft < -CENTER_TRIM_VAL} do {
        //systemChat format ["Pitch Locked out! Return Pitch to Center!"];
        _heli setVariable ["fza_sfmplus_flightControlLockOut", true];
    };

    while {_cyclicLeftRight > CENTER_TRIM_VAL || _cyclicLeftRight < -CENTER_TRIM_VAL} do {
        //systemChat format ["Roll Locked out! Return Roll to Center!"];
        _heli setVariable ["fza_sfmplus_flightControlLockOut", true];
    };
};

if (fza_sfmplus_pedalCenterTrimMode) then {
    while {_pedalLeftRight > CENTER_TRIM_VAL || _pedalLeftRight < -CENTER_TRIM_VAL} do {
        //systemChat format ["Yaw Locked out! Return Yaw to Center!"];
        _heli setVariable ["fza_sfmplus_flightControlLockOut", true];
    };
};