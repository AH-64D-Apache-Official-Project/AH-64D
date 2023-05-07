/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_ihadssControler

Description:
    Controls the varius elements of the Ihadss 

Parameters:
	_heli - The heli object to draw the IHADSS for

Returns:
    Nothing

Examples:
	--- Code
    [_heli] call fza_ihadss_fnc_ihadssControler
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(isNil "fza_ah64_notargeting")) exitwith {};

//Current Ihadss
[_heli] call fza_ihadss_fnc_ihadssDraw;


[_heli] call fza_ihadss_fnc_CscopeDraw;
[_heli] call fza_ihadss_fnc_constraintBoxDraw;

