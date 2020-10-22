#include "\fza_ah64_controls\headers\selections.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
params ["_heli"];

private _wcas = [_heli] call fza_fnc_coreGetWCAs;
_wcas resize 26;
_wcas = _wcas apply {[_x # 1, ""] select (isNil "_x")};

{
	_heli setObjectTexture [_forEachIndex + SEL_PR_WCA_1, _x];
	_heli setObjectTexture [_forEachIndex + SEL_GR_WCA_1, _x];
} forEach _wcas;