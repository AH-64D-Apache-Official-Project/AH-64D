/* ----------------------------------------------------------------------------
Function: fza_fnc_eventGetIn

Description:
    Event handler that sets up apache when someone gets inside.

Parameters:
    _heli - the helicopter to modify

Returns:
	Nothing

Examples:

Author:
	unknown
---------------------------------------------------------------------------- */
params ["_heli"];

if (player == driver _heli) then {
    if (_heli iskindof "fza_ah64d_b2e_nr") then {
        fza_ah64_agmode = 2;
    } else {
        fza_ah64_agmode = 0;
    };

    fza_ah64_hfmode = _heli;
    fza_ah64_guncontrol = 0;
};