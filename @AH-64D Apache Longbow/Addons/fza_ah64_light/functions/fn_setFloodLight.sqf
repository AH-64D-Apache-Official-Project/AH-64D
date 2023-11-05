/* ----------------------------------------------------------------------------
Function: fza_light_fnc_setFloodLight

Description:
    Sets the cockpit light to the correct state

Parameters:
    _heli - The heli to act upon
    _state - whether the cockpit light should be off. 0 or false for off, 1 or true for on.

Returns:
    Nothing

Examples:
    --- Code
    [_heli, false] call fza_light_fnc_setFloodLight;
    //Cockpit light is now off
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli", "_state"];

private _action = ["searchlightoff", "searchlighton"] select _state;

/*if (isnull(_heli turretUnit [0])) exitwith {
    _ai = group player createUnit ["B_RangeMaster_F", [0,0,0], [], 0, "NONE"];
    hideObject _ai;
    _ai moveIngunner _heli;
    _heli action [_action, _heli];
    _heli turretUnit [0] action [_action, _heli];
    _heli deleteVehicleCrew _ai;
    deleteVehicle _ai;
};*/

if (player == driver _heli) exitWith {
    [_action, _heli] remoteExec ["action", _heli turretUnit [0]];
};

_heli action [_action, _heli];