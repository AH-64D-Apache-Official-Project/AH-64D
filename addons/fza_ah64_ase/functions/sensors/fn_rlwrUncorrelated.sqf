/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rlwrUncorrelated

Description:
    Whether an RLWR radar threat is too far above or below the aircraft for its receivers to give a bearing: an
    uncorrelated detect, shown just in front of the ownship

Parameters:
    _heli   - the helicopter
    _target - the threat, or its position AGL

Returns:
    Bool

Examples:
    [_heli, _object] call fza_ase_fnc_rlwrUncorrelated

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_target"];

private _agl = if (_target isEqualType objNull) then {ASLToAGL (aimPos _target)} else {_target};
(_heli worldToModelVisual _agl) params ["_x", "_y", "_z"];
abs (_z atan2 sqrt (_x ^ 2 + _y ^ 2)) > ASE_RLWR_ELEV_LIMIT
