_heli = _this select 0;

if ((isengineon _heli || [_heli] call fza_fnc_engineAPUOn) && (typeof _heli == "fza_ah64d_b2e")) then {
    if (!(isVehicleRadarOn _heli)) then {
        player action["ActiveSensorsOn", _heli];
    };
    if (isVehicleRadarOn _heli) then {
        player action["ActiveSensorsOff", _heli];
    };
};