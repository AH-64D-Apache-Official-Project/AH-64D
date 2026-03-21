#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

if (isGamePaused || CBA_missionTime < 0.1) exitwith {};

//Main Rotor
[_heli] call fza_sfmplus_fnc_simpleRotorMain;

//Tail Rotor
[_heli] call fza_sfmplus_fnc_simpleRotorTail;

//Fuselage
private _fuselageCenter    = _heli getVariable "fza_sfmplus_fuselageCenter";

private _fuselageTopCenter   = [0.0, 0.74, -1.60];
private _fuselageTopRotation = [5.0, 0.0, 0.0];
private _fuselageTopCount    = _heli getVariable "fza_sfmplus_fuselageTopCount";
private _fuselageTop         = _heli getVariable "fza_sfmplus_fuselageTop";
[_heli, _fuselageTopCenter, _fuselageTopRotation, _fuselageTopCount, _fuselageTop] call fza_sfmplus_fnc_fuselage;

private _fuselageSideCenter   = [0.0, 0.74, -1.60];
private _fuselageSideRotation = [5.0, 90.0, 0.0];
private _fuselageSideCount  = _heli getVariable "fza_sfmplus_fuselageSideCount";
private _fuselageSide       = _heli getVariable "fza_sfmplus_fuselageSide";
[_heli, _fuselageSideCenter, _fuselageSideRotation, _fuselageSideCount, _fuselageSide] call fza_sfmplus_fnc_fuselage;

private _fuselageFrontCenter   = [0.0, 2.29, -1.60];
private _fuselageFrontRotation = [0.0, 90.0, 90.0];
private _fuselageFrontCount    = _heli getVariable "fza_sfmplus_fuselageFrontCount";
private _fuselageFront	       = _heli getVariable "fza_sfmplus_fuselageFront";
[_heli, _fuselageFrontCenter, _fuselageFrontRotation, _fuselageFrontCount, _fuselageFront] call fza_sfmplus_fnc_fuselage;

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