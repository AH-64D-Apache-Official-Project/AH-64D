#include "\fza_ah64_controls\headers\selections.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
params ["_heli"];

private _wcas = [_heli] call fza_fnc_coreGetObjectsLookedAt;
_warnings resize 13;
_advisories resize 13;

_warnings append _advisories;

_warnings apply {[_x, ""] select (isNil "_x")};

private _startSel = [SEL_PL_WCA_1, SEL_GL_WCA_1] select (gunner _heli == player);

{
	_heli setObjectTexture [_forEachIndex + SEL_PL_WCA_1, _x # 1];
	_heli setObjectTexture [_forEachIndex + SEL_GL_WCA_1, _x # 1];
} forEach _warnings;