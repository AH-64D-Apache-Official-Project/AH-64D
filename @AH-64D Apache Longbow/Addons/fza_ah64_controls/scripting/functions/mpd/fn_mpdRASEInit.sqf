#include "\fza_ah64_controls\headers\selections.h"
params ["_heli"];

_heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_us\tex\mpd\ase.paa"];
[_heli] call fza_fnc_targetingVariable;