/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_tofStart

Description:
    Starts a launched Hellfire's HF TOF countdown (the missile launched first
    shows first, then the others), from its time of flight
    estimated at launch (fza_hellfire_fnc_tofEstimate). Shared, so both crew
    stations count it down.

Parameters:
    _heli - The helicopter
    _tof  - Estimated time of flight (s)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_tof"];

private _list = +(_heli getVariable ["fza_ah64_tofCountDown", []]);
_list pushBack (CBA_missionTime + _tof);
_heli setVariable ["fza_ah64_tofCountDown", _list, true];
