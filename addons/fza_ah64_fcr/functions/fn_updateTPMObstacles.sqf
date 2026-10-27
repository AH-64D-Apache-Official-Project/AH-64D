/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_updateTPMObstacles

Description:
    Keeps the TPM obstacle picture for this machine. Runs every frame from
    fn_controller so the IHADSS C-scope has obstacles whether or not an MPD is
    showing the TPM page. The picture is replaced all at once as each full scan
    cycle completes, the FCR's one cadence.

    Writes (all local):
        fza_ah64_fcrTPMObsDisplay - [[x, y, topASL], ...] obstacles in the picture
        fza_ah64_fcrTPMObsJson    - the same picture as a JSON array of {a, r}
        fza_ah64_fcrTPMObsStamp   - incremented whenever the picture changes

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if ((_heli getVariable "fza_ah64_fcrMode") != FCR_DISP_MODE_TPM) exitWith {};

_heli getVariable "fza_ah64_fcrState" params ["_fcrScanState", "_fcrScanStartTime"];

private _publish = {
    params ["_obsDisplay", "_obsJson"];
    _heli setVariable ["fza_ah64_fcrTPMObsDisplay", _obsDisplay];
    _heli setVariable ["fza_ah64_fcrTPMObsJson",    _obsJson];
    _heli setVariable ["fza_ah64_fcrTPMObsStamp",   (_heli getVariable ["fza_ah64_fcrTPMObsStamp", 0]) + 1];
};

// Obstacles are not presented if FCR data is not valid (fault); a commanded
// clear drops them too. A stopped healthy radar keeps its picture.
private _epoch = _heli getVariable ["fza_ah64_fcrTPMClearEpoch", 0];
if (_fcrScanState == FCR_MODE_FAULT || _epoch != (_heli getVariable ["fza_ah64_fcrTPMObsEpoch", -1])) then {
    _heli setVariable ["fza_ah64_fcrTPMObsEpoch", _epoch];
    _heli setVariable ["fza_ah64_fcrTPMObsCycle", -1];
    if ((_heli getVariable ["fza_ah64_fcrTPMObsDisplay", []]) isNotEqualTo []) then {
        [[], "[]"] call _publish;
    };
};

if !(_fcrScanState in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]) exitWith {};

private _elapsed = CBA_missionTime - _fcrScanStartTime;
if (_elapsed < 0 || { _heli getVariable ["fza_ah64_fcrWaitingForStart", false] }) exitWith {};

[_heli] call fza_fcr_fnc_buildTPMData;

// A scan restart or a sector change starts a fresh cycle: no picture until it completes
private _halfFov  = _heli getVariable ["fza_ah64_fcrTpmHalfFov", 90];
private _cycleIdx = floor (_elapsed / (([_heli] call fza_fcr_fnc_getScanTiming) # 1));
private _prevIdx  = _heli getVariable ["fza_ah64_fcrTPMObsCycle", -1];
private _prevFov  = _heli getVariable ["fza_ah64_fcrTPMObsHalfFov", -1];
_heli setVariable ["fza_ah64_fcrTPMObsCycle",   _cycleIdx];
_heli setVariable ["fza_ah64_fcrTPMObsHalfFov", _halfFov];
if (_prevIdx < 0 || _cycleIdx <= _prevIdx || _halfFov != _prevFov) exitWith {};

private _maxRange   = 2500;
private _heliPos    = getPosASL _heli;
private _heading    = getDir _heli;
private _sensorOff  = _heli selectionPosition ["sensorPos", "Memory"];
private _sensorPos  = [_heliPos # 0, _heliPos # 1, (_heliPos # 2) + ([3, _sensorOff # 2] select (_sensorOff isNotEqualTo [0,0,0]))];
private _clearanceM = ([20, 50, 100, 200] select (_heli getVariable ["fza_ah64_fcrTpmClearance", 1])) * 0.3048;
private _safeHeight = (_heliPos # 2) - _clearanceM;

private _obsDisplay = [];
private _obsParts   = [];
{
    _x params ["_ox", "_oy", ["_oTopZ", 1e9]];
    private _oPos   = [_ox, _oy, 0];
    private _oRange = _heliPos distance2D _oPos;
    private _oAzi   = [(_heliPos getDir _oPos) - _heading] call CBA_fnc_simplifyAngle180;
    if ((abs _oAzi) > _halfFov || _oRange > _maxRange) then { continue; };
    // Only structures penetrating the clearance plane, with radar LOS to their top
    if (_oTopZ < _safeHeight) then { continue; };
    if (terrainIntersectASL [_sensorPos, [_ox, _oy, _oTopZ - 0.5]]) then { continue; };

    _obsParts   pushBack format ['{"a":%1,"r":%2}', _oAzi toFixed 1, (_oRange / _maxRange) toFixed 4];
    _obsDisplay pushBack [_ox, _oy, _oTopZ];
} forEach (_heli getVariable ["fza_ah64_fcrTPMObstacles", []]);

[_obsDisplay, "[" + (_obsParts joinString ",") + "]"] call _publish;
