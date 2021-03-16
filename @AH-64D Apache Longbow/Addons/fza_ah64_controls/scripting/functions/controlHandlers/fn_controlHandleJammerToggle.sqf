/* ----------------------------------------------------------------------------
Function: fza_fnc_controlHandleJammerToggle

Description:
    Toggles both jammers between OFF and AUTO.
    
    It toggles each individually, not as a group, for example if IR was OFF and RF was AUTO, after running this it would be IR - AUTO and RF - OFF.

Parameters:
	_heli - The heli whose jammers you would like to toggle between off an auto

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_controlHandleJammerToggle
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params ["_heli"];

if (_heli getVariable "fza_ah64_rfjstate" == 1) exitwith {
    _heli setVariable ["fza_ah64_rfjstate", 0, true];
};
if (_heli getVariable "fza_ah64_irjstate" == 1) exitwith {
    _heli setVariable ["fza_ah64_irjstate", 0, true];
};

_heli setVariable ["fza_ah64_rfjstate", (_heli getVariable "fza_ah64_rfjstate") + 1, true];
_heli setVariable ["fza_ah64_irjstate", (_heli getVariable "fza_ah64_irjstate") + 1, true];
//_heli getVariable "fza_ah64_rfjstate" = fza_ah64_rfjstate + 1;
//_heli getVariable "fza_ah64_irjstate" = fza_ah64_irjstate + 1;
