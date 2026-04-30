/* ----------------------------------------------------------------------------
Function: fza_fuel_fnc_fuelMgmtVariables

Description:
    Initialises all fuel management state variables on a helicopter.
    Called from fza_sfmplus_fnc_coreConfig after the SFM fuel variables.

Parameters:
    _heli - The helicopter to initialise [Unit].

Returns:
    None

Author:
    FZA Development Team
---------------------------------------------------------------------------- */
params ["_heli"];

// Crossfeed valve position: "NORM" | "FWD" | "AFT"
_heli setVariable ["fza_fuel_crossfeedMode", "NORM"];

// XFER pump selection: "OFF" | "AFT" | "FWD" | "AUTO"
_heli setVariable ["fza_fuel_xferMode", "AUTO"];

// XFER popup submenu open state

// Boost pump state
_heli setVariable ["fza_fuel_boostOn", false];

// Fuel system status flags
_heli setVariable ["fza_fuel_intercellTransferActive", false];
_heli setVariable ["fza_fuel_intercellTransferDir", 0];
_heli setVariable ["fza_fuel_eng1FuelAvail", true];
_heli setVariable ["fza_fuel_eng2FuelAvail", true];
_heli setVariable ["fza_fuel_apuFuelAvail",  true];

// AUX tank on/off — L controls all left-side stations, R controls all right-side stations
// Default OFF — crew must arm before transfer begins
_heli setVariable ["fza_fuel_lAuxOn", false];
_heli setVariable ["fza_fuel_rAuxOn", false];

// CHECK sub-mode
_heli setVariable ["fza_fuel_checkMinutes",   15];
_heli setVariable ["fza_fuel_checkRunning",   false];
_heli setVariable ["fza_fuel_checkDone",      false];
_heli setVariable ["fza_fuel_checkStartTime", 0];
_heli setVariable ["fza_fuel_checkStartFuel", 0];
_heli setVariable ["fza_fuel_checkActivePlt", false];
_heli setVariable ["fza_fuel_checkActiveCpg", false];
_heli setVariable ["fza_fuel_checkPendingAdvisory", false];
_heli setVariable ["fza_fuel_checkStartZulu",   ""];
_heli setVariable ["fza_fuel_checkBurnoutZulu", ""];
_heli setVariable ["fza_fuel_checkVFRZulu",     ""];
_heli setVariable ["fza_fuel_checkIFRZulu",     ""];

// CHECK computed display values (lb/hr, seconds elapsed)
_heli setVariable ["fza_fuel_checkElapsedSec", 0];
_heli setVariable ["fza_fuel_checkBurnRate",   0];
