/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_rfiCuedExit

Description:
    Leaves FCR cued search, as any FCR control does other than choosing an RFI threat, the CUED switch or the scan
    switch

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_fcr_fnc_rfiCuedExit

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if ((_heli getVariable ["fza_ah64_fcrCued", [false, objNull]]) # 0) then {
    _heli setVariable ["fza_ah64_fcrCued", [false, objNull], true];
};
