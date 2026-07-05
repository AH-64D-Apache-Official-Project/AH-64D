#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _heliPosASL     = getPosASL _heli;
private _currentHalfFov = _heli getVariable ["fza_ah64_fcrTpmHalfFov", 90];
private _maxRange       = 2500;

// Rebuild only when heli has moved >200m — structures don't move
private _lastObsPos = _heli getVariable ["fza_ah64_fcrTPMLastObsPos", [0,0,-9999]];
if (_heliPosASL distance2D _lastObsPos > 200) then {
    _heli setVariable ["fza_ah64_fcrTPMLastObsPos", _heliPosASL];

    private _nearObjs  = nearestObjects [_heliPosASL, ["Building", "PowerLine"], _maxRange];
    private _obstacles = [];
    {
        if (count _obstacles >= 64) exitWith {};
        private _objPos   = getPosASL _x;
        private _objRange = _heliPosASL distance2D _objPos;
        if (_objRange < 100) then { continue; };

        (boundingBoxReal _x) params ["_minBB", "_maxBB"];
        private _structHeight = (_maxBB#2) - (_minBB#2);
        if (_structHeight < 10) then { continue; };

        private _relAzi = [_heli getRelDir _x] call CBA_fnc_simplifyAngle180;
        if ((abs _relAzi) > _currentHalfFov) then { continue; };

        _obstacles pushBack [round (_relAzi * 10) / 10, round _objRange, "TO"];
    } forEach _nearObjs;

    _heli setVariable ["fza_ah64_fcrTPMObstacles", _obstacles];
};
