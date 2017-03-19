if(!(isNil "fza_ah64_noturrets")) exitwith {};
_heli = _this select 0;
while {alive _heli} do
{
waituntil{local _heli && (local gunner _heli || isnull gunner _heli || !(alive gunner _heli)) && (!(player == driver _heli) || !(player == gunner _heli))};
	if(local _heli && (local gunner _heli || isnull gunner _heli || !(alive gunner _heli)) && (!(player == driver _heli) || !(player == gunner _heli))) then
	{
			_curcontrol = (_heli animationphase "tads_tur");
			_curguncontrol = (_heli animationphase "tads");
			if(_curcontrol > 1.5) then {_curcontrol = 1.5;};
			if(_curcontrol < -1.5) then {_curcontrol = -1.5;};
			if(_curguncontrol > 0.28777) then {_curguncontrol = 0.28777;};
			if(!(isengineon _heli)) then {_curcontrol = 0; _curguncontrol = 0.17;};
			if(currentweapon _heli in fza_ah64_rocketweps14 || currentweapon _heli in fza_ah64_rocketweps23 || currentweapon _heli in fza_ah64_rocketweps1 || currentweapon _heli in fza_ah64_rocketweps2 || currentweapon _heli in fza_ah64_rocketweps3 || currentweapon _heli in fza_ah64_rocketweps4) then
			{
				//0.28777//
				_fza_ah64_pylonelev = _curguncontrol;
				if("fza_ah64_rwp_fail" in (_heli magazinesturret [-1]) && "fza_ah64_lwp_fail" in (_heli magazinesturret [-1])) then {_fza_ah64_pylonelev = 5.07;};
				if(_curguncontrol > 0) then {_fza_ah64_pylonelev = _curguncontrol * 3;};
				if(_curguncontrol < 0) then {_fza_ah64_pylonelev = _curguncontrol * 6;};
				if(_fza_ah64_pylonelev > 1) then {_fza_ah64_pylonelev = 1;};
				if(_fza_ah64_pylonelev < -1) then {_fza_ah64_pylonelev = -1;};
				_fza_ah64_pylonelev1 = _fza_ah64_pylonelev;
				_fza_ah64_pylonelev2 = _fza_ah64_pylonelev;
				_fza_ah64_pylonelev3 = _fza_ah64_pylonelev;
				_fza_ah64_pylonelev4 = _fza_ah64_pylonelev;
				if("fza_auxtank_230_1" in magazines _heli) then {_fza_ah64_pylonelev1 = 0.507;};
				if("fza_auxtank_230_2" in magazines _heli) then {_fza_ah64_pylonelev2 = 0.507;};
				if("fza_auxtank_230_3" in magazines _heli) then {_fza_ah64_pylonelev3 = 0.507;};
				if("fza_auxtank_230_4" in magazines _heli) then {_fza_ah64_pylonelev4 = 0.507;};
				_heli animate ["pylon1",(_fza_ah64_pylonelev1)];
				_heli animate ["pylon2",(_fza_ah64_pylonelev2)];
				_heli animate ["pylon3",(_fza_ah64_pylonelev3)];
				_heli animate ["pylon4",(_fza_ah64_pylonelev4)];
			} else {
				_heli animate ["pylon1",0.507];
				_heli animate ["pylon2",0.507];
				_heli animate ["pylon3",0.507];
				_heli animate ["pylon4",0.507];
			};
			if("fza_ah64_gun_fail" in (_heli magazinesturret [-1]) || ("fza_ah64_rwp_fail" in (_heli magazinesturret [-1]) && "fza_ah64_lwp_fail" in (_heli magazinesturret [-1]))) then {_curcontrol = 0; _curguncontrol = 0.17;};
			_heli animate ["mainTurret",_curcontrol];
			_heli animate ["mainGun",_curguncontrol];
	};
sleep 0.03;
};