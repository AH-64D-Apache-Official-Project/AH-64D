#include "\fza_ah64_controls\headers\selections.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
params ["_heli"];

private _wcas = [_heli] call fza_fnc_coreGetWCAs;
_wcas resize 26;
_wcas apply {[_x # 1, ""] select (isNil "_x")};

{
	_heli setObjectTexture [_forEachIndex + SEL_PL_WCA_1, _x # 1];
	_heli setObjectTexture [_forEachIndex + SEL_GL_WCA_1, _x # 1];
} forEach _wcas;