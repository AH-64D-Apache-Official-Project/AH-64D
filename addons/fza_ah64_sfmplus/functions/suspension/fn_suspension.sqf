/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_suspension

Description:
    Updates the suspension system for the helicopter.
    
Parameters:
    _heli            - The helicopter to get information from [Unit].
    _index           - Wheel index identifier [Number].
    _suspensionPos   - Model-space position of the suspension mount point [Array].
    _wheelPosComp    - Model-space wheel position at full compression, relative to suspensionPos [Array].
    _wheelPosNonComp - Model-space wheel position at full extension, relative to suspensionPos [Array].
    _wheelRadius     - Radius of the wheel [Number].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli", "_index", "_suspensionPos", "_wheelPosComp", "_wheelPosNonComp", "_wheelRadius"];

private _grossWeightInKg      = 8006; // 17650 lbs
private _numWheels            = 3;
private _staticSagRatio       = 0.6;
private _criticalDampingRatio = 1.2;

private _suspensionCompLength    = abs (_wheelPosComp    select 2) + _wheelRadius;
private _suspensionNonCompLength = abs (_wheelPosNonComp select 2) + _wheelRadius;
private _maxTravel               = _suspensionNonCompLength - _suspensionCompLength;

private _staticSag       = (_maxTravel * _staticSagRatio) max 0.001;
private _restCompression = _staticSag;

private _sprungMassPerWheel = _grossWeightInKg / _numWheels;
private _stiffness          = (_grossWeightInKg * 9.81) / (_numWheels * _staticSag);

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

private _deltaTime       = _heli getVariable "fza_sfmplus_deltaTime";
private _prevCompression = _heli getVariable "fza_sfmplus_prevCompression" select _index;
private _contactFrames   = _heli getVariable "fza_sfmplus_contactFrames"   select _index;
private _hasLanded       = _heli getVariable "fza_sfmplus_hasLanded"       select _index;

// --- Stability pre-computation -----------------------------------------------
private _dt             = _deltaTime max 0.02;
private _maxStableK     = (2.0 * _sprungMassPerWheel) / (_dt * _dt);
private _stableK        = _stiffness min _maxStableK;
private _stableCritDamp = 2.0 * sqrt(_stableK * _sprungMassPerWheel);
private _stableD        = _criticalDampingRatio * _stableCritDamp;
private _maxCompVel     = _maxTravel / _dt;
private _impulseLimit   = (_sprungMassPerWheel * _maxCompVel) / _dt;
private _maxForce       = (_sprungMassPerWheel * 9.81) min _impulseLimit;
// -----------------------------------------------------------------------------

// --- Raycast -----------------------------------------------------------------
private _rayOffset            = 10;
private _wheelNonCompWorld    = _heli modelToWorld (_suspensionPos vectorAdd _wheelPosNonComp);
private _wheelNonCompWorldASL = AGLToASL _wheelNonCompWorld;

private _rayStart = [
    _wheelNonCompWorldASL select 0,
    _wheelNonCompWorldASL select 1,
    (_wheelNonCompWorldASL select 2) + _rayOffset
];
private _rayEnd = [
    _wheelNonCompWorldASL select 0,
    _wheelNonCompWorldASL select 1,
    (_wheelNonCompWorldASL select 2) - 1000
];

private _intersections = lineIntersectsSurfaces [_rayStart, _rayEnd, _heli, objNull, true, 32, "GEOM", "NONE"];

if (count _intersections == 0) then {
    _intersections = lineIntersectsSurfaces [_rayStart, _rayEnd, _heli, objNull, true, 32, "TERRAIN", "NONE"];
};

// Filter: take the first intersection at or below the ASL wheel center + radius.
private _filterThreshold = (_wheelNonCompWorldASL select 2) + _wheelRadius;
private _intersectPosAsl = [];
{
    private _pt = _x select 0;
    if ((_pt select 2) <= _filterThreshold) exitWith {
        _intersectPosAsl = _pt;
    };
} forEach _intersections;

