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
_heli setVariable ["fza_fuel_xferMode", "OFF"];

// XFER popup submenu open state
_heli setVariable ["fza_fuel_xferMenuOpen", false];

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
_heli setVariable ["fza_fuel_checkActive",    false];
_heli setVariable ["fza_fuel_checkMinutes",   20];
_heli setVariable ["fza_fuel_checkStartTime", 0];
_heli setVariable ["fza_fuel_checkStartFuel", 0];

// CHECK computed display values (lb/hr, minutes)
_heli setVariable ["fza_fuel_checkElapsedSec", 0];
_heli setVariable ["fza_fuel_checkBurnRate",   0];
_heli setVariable ["fza_fuel_checkBurnoutMin", 0];
_heli setVariable ["fza_fuel_checkVFRRes",     0];
_heli setVariable ["fza_fuel_checkIFRRes",     0];
