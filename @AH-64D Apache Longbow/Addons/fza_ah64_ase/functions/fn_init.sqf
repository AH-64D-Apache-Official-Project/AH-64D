/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_init

Description:
    Initialize public variables on mission startup
    To set up information accessible by all crew members

Parameters:
    _heli - the helicopter upon which to execute the code

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_init

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

if (!(_heli getVariable ["fza_ah64_aseInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_aseInitialised", true, true];

    _heli setVariable ["fza_ah64_ase_updateTimer",      0,                      true];

    //--Chaff       - Aircraft common
    _heli setVariable ["fza_ah64_ase_chaffState",       ASE_CHAFF_STATE_SAFE,   true];
    //--RLWR        - Aircraft Common
    _heli setVariable ["fza_ah64_ase_rlwrPwr",          ASE_RLWR_STATE_OFF,     true];
    _heli setVariable ["fza_ah64_ase_objects",          [],                     true];
    _heli setVariable ["fza_ah64_ase_rlwrcount",        [],                     true];
    //--IR Jammer   - Aircraft Common
    _heli setVariable ["fza_ah64_ase_msnEquipPwr",      ASE_MSNEQUIP_STATE_OFF, true];
    _heli setVariable ["fza_ah64_ase_irJamState",       [0,0,0],                true];
    //--Autopage    - Crewstation independent
    _heli setVariable ["fza_ah64_ase_autopage",         ASE_AUTOPAGE_OFF,       true];
    _heli setVariable ["fza_ah64_ase_data",             [[],[],[]],             true];
};