if (count _intersectPosAsl > 0) then {
    private _distToGround = (_rayStart select 2) - (_intersectPosAsl select 2);
    private _heightAgl    = (_distToGround - _rayOffset) - _wheelRadius;

    private _compression = (0.0 - _heightAgl) max 0.0;
    _compression         = _compression min _maxTravel;

    // Set the hasLanded flag on first contact.
    if (_compression > 0.0 && !_hasLanded) then {
        [_heli, "fza_sfmplus_hasLanded", _index, true, true] call fza_fnc_setArrayVariable;
    };

    // Suppress upward PhysX restitution velocity every frame while any
    // wheel is compressed. Only the upward (positive Z) component is
    // zeroed so horizontal motion from pilot input is fully preserved.
    // This runs on every wheel call but setVelocity is cheap and the
    // redundant calls on W1/W2 are harmless — the last one wins and
    // the value is the same each time since we only touch Z when > 0.05.
    if (_compression > 0.0 && _index == 0) then {
        private _vel    = velocity _heli;
        private _vertVel = _vel select 2;
        if (_vertVel > 0.05) then {
            _heli setVelocity [_vel select 0, _vel select 1, 0];
        };
    };

    [_heli, "fza_sfmplus_contactFrames", _index, _contactFrames + 1, true] call fza_fnc_setArrayVariable;

    private _compressionVel = 0.0;
    private _springForce    = 0.0;
    private _damperForce    = 0.0;
    private _totalForce     = 0.0;

    if (_prevCompression > 0.0) then {
        private _compressionDelta = _compression - _prevCompression;
        if (abs _compressionDelta < _maxTravel) then {
            _compressionVel = _compressionDelta / _dt;
        };
        _compressionVel = _compressionVel min  _maxCompVel;
        _compressionVel = _compressionVel max (-_maxCompVel);
    };

    _springForce = _stableK * _compression;

    // Semi-implicit damping: clamp so damper can never pull down
    // harder than the spring pushes up. Prevents Euler instability.
    _damperForce = (_stableD * _compressionVel) max (-_springForce);

    _totalForce = (_springForce + _damperForce) max 0.0;
    _totalForce = _totalForce min _maxForce;

    _heli addForce [[0, 0, _totalForce], _suspensionPos];

    [_heli, "fza_sfmplus_prevCompression", _index, _compression, true] call fza_fnc_setArrayVariable;

    // --- RPT log: first 10 contact frames per wheel --------------------------
    if (_contactFrames <= 10) then {
        diag_log format [
            "SUSP | CF%1 W%2 | C:%3 Vel:%4 Fs:%5 Fd:%6 Ft:%7 HL:%8 RC:%9 MT:%10",
            _contactFrames,
            _index,
            _compression     toFixed 4,
            _compressionVel  toFixed 3,
            _springForce     toFixed 1,
            _damperForce     toFixed 1,
            _totalForce      toFixed 1,
            _hasLanded,
            _restCompression toFixed 4,
            _maxTravel       toFixed 4
        ];
    };
    // -------------------------------------------------------------------------

} else {
    if ((_heli getVariable "fza_sfmplus_prevCompression" select _index) != 0.0) then {
        [_heli, "fza_sfmplus_prevCompression", _index, 0.0, true] call fza_fnc_setArrayVariable;
    };
    [_heli, "fza_sfmplus_contactFrames", _index, 0, true] call fza_fnc_setArrayVariable;
    [_heli, "fza_sfmplus_hasLanded", _index, false, true] call fza_fnc_setArrayVariable;
};

[_heli, _suspensionPos vectorAdd _wheelPosComp, _wheelRadius, 0] call fza_sfmplus_fnc_suspensionWheel;

#ifdef __A3_DEBUG__
[_heli, _suspensionPos, _suspensionPos vectorAdd _axisX, "red"]   call fza_fnc_debugDrawLine;
[_heli, _suspensionPos, _suspensionPos vectorAdd _axisY, "green"] call fza_fnc_debugDrawLine;
[_heli, _suspensionPos, _suspensionPos vectorAdd _axisZ, "blue"]  call fza_fnc_debugDrawLine;
#endif