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
private _VolumePassthrough = [[0, 0],[0.1, 0.5],[1, 1]];

if (_doorPhase < 0.5) then {
    _heli animateSource ["pdoor", 1];
    playsound "fza_ah64_rh_dooropen1";
    while {_heli animationPhase "pdoor" != 1} do {
        private _passthrough = ([_VolumePassthrough, _heli animationPhase "pdoor"] call fza_fnc_linearInterp) # 1;
        setCustomSoundController [_heli, "CustomSoundController1", _passthrough];
        sleep 0.001;
    };
};
if (_doorPhase > 0.5) then {
    _heli animateSource ["pdoor", 0];
    while {_heli animationPhase "pdoor" != 0} do {
        private _passthrough = ([_VolumePassthrough, _heli animationPhase "pdoor"] call fza_fnc_linearInterp) # 1;
        setCustomSoundController [_heli, "CustomSoundController1", _passthrough];
        sleep 0.001;
    };
    playsound "fza_ah64_rh_doorclose1";
}; 