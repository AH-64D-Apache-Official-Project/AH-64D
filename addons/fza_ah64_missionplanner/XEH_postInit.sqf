if (!isServer) exitWith {};

// A player who leaves mid-apply would otherwise leave the aircraft's controls locked
addMissionEventHandler ["HandleDisconnect", {
    params ["_unit"];
    {
        _x setVariable ["fza_mplanner_applyingBy", objNull, true];
        _x setVariable ["fza_mplanner_applyUntil", 0, true];
        _x setVariable ["fza_mplanner_rearming", false, true];
        _x setVariable ["bmkhs_inputLockout", false, true];
        // Pylon check and mass for what was done, once the aircraft has a new owner
        [{["fza_mplanner_finish", [_this, false], _this] call CBA_fnc_targetEvent}, _x, 2] call CBA_fnc_waitAndExecute;
    } forEach (vehicles select {(_x getVariable ["fza_mplanner_applyingBy", objNull]) isEqualTo _unit});
    false
}];
