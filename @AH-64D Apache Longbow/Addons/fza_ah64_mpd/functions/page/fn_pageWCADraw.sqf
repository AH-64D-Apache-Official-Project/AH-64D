#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
params ["_heli", "_mpdIndex"];

private _wcas = [_heli] call fza_fnc_coreGetWCAs;
_wcas resize 18;
_wcas = _wcas apply {[_x, [WCA_ADVISORY, ""]] select (isNil "_x")};

{
    [_heli, MFD_INDEX_OFFSET(_forEachIndex), _x # 1] call fza_mpd_fnc_updateMfdText;
    [_heli, MFD_INDEX_OFFSET(_forEachIndex), _x # 0] call fza_mpd_fnc_updateMfdValue;
} forEach _wcas;