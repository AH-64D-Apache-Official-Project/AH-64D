/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamChat

Description:
    HandleChatMessage: a player's chat on any channel is scrambled at the stronger of the
    sender's and this player's radio jamming (fza_ase_fnc_rJamComms), on every machine,
    the sender's included.

Parameters:
    The HandleChatMessage mission event's parameters

Returns:
    String - the scrambled message, or nothing to leave it as it is

Examples:
    addMissionEventHandler ["HandleChatMessage", {_this call fza_ase_fnc_rJamChat}]

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["", "", "", ["_text", "", [""]], ["_person", objNull, [objNull]], "", "", "", "", "", ["_chatMessageType", 0, [0]]];

if (isNull _person || {_chatMessageType != 0} || {_text isEqualTo ""}) exitWith {nil};

private _strength = (_person getVariable ["fza_ah64_commsJam", 0]) max (missionNamespace getVariable ["fza_ase_commsJam", 0]);
if (_strength <= 0) exitWith {nil};

private _noise = toArray "#$%&*@!?~^+=/";
private _chars = toArray _text;
{
    if (_x != 32 && {random 1 < _strength}) then {_chars set [_forEachIndex, selectRandom _noise];};
} forEach _chars;
toString _chars
