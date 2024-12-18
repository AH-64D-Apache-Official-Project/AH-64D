params ["_heli", ["_addKm", false]];
#include "\fza_ah64_dms\headers\constants.h"
#define SCALE_MPS_KNOTS 1.94
private _waypointIndex = (_heli getVariable "fza_dms_routeNext")#0;
private _waypoint = [_heli, _waypointIndex, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
private _waypointId = _waypointIndex call fza_dms_fnc_pointToString;
private _groundSpeed = vectorMagnitude velocity _heli;
private _groundSpeedStr = (_groundSpeed * SCALE_MPS_KNOTS) toFixed 0;

if (isNil "_waypoint") exitwith {
    [_waypointId, _groundSpeedStr, "", ""];
};

private _distance = (_waypoint distance2D getposasl _heli);
private _distanceStr = (_distance/1000) toFixed 1;

private _etaStr = "";
if (_groundSpeed > 0.05) then {
    private _eta = _distance / _groundSpeed;
    if (_eta < 10*60*60 && _eta >= 5*60) then {
        _etaStr = [_eta / 60, "M:SS"] call CBA_fnc_formatElapsedTime;
    };
    if (_eta < 5*60) then {
        _etaStr = [_eta, "M:SS"] call CBA_fnc_formatElapsedTime;
    };
};

if _addKm then {
    _distanceStr = _distanceStr + "km";
};

[_waypointId, _groundSpeedStr, _distanceStr, _etaStr];