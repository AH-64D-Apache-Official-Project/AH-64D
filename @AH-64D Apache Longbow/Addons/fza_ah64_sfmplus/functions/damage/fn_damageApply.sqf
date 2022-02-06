/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_damageApply

Description:
    Applies damage within a defined period of time after exceeding aircraft
    operating limits. 

Parameters:
	_heli      - The helicopter to get information from [Unit].
    _deltaTime - Passed delta time from core update.

Returns:
    ...

Examples:
    ...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];

if (!local _heli) exitWith {};

private _pctNR         = (_heli getVariable "fza_sfmplus_engPctNP" select 0) max (_heli getVariable "fza_sfmplus_engPctNP" select 1);
private _eng1PctTQ     = _heli getVariable "fza_sfmplus_engPctTQ" select 0;
private _eng2PctTQ     = _heli getVariable "fza_sfmplus_engPctTQ" select 1;
private _engPctTQ      = _eng1PctTQ max _eng2PctTQ;
private _totRtrDmg     = _heli getHit _rtrDmgHitName;
private _isSingleEng   = _heli getVariable "fza_sfmplus_isSingleEng";
private _dmgTimerCont  = _heli getVariable "fza_sfmplus_dmgTimerCont";
private _dmgTimerTrans = _heli getVariable "fza_sfmplus_dmgTimerTrans";


private _applyDamage = false;

if (isEngineOn _heli) then {
    //With the power levers at idle
    if (_pctNR <= 0.50 && _engPctTQ >= 0.30) then {
        _applyDamage = true;
    };

    if (_pctNR <= 0.9 && (_eng1PctTQ >= 0.7 || getpos _heli select 2 > 1)) then {
        _applyDamage = true;
    };
    //With the power levers at fly
    if (_pctNR > 0.9) then {
        if (_isSingleEng == true) then {
            if (_engPctTQ <= 1.10) then {
                _dmgTimerCont  = 0;
                _dmgTimerTrans = 0;
                _heli setVariable ["fza_sfmplus_dmgTimerCont", _dmgTimerCont];
                _heli setVariable ["fza_sfmplus_dmgTimerTrans", _dmgTimerTrans];
            };
            //2.5 min SE contingency
            if (_engPctTQ > 1.10 && _engPctTQ <= 1.22) then {
                _dmgTimerCont = _dmgTimerCont + _deltaTime;
                    
                if (_dmgTimerCont >= 150) then {    //2.5 minutes = 150 sec
                    _dmgTimerCont = 150;
                    _applyDamage = true;
                };

                _heli setVariable ["fza_sfmplus_dmgTimerCont", _dmgTimerCont];
            } else {
                _dmgTimerCont  = 0;
                _heli setVariable ["fza_sfmplus_dmgTimerCont", _dmgTimerCont];
            };
            //6 sec transient
            if (_engPctTQ > 1.22 && _engPctTQ <= 125) then {
                _dmgTimerTrans = _dmgTimerTrans + _deltaTime;
                    
                if (_dmgTimerTrans >= 6) then {    //2.5 minutes = 150 sec
                    _dmgTimerTrans = 6;
                    
                    _applyDamage = true;
                };

                _heli setVariable ["fza_sfmplus_dmgTimerTrans", _dmgTimerTrans];
            } else {
                _dmgTimerTrans  = 0;
                _heli setVariable ["fza_sfmplus_dmgTimerTrans", _dmgTimerTrans];
            };
            if (_engPctTQ > 1.25) then {
                _applyDamage = true;
            };
        } else {
            if (_engPctTQ <= 1.0) then {
                _dmgTimerTrans = 0;
                _heli setVariable ["fza_sfmplus_dmgTimerTrans", _dmgTimerTrans];
            };
            //6 sec transient
            if (_engPctTQ > 1.0 && _engPctTQ <= 1.15) then {
                _dmgTimerTrans = _dmgTimerTrans + _deltaTime;
                
                if (_dmgTimerTrans >= 6) then {
                    _dmgTimerTrans = 6;

                    _applyDamage = true;
                };

                _heli setVariable ["fza_sfmplus_dmgTimerTrans", _dmgTimerTrans];
            };
            if (_engPctTQ > 1.15) then {
                _applyDamage = true;
            };
        };
    };
};

if (_applyDamage) then {
    private _dmg = _totRtrDmg + (_dmgPerSec * _deltaTime);
    _heli setHit ["velka vrtule", _dmg];
}