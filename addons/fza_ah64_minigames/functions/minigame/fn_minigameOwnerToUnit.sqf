// fza_mg_fnc_minigameOwnerToUnit - finds the player unit currently owned by the given owner id, for CBA_fnc_targetEvent
// targeting (CBA_fnc_targetEvent needs an object/group, not a raw owner id - owner ids are tracked in session state
// instead of unit references because they stay stable across death/respawn). Params: _ownerId. Returns: object or objNull.
params [["_ownerId", -1]];
if (_ownerId == -1) exitWith {objNull};
(allPlayers select {owner _x == _ownerId}) param [0, objNull]
