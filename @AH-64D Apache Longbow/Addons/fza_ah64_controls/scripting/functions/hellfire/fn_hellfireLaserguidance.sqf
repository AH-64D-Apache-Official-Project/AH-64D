/* ----------------------------------------------------------------------------
Function: fza_fnc_hellfireLaserguidance

Description:
	Calls the Ace hellfire Guidance Perframe event handler with Desired input
    used in the fired event handler

Parameters:
    _heli - the helicopter

Returns:
	Nothing

Examples:

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_shooter", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];


if (!(_ammo isKindOf "MissileBase")) exitWith {};

if (ace_missileguidance_enabled < 1 || {!local _projectile} ) exitWith {};

if ( !isPlayer _shooter && { ace_missileguidance_enabled < 2 } ) exitWith {};


private _configs = configProperties [(configFile >> "CfgAmmo" >> _ammo), "configName _x == ""ace_missileguidance""", false];
if ((count _configs) < 1) exitWith {};

private _config = configFile >> "CfgAmmo" >> _ammo >> "ace_missileguidance";

private _heli = vehicle _shooter;
private _target = _shooter getVariable ["ace_missileguidance_target", nil];
private _targetPos = _shooter getVariable ["ace_missileguidance_targetPosition", nil];
private _seekerType = _shooter getVariable ["ace_missileguidance_seekerType", nil];
private _lockMode = _shooter getVariable ["ace_missileguidance_lockMode", nil];
private _attackProfile = [_heli] call fza_fnc_getAttackProfile;
private _lasercode = 1111;

if !(isNull laserTarget _heli) then {
    _laserCode = [_heli, "Primary_Alternate", 0] call fza_fnc_getLaserCode;
} else {
    _laserCode = [_heli, "Primary_Alternate", 1] call fza_fnc_getLaserCode;
};

private _laserInfo = [_laserCode #1, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH];

private _launchPos = getPosASL _heli;

if (isNil "_seekerType" || {!(_seekerType in (getArray (_config >> "seekerTypes")))}) then {
    _seekerType = getText (_config >> "defaultSeekerType");
};
if (isNil "_attackProfile" || {!(_attackProfile in (getArray (_config >> "attackProfiles")))}) then {
    _attackProfile = getText (_config >> "defaultAttackProfile");
};
if (isNil "_lockMode" || {!(_lockMode in (getArray (_config >> "seekerLockModes")))}) then {
    _lockMode = getText (_config >> "defaultSeekerLockMode");
};

private _seekLastTargetPos = (getNumber ( _config >> "seekLastTargetPos")) == 1;
private _lastKnownPosState = [_seekLastTargetPos];
if (_seekLastTargetPos && {!isNil "_target"}) then {
    _lastKnownPosState set [1, (getposasl _target)];
} else {
    _lastKnownPosState set [1, [0,0,0]];
};
systemChat str _shooter;
private _args = [_this,
            [   _shooter,
                [_target, _targetPos, _launchPos],
                _seekerType,
                _attackProfile,
                _lockMode,
                _laserInfo
            ],
            [
                getNumber ( _config >> "minDeflection" ),
                getNumber ( _config >> "maxDeflection" ),
                getNumber ( _config >> "incDeflection" )
            ],
            [
                getNumber ( _config >> "seekerAngle" ),
                getNumber ( _config >> "seekerAccuracy" ),
                getNumber ( _config >> "seekerMaxRange" ),
                getNumber ( _config >> "seekerMinRange" )
            ],
            [ diag_tickTime, [], [], _lastKnownPosState]
        ];

private _onFiredFunc = getText (configFile >> "ace_missileguidance_SeekerTypes" >> _seekerType >> "onFired");

if (_onFiredFunc != "") then {
    _args call (missionNamespace getVariable _onFiredFunc);
};

_onFiredFunc = getText (configFile >> "ace_missileguidance_AttackProfiles" >> _attackProfile >> "onFired");
if (_onFiredFunc != "") then {
    _args call (missionNamespace getVariable _onFiredFunc);
};

_onFiredFunc = getText (_config >> "onFired");
if (_onFiredFunc != "") then {
    _args call (missionNamespace getVariable _onFiredFunc);
};
copyToClipboard str _args;
[ace_missileguidance_fnc_guidancePFH, 0, _args ] call CBA_fnc_addPerFrameHandler;


/*
_heli setVariable ["fza_ah64_shotat_list", (_heli getVariable "fza_ah64_shotat_list")+[_target], true];
_heli setVariable ["fza_ah64_shotmissile_list", (_heli getVariable "fza_ah64_shotmissile_list")+[_projectile], true];
private _pfh = "fza_pfh_agm114_helper_" + str _projectile;

[_pfh, "onEachFrame", {
	params["_projectile","_pfh"];

	if(!alive _projectile)exitWith{
		[_pfh, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		_heli setVariable ["fza_ah64_shotat_list", (_heli getVariable "fza_ah64_shotat_list")-[_target, objNull], true];
		_heli setVariable ["fza_ah64_shotmissile_list", (_heli getVariable "fza_ah64_shotmissile_list")-[_projectile, objNull], true];
	};
	
}, [_projectile,_pfh, _heli, _targ]] call BIS_fnc_addStackedEventHandler;