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
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli","_munition","_hostile", "_instigator","_missile"];

if !(player == driver _heli || player == gunner _heli) exitwith {};

private _rlwrPwr    = _heli getVariable "fza_ah64_ase_rlwrPwr";
private _irJamState = _heli getVariable "fza_ah64_ase_irJamState";
Private _mpdLeft    = [_heli, 0] call fza_mpd_fnc_currentPage;
Private _mpdright   = [_heli, 1] call fza_mpd_fnc_currentPage;
private _posHeli    = getpos _heli;
private _posInc     = getpos _missile;

private _seekerhead = getNumber (configFile >> "CfgAmmo" >> typeof _missile >> "weaponLockSystem");
private _identity   = format ["fza_ah64_bt_%1", [_hostile] call fza_ase_fnc_adaClassification];

waitUntil {(_heli distance _missile <= ASE_DETECT_RANGE_M);};
private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (_posInc select 0), (_posInc select 1)] call fza_fnc_relativeDirection;
private _dirAud = format ["fza_ah64_bt_%1oclock", [_theta] call fza_fnc_bearingClock];

if (_irJamState == ASE_IRJAM_STATE_OPER && _heli animationPhase "msn_equip_British" == 1) exitWith {
    [_heli, ASE_MSL, _hostile, "fza_ah64_launch", 0.65, "fza_ah64_launch", 0.65, _dirAud, 1.3] call fza_audio_fnc_addASEMessage;
    if !(_mpdLeft == "ase" || _mpdRight == "ase") then {
        [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
    };
};

if ([_seekerhead, 8] call BIS_fnc_bitwiseAND != 0 && _rlwrPwr == "on") exitWith {
    [_heli, ASE_LNC, _hostile, _identity, 1, _dirAud, 1.3, "fza_ah64_launch", 0.65] call fza_audio_fnc_addASEMessage;
    if !(_mpdLeft == "ase" || _mpdRight == "ase") then {
        [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
    };
};