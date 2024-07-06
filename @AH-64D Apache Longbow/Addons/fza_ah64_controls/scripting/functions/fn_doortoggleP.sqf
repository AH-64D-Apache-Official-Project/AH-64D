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
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _doorPhase = _heli animationphase "pdoor";

if (_doorPhase < 0.5) then {
    _heli animateSource ["pdoor", 1];
    playsound "fza_ah64_rh_dooropen1";
    while {_heli animationPhase "pdoor" != 1} do {
        setCustomSoundController [_heli, "CustomSoundController1", _heli animationPhase "pdoor"];
        sleep 0.001;
    };
};
if (_doorPhase > 0.5) then {
    _heli animateSource ["pdoor", 0];
    while {_heli animationPhase "pdoor" != 0} do {
        setCustomSoundController [_heli, "CustomSoundController1", _heli animationPhase "pdoor"];
        sleep 0.001;
    };
    playsound "fza_ah64_rh_doorclose1";
}; 