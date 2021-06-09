/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusApplyDamage

Description:

Parameters:

Returns:


Examples:


Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"]


/*
[] spawn {  
    run = true;  
 
    _totDmg = 0; 
 
    while {run} do {  
        _heli = vehicle player; 
        _time = ["myTime"] call BIS_fnc_deltaTime; 
        _dps  = 0.033; 
 
        _dmg  = _dps * _time; 
        _totDmg = _totDmg + _dmg; 
         
		if (_totDmg > 1.0) then { 
		_totDmg = 1.0;
		}; 
 
         _heli setHit ["velka vrtule", _totDmg];

        hintSilent format ["Total Damage = %1", _totDmg]; 
 
        sleep 0.1;  
 }  
}
*/