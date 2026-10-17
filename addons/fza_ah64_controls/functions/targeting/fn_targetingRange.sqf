/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingRange

Description:
    The range the weapons processor uses for a crew station, from its
    selected range source. The last selected source stays in use; while it
    cannot give a range the crew station's default range is used.

    Laser    - *XXXX m while that station lases, XXXX m after, 500-9999 m; under
               500 m there is no laser range and nothing is shown
    Radar    - RX.X km to the NTS, selected by a new NTS with FCR as the sight
    Nav      - NXX.X km to a coordinate point
    Manual   - MXX.X km, entered on the WPN page
    Auto     - AXX.X km, the selected sight LOS against zero radar altitude
    Default  - 3.0 km CPG, 1.5 km pilot

    Manual and auto range with every sight; TADS also with laser and nav, FCR
    with radar (R?? without a valid radar range), HMD with nav. In cooperative
    rockets the pilot uses the CPG's range.

Parameters:
    _heli - The helicopter
    _seat - The crew station, "plt"/"cpg" or a crew unit

Returns:
    [range (m), HAD text, RANGE_SRC_* in use]

Examples:
    --- Code
    ([_heli, player] call fza_fnc_targetingRange) params ["_range", "_text", "_source"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_seat"];

_seat = [_heli, _seat] call fza_fnc_getSeat;
if (isNil "_seat") exitWith {[RANGE_DEFAULT_CPG, "3.0", RANGE_SRC_DEFAULT]};

// Cooperative rockets: rockets actioned with the pilot firing and a CPG aboard; the CPG's LOS and range are used
if (_seat == "plt" && {(_heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE]) == WAS_WEAPON_RKT && {isManualFire _heli && {isPlayer gunner _heli}}}) then {
    _seat = "cpg";
};

private _km      = {(_this / 1000) toFixed 1};
private _default = [RANGE_DEFAULT_CPG, RANGE_DEFAULT_PLT] select (_seat == "plt");
private _sight   = [_heli, "fza_ah64_sight", _seat] call fza_fnc_getSeatVariable;
if (isNil "_sight") then {_sight = SIGHT_HMD};
(_heli getVariable ["fza_ah64_rangeSrc_" + _seat, [RANGE_SRC_DEFAULT, 0]]) params ["_source", "_value"];


// Sources each sight can range with; any other uses the default
private _allowed = switch (_sight) do {
    case SIGHT_TADS: {[RANGE_SRC_LASER, RANGE_SRC_NAV, RANGE_SRC_MANUAL, RANGE_SRC_AUTO]};
    case SIGHT_FCR:  {[RANGE_SRC_RADAR, RANGE_SRC_MANUAL, RANGE_SRC_AUTO]};
    default          {[RANGE_SRC_NAV, RANGE_SRC_MANUAL, RANGE_SRC_AUTO]};
};
if !(_source in _allowed) then {_source = RANGE_SRC_DEFAULT};

private _heliPos = getPosASL _heli;
private _result  = switch (_source) do {
    case RANGE_SRC_LASER: {
        if (!isNull laserTarget _heli && {(_heli getVariable ["fza_ah64_laserSeat", "cpg"]) == _seat}) then {
            private _range = round ((_heli distance laserTarget _heli) min RANGE_LASER_MAX);
            [[_default, ""], [_range, "*" + str _range]] select (_range >= RANGE_LASER_MIN)
        } else {
            [[], [_value, str round (_value min RANGE_LASER_MAX)]] select (_value >= RANGE_LASER_MIN)
        };
    };
    case RANGE_SRC_RADAR: {
        (_heli getVariable ["fza_ah64_fcrNts", [objNull, [0, 0, 0]]]) params [["_nts", objNull], ["_ntsPos", [0, 0, 0]]];
        if (isNull _nts || {_ntsPos isEqualTo [0, 0, 0]}) then {[]} else {
            private _range = _heliPos distance _ntsPos;
            [_range, "R" + ((_range min 9900) call _km)]
        };
    };
    case RANGE_SRC_NAV: {
        if (_value isEqualTypeArray [0, 0, 0]) then {
            private _range = _heliPos distance _value;
            [[], [_range, "N" + ((_range max 100) call _km)]] select (_range <= RANGE_NAV_MAX)
        } else {[]};
    };
    case RANGE_SRC_MANUAL: {
        [[], [_value, "M" + (_value call _km)]] select (_value > 0)
    };
    case RANGE_SRC_AUTO: {
        private _unit = [driver _heli, gunner _heli] select (_seat == "cpg");
        private _dir  = switch (_sight) do {
            case SIGHT_TADS: {[_heli, "TADS"] call fza_fnc_targetingAcqVec};
            // The local crew's head LOS from the camera; eyeDirection does not follow the head in a vehicle
            case SIGHT_HMD:  {
                switch (true) do {
                    case (_unit == player): {getCameraViewDirection player};
                    case (isNull _unit):    {_heli vectorModelToWorldVisual [0, 1, 0]};
                    default                 {eyeDirection _unit};
                };
            };
            case SIGHT_FCR:  {
                private _ntsPos = (_heli getVariable ["fza_ah64_fcrNts", [objNull, [0, 0, 0]]]) param [1, [0, 0, 0]];
                [_heliPos vectorFromTo _ntsPos, _heli vectorModelToWorldVisual [0, 1, 0]] select (_ntsPos isEqualTo [0, 0, 0])
            };
            default {_heli vectorModelToWorldVisual [0, 1, 0]};
        };
        // Where the sight line meets the ground at zero radar altitude, with the line at least 1 deg below the horizon
        private _sinDepression = -((vectorNormalized _dir) # 2);
        if (_sinDepression >= sin 1) then {
            private _range = ((_heli getVariable ["bmkhs_radAlt", 0]) / _sinDepression) max 100;
            [[], [_range, "A" + (_range call _km)]] select (_range <= RANGE_AUTO_MAX)
        } else {[]};
    };
    default {[]};
};

// The default range; FCR shows R?? without a valid radar range
if (_result isEqualTo []) exitWith {[_default, [_default call _km, "R??"] select (_sight == SIGHT_FCR), RANGE_SRC_DEFAULT]};
// Under the laser's minimum range the default is used with nothing shown
if ((_result # 1) == "") exitWith {_result + [RANGE_SRC_DEFAULT]};
_result + [_source]
