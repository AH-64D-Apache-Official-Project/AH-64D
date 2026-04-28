/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_controller

Description:
    Main draw3D weapons controller. Keeps fza_ma_safe selected on the
    vehicle's Arma turret at all times so all firing is fully scripted.
    Ensures PLT has ManualFire when flying solo, then dispatches to each
    weapon sub-system's pylon/aim controller.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _sightSeat = if (player == driver _heli) then {"plt"} else {"cpg"};
_heli setVariable ["fza_ah64_sightData_" + _sightSeat, (_heli call fza_weapons_fnc_sightData), isMultiplayer];

_heli selectWeaponTurret ["fza_ah64_trigger", [0]];
_heli selectWeaponTurret ["fza_ah64_trigger", [-1]];

_heli call fza_weapons_fnc_pylonController;
_heli call fza_weapons_fnc_cannonPylonController;
_heli call fza_weapons_fnc_rocketPylonController;
_heli call fza_weapons_fnc_hellfirePylonController;
