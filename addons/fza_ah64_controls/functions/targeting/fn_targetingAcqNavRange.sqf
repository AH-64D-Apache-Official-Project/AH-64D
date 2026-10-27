/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingAcqNavRange

Description:
    Slaving to a stored point replaces the crew station's range source with the
    nav range to it, NXX.X. Any other source, ?01 or a point no longer stored
    leaves the range source as it was.

Parameters:
    _heli - The helicopter
    _seat - "plt" or "cpg"
    _acq  - The acquisition source slaved to

Returns:
    Nothing

Examples:
    [_heli, "cpg", "T01"] call fza_fnc_targetingAcqNavRange

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_seat", "_acq"];

if !(ACQ_IS_POINT(_acq)) exitWith {};
private _pointPos = [_heli, _acq] call fza_fnc_targetingAcqPoint;
if (_pointPos isEqualTo []) exitWith {};
[_heli, _seat, RANGE_SRC_NAV, _pointPos] call fza_fnc_targetingRangeSet;
