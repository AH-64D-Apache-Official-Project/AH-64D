/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_dataHandling

Description:
    Handling of Data to be revealed by Radar Sweep

Parameters:

Returns:
    Nothing
    
Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli"];

_heli getVariable "fza_ah64_fcrLastScan"    params ["_dir", "_pos", "_time"]; 
_heli getVariable "fza_ah64_fcrState"       params ["_state", "_fcrScanStartTime"]; 
private _displayTargets = _heli getVariable "fza_ah64_fcrTargets";
private _fcrData    = _heli getVariable "fza_ah64_fcrData";
Private _fcrMode    = _heli Getvariable "fza_ah64_fcrMode";

//Condition calulations
private _fcrScanDeltaTime = time - _fcrScanStartTime;
private _scanrelBearing = 0;
private _scanPercentage = 0;
private _eval = {true};
private _lifetime = 1;

//Fcr Bar info
switch (_fcrMode) do {
    case 1: {
        _fcrBearing = [[0, -45],[50, 45],[100, -45]];
        _scanPercentage = (_fcrScanDeltaTime % 3.2) * 31.25;
        _scanrelBearing = ([_fcrBearing, _scanPercentage] call fza_fnc_linearInterp)#1;
        _eval = [{_aziAngle <= _scanrelBearing || _range <= 4000}, {_aziAngle >= _scanrelBearing || _range >= 4000}] select !(_scanPercentage > 50);
    };
    case 2: {
        _scanPercentage = (_fcrScanDeltaTime % 6.4) * 15.625;
        _scanrelBearing = ([_scanPercentage * -3.6] call CBA_fnc_simplifyAngle180);
        _eval = [{_aziAngle < _scanrelBearing || _aziAngle < 0}, {_aziAngle < _scanrelBearing || _aziAngle > 0}] select !(_scanPercentage > 50);
    };
};

{
    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];
    if !(call _eval) then {
        _search = _displayTargets findif {_x#3 isEqualTo _target;};
        if (_search != -1) exitwith {
            _displayTargets set [_search, [_pos, _type, _moving, _target, _aziAngle, _elevAngle, _range, _lifetime]];   //Update existing targets 
        };
        _search = _displayTargets findif {(_x#1 + (((_x#6 * -1) + 8000)* 0.0001)) < (_type + (((_range * -1) + 8000)* 0.0001))};  
        _displayTargets insert [_search, [[_pos, _type, _moving, _target, _aziAngle, _elevAngle, _range, _lifetime]]];  //insert new targets into correctly sorted position
    };
} foreach _fcrData;

{
    _x params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range","_remaininglife"];
    if ([] call _eval) then {continue;};
    _search = _fcrData findif {_x#3 isEqualTo _target;};
    if (_search == -1) then {
        if (_remaininglife <= 0) exitwith {
            _displayTargets deleteAt _foreachindex;
        };
        _displayTargets set [_search, [_pos, _type, _moving, _target, _aziAngle, _elevAngle, _range, (_remaininglife - 1)]];
    };
    //possibly a need for data validation to remove any remaining target tracks not checked
} foreach _displaytargets;

//private _displayTargets = [_displayTargets, [], {(_x#1 + (((_x#6 * -1) + 8000)* 0.0001))}, "DESCEND"] call BIS_fnc_sortBy;

_heli setvariable ["fza_ah64_fcrTargets", _displayTargets];

/*
hintsilent format ["Relative Bearing =%1
                    \nScan Percent = %2
                    \nDisplay Targets = %3"
                    ,round _scanrelBearing
                    ,round _scanPercentage
                    ,_displayTargets];*/