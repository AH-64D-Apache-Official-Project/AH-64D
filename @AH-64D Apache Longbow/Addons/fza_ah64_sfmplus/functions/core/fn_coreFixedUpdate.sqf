#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (isGamePaused || CBA_missionTime < 0.1) exitwith {};

//Main Rotor
[_heli] call fza_sfmplus_fnc_simpleRotorMain;

//Tail Rotor
[_heli] call fza_sfmplus_fnc_simpleRotorTail;

//Drag
[_heli] call fza_sfmplus_fnc_fuselageDrag;

//Right Wing
[ _heli
 ,[1.5,1.9,-1.4]
 ,12.0 
 ,0.0 
 ,2.00 
 ,1.0 
 ,0.0 
 ,0.0 
 ,1.0 ] call fza_sfmplus_fnc_aeroWing;
//Left Wing
[ _heli
 ,[-1.5,1.9,-1.4]
 ,12.0
 ,0.0 
 ,2.00 
 ,1.0 
 ,0.0 
 ,0.0 
 ,1.0 ] call fza_sfmplus_fnc_aeroWing;
//Vertical fin
[ _heli
 ,[0.0, -6.3, -0.75]
 ,0.0
 ,-90.0
 ,2.25
 ,0.95
 ,-1.2
 ,0.0
 ,1.0 ] call fza_sfmplus_fnc_aeroWing;

//Stabilator
[_heli] call fza_sfmplus_fnc_aeroStabilator;