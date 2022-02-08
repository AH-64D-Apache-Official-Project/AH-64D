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

if (!local _heli) exitWith {}; //Should've also have been run on the local machine
if(!(_munition isKindOf "missileBase") || !(isengineon _heli || (alive _heli))) exitwith {};
private _missile = nearestobject [_hostile,_munition];
if !(missileTarget _missile == _heli) exitwith {}; // Would this ever be true?

if (_missile in fza_ah64_incomingmissiles) exitwith {};
fza_ah64_incomingmissiles pushback _missile;

//Add target info to databases
fza_ah64_threatfiring pushBackUnique vehicle _instigator;
fza_ah64_targetlist pushBackUnique vehicle _instigator;

//ase page link Beg
if (_heli getVariable "fza_ah64_aseautopage" == 2 && _hostile in fza_ah64_asethreatsdraw) then {
    [_heli, 1, "ase"] call fza_fnc_mpdSetDisplay;
};
//ase page link End

_this spawn fza_fnc_aseBetty;

[_heli, _munition, _hostile] spawn {
    params ["_heli", "_munition", "_hostile"];

    private _irjon = _heli getVariable "fza_ah64_irJamOn";
    private _irjstate = _heli getVariable "fza_ah64_irjstate";
    private _rfjon = _heli getVariable "fza_ah64_rfJamOn";
    private _rfjstate = _heli getVariable "fza_ah64_rfjstate";

    private _seekerhead = getNumber (configFile >> "CfgAmmo" >> _munition >> "weaponLockSystem");
    if (_irjstate == 1 && !_irjon) then {
        if (([_seekerhead, 2] call BIS_fnc_bitwiseAND != 0) && (_heli getVariable "fza_ah64_irjstate" == 1)) then {
            [_heli] spawn fza_fnc_aseHandleIrcontrol;
        };
    };

    if (_RFjstate == 1 && !_rfjon) then {   
        if (([_seekerhead, 8] call BIS_fnc_bitwiseAND != 0) && (_heli getVariable "fza_ah64_rfjstate" == 1)) then {
            [_heli] spawn fza_fnc_aseHandleRfcontrol;
        };
    };

    sleep 25;
    
    fza_ah64_threatfiring = fza_ah64_threatfiring - [_hostile];
};