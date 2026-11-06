#include "\fza_ah64_dms\headers\constants.h"
params ["_pos", "_active"];
_active params ["_pf", "_nf"];

if (_pos isEqualTo [] || {_pf isEqualTo [] && {_nf isEqualTo []}}) exitWith {ZONE_CLASS_NONE};
private _p = [_pos # 0, _pos # 1, 0];
if (_nf findIf {_p inPolygon _x} != -1) exitWith {ZONE_CLASS_NF};
if (_pf isNotEqualTo [] && {_p inPolygon _pf}) exitWith {ZONE_CLASS_PF};
ZONE_CLASS_NONE
