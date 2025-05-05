params ["_heli"];

if (!(currentPilot _heli == player) || !(local _heli)) exitWith {};

private _cyclicFwdAft    = _heli getVariable "fza_sfmplus_cyclicFwdAft";
private _cyclicLeftRight = _heli getVariable "fza_sfmplus_cyclicLeftRight";
private _pedalLeftRight  = _heli getVariable "fza_sfmplus_pedalLeftRight";

if (fza_sfmplus_cyclicCenterTrimMode) then {
    while {_cyclicFwdAft > 0.01 || _cyclicFwdAft < -0.01} do {
        //systemChat format ["Pitch Locked out! Return Pitch to Center!"];
        _heli setVariable ["fza_sfmplus_flightControlLockOut", true];
    };

    while {_cyclicLeftRight > 0.01 || _cyclicLeftRight < -0.01} do {
        //systemChat format ["Roll Locked out! Return Roll to Center!"];
        _heli setVariable ["fza_sfmplus_flightControlLockOut", true];
    };
};

if (fza_sfmplus_pedalCenterTrimMode) then {
    while {_pedalLeftRight > 0.01 || _pedalLeftRight < -0.01} do {
        //systemChat format ["Yaw Locked out! Return Yaw to Center!"];
        _heli setVariable ["fza_sfmplus_flightControlLockOut", true];
    };
};