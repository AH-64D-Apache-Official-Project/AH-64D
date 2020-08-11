#include "\fza_ah64_controls\headers\selections.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
params ["_heli"];

private _wcas = [_heli getVariable "fza_ah64_wcas", [], {_x # 1}] call BIS_fnc_sortBy;
private _warnings = _wcas select {(_this # 0) in [WCA_WARNING, WCA_CAUTION]};
private _advisories = _wcas select {(_this # 0) == WCA_ADVISORY};

_warnings resize 13;
_advisories resize 13;

_warnings append _advisories;

_warnings apply {[_x, ""] select (isNil "_x")};

private _startSel = [SEL_PR_WCA_1, SEL_GR_WCA_1] select (gunner _heli == player);

{
	_heli setObjectTexture [_forEachIndex + _startSel, format ["\fza_ah64_us\tex\MPD\%1.paa", _x # 2]]
} forEach _warnings;