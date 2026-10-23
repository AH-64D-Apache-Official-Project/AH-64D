/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_cycleNTS

Description:
    Cycles the NTS to the next of the targets the FCR formats and the IHADSS
    show: the top FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS displayed
    (fza_fcr_fnc_resolveDisplay), at the position shown.

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli"];

// Up to date with the target file, which may have changed this frame
_heli setVariable ["fza_ah64_fcrDisplayFrame", -1];
_heli call fza_fcr_fnc_resolveDisplay;
private _shown = (_heli getVariable ["fza_ah64_fcrDisplayTargets", []]) select [0, FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS];
if (_shown isEqualTo []) exitWith {
    [_heli, "fza_ah64_fcrNts", [objNull, [0, 0, 0], []]] call fza_fnc_updateNetworkGlobal;
};

private _oldNts = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _next   = _shown # (((_shown findIf {(_x # 3) isEqualTo _oldNts}) + 1) mod count _shown);
private _file   = _heli getVariable ["fza_ah64_fcrTargets", []];
private _rec    = _file param [_file findIf {(_x # 3) isEqualTo (_next # 3)}, []];
[_heli, "fza_ah64_fcrNts", [_next # 3, _next # 0, _rec]] call fza_fnc_updateNetworkGlobal;
