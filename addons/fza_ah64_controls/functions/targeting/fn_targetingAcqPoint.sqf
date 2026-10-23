/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqPoint

Description:
    The point a sight slaved to an acquisition source aims at: the NTS for FCR,
    the stored point for a coordinate point (W01, C51, T01), otherwise far out
    along the acquisition LOS from the TADS.

Parameters:
    _heli - The helicopter
    _acq  - Acquisition source name

Returns:
    PositionASL, or [] when the source gives no LOS to slave to (FCR without an NTS, ?01, a point no longer stored)

Examples:
    [_heli, "PHS"] call fza_fnc_targetingAcqPoint

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_acq"];

if (_acq == "FCR") exitWith {
    (_heli getVariable ["fza_ah64_fcrNts", [objNull, [0, 0, 0]]]) params [["_nts", objNull], ["_ntsPos", [0, 0, 0]]];
    [_ntsPos, []] select (isNull _nts || {_ntsPos isEqualTo [0, 0, 0]})
};

// A coordinate point, at its stored position and altitude; ?01 is no point
if (ACQ_IS_POINT(_acq)) exitWith {
    private _id = [_heli, _acq] call fza_dms_fnc_pointParse;
    if (_id isEqualTo []) exitWith {[]};
    private _pos = [_heli, _id, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
    if (isNil "_pos") exitWith {[]};
    [_pos # 0, _pos # 1, [_heli, _id, POINT_GET_ALT_MSL] call fza_dms_fnc_pointGetValue]
};

(_heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd")) vectorAdd (([_heli, _acq] call fza_fnc_targetingAcqVec) vectorMultiply 2000)
