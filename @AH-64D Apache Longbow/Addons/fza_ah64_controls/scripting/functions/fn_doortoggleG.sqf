/* ----------------------------------------------------------------------------
Function: fza_fnc_doortoggleG

Description:
    opens/closes the gunner door

Parameters:

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_doortoggleG;
    statement="[this] spawn fza_fnc_doortoggleG";

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _doorPhase = _heli animationphase "gdoor";
private _VolumePassthrough = [[0, 0],[0.1, 0.5],[1, 1]];

if (_doorPhase < 0.5) then {
    _heli animateSource ["gdoor", 1];
    playsound "fza_ah64_rh_dooropen1";
    while {_heli animationPhase "gdoor" != 1} do {
        private _passthrough = ([_VolumePassthrough, _heli animationPhase "gdoor"] call fza_fnc_linearInterp) # 1;
        setCustomSoundController [_heli, "CustomSoundController2", _passthrough];
        sleep 0.001;
    };
};
if (_doorPhase > 0.5) then {
    _heli animateSource ["gdoor", 0];
    while {_heli animationPhase "gdoor" != 0} do {
        private _passthrough = ([_VolumePassthrough, _heli animationPhase "gdoor"] call fza_fnc_linearInterp) # 1;
        setCustomSoundController [_heli, "CustomSoundController2", _passthrough];
        sleep 0.001;
    };
    playsound "fza_ah64_rh_doorclose1";
}; 