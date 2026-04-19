#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (!local _heli) exitWith {};

[_heli] call fza_sfmplus_fnc_fuselageFront;
[_heli] call fza_sfmplus_fnc_fuselageTop;
[_heli] call fza_sfmplus_fnc_fuselageSide;
