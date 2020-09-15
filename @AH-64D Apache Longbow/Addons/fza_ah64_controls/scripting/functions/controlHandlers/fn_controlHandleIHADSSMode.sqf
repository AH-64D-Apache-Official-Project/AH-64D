/* ----------------------------------------------------------------------------
Function: fza_fnc_controlHandleIHADSSMode

Description:
	Switches the helicopter's HMD between the different modes.

Parameters:
	_heli - The apache helicopter to change the autopage setting for.

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_controlHandleIHADSSMode
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
if (fza_ah64_hmdfsmode == "trans") exitwith {
    fza_ah64_hmdfsmode = "cruise";
};
if (fza_ah64_hmdfsmode == "cruise") exitwith {
    fza_ah64_hmdfsmode = "hover";
};
if (fza_ah64_hmdfsmode == "hover") exitwith {
    fza_ah64_hmdfsmode = "bobup";
};
if (fza_ah64_hmdfsmode == "bobup") exitwith {
    fza_ah64_hmdfsmode = "trans";
};