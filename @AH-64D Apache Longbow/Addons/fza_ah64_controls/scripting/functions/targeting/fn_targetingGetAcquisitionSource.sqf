/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingGetAcquisitionSource

Description:
    Gets the player's seat's aquisition source. Can optionally be used to find the other crewstation's seat

    - 0 is FCR / TADS (depending on if you have a radar)
    - 1 is HMD
    - 2 is AUTO
    - 3 is FXD

Parameters:
    _heli - The helicopter to act on
    _swapSeat - (optional) whether the other seat's acq source should be found (default false)

Returns:
	The number of the acquisition source that is used, or -1 if the player is not in either seat

Examples:
    Getting your own seat's info
	--- Code
    _ret = [_heli] call fza_fnc_targetingGetAcquisitionSource
    // _ret => 0
    ---

    Getting the opposite crewstation's info
    --- Code
    _ret = [_heli, true] call fza_fnc_targetingGetAcquisitionSource
    // _ret => 0
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", ["_swapSeat", false]];

if (player == driver _heli || _swapSeat && player == gunner _heli) exitWith {
    _heli getVariable "fza_ah64_acq_plt";
};
if (player == gunner _heli || _swapSeat && player == driver _heli) exitWith {
    _heli getVariable "fza_ah64_acq_cpg";
};
-1;