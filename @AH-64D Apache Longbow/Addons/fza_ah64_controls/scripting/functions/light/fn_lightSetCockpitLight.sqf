/* ----------------------------------------------------------------------------
Function: fza_fnc_lightSetCockpitLight

Description:
    Sets the cockpit light to the correct state

Parameters:
    _heli - The heli to act upon
    _state - whether the cockpit light should be off. 0 or false for off, 1 or true for on.

Returns:
    Nothing

Examples:
    --- Code
    [_heli, false] call fza_fnc_lightSetCockpitLight;
    //Cockpit light is now off
    ---

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli", "_state"];

private _action = ["searchlightoff", "searchlighton"] select _state;

if !(_heli turretLocal [0]) exitWith {
    _this remoteExec ["fza_fnc_lightSetCockpitLight", _heli turretUnit [0]];
};

//spawn ai when no gunner
if (isnull(_heli turretUnit [0])) then {
    _ai = group player createUnit ["B_RangeMaster_F", [0,0,0], [], 0, "NONE"];
    hideObject _ai;
    _ai moveIngunner _heli;
    (vehicle player turretUnit [0]) action [_action,vehicle player];
    _heli deleteVehicleCrew gunner _heli;
};

(vehicle player turretUnit [0]) action [_action, vehicle player];