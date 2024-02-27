/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_PostProccess;

Description:
    cycle the targeting system to the next FCR target

Parameters:
    _heli - the heli to act upon

Returns:
    Nothing
    
Examples:
    [_heli] call fza_fcr_fnc_PostProccess;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli","_scale","_heliCtr"];

private _displayTargets = _heli getvariable "fza_ah64_fcrDisplayTargets";
private _fcrTargets     = _heli getVariable "fza_ah64_fcrTargets";
private _fcrState       = _heli getVariable "fza_ah64_fcrState";
private _lastScanInfo   = _heli getVariable "fza_ah64_fcrLastScan";
Private _fcrMode        = _heli Getvariable "fza_ah64_fcrMode";
_fcrState params ["_fcrScanState", "_fcrScanStartTime"];
private _fcrScanDeltaTime = time - _fcrScanStartTime;
private _scanrelBearing = 0;
private _scanPercentage = 0;
private _eval = {true};
private _posHeli = Getposasl _heli;

//Fcr Bar info
switch (_fcrMode) do {
    case 1: {
        _fcrBearing = [[0, -45],[50, 45],[100, -45]];
        _scanPercentage = (_fcrScanDeltaTime % 3.2) * 31.25;
        _scanrelBearing = ([_fcrBearing, _scanPercentage] call fza_fnc_linearInterp)#1;
        _eval = [{_aziAngle <= _scanrelBearing || _range <= 4000}, {_aziAngle >= _scanrelBearing || _range >= 4000}] select (_scanPercentage <= 50);
    };
    case 2: {
        _scanPercentage = (_fcrScanDeltaTime % 6.4) * 15.625;
        _scanrelBearing = ([_scanPercentage * -3.6] call CBA_fnc_simplifyAngle180);
        _eval = [{_aziAngle < _scanrelBearing || _aziAngle < 0}, {_aziAngle < _scanrelBearing || _aziAngle > 0}] select (_scanPercentage <= 50);
    };
};

{
    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range", "_uiCtr"];
    if ([] call _eval) then {continue;};
    _search = _fcrTargets findif {_x#3 isEqualTo _target;};
    if (_search == -1) then {
        _displayTargets deleteAt _foreachindex;
    } else {
        private _aziAngle = _fcrTargets#_search#4;
        if ([] call _eval) then {
            _displayTargets deleteAt _foreachindex;
        };
    };
} foreach _displayTargets;

{
    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];
    if ([] call _eval) then {continue;};
    _search = _displayTargets findif {_x#3 isEqualTo _target;};
    if (_search != -1) then {
        _displayTargets deleteAt _search;
    };
    private _x = _heliCtr#0 + sin _aziAngle * (_range * _scale);
    private _y = _heliCtr#1 - cos _aziAngle * (_range * _scale);
    private _uiCtr = [_x, _y, 0];
    _displayTargets pushBackunique [_pos, _type, _moving, _target, _aziAngle, _elevAngle, _range, _uiCtr];
} foreach _fcrTargets;

_displayTargets = [_displayTargets, [], {(_x#1 + (((_x#6 * -1) + 8000)* 0.0001))}, "DESCEND"] call BIS_fnc_sortBy;
_heli setvariable ["fza_ah64_fcrDisplayTargets", _displayTargets];

if (_scanPercentage > 95) then {
    private _oldNts = (_heli getVariable "fza_ah64_fcrNts") # 0;
    private _newNtsIndex = _displayTargets findIf {_x # 3 == _oldNts};
    if (_newNtsIndex == -1) then {
        _heli setVariable ["fza_ah64_fcrNts", [_displayTargets # 0 # 3,_displayTargets # 0 # 0], true];
    };
    if(count _displayTargets == 0) then {
        _heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0]], true];
    };
};

hintsilent format ["Relative Bearing =%1
                    \nScan Percent = %2
                    \nDisplay Targets = %3"
                    ,round _scanrelBearing
                    ,round _scanPercentage
                    ,_displayTargets];

_displayTargets;

