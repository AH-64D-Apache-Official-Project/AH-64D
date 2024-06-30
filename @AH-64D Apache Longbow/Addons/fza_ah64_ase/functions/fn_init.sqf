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
params ["_heli"];

if (!(_heli getVariable ["fza_ah64_aseInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_aseInitialised", true, true];

    //--Chaff       - Aircraft common
    _heli setVariable ["fza_ah64_ase_chaffState",       "safe", true];
    //--RLWR        - Aircraft Common
    _heli setVariable ["fza_ah64_ase_rlwrPwr",          "off",  true];
    _heli setVariable ["fza_ah64_ase_rlwrCount",        0,      true];
    _heli setVariable ["fza_ah64_ase_rlwrObjects",      [],     true];
    _heli setVariable ["fza_ah64_ase_audioList",        [],     true];
    //--IR Jammer   - Aircraft Common
    _heli setVariable ["fza_ah64_ase_msnEquipPwr",      "off",  true];
    _heli setVariable ["fza_ah64_ase_irJamState",       0,      true];
    _heli setVariable ["fza_ah64_ase_irJamTimer",       0.0,    true];
    _heli setVariable ["fza_ah64_ase_irJamLaunchTimer", 0,      true];
    //--Autopage    - Crewstation independent
    _heli setVariable ["fza_ah64_ase_autopage",         1,      true];
    _heli setVariable ["fza_ah64_ase_searchingObj",     [],     true];
    _heli setVariable ["fza_ah64_ase_acquisitionObj",   [],     true];
    _heli setVariable ["fza_ah64_ase_trackingobj",      [],     true];
};