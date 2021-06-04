/* ----------------------------------------------------------------------------
Function: fza_fnc_aseHandleRfControl

Description:
    Handles the RF jammer overheat

Parameters:
    _heli - The helicopter

Returns:
	nothing

Examples:
	_this spawn fza_fnc_aseHandleRfcontrol;
    
Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (!(_heli getVariable "fza_ah64_irjamfail")) then {
    _heli setVariable ["fza_ah64_rfjon", 1, true];
    while {
        (fza_ah64_rfjammer < 61 && _heli getVariable "fza_ah64_rfjon" == 1)
    }
    do {
        fza_ah64_rfjammer = fza_ah64_rfjammer + 1;
        sleep 1;
    };
    if (fza_ah64_rfjammer > 60) then {
        _heli setVariable ["fza_ah64_rfjon", 0, true];
    };
    while {
        (fza_ah64_rfjammer > 0 && _heli getVariable "fza_ah64_rfjon" == 0)
    }
    do {
        fza_ah64_rfjammer = fza_ah64_rfjammer - 1;
        sleep 1;
    };
} else {
    _heli setVariable ["fza_ah64_rfjon", 0, true];
};