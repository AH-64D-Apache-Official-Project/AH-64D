/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_tofStart

Description:
    Records a Hellfire launch (MSL LAUNCH, and ALT LAUNCH for the rockets)
    and starts its HFTOF countdown (the missile launched first shows first,
    then the others), from its time of flight estimated at launch
    (fza_hellfire_fnc_tofEstimate). Shared, so both crew stations count it
    down.

Parameters:
    _heli    - The helicopter
    _tof     - Estimated time of flight (s), negative for none
    _laseCue - (optional, default false) The target has to be lased for the
               missile's terminal guidance: LASE NN TRGT

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_tof", ["_laseCue", false]];

// [arrival time, lase cue] per missile
private _list = (_heli getVariable ["fza_ah64_tofCountDown", []]) select {_x isEqualType [] && {(_x # 0) > CBA_missionTime}};
if (_tof >= 0) then {_list pushBack [CBA_missionTime + _tof, _laseCue]};
_heli setVariable ["fza_ah64_tofCountDown", _list, true];
_heli setVariable ["fza_ah64_mslLaunchAt", CBA_missionTime, true];
