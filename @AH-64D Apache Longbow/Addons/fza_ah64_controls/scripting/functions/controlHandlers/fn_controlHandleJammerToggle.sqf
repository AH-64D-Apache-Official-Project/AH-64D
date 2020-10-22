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

if (fza_ah64_rfjstate == 1) exitwith {
    fza_ah64_rfjstate = 0;
};
if (fza_ah64_irjstate == 1) exitwith {
    fza_ah64_irjstate = 0;
};

fza_ah64_rfjstate = fza_ah64_rfjstate + 1;
fza_ah64_irjstate = fza_ah64_irjstate + 1;