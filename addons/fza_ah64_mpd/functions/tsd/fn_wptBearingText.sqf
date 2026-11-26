/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_wptBearingText

Description:
    The bearing to the active waypoint, for the bottom heading box of the TSD and ASE page: 1 to 360, or nothing with
    no active waypoint.

Parameters:
    _heli - the helicopter

Returns:
    String

Examples:
    [_heli] call fza_mpd_fnc_wptBearingText

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli"];

private _next = _heli getVariable ["fza_dms_routeNext", []];
if !(_next isEqualType [] && {_next isNotEqualTo []}) exitWith {""};
private _waypoint = [_heli, _next # 0, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
if (isNil "_waypoint" || {!(_waypoint isEqualType [])} || {count _waypoint < 2}) exitWith {""};
private _bearing = round (_heli getDir _waypoint);
str ([_bearing, 360] select (_bearing % 360 == 0))
