/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_drivetrainNoseGearbox1

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
params ["_heli"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _engPctTq         = _heli getVariable "fza_sfmplus_engPctTQ" select 0;
private _isSingleEng      = _heli getVariable "fza_sfmplus_isSingleEng";
private _grbxHitPtDmg     = _heli getHitPointDamage "hit_drives_noseGearbox1";
private _dmgTimerCont     = _heli getVariable "fza_systems_dmgTimerCont";
private _dmgTimerTrans    = _heli getVariable "fza_systems_dmgTimerTrans";
private _applyDamage      = false;
private _engOverspeed     = false;

private _persistentDmg    = 0.0;
private _dynamicDmgStage1 = 0.0;
private _dynamicDmgStage2 = 0.0;
private _dynamicDmgStage3 = 0.0;

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
    };
};
 
if (_isSingleEng == true) then {
    if (_applyDamage) then {
        //--Dynamic damage
        if (_engPctTq > 1.10) then {
            _dynamicDmgStage1 = (_engPctTq - 1.10) / 10.0;
        };
        if (_engPctTq > 1.22) then {
            _dynamicDmgStage2 = (_engPctTq - 1.22) / 20.0;
        };
        if (_engPctTq > 1.25) then {
            _dynamicDmgStage3 = (_engPctTq - 1.25) / 40.0;
        };
    };
};
//--Persistent damage
if (_grbxHitPtDmg > 0.25) then {
    _persistentDmg = _grbxHitPtDmg / 600.0;
};
if (_grbxHitPtDmg > 0.50) then {
    _persistentDmg = _grbxHitPtDmg / 500.0;
};
if (_grbxHitPtDmg > 0.75) then {
    _persistentDmg = _grbxHitPtDmg / 400.0;
};

private _dmgPerSec = (_persistentDmg + _dynamicDmgStage1 + _dynamicDmgStage2 + _dynamicDmgStage3) * _deltaTime;
private _grbxDmg   = _grbxHitPtDmg + _dmgPerSec;

_heli setHitPointDamage ["hit_drives_noseGearbox1", _grbxDmg];

if (_grbxHitPtDmg == 1.0) then {
    _engOverspeed = true;
    [_heli, "fza_ah64_engineOverspeed", 0, _engOverspeed, true] call fza_fnc_setArrayVariable;
};