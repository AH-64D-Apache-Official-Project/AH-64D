_helo = _this select 0;

enableCamShake true;
while {(alive _helo) && (player in _helo)} do {
    if(player in _helo) then { 	
		//Do camshake checks & calculations
		if(speed _helo > 37) then { //20knts + (scales effect)
			//Calculate power based on speed - higher the speed, greater the shake
			_power = (((speed _helo) - 200) * 0.35) / 50;
			addCamShake [_power, 4, 20]; //Power, duration, frequency			
		};
    };	
	sleep 0.5;
};
