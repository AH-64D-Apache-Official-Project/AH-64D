/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingSetSightSelect

Description:
    Sets the player's seat's sight to the source specified
    - 0 is FCR
    - 1 is HMD
    - 2 is TADS
    - 3 is FXD

Parameters:
    _heli - The helicopter to act on
    _sight - The sight ID

Returns:
    Nothing

Examples:
    --- Code
    [_heli, 0] call fza_fnc_targetingSetSightSelect
    // The sigght is now 0 (FCR).
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_sight"];

if (player == driver _heli) then {
    _heli setVariable ["fza_ah64_sight_plt", _sight, true];
};
if (player == gunner _heli) then {
    _heli setVariable ["fza_ah64_sight_cpg", _sight, true];
}