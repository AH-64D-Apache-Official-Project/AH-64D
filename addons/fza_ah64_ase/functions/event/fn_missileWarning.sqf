/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_missileWarning

Description:
    Audio & text warning of direction of incoming missile

Parameters:
    _heli: Object - Object the event handler is assigned to
    _munition: String - Ammo type that was fired on the target
    _hostile: Object - Vehicle that fired the weapon. In case of soldier, unit is returned
    _instigator: Object - Person who pulled the trigger
    _missile: Object - the incoming missile
    
Returns:
    Nothing
    
Examples:
    _this spawn fza_ase_fnc_missileWarning;
    
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli","_hostile","_missile"];

if (player != driver _heli && player != gunner _heli) exitWith {};

// Once a missile: the incoming missile event and the MWS both report it
private _announced = (_heli getVariable ["fza_ah64_ase_mslAnnounced", []]) select {alive _x};
if (isNull _missile || {_missile in _announced}) exitWith {};
_heli setVariable ["fza_ah64_ase_mslAnnounced", _announced + [_missile]];
// The MWS reports the missile alone: who fired it, for the voice
if (isNull _hostile) then {_hostile = vehicle ((getShotParents _missile) param [0, objNull]);};
waitUntil {isNull _missile || {_heli distance _missile <= ASE_DETECT_RANGE_M}};
if (isNull _missile) exitWith {};

private _rlwrPwr  = _heli getVariable ["fza_ah64_ase_rlwrPwr", ASE_RLWR_STATE_OFF];
private _mpdLeft  = [_heli, 0] call fza_mpd_fnc_currentPage;
private _mpdright = [_heli, 1] call fza_mpd_fnc_currentPage;
private _theta = _heli getRelDir _missile;
private _dirAud = format ["fza_ah64_bt_%1oclock", [_theta] call fza_ase_fnc_bearingClock];

_heli getVariable ["fza_ah64_ase_irJamState", [ASE_IRJAM_STATE_OFF, 0, 0]] params ["_irJamState"];
if (_irJamState == ASE_IRJAM_STATE_OPER && _heli animationPhase "msn_equip_British" == 1) exitWith {
    [_heli, ASE_MSL, _hostile, "fza_ah64_missile", 0.6, "fza_ah64_missile", 0.6, _dirAud, 0.6] call fza_audio_fnc_addASEMessage;
    if (_mpdLeft != "ase" && _mpdRight != "ase") then {
        [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
    };
};

[_heli, _hostile] call fza_ase_fnc_classification params ["_soundclass"];
private _identity = format ["fza_ah64_bt_%1", _soundclass];
private _seekerhead = getNumber (configOf _missile >> "weaponLockSystem");
if ([_seekerhead, 8] call BIS_fnc_bitwiseAND != 0 && _rlwrPwr == ASE_RLWR_STATE_ON) exitWith {
    [_heli, ASE_LNC, _hostile, _identity, 1, _dirAud, 0.7, "fza_ah64_launch", 0.6] call fza_audio_fnc_addASEMessage;
    if (_mpdLeft != "ase" && _mpdRight != "ase") then {
        [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
    };
};
