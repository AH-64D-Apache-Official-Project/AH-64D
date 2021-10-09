/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingVariable
Description:
	Handles repetitive Heavy Variable management. Should be run in the Slowscheduler.
Parameters:
	_heli - The helicopter to act on
Returns:
	Nothing
Examples:
	--- Code
    [_heli] call fza_fnc_targetingVariable;
	---
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
if (!(player in _heli)) exitwith {};

//remove dead targets
fza_ah64_targetlist = fza_ah64_targetlist - allDead;

//TSD ATK LIST
if (([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "tsd") && (_heli getVariable "fza_ah64_tsdmode" == "atk")) then {
	fza_ah64_tsddisptargs = fza_ah64_targetlist select {
		_distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _x select 0), (getposatl _x select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);

		(((((_heli distance _x) * (_heli getVariable "fza_ah64_rangesetting")) < 0.71) && (_distOffAxis < 45)) || ((((_heli distance _x) * (_heli getVariable "fza_ah64_rangesetting")) < 0.4) && (_distOffAxis < 90)))
	};
};

//cscope
if (_heli getVariable "fza_ah64_fcrcscope") then {
	if (count fza_ah64_fcrlist > 16) then {
		fza_ah64_Cscopelist = [fza_ah64_fcrlist, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
	} else {
		fza_ah64_Cscopelist = fza_ah64_fcrlist;
	}; 
};

