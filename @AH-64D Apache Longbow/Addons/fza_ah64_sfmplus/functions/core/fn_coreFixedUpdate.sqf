#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (isGamePaused || CBA_missionTime < 0.1) exitwith {
    _heli setVariable ["fza_sfmplus_previousTime",  diag_tickTime];
    _heli setVariable ["fza_sfmplus_deltaTime_avg", [fza_sfmplus_movingAverageSize] call fza_sfmplus_fnc_smoothAverageInit]
};

//Main Rotor
[_heli] call fza_sfmplus_fnc_simpleRotorMain;

//Tail Rotor
[_heli] call fza_sfmplus_fnc_simpleRotorTail;

//Drag
[_heli] call fza_sfmplus_fnc_fuselageDrag;

//Vertical fin
[_heli] call fza_sfmplus_fnc_aeroWing;

//Stabilator
[_heli] call fza_sfmplus_fnc_aeroStabilator;