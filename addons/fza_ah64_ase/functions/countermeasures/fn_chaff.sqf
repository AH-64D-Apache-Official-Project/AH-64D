/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_chaff

Description:
    The Chaff/Consent control. US: chaff. HIDAS: chaff in MAN, consent in SEMI, nothing
    in AUTO.

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_chaff

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

if !(_heli getVariable ["bmkhs_dcBusOn", false]) exitWith {};

// HIDAS arming is a UTIL page item, not built: power alone dispenses
if (ASE_HIDAS(_heli)) exitWith {
    switch (_heli getVariable ["fza_ah64_ase_cmdsMode", ASE_CMDS_MAN]) do {
        case ASE_CMDS_MAN: {
            [_heli, ASE_CMDS_PGM_MAN_CHAFF, "B"] call fza_ase_fnc_cmdsDispense;
        };
        case ASE_CMDS_SEMI: {
            [_heli] call fza_ase_fnc_cmdsConsent;
        };
    };
};

if (_heli getVariable ["fza_ah64_ase_chaffState", ASE_CHAFF_STATE_SAFE] == ASE_CHAFF_STATE_ARM) then {
    [_heli, ASE_CMDS_PGM_CHAFF_US, "B"] call fza_ase_fnc_cmdsDispense;
};
