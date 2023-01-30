/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_drivetrainTransmission

Description:
	Updates all of the modules core functions.
	
Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];
#include "\fza_ah64_systems\headers\systems.hpp"

if (!local _heli) exitWith {};

private _eng1PctTQ     = _heli getVariable "fza_sfmplus_engPctTQ" select 0;
private _eng2PctTQ     = _heli getVariable "fza_sfmplus_engPctTQ" select 1;
private _engPctTQ      = _eng1PctTQ max _eng2PctTQ;
private _isSingleEng   = _heli getVariable "fza_sfmplus_isSingleEng";
private _totXmsnDmg    = _heli getHitPointDamage "hit_drives_transmission";
private _dmgTimerCont  = _heli getVariable "fza_systems_dmgTimerCont";
private _dmgTimerTrans = _heli getVariable "fza_systems_dmgTimerTrans";
private _applyDamage   = false;

if (isEngineOn _heli) then {
    if (_isSingleEng == true) then {
        if (_engPctTQ <= 1.10) then {
            _dmgTimerCont  = 0;
            _dmgTimerTrans = 0;
            _heli setVariable ["fza_systems_dmgTimerCont",  _dmgTimerCont];
            _heli setVariable ["fza_systems_dmgTimerTrans", _dmgTimerTrans];
        };
        //2.5 min SE contingency
        if (_engPctTQ > 1.10 && _engPctTQ <= 1.22) then {
            _dmgTimerCont = _dmgTimerCont + _deltaTime;
                    
            if (_dmgTimerCont >= 150) then {    //2.5 minutes = 150 sec
                _dmgTimerCont = 150;
                _applyDamage = true;
            };

            _heli setVariable ["fza_systems_dmgTimerCont", _dmgTimerCont];
        } else {
            _dmgTimerCont  = 0;
            _heli setVariable ["fza_systems_dmgTimerCont", _dmgTimerCont];
        };
        //6 sec transient
        if (_engPctTQ > 1.22 && _engPctTQ <= 125) then {
            _dmgTimerTrans = _dmgTimerTrans + _deltaTime;
            if (_dmgTimerTrans >= 6) then {
                _dmgTimerTrans = 6;
                    
                _applyDamage = true;
            };
            _heli setVariable ["fza_systems_dmgTimerTrans", _dmgTimerTrans];
        } else {
            _dmgTimerTrans  = 0;
            _heli setVariable ["fza_systems_dmgTimerTrans", _dmgTimerTrans];
        };
        if (_engPctTQ > 1.25) then {
            _applyDamage = true;
        };
    } else {
        if (_engPctTQ <= 1.0) then {
            _dmgTimerTrans = 0;
            _heli setVariable ["fza_systems_dmgTimerTrans", _dmgTimerTrans];
        };
        //6 sec transient
         if (_engPctTQ > 1.0 && _engPctTQ <= 1.15) then {
            _dmgTimerTrans = _dmgTimerTrans + _deltaTime;
                
            if (_dmgTimerTrans >= 6) then {
                _dmgTimerTrans = 6;

                _applyDamage = true;
            };

            _heli setVariable ["fza_systems_dmgTimerTrans", _dmgTimerTrans];
        };
        if (_engPctTQ > 1.15) then {
            _applyDamage = true;
        };
    };
};

if (_applyDamage) then {
    private _dmg = _totXmsnDmg + (DMG_PER_SEC * _deltaTime);
    _heli setHitPointDamage ["hit_drives_transmission", _dmg];
};

if (_totXmsnDmg == 1.0) then {
    _heli setHitPointDamage ["hithrotor",           1.0];
    _heli setHitPointDamage ["hitvrotor",           1.0];
    _heli setHitPointDamage ["hit_elec_generator1", 1.0];
    _heli setHitPointDamage ["hit_elec_generator2", 1.0];
    _heli setHitPointDamage ["hit_hyd_priPump",     1.0];
    _heli setHitPointDamage ["hit_hyd_utilPump",    1.0];
};