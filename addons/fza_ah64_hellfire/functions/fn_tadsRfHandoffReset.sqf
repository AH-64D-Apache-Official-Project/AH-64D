/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_tadsRfHandoffReset
Description: 
    Clears any cached/frozen TADS->RF handoff package.
Parameters:
    _heli - The helicopter
Returns:
    Nothing
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

[_heli, "fza_ah64_tadsRfHandoffStart",        -1]      call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_tadsRfHandoffLast",         []]      call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_tadsRfHandoffData",         []]      call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_tadsRfHandoffLoblTarget",   objNull] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_tadsRfHandoffDelay",        -1]      call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_tadsRfHandoffLastScanTime", -1]      call fza_fnc_updateNetworkGlobal;
_heli setVariable ["fza_ah64_tadsRfHandoffLastSampleTime",    -1];
_heli setVariable ["fza_ah64_tadsRfHandoffLastCmCheckTime",   -1];
_heli setVariable ["fza_ah64_tadsRfHandoffLastDecoyTime",     -1];
