/* ----------------------------------------------------------------------------
Function: fza_fnc_aseJammer

Description:
    jamming of missile if ase page jammer active

Parameters:
    _heli - The helicopter that fired it
    _munition - Missile
    _hostile - is it hostile
	
Returns:
	Nothing
	
Examples:
	_this spawn fza_fnc_aseJammer;
	
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */

params ["_heli","_munition","_hostile"];

if(!(_munition isKindOf "missileBase") || !(isengineon _heli || (alive _heli))) exitwith {};
_missile = nearestobject [_hostile,_munition];
if !(MissileTarget _missile == _heli) exitwith {};

////stop one of the double event handler Beg
_Counter = _hostile getVariable ["fza_ah64_shotCounter1", 0];
_hostile setVariable ["fza_ah64_shotCounter1", (_counter + 1) % 2];
if (_counter % 2 == 1) exitWith {};
////stop one of the double event handler END

//Info Variable
if(!(_hostile in fza_ah64_threatfiring)) then {fza_ah64_threatfiring = fza_ah64_threatfiring + [_hostile];};
if (([_hostile] call fza_fnc_targetIsADA) && !(_hostile in fza_ah64_targetlist)) then {fza_ah64_targetlist = fza_ah64_targetlist + [_hostile];};
//Info Variable

//ase page link Beg
if (_heli getVariable "fza_ah64_aseautopage" == 2) then {
	[_heli, 1, "ase"] call fza_fnc_mpdSetDisplay;
};
_seekerhead = getText (configFile >> "CfgAmmo" >> _munition >> "weaponLockSystem");
if (("2" in _seekerhead) && (_heli getVariable "fza_ah64_irjstate" == 1)) then {
	_irjammerscript = _this spawn fza_fnc_aseHandleIrcontrol;
};
if (("8" in _seekerhead) && (_heli getVariable "fza_ah64_rfjstate" == 1)) then {
	_rfjammerscript = _this spawn fza_fnc_aseHandleRfcontrol;
};
//ase page link End

_seekerhead = getText (configFile >> "CfgAmmo" >> _munition >> "weaponLockSystem");
_timer = 1;
while {(MissileTarget _missile == _heli) && (alive _heli)} do {
	if (("2" in _seekerhead) && (_heli getVariable "fza_ah64_irjstate" == 1) || (_heli getVariable "fza_ah64_irjon" == 1) && (_heli getHitPointDamage "HitLfab" < 0.8)) then {
		[vehicle player, "fza_AseIRjammer", [-1]] call BIS_fnc_fire;
		_timer = 1;
	};
	if (("8" in _seekerhead) && (_heli getVariable "fza_ah64_rfjstate" == 1) || (_heli getVariable "fza_ah64_rfjon" == 1) && (_heli getHitPointDamage "Hitrfab" < 0.8)) then {
		[vehicle player, "fza_AseRFjammer", [-1]] call BIS_fnc_fire;
		_timer = 0.5;
	};
	sleep _timer;
};

player setammo ["fza_AseIRjammer",999999999];
player setammo ["fza_AseRFjammer",999999999];

sleep 15;
fza_ah64_threatfiring = fza_ah64_threatfiring - [_hostile];

//auto deploy stop 
if (_heli getVariable "fza_ah64_rfjstate" == 1) then {_heli setVariable ["fza_ah64_rfjon", 0, true];};
if (_heli getVariable "fza_ah64_irjstate" == 1) then {_heli setVariable ["fza_ah64_irjon", 0, true];};