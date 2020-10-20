private["_heli"];
_heli = _this select 0;
_selWeapon = currentWeapon _heli;

// M230 SHAKE
if ((player == driver _heli || player == gunner _heli) && _selWeapon == "fza_m230")
    then 
	{
        private addCamShake [0.40, 1, 25];
    };