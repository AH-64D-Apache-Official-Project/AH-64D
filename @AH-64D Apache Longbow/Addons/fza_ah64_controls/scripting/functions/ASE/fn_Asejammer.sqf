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
	Dont call this script, this script is designed to be used by the system, not players in debug
	
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli","_munition","_hostile"];

player setammo ["fza_AseIRjammer",999999999];
player setammo ["fza_AseRFjammer",999999999];

private _irjon = _heli getVariable "fza_ah64_irjon";
private _irjstate = _heli getVariable "fza_ah64_irjstate";
private _Lfab = _heli getHitPointDamage "HitLfab";
private _rfjon = _heli getVariable "fza_ah64_rfjon";
private _rfjstate = _heli getVariable "fza_ah64_rfjstate";
private _rfab = _heli getHitPointDamage "Hitrfab";

//STANDBY jammers
if (_irjstate == 1 && _irjon == 0 && _Lfab < 0.8 || _RFjstate == 1 && _RFjon == 0 && _Rfab < 0.8) then {

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
    
    _rfoper = (_heli getVariable "fza_ah64_rfjon");
    _iroper = (_heli getVariable "fza_ah64_irjon");
    
    //ase page link Beg
    if (_heli getVariable "fza_ah64_aseautopage" == 2 && _hostile in fza_ah64_asethreatsdraw) then {
        [_heli, 1, "ase"] call fza_fnc_mpdSetDisplay;
    };
    _seekerhead = getText (configFile >> "CfgAmmo" >> _munition >> "weaponLockSystem");
    if (("2" in _seekerhead) && (_heli getVariable "fza_ah64_irjstate" == 1)) then {
		if (_heli getVariable "fza_ah64_irjon" == 0) then {
            _irjammerscript = _this spawn fza_fnc_aseHandleIrcontrol;
        };
    };
    if (("8" in _seekerhead) && (_heli getVariable "fza_ah64_rfjstate" == 1)) then {
		if (_heli getVariable "fza_ah64_RFjon" == 0) then {
            _rfjammerscript = _this spawn fza_fnc_aseHandleRfcontrol;
        };
    };
    //ase page link End
    
    //activation delay
    sleep 1.5;

    _seekerhead = getText (configFile >> "CfgAmmo" >> _munition >> "weaponLockSystem");
    //RF Jammer
    if ("8" in _seekerhead) then {
        while {(MissileTarget _missile == _heli) && (alive _heli)} do {
            if ((_heli getVariable "fza_ah64_RFjstate" == 1) && (_heli getHitPointDamage "HitRfab" < 0.8) && (_heli getVariable ["fza_ah64_RFOdeploying", false] == false)) then {
                [vehicle player, "fza_AseRFjammer", [-1]] call BIS_fnc_fire;
                _heli setVariable ["fza_ah64_RFSdeploying", true, true];
            };
            sleep 1;
        };
    };
    _heli setVariable ["fza_ah64_RFSdeploying", false, true];
    //IR Jammer
    if ("2" in _seekerhead) then {
        while {(MissileTarget _missile == _heli) && (alive _heli)} do {
            if ((_heli getVariable "fza_ah64_irjstate" == 1) && (_heli getHitPointDamage "HitLfab" < 0.8) && (_heli getVariable ["fza_ah64_IROdeploying", false] == false)) then {
                [vehicle player, "fza_AseIRjammer", [-1]] call BIS_fnc_fire;
                _heli setVariable ["fza_ah64_IRSdeploying", true, true];
            };
            sleep 1;
        };
    };
    _heli setVariable ["fza_ah64_IRSdeploying", false, true];

    sleep 25;
    fza_ah64_threatfiring = fza_ah64_threatfiring - [_hostile];

    //auto deploy stop 
    if (_heli getVariable "fza_ah64_rfjstate" == 1 && _rfoper == 0) then {_heli setVariable ["fza_ah64_rfjon", 0, true];};
    if (_heli getVariable "fza_ah64_irjstate" == 1 && _iroper == 0) then {_heli setVariable ["fza_ah64_irjon", 0, true];};
};

//IR Operational jammers
if (_irjon == 1 && _Lfab < 0.8) then {
    //activation delay
    sleep 1.5;
    if (_heli getVariable ["fza_ah64_IROdeploying", false] == false) then {
        while {((_heli getVariable "fza_ah64_irjon" == 1) && (_heli getHitPointDamage "HitLfab" < 0.8) && (alive _heli))} do {
            if (_heli getVariable ["fza_ah64_IRSdeploying", false] == false) then {
                [vehicle player, "fza_AseIRjammer", [-1]] call BIS_fnc_fire;
                _heli setVariable ["fza_ah64_IROdeploying", true, true];
            };
            sleep 1;
        };
        _heli setVariable ["fza_ah64_IROdeploying", false, true];
    };
};

//RF Operational jammers
if (_RFjon == 1 && _Rfab < 0.8) then {
    //activation delay
    sleep 1.5;
    if (_heli getVariable ["fza_ah64_RFOdeploying", false] == false) then {
        while {((_heli getVariable "fza_ah64_RFjon" == 1) && (_heli getHitPointDamage "HitRfab" < 0.8) && (alive _heli))} do {
            if (_heli getVariable ["fza_ah64_RFSdeploying", false] == false) then {
                [vehicle player, "fza_AseRFjammer", [-1]] call BIS_fnc_fire;
                _heli setVariable ["fza_ah64_RFOeploying", true, true];
            };
            sleep 0.5;
        };
        _heli setVariable ["fza_ah64_RFOdeploying", false, true];
    };
};
