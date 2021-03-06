/* ----------------------------------------------------------------------------
Function: fza_fnc_doortoggleP

Description:
     opens/closes the pilot door

Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_doortoggleP;
    statement="[this] spawn fza_fnc_doortoggleP";

Author:
    Unknown
---------------------------------------------------------------------------- */
_heli = _this select 0;

if (_heli animationphase "pdoor" < 0.5) then {
    _heli animateSource["pdoor", 1];
    playsound "fza_ah64_rh_dooropen1";
};
if (_heli animationphase "pdoor" > 0.5) then {
    _heli animateSource["pdoor", 0];
    waituntil {
        (_heli animationphase "pdoor" < 0.1);
    };
    playsound "fza_ah64_rh_doorclose1";
}; 