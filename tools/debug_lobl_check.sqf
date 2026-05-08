/*
    debug_lobl_check.sqf
    Copy to your mission folder root, then run from the debug console:
        execVM "debug_lobl_check.sqf";

    Finds the vehicle at the centre of your screen and walks through every
    step of fza_hellfire_fnc_arhTargetConstraint + the TADS RF handoff scan
    so you can see exactly which check is failing.
*/

private _heli = vehicle player;

// -----------------------------------------------------------------------
// 1. Resolve target — object under screen centre, fallback to cursorObject
// -----------------------------------------------------------------------
private _targ = objNull;
private _camPos = positionCameraToWorld [0, 0, 0];
private _camDir = vectorNormalized ((screenToWorld [0.5, 0.5]) vectorDiff _camPos);

for "_i" from 1 to 800 do {
    private _pt    = _camPos vectorAdd (_camDir vectorMultiply (_i * 10));
    private _found = nearestObjects [_pt, ["LandVehicle", "StaticWeapon", "Air"], 15] select {
        !(_x isEqualTo _heli) && !(_x isKindOf "Man") && alive _x && (vehicle _x isEqualTo _x)
    };
    if (count _found > 0) exitWith { _targ = _found # 0; };
};
if (isNull _targ) then { _targ = cursorObject; };
if (isNull _targ) exitWith { hint "DEBUG LOBL: No vehicle found at screen centre."; };

// -----------------------------------------------------------------------
// 2. Gather measurements
// -----------------------------------------------------------------------
private _targPos   = getPosASL _targ;
private _targSpeed = speed _targ;
private _dist      = _heli distance _targPos;

private _seekerAngle = getNumber (configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance" >> "seekerAngle");

// -----------------------------------------------------------------------
// 3. Individual checks
// -----------------------------------------------------------------------

// Seeker cone
private _toTarget  = (getPosASL _heli) vectorFromTo _targPos;
private _dot       = (vectorDir _heli) vectorDotProduct _toTarget;
private _inCone    = _dot >= cos _seekerAngle;
private _coneAngle = acos (_dot min 1 max -1);

// LOS
private _canSee = [_heli, _targ, false] call ace_missileguidance_fnc_checkLos
               || [_heli, _targ, true]  call ace_missileguidance_fnc_checkLos;

// Distance bands
private _tooClose     = _dist <= 500;
private _isMoving     = _targSpeed >= 6;
private _inForceLobl  = _dist <= 2000;
private _inLoalSwitch = _dist <= 2500;
private _inStationary = _dist <= 6000;
private _inMoving     = _dist <= 8000;

// Simulate fn_arhTargetConstraint (corrected band order: 2000 before 2500)
private _canFire   = false;
private _startLobl = false;
private _reason    = "UNKNOWN";

if (_tooClose) then {
    _reason = "TOO CLOSE (<= 500 m)";
} else {
    if (!_inCone) then {
        _reason = format ["OUT OF SEEKER CONE — %1 deg off boresight (limit %2 deg)", round (_coneAngle * 10) / 10, _seekerAngle];
    } else {
        if (_isMoving) then {
            if (!_inMoving || !_canSee) then {
                _reason = format ["MOVING — out of range or no LOS. dist=%1 m canSee=%2", round _dist, _canSee];
            } else {
                _canFire = true; _startLobl = true;
                _reason = "MOVING — canFire=true startLOBL=true";
            };
        } else {
            if (_inForceLobl) then {
                _canFire = _canSee; _startLobl = _canSee;
                _reason = format ["<= 2000 m (force LOBL) — canSee=%1 canFire=%2 startLOBL=%3", _canSee, _canFire, _startLobl];
            } else {
                if (_inLoalSwitch) then {
                    _canFire = true; _startLobl = _canSee;
                    _reason = format ["<= 2500 m (LOAL/LOBL switch) — canSee=%1 startLOBL=%2", _canSee, _startLobl];
                } else {
                    if (_inStationary) then {
                        _canFire = true; _startLobl = false;
                        _reason = "<= 6000 m (stationary LOAL) — canFire=true startLOBL=false";
                    } else {
                        _reason = format ["OUT OF RANGE — %1 m > 6000 m", round _dist];
                    };
                };
            };
        };
    };
};

// TADS RF handoff state
private _hdData          = _heli getVariable ["fza_ah64_tadsRfHandoffData", []];
private _hdLast          = _heli getVariable ["fza_ah64_tadsRfHandoffLast", []];
private _handoffFrozen   = (_hdData isEqualType [] && {count _hdData >= 1});
private _handoffPos      = [0,0,0];
if _handoffFrozen then { _handoffPos = _hdData # 0; } else {
    if (_hdLast isEqualType [] && {count _hdLast >= 1}) then { _handoffPos = _hdLast # 0; };
};
private _distFromHandoff = if (_handoffPos isEqualTo [0,0,0]) then {9999} else {_targ distance (ASLToAGL _handoffPos)};
private _inHandoffRadius = _distFromHandoff <= 75;
private _isValidScanType = _targ isKindOf "LandVehicle" || _targ isKindOf "StaticWeapon" || _targ isKindOf "Air";
private _cachedLoblTgt   = _heli getVariable ["fza_ah64_tadsRfHandoffLoblTarget", objNull];

// -----------------------------------------------------------------------
// 4. Report
// -----------------------------------------------------------------------
hint format [
    "=== LOBL DEBUG ===
\nTarget: %1
\nType: %2
\nDist: %3 m  Speed: %4 km/h
\n
\n--- Seeker Cone ---
\nAngle off boresight: %5 deg
\nCone half-angle:     %6 deg
\nIN CONE: %7
\n
\n--- LOS ---
\nCAN SEE: %8
\n
\n--- Constraint Result ---
\ncanFire: %9   startLOBL: %10
\nReason: %11
\n
\n--- TADS RF Handoff ---
\nHandoff frozen: %12
\nDist from handoff pos: %13 m
\nWithin 75m scan radius: %14
\nValid scan type (incl Air): %15
\nCached LOBL target: %16",
    _targ, typeOf _targ,
    round _dist, round _targSpeed,
    round (_coneAngle * 10) / 10, _seekerAngle, _inCone,
    _canSee,
    _canFire, _startLobl, _reason,
    _handoffFrozen,
    round _distFromHandoff, _inHandoffRadius, _isValidScanType,
    str _cachedLoblTgt
];
