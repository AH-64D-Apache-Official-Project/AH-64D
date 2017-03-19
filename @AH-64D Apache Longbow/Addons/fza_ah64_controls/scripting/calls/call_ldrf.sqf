_heli = _this select 0;

if(fza_ah64_laserstate == 1 && player == gunner _heli) then
{
	_ah64laser = objNull;
	if(count fza_ah64_desiglist < 1) then
	{
		_ah64laser = "LaserTargetW" createvehicle [0,0,0];
		fza_ah64_desiglist = fza_ah64_desiglist + [_ah64laser];
		publicvariable "fza_ah64_desiglist";
	} else {
		{
			if(local _x) exitwith {_ah64laser = _x;};
		} foreach fza_ah64_desiglist;
	};

	(group gunner _heli) reveal _ah64laser;

	if(isNil "fza_ah64_selflaser_val") then {fza_ah64_selflaser_val = 0;};

	if(cameraView == "GUNNER") then
	{
		_screenpos = ATLToASL screenToWorld [0.5,0.5];
		_objislist = lineIntersectsWith [getposasl _heli, _screenpos, _heli, _ah64laser, true];
		if(count _objislist > 0) then
		{
			_obsobj = _objislist select 0;
			_direction = ((_screenpos select 0) - (getpos _heli select 0)) atan2 ((_screenpos select 1) - (getpos _heli select 1));
			_pitch = ((_screenpos select 2) - (getposasl _heli select 2)) atan2 ([(getposasl _heli select 0),(getposasl _heli select 1),0] distance [(_screenpos select 0),(_screenpos select 1),0]);
			if(fza_ah64_targlos == 0 && currentweapon _heli in ["fza_agm114_23_8","fza_agm114_14_8","fza_agm114_1_4","fza_agm114_2_4","fza_agm114_3_4","fza_agm114_4_4","fza_agm114_1_ul","fza_agm114_1_ur","fza_agm114_1_ll","fza_agm114_1_lr","fza_agm114_2_ul","fza_agm114_2_ur","fza_agm114_2_ll","fza_agm114_2_lr","fza_agm114_3_ul","fza_agm114_3_ur","fza_agm114_3_ll","fza_agm114_3_lr","fza_agm114_4_ul","fza_agm114_4_ur","fza_agm114_4_ll","fza_agm114_4_lr"]) then
			{
				fza_ah64_selflaser_val = fza_ah64_selflaser_val + 0.5;
			};
		_corpos = [(getpos _heli select 0) + (sin _direction * ((_obsobj distance _heli) - fza_ah64_selflaser_val)),(getpos _heli select 1) + (cos _direction * ((_obsobj distance _heli) - fza_ah64_selflaser_val)),(getposasl _heli select 2) + (sin _pitch * ((_obsobj distance _heli) - fza_ah64_selflaser_val))];
		_ah64laser setposasl _corpos;
		} else {
			_ah64laser setpos (screenToWorld [0.5,0.5]);
			fza_ah64_selflaser_val = 0;
		};
	};
} else {
	_ah64laser = objNull;
	{
		if(local _x || isNull _x) exitwith
		{
			fza_ah64_desiglist = fza_ah64_desiglist - [_x];
			publicvariable "fza_ah64_desiglist";
			deletevehicle _ah64laser;
		};
	} foreach fza_ah64_desiglist;
	fza_ah64_selflaser_val = 0;
};