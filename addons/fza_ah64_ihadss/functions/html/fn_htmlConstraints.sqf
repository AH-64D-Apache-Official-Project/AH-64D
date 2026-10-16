/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_htmlConstraints

Description:
    Hellfire constraints box state for the HTML IHADSS, using the same target
    selection as fza_ihadss_fnc_constraintBoxDraw.

Parameters:
    _heli - The helicopter

Returns:
    [azimuth off the nose, elevation off the nose, LOBL, in constraints, allowable angle],
    or [] when there is nothing to show

Examples:
    --- Code
    private _msl = [_heli] call fza_ihadss_fnc_htmlConstraints
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _indicateLobl   = false;
private _vector         = [];
private _allowableAngle = 7.5;
private _useTads        = false;

if (_heli getVariable "fza_ah64_selectedMissile" == "fza_agm114l_wep") then {
    // RF is 20 deg in LOAL and LOBL, 5 deg when tracking a target inside 1 km
    _allowableAngle = 20;
    private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
    if (_sight == SIGHT_TADS) then {
        private _handoffPos  = [0, 0, 0];
        private _handoffData = _heli getVariable ["fza_ah64_tadsRfHandoffData", []];
        private _handoffLast = _heli getVariable ["fza_ah64_tadsRfHandoffLast", []];
        if (_handoffData isEqualType [] && {count _handoffData >= 1}) then {
            _handoffPos = _handoffData # 0;
        } else {
            if (_handoffLast isEqualType [] && {count _handoffLast >= 1}) then {
                _handoffPos = _handoffLast # 0;
            };
        };
        if (_handoffPos isNotEqualTo [0, 0, 0]) then {
            private _loblTarget = _heli getVariable ["fza_ah64_tadsRfHandoffLoblTarget", objNull];
            private _loblValid  = false;
            if (!isNull _loblTarget) then {
                _loblValid = ([_heli, [getPosASL _loblTarget, speed _loblTarget, _loblTarget], true] call fza_hellfire_fnc_arhTargetConstraint) # 1;
            };
            if (_loblValid) then {
                _vector         = _heli worldToModelVisual (ASLToAGL getPosASL _loblTarget);
                _indicateLobl   = true;
                if (_heli distance _loblTarget < 1000) then {_allowableAngle = 5};
            } else {
                _vector = _heli worldToModelVisual (ASLToAGL _handoffPos);
            };
        };
    } else {
        _heli getVariable "fza_ah64_fcrNts" params ["_ntsObj", "_ntsPos"];
        if !isNull _ntsObj then {
            _indicateLobl = ([_heli, [_ntsPos, speed _ntsObj, _ntsObj], true] call fza_hellfire_fnc_arhTargetConstraint) # 1;
            _vector = _heli worldToModelVisual (ASLToAGL _ntsPos);
            if _indicateLobl then {
                _vector = _heli worldToModelVisual (ASLToAGL getPosASL _ntsObj);
                if (_heli distance _ntsObj < 1000) then {_allowableAngle = 5};
            };
        };
    };
} else {
    private _lasePos = [_heli] call fza_hellfire_fnc_salFindLaserDesignation;
    if !isNil "_lasePos" then {
        _vector       = _heli worldToModelVisual (ASLToAGL _lasePos);
        _indicateLobl = true;
    } else {
        if (_heli getVariable "fza_ah64_hellfireTrajectory" == "DIR") then {
            _useTads = true;
        } else {
            _vector = [0, 1, 0];
        };
    };
    if _indicateLobl then {_allowableAngle = 20};
};

private _angles = [];
if _useTads then {
    _angles = [_heli getVariable "fza_ah64_tadsAzimuth", _heli getVariable "fza_ah64_tadsElevation"];
} else {
    if (_vector isNotEqualTo []) then {
        _angles = [(_vector # 0) atan2 (_vector # 1), (_vector # 2) atan2 (_vector # 1)];
    };
};
if (_angles isEqualTo []) exitWith {[]};
_angles set [0, [_angles # 0] call CBA_fnc_simplifyAngle180];

if (_heli ammo (_heli getVariable "fza_ah64_selectedMissile") == 0) then {
    _indicateLobl = false;
};

private _inConstraints = ((abs (_angles # 0)) max (abs (_angles # 1))) < _allowableAngle;

[_angles # 0, _angles # 1, _indicateLobl, _inConstraints, _allowableAngle]
