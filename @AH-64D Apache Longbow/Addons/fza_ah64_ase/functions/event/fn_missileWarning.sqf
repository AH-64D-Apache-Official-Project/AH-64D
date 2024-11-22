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

if (player != driver _heli && player != gunner _heli) exitwith {};

_Counter = _heli getVariable ["fza_ah64_ASEAudiocounter", 0];
_heli setVariable ["fza_ah64_ASEAudiocounter", (_counter + 1) % 2];
if (_counter % 2 == 1) exitwith {};
waitUntil {(_heli distance _missile <= ASE_DETECT_RANGE_M);};

private _rlwrPwr  = _heli getVariable "fza_ah64_ase_rlwrPwr";
private _mpdLeft  = [_heli, 0] call fza_mpd_fnc_currentPage;
private _mpdright = [_heli, 1] call fza_mpd_fnc_currentPage;
private _theta = _heli getRelDir _missile;
private _dirAud = format ["fza_ah64_bt_%1oclock", [_theta] call fza_fnc_bearingClock];

_heli getVariable "fza_ah64_ase_irJamState" params ["_irJamState"];
if (_irJamState == ASE_IRJAM_STATE_OPER && _heli animationPhase "msn_equip_British" == 1) exitWith {
    [_heli, ASE_MSL, _hostile, "fza_ah64_launch", 0.6, "fza_ah64_launch", 0.6, _dirAud, 1] call fza_audio_fnc_addASEMessage;
    if (_mpdLeft != "ase" && _mpdRight != "ase") then {
        [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
    };
};

[_heli, _hostile] call fza_ase_fnc_classification params ["_soundclass"];
private _seekerhead = getNumber (configFile >> "CfgAmmo" >> typeof _missile >> "weaponLockSystem");
if ([_seekerhead, 8] call BIS_fnc_bitwiseAND != 0 && _rlwrPwr == ASE_RLWR_STATE_ON) exitWith {
    [_heli, ASE_LNC, _hostile, _soundclass, 1, _dirAud, 1.3, "fza_ah64_launch", 0.6] call fza_audio_fnc_addASEMessage;
    if (_mpdLeft != "ase" && _mpdRight != "ase") then {
        [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
    };
};