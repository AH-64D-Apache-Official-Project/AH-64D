/* ----------------------------------------------------------------------------
Function: fza_fnc_aseJammer

Description:
    jamming of missile if ase page jammer active

Parameters:
    _Heli - The helicopter that fired it
    _munition - Missile
    _Hostile - is it hostile
	
Returns:
	Nothing
	
Examples:
	_this spawn fza_fnc_aseJammer;
	
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */

params ["_Heli","_munition","_Hostile"];

if(!(_munition isKindOf "missileBase") || !(isengineon _Heli || (alive _Heli))) exitwith {};
_Missile = nearestobject [_Hostile,_munition];
if !(MissileTarget _Missile == _Heli) exitwith {};

////stop one of the double event handler Beg
_Counter = _Hostile getVariable ["fza_ah64_shotCounter1", 0];
_Hostile setVariable ["fza_ah64_shotCounter1", (_counter + 1) % 2];
if (_counter % 2 == 1) exitWith {};
////stop one of the double event handler END

//Info Variable
if(!(_Hostile in fza_ah64_threatfiring)) then {fza_ah64_threatfiring = fza_ah64_threatfiring + [_Hostile];};
if (([_Hostile] call fza_fnc_targetIsADA) && !(_Hostile in fza_ah64_targetlist)) then {fza_ah64_targetlist = fza_ah64_targetlist + [_Hostile];};
//Info Variable

//ase page link Beg
if (_Heli getVariable "fza_ah64_aseautopage" == 2) then {
	[_Heli, 1, "ase"] call fza_fnc_mpdSetDisplay;
};
_Seekerhead = getText (configFile >> "CfgAmmo" >> _munition >> "weaponLockSystem");
if (("2" in _seekerhead) && (_Heli getVariable "fza_ah64_irjstate" == 1)) then {
	_irjammerscript = _this spawn fza_fnc_aseHandleIrcontrol;
};
if (("8" in _seekerhead) && (_Heli getVariable "fza_ah64_rfjstate" == 1)) then {
	_rfjammerscript = _this spawn fza_fnc_aseHandleRfcontrol;
};
//ase page link End

_Seekerhead = getText (configFile >> "CfgAmmo" >> _munition >> "weaponLockSystem");
_timer = 1;
while {(MissileTarget _Missile == _Heli) && (alive _Heli)} do {
	if (("2" in _seekerhead) && (_Heli getVariable "fza_ah64_irjstate" == 1) || (_Heli getVariable "fza_ah64_irjon" == 1)) then {
		[vehicle player, "fza_AseIRjammer", [-1]] call BIS_fnc_fire;
		_timer = 1;
	};
	if (("8" in _seekerhead) && (_Heli getVariable "fza_ah64_rfjstate" == 1) || (_Heli getVariable "fza_ah64_rfjon" == 1)) then {
		[vehicle player, "fza_AseRFjammer", [-1]] call BIS_fnc_fire;
		_timer = 0.5;
	};
	sleep _timer;
};

player setammo ["fza_AseIRjammer",999999999];
player setammo ["fza_AseRFjammer",999999999];

sleep 15;
fza_ah64_threatfiring = fza_ah64_threatfiring - [_Hostile];

//auto deploy stop 
if (_Heli getVariable "fza_ah64_rfjstate" == 1) then {_Heli setVariable ["fza_ah64_rfjon", 0, true];};
if (_Heli getVariable "fza_ah64_irjstate" == 1) then {_Heli setVariable ["fza_ah64_irjon", 0, true];};
