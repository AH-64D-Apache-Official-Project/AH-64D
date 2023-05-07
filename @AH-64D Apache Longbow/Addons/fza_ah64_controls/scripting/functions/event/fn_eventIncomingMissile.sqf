/* ----------------------------------------------------------------------------
Function: fza_fnc_eventIncomingMissile

Description:
    Event handler that handles the ASE system's reaction to incoming missiles

Parameters:
    _heli: Object - Object the event handler is assigned to
    _munition: String - Ammo type that was fired on the target
    _hostile: Object - Vehicle that fired the weapon. In case of soldier, unit is returned
    _instigator: Object - Person who pulled the trigger
    
Returns:
    Nothing
    
Examples:
    _this call fza_fnc_aseJammer; //Incoming missile event args
    
Author:
    Rosd6(Dryden), mattysmith22
---------------------------------------------------------------------------- */
params ["_heli","_munition","_hostile", "_instigator"];

if(!(_munition isKindOf "missileBase") || !(isengineon _heli || (alive _heli))) exitwith {};
private _missile = nearestobject [_hostile,_munition];

[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;

_Counter = _heli getVariable ["fza_ah64_ASEAudiocounter", 0];
_heli setVariable ["fza_ah64_ASEAudiocounter", (_counter + 1) % 2];
if (_counter % 2 == 1) exitwith {};

_this spawn fza_ase_fnc_missileWarning;