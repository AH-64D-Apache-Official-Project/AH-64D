/* ----------------------------------------------------------------------------
Function: fza_fnc_avionicsLoadFactor

Description:
    The aircraft's vertical load factor at the crew, between the PLT and CPG seats,
    averaged over the last 0.25 s. One sample a frame, whoever asks first (the IHADSS
    G readout, the rocket ACCEL LIMIT).

    HeliSim's bodyAccel is the specific force at the CG; the crew sit forward of it, so
    the rotation adds alpha x r (pitch/roll rate changing) and w x (w x r) (centripetal):
        n = (bodyAccel + alpha x r + w x (w x r)) / g
    r is the seat midpoint from the Seats arms in BMKHS_HeliSim, less getCenterOfMass.

    Only the owner solves HeliSim, so a crew station on another machine still reads the
    gmeterZ sound controller.

Parameters:
    _heli - The helicopter

Returns:
    Load factor (G)

Examples:
    --- Code
    [_heli] call fza_fnc_avionicsLoadFactor
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\bmkhs_helisim\functions\core\core.hpp"

private _now     = diag_tickTime;
private _gSamples = (_heli getVariable ["fza_ihadss_gSamples", []]) select {_now - (_x # 0) <= 0.25};
if (_heli getVariable ["fza_ihadss_gSampleFrame", -1] != diag_frameNo) then {
    _heli setVariable ["fza_ihadss_gSampleFrame", diag_frameNo];

    private _nz = if (local _heli) then {
        private _crewPoint = _heli getVariable "fza_ihadss_gCrewPoint";
        if (isNil "_crewPoint") then {
            private _seats = "true" configClasses (configOf _heli >> "BMKHS_HeliSim" >> "Seats");
            _crewPoint = [0, 0, 0];
            {_crewPoint = _crewPoint vectorAdd getArray (_x >> "arm")} forEach _seats;
            _crewPoint = _crewPoint vectorMultiply (1 / (1 max count _seats));
            _heli setVariable ["fza_ihadss_gCrewPoint", _crewPoint];
        };

        private _deltaTime = _heli getVariable "bmkhs_deltaTime";
        private _w         = _heli getVariable "bmkhs_angVelModelSpace";
        private _wPrev     = _heli getVariable ["fza_ihadss_gAngVelPrev", _w];
        _heli setVariable ["fza_ihadss_gAngVelPrev", _w];
        private _alpha = if (_deltaTime > 0.0001) then {(_w vectorDiff _wPrev) vectorMultiply (1 / _deltaTime)} else {[0, 0, 0]};

        private _r     = _crewPoint vectorDiff (getCenterOfMass _heli);
        private _fCrew = (_heli getVariable "bmkhs_bodyAccel")
            vectorAdd (_alpha vectorCrossProduct _r)
            vectorAdd (_w vectorCrossProduct (_w vectorCrossProduct _r));
        (_fCrew # 2) / GRAVITY
    } else {
        _heli getSoundController "gmeterZ"
    };
    _gSamples pushBack [_now, _nz];
};
_heli setVariable ["fza_ihadss_gSamples", _gSamples];
if (_gSamples isEqualTo []) exitWith {1};
private _gSum = 0;
{_gSum = _gSum + (_x # 1)} forEach _gSamples;
_gSum / count _gSamples
