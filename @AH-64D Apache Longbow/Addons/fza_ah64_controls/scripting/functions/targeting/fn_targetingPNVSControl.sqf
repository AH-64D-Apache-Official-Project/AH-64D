/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingPNVSControl

Description:
    Handles the movement of the PNVS when the player moves their head or mouse (depending on if they are in head tracking mode.)

Parameters:
    _heli - The helicopter to act on

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_targetingPNVSControl
    ---

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli"];

if (player != driver _heli) exitwith {};

private _acBusOn        = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn        = _heli getVariable "fza_systems_dcBusOn";
private _pnvsControl    = _heli getVariable "fza_ah64_ihadss_pnvs_cam";
private _monocle        = _heli getVariable "fza_ah64_monocleinbox";

//Pnvs Stowed
if (!_pnvsControl || !(_acBusOn && _dcBusOn) || _monocle) exitwith {
    _heli animateSource["pnvs", -120, 0.5];
    _heli animateSource["pnvs_vert", 0];
};

(( _heli vectorWorldToModelVisual getCameraViewDirection player) call CBA_fnc_vect2Polar) params ["_mag", "_az", "_el"];
if (_heli getHit "pnvs" >= 0.8) then {
    _az = -1;
    _el = 1;
};
_heli animateSource["pnvs", rad ([_az] call CBA_fnc_simplifyAngle180)];
_heli animateSource["pnvs_vert", rad ([_el] call CBA_fnc_simplifyAngle180)];