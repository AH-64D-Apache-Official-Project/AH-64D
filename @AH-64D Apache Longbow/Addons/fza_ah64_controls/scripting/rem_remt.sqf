_heli = _this select 0;

if (player == gunner _heli && fza_ah64_laserstate == 1) exitwith {
    fza_ah64_laserstate = 0;
    _heli vehiclechat "Laser OFF.";
};

_heli removemagazine "Laserbatteries";
_heli removeweapon "Laserdesignator_mounted";