/* ----------------------------------------------------------------------------
Function: fza_fnc_targetinglockCamToTarget
Description:
    Locks the gunner's TADS to the current target
Parameters:
    _heli - The helicopter to act on
Returns:
    Nothing
Examples:
    --- Code
    [_heli] call fza_fnc_targetingLockCamToTarget 
    ---
Authors:
    AngusLogan02, Rosd6(Dryden), mattysmith22
---------------------------------------------------------------------------- */
params["_heli"];
_tgt = cursorTarget;
if (player != gunner _heli) exitWith {};

_tgt = cursorTarget;

if (isNull (_heli getVariable "fza_ah64_tadsLocked") && !isNull _tgt) then {
    [_heli, "fza_ah64_tadsLocked", _tgt] call fza_fnc_updateNetworkGlobal;
} else {
    [_heli, "fza_ah64_tadsLocked", objNull] call fza_fnc_updateNetworkGlobal;
};

