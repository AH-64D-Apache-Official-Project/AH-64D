/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingSched
Description:
	Handles repetitive target management. Should be run regularly in the scheduler.
Parameters:
	_heli - The helicopter to act on
Returns:
	Nothing
Examples:
	--- Code
    [_heli] call fza_fnc_targetingSched
	---
Author:
	Unknown
---------------------------------------------------------------------------- */
params ["_heli"];
if (!(player in _heli)) exitwith {};

//SELECTABLE TARGETS
_visibleTargets = switch (true) do {
    case (_heli getVariable "fza_ah64_pfz_count" != 0 && _heli getVariable "fza_ah64_tsdsort" < 4): {
        [_heli, (_heli getVariable "fza_ah64_pfzs") select (_heli getVariable "fza_ah64_pfz_count") - 1] call fza_fnc_targetingFilterType;
    };
    case (_heli getVariable "fza_ah64_tsdsort" > 3): {
        [_heli, (_heli getVariable "fza_ah64_pfzs") select (_heli getVariable "fza_ah64_tsdsort") - 4] call fza_fnc_targetingFilterType;
    };
    case ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "fcr"): {
        [_heli, fza_ah64_dispfcrlist - alldead] call fza_fnc_targetingFilterType;
    };
    case ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "tsd"): {
        [_heli, fza_ah64_tsddisptargs - alldead] call fza_fnc_targetingFilterType;
    };
    default {
        [_heli, fza_ah64_targetlist - alldead] call fza_fnc_targetingFilterType;
    };
};
/*
_visibleTargets =
	if (_heli getVariable "fza_ah64_pfz_count" != 0 && _heli getVariable "fza_ah64_tsdsort" < 4) then {
		[_heli, (_heli getVariable "fza_ah64_pfzs") select (_heli getVariable "fza_ah64_pfz_count") - 1] call fza_fnc_targetingFilterType;
	} else {
		if (_heli getVariable "fza_ah64_tsdsort" > 3) then {
			[_heli, (_heli getVariable "fza_ah64_pfzs") select (_heli getVariable "fza_ah64_tsdsort") - 4] call fza_fnc_targetingFilterType;
		} else {
			if ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "fcr") then {
				fza_ah64_dispfcrlist - alldead;
			} else {
				if ([_heli, 1] call fza_fnc_mpdGetCurrentDisplay == "tsd") then {
					fza_ah64_tsddisptargs - alldead;
				} else {
					fza_ah64_targetlist - alldead;
				};
			};
		};
	};
*/
if (inputAction "vehLockTargets" > 0.5 && fza_ah64_locktargstate == 0 && count _visibleTargets > 0) then {
    if (fza_ah64_mynum >= count _visibleTargets - 1) then {
        fza_ah64_mynum = 0;
    } else {
        fza_ah64_mynum = fza_ah64_mynum + 1;
    };
    fza_ah64_mycurrenttarget = _visibleTargets select(fza_ah64_mynum);
    fza_ah64_locktargstate = 1;
};
if (inputAction "vehLockTargets" < 0.5 && fza_ah64_locktargstate == 1) then {
    fza_ah64_locktargstate = 0;
};
if (inputAction "lockTarget" > 0.5) then {
    fza_ah64_mycurrenttarget = cursorTarget;
};