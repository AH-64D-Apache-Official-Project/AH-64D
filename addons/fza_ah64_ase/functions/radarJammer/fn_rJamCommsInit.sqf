/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamCommsInit

Description:
    On each machine with a player: starts the check for radios jammed by an AH-64D's radar
    jammer (fza_ase_fnc_rJamComms) and the scrambling of jammed chat (fza_ase_fnc_rJamChat).

Parameters:
    None

Returns:
    Nothing

Examples:
    call fza_ase_fnc_rJamCommsInit

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
if (!hasInterface) exitWith {};

fza_ase_commsJam     = 0;
fza_ase_commsJammers = [];
fza_ase_commsListAt  = 0;
fza_ase_commsWritten = createHashMap;
fza_ase_commsStatic  = [];
fza_ase_commsStaticTarget = [0, 0, -1e9];
fza_ase_commsStaticBeat   = 0;
fza_ase_commsAcreOn       = false;
fza_ase_commsStaticSeat   = [];
fza_ase_commsStaticMakeUp = 1;
fza_ase_commsMakeUp       = createHashMap;
fza_ase_commsAcreJam = 0;
// One code value, so it can be told apart from another mod's ACRE signal function
fza_ase_commsAcreWrapper = {_this call fza_ase_fnc_rJamAcreSignal};

addMissionEventHandler ["HandleChatMessage", {_this call fza_ase_fnc_rJamChat}];
[{call fza_ase_fnc_rJamComms}, ASE_RJAM_COMMS_INTERVAL] call CBA_fnc_addPerFrameHandler;
