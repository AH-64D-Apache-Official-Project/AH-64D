_helo = _this select 0;

enableCamShake true;
while {(alive _helo) && (player in _helo)} do {
    if {(player in _helo) &&  (!isEngineOn _helo)} then { 	
			addCamShake [0.05, 4, 50]; //Power, duration, frequency			
		};
    };	
	sleep 0.5;
};
