/* ----------------------------------------------------------------------------
Function: fza_fnc_aseRLWR


Description:
	Handles the Radar/Laser Warning Receiver

Parameters:
	heli: Object - Vehicle the event handler is assigned to

Returns:
	Nothing

Examples:
    [_heli] call fza_fnc_aseRLWR

Author:
	BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"

params ["_heli"];

private _rlwrPwr     = _heli getVariable "fza_ah64_ase_rlwrPwr";
private _rlwrObjects = [];
private _rlwrCount   = 0;
//If the RLWR is on
if (_rlwrPwr == "on") then {
    //Sensor targets - Lasers, Search
    {
        _x params ["_target", "_type", "_relationship", "_sensor"];
        private _distance_m = _heli distance2d _target;
        //Lasers
        if ("laser" in _sensor) then {
            if (_distance_m <= ASE_LSR_RANGE_M) then {
                _rlwrObjects pushBack [ASE_LSR, _heli getRelDir _target];
            };
        };
        //Search
        if ("passiveradar" in _sensor) then {
            if (_distance_m <= ASE_SRH_RANGE_M) then {
                _rlwrObjects pushBack [ASE_SRH, _heli getRelDir _target];
            };
        };
    } foreach getSensorTargets _heli;

    //Sensor threats - Acquisition, Track and Launch
    {
        _x params ["_object", "_type", "_sensor"];
        private _distance_m = _heli distance2d _object;
        //Acquisition
        if ("marked" in _type) then {
            if (_distance_m <= ASE_ACQ_RANGE_M) then {
                _rlwrObjects pushBack [ASE_ACQ, _heli getRelDir _object];
            };
        };
        //Track
        if ("locked" in _type) then {
            if (_distance_m <= ASE_TRK_RANGE_M) then {
                _rlwrObjects pushBack [ASE_TRK, _heli getRelDir _object];
            };
        };
        //Launch
        //Rhea Missile only currently
        if (["missile_sam_04_fly_f.p3d", str _object] call BIS_fnc_inString) then {
            if (_distance_m <= ASE_LNC_RANGE_M) then {
                _rlwrObjects pushBack [ASE_LNC, _heli getRelDir _object];
            };
        };
    } foreach getSensorThreats _heli;
    _rlwrObjects = [_rlwrObjects, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy;
} else { _rlwrObjects = []; };
_heli setVariable ["fza_ah64_ase_rlwrObjects", _rlwrObjects];
_rlwrCount = count _rlwrObjects;
_heli setVariable ["fza_ah64_ase_rlwrCount", _rlwrCount];