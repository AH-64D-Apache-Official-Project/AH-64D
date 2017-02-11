if(!(isNil "fza_ah64_noufd")) exitwith {};
_heli = _this select 0;
_advlist = [];
_caulist = [];
_wrnlist = [];
_rtrbrake = 0;
_canopy = 0;
_trdam = 0;
_bingo = 0;
_mrdam = 0;
_tadsdam = 0;
_gunjam = 0;
_gunfail = 0;
_pnvsfail = 0;
_transdam = 0;
_fcrfail = 0;
_e1fire = 0;
_e2fire = 0;
_apufire = 0;
_irjoheat = 0;
_rfjoheat = 0;
_irjfail = 0;
_rfjfail = 0;
_hovhold = 0;
_baton = 0;
_apuon = 0;
_mpdpwr = 0;
_bingoa = 0;
_pylon1dam = 0;
_pylon2dam = 0;
_pylon3dam = 0;
_pylon4dam = 0;
_pylon5dam = 0;
_gundam = 0;
_rwingdam = 0;
_lwingdam = 0;
_e1start = 0;
_e2start = 0;

if(isNil "fza_ah64_fuelsave") then {fza_ah64_fuelsave = 1;};

//waituntil {(gunner _heli == player || driver _heli == player)};

_wcacall = {
		_heli = _this select 0;
		_start = _this select 1;
		_end = _this select 2;
		_list = _this select 3;
		_counter = count _list - 1;
		_selection = _start;
		while {(_counter >= 0 && _selection <= _end)} do
		{
			_heli setobjecttexture [_selection,(_list select _counter)];
			_selection = _selection + 1;
			_counter = _counter - 1;
			sleep 0.03;
		};
		if(count _list < 5) then
		{
			_selection = _end;
			while {(_selection >= (count _list + _start))} do
			{
				_heli setobjecttexture [_selection,""];
				_selection = _selection - 1;
				sleep 0.03;
			};
		};
};

while {(time > -1)} do
{
waituntil{(vehicle player) iskindof "fza_ah64base"};
_heli = vehicle player;
waitUntil {((driver (vehicle player) == player || gunner (vehicle player) == player))};

///////NAV///////
	if(!(isnil "fza_ah64_waypointdata")) then
	{
	if(fza_ah64_curwpnum > (count fza_ah64_waypointdata - 1)) then {fza_ah64_curwpnum = 0;};
	fza_ah64_curwp = fza_ah64_waypointdata select fza_ah64_curwpnum;
	if([(getposasl _heli select 0),(getposasl _heli select 1),0] distance fza_ah64_curwp < 500) then {fza_ah64_curwpnum = fza_ah64_curwpnum + 1;};
	};
/////////////////

_hour = round(floor daytime);
_min = round(floor((daytime - floor(daytime)) * 60));
_sec = floor((((daytime - floor daytime) * 60) - floor((daytime - floor daytime) * 60)) * 60);
_hourformat1 = [_hour,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_hourformat2 = [_hour,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;
_minformat1 = [_min,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_minformat2 = [_min,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;
_secformat1 = [_sec,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_secformat2 = [_sec,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;
_intfuelweight = round(fza_ah64_fuelsave * 2538);
_intfuelformat1 = [_intfuelweight,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitthou;
_intfuelformat2 = [_intfuelweight,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
_intfuelformat3 = [_intfuelweight,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_intfuelformat4 = [_intfuelweight,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;
///WCA///
	_mags = _heli magazinesturret [-1];
	_magsg = magazines _heli;

////GUNNER WEAPON DAMAGE////
if(player == gunner _heli && !(local _heli)) then
{
	if("fza_ah64_mdam_pylon1" in _mags && _pylon1dam == 0) then
	{
		_pylon1dam = 1;
		[_heli,"pylon1"] call fza_ah64_weapondamage;
	} else {
		_pylon1dam = 0;
	};

	if("fza_ah64_mdam_pylon2" in _mags && _pylon2dam == 0) then
	{
		_pylon2dam = 1;
		[_heli,"pylon2"] call fza_ah64_weapondamage;
	} else {
		_pylon2dam = 0;
	};

	if("fza_ah64_mdam_pylon3" in _mags && _pylon3dam == 0) then
	{
		_pylon3dam = 1;
		[_heli,"pylon3"] call fza_ah64_weapondamage;
	} else {
		_pylon3dam = 0;
	};

	if("fza_ah64_mdam_pylon4" in _mags && _pylon4dam == 0) then
	{
		_pylon4dam = 1;
		[_heli,"pylon4"] call fza_ah64_weapondamage;
	} else {
		_pylon4dam = 0;
	};

	if("fza_ah64_mdam_lwing" in _mags && _lwingdam == 0) then
	{
		_lwingdam = 1;
		[_heli,"lwing"] call fza_ah64_weapondamage;
	} else {
		_lwingdam = 0;
	};

	if("fza_ah64_mdam_rwing" in _mags && _rwingdam == 0) then
	{
		_rwingdam = 1;
		[_heli,"rwing"] call fza_ah64_weapondamage;
	} else {
		_rwingdam = 0;
	};

	if("fza_ah64_gun_jam" in _mags && _gundam == 0) then
	{
		_gundam = 1;
		_heli removemagazine "fza_m230_1200";
		_heli removemagazine "fza_m230_350";
	} else {
		_gundam = 1;
	};
};
///end gunner weapon damage//
	if("fza_ah64_rdp_fail" in _mags && "fza_ah64_ldp_fail" in _mags) then
	{
		fza_ah64_pr_mpd = "fail";
		_heli setobjecttexture [303,""];
		fza_ah64_pl_mpd = "fail";
		_heli setobjecttexture [302,""];
	};
	if(fza_ah64_apuon == 1) then
	{
		_heli setobjecttexture [433,"\fza_ah64_us\tex\in\pushbut.paa"];
	} else {
		_heli setobjecttexture [433,""];
	};
	if(fza_ah64_apuon == 0 && fza_ah64_pwron == 0 && !(isengineon _heli) && !(_heli animationphase "plt_eng1_start" > 0.5) && !(_heli animationphase "plt_eng2_start" > 0)  && fza_ah64_cem) then
	{
		fza_ah64_pr_mpd = "off";
		_heli setobjecttexture [303,""];
		fza_ah64_pl_mpd = "off";
		_heli setobjecttexture [302,""];
		_mpdpwr = 0;
	};
	if((fza_ah64_apuon == 1 || fza_ah64_pwron == 1 || isengineon _heli || _heli animationphase "plt_eng1_start" > 0 || _heli animationphase "plt_eng2_start" > 0) && _mpdpwr == 0) then
	{
		if(fza_ah64_pl_mpd == "off") then {fza_ah64_pl_mpd = "fuel";};
		if(fza_ah64_pr_mpd == "off") then {fza_ah64_pr_mpd = "eng";};
		_mpdpwr = 1;
	};
	if("fza_ah64_rdp_fail" in _mags && !("fza_ah64_ldp_fail" in _mags) && fza_ah64_pl_mpd != "fail") then
	{
		fza_ah64_pr_mpd = "fail";
		_heli setobjecttexture [303,""];
	};
	if("fza_ah64_ldp_fail" in _mags && !("fza_ah64_rdp_fail" in _mags) && fza_ah64_pr_mpd != "fail") then
	{
		fza_ah64_pl_mpd = "fail";
		_heli setobjecttexture [302,""];
	};
	if(fza_ah64_apuon == 1 && _apuon == 0) then
	{
		_advlist = _advlist + ["\fza_ah64_us\tex\UFD\APUON_A_co.paa"];
		_advlist set [(count _advlist - 1),"\fza_ah64_us\tex\UFD\APUON_A_co.paa"];
		_apuon = 1;
	};
	if(fza_ah64_apuon == 0) then
	{
		_advlist = _advlist - ["\fza_ah64_us\tex\UFD\APUON_A_co.paa"];
		_apuon = 0;
	};
/*
	if(fza_ah64_pwron == 1 && _baton == 0) then
	{
		_advlist = _advlist + ["\fza_ah64_us\tex\UFD\BATTERYON_A_co.paa"];
		_advlist set [(count _advlist - 1),"\fza_ah64_us\tex\UFD\BATTERYON_A_co.paa"];
		_baton = 1;
	};
	if(fza_ah64_pwron == 0) then
	{
		_advlist = _advlist - ["\fza_ah64_us\tex\UFD\BATTERYON_A_co.paa"];
		_baton = 0;
	};
*/
	if(isAutoHoverOn _heli && _hovhold == 0) then
	{
		_advlist = _advlist + ["\fza_ah64_us\tex\UFD\ATTHLD_A_co.paa"];
		_advlist set [(count _advlist - 1),"\fza_ah64_us\tex\UFD\ATTHLD_A_co.paa"];
		_hovhold = 1;
	};
	if(!(isAutoHoverOn _heli)) then
	{
		_advlist = _advlist - ["\fza_ah64_us\tex\UFD\ATTHLD_A_co.paa"];
		_hovhold = 0;
	};
	if(_rtrbrake == 0 && (_heli animationphase "plt_rtrbrake" < 1)) then
	{
		_advlist = _advlist + ["\fza_ah64_us\tex\UFD\RTRBRKON_C_co.paa"];
		_advlist set [(count _advlist - 1),"\fza_ah64_us\tex\UFD\RTRBRKON_C_co.paa"];
		_rtrbrake = 1;
	};
	if(isengineon _heli || (_heli animationphase "plt_rtrbrake" > 0)) then
	{
		_advlist = _advlist - ["\fza_ah64_us\tex\UFD\RTRBRKON_C_co.paa"];
		_rtrbrake = 0;
	};
	if(_canopy == 0 && (_heli animationphase "gdoor" > 0 || _heli animationphase "pdoor" > 0)) then
	{
		_advlist = _advlist + ["\fza_ah64_us\tex\UFD\CANOPYOPEN_A_co.paa"];
		_advlist set [(count _advlist - 1),"\fza_ah64_us\tex\UFD\CANOPYOPEN_A_co.paa"];
		_canopy = 1;
	};
	if(_heli animationphase "gdoor" == 0 && _heli animationphase "pdoor" == 0) then
	{
		_advlist = _advlist - ["\fza_ah64_us\tex\UFD\CANOPYOPEN_A_co.paa"];
		_canopy = 0;
	};
	if(fza_ah64_fuelsave <= 0.1 && _bingo == 0) then
	{
		_caulist = _caulist + ["\fza_ah64_us\tex\UFD\FWDFUELLOW_C_co.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\FWDFUELLOW_C_co.paa"];
		_bingo = 1;
	};
	if(fza_ah64_fuelsave > 0.1 && _bingo == 1) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\FWDFUELLOW_C_co.paa"];
		_bingo = 0;
	};
	if(fza_ah64_fuelsave <= 0.05 && _bingoa == 0) then
	{
		_caulist = _caulist + ["\fza_ah64_us\tex\UFD\AFTFUELLO_C_co.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\AFTFUELLO_C_co.paa"];
		_bingoa = 1;
	};
	if(fza_ah64_fuelsave > 0.05 && _bingoa == 1) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\AFTFUELLO_C_co.paa"];
		_bingoa = 0;
	};
	if("fza_ah64_tailrotor_dam" in _mags && _trdam == 0) then
	{
		_caulist = _caulist + ["\fza_ah64_us\tex\UFD\TAILRTRHYD_W_co.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\TAILRTRHYD_W_co.paa"];
		_trdam = 1;
	};
	if("fza_ah64_tailrotor_fail" in _mags && _trdam < 2) then
	{
		_wrnlist = _wrnlist + ["\fza_ah64_us\tex\UFD\TAILRTRHYD_W_co.paa"];
		_wrnlist set [(count _wrnlist - 1),"\fza_ah64_us\tex\UFD\TAILRTRHYD_W_co.paa"];
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\TAILRTRHYD_W_co.paa"];
		_trdam = 2;
	};
	if(_trdam > 0 && !("fza_ah64_tailrotor_fail" in _mags || "fza_ah64_tailrotor_dam" in _mags)) then
	{
		_wrnlist = _wrnlist - ["\fza_ah64_us\tex\UFD\TAILRTRHYD_W_co.paa"];
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\TAILRTRHYD_W_co.paa"];
		_trdam = 0;
	};
/*
	if("fza_ah64_rotor_dam" in _mags && _mrdam == 0) then
	{
		_wrnlist = _wrnlist + ["\fza_ah64_us\tex\UFD\HRTRRPM.paa"];
		_wrnlist set [(count _wrnlist - 1),"\fza_ah64_us\tex\UFD\HRTRRPM.paa"];
		_mrdam = 1;
	};
	if("fza_ah64_rotor_fail" in _mags && _mrdam < 2) then
	{
		_wrnlist = _wrnlist + ["\fza_ah64_us\tex\UFD\LRTRRPM.paa"];
		_wrnlist set [(count _wrnlist - 1),"\fza_ah64_us\tex\UFD\LRTRRPM.paa"];
		_wrnlist = _wrnlist - ["\fza_ah64_us\tex\UFD\HRTRRPM.paa"];
		_mrdam = 2;
	};
	if(_mrdam > 0 && !("fza_ah64_rotor_dam" in _mags || "fza_ah64_rotor_fail" in _mags)) then
	{
		_wrnlist = _wrnlist - ["\fza_ah64_us\tex\UFD\HRTRRPM.paa"];
		_wrnlist = _wrnlist - ["\fza_ah64_us\tex\UFD\LRTRRPM.paa"];
		_mrdam = 0;
	};
	if("fza_ah64_tads_dam" in _mags && _tadsdam == 0) then
	{
		_caulist = _caulist + ["\fza_ah64_us\tex\UFD\TADSDEGR.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\TADSDEGR.paa"];
		_tadsdam = 1;
	};
	if("fza_ah64_tads_fail" in _mags && _tadsdam < 2) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\TADSDEGR.paa"];
		_caulist = _caulist + ["\fza_ah64_us\tex\UFD\TADSFAIL.paa"];
		_caulist = _caulist + ["\fza_ah64_us\tex\UFD\LASEFAIL.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\TADSFAIL.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\LASEFAIL.paa"];
		_tadsdam = 2;
	};
	if(_tadsdam > 0 && !("fza_ah64_tads_fail" in _mags || "fza_ah64_tads_dam" in _mags)) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\TADSDEGR.paa"];
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\TADSFAIL.paa"];
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\LASEFAIL.paa"];
		_tadsdam = 0;
	};
	if("fza_ah64_gun_jam" in _mags && _gunjam == 0) then
	{
		_caulist  = _caulist + ["\fza_ah64_us\tex\UFD\GUNJAM.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\GUNJAM.paa"];
		_gunjam = 1;
	};
	if(_gunjam > 0 && !("fza_ah64_gun_jam" in _mags)) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\GUNJAM.paa"];
		_gunjam = 0;
	};
	if("fza_ah64_gun_fail" in _mags && _gunfail == 0) then
	{
		_caulist  = _caulist + ["\fza_ah64_us\tex\UFD\GUNACTFAIL.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\GUNACTFAIL.paa"];
		_gunfail = 1;
	};
	if(_gunfail > 0 && !("fza_ah64_gun_fail" in _mags)) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\GUNACTFAIL.paa"];
		_gunfail = 0;
	};
	if("fza_ah64_pnvs_fail" in _mags && _pnvsfail == 0) then
	{
		_caulist  = _caulist + ["\fza_ah64_us\tex\UFD\PNVSFAIL.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\PNVSFAIL.paa"];
		_pnvsfail = 1;
	};
	if(_pnvsfail > 0 && !("fza_ah64_pnvs_fail" in _mags)) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\PNVSFAIL.paa"];
		_pnvsfail = 0;
	};
*/
	if("fza_ah64_trans_dam" in _mags && _transdam == 0) then
	{
		_caulist  = _caulist + ["\fza_ah64_us\tex\UFD\MAINXMSN_C_co.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\MAINXMSN_C_co.paa"];
		_transdam = 1;
	};
	if("fza_ah64_trans_fail" in _mags && _transdam < 2) then
	{
		_wrnlist = _wrnlist + ["\fza_ah64_us\tex\UFD\MAINXMSN_C_co.paa"];
		_wrnlist set [(count _wrnlist - 1),"\fza_ah64_us\tex\UFD\MAINXMSN_C_co.paa"];
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\MAINXMSN_C_co.paa"];
		_transdam = 2;
	};
	if(_transdam > 0 && !("fza_ah64_trans_dam" in _mags || "fza_ah64_trans_fail" in _mags)) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\MAINXMSN_C_co.paa"];
		_wrnlist = _wrnlist - ["\fza_ah64_us\tex\UFD\MAINXMSN_C_co.paa"];
		_transdam = 0;
	};
/*
	if("fza_ah64_fcr_fail" in _mags && _fcrfail == 0) then
	{
		_caulist = _caulist + ["\fza_ah64_us\tex\UFD\FCRFAIL.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\FCRFAIL.paa"];
		_fcrfail = 1;
	};
	if(_fcrfail > 0 && !("fza_ah64_fcr_fail" in _mags)) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\FCRFAIL.paa"];
		_fcrfail = 0;
	};
*/
	if("fza_ah64_e1_fire" in _mags) then
	{
		_heli setobjecttexture [1192,"\fza_ah64_us\tex\in\pushbut.paa"];
	} else {
		_heli setobjecttexture [1192,""];
		_e1fire = 0;
	};
	if("fza_ah64_e2_fire" in _mags) then
	{
		_heli setobjecttexture [1194,"\fza_ah64_us\tex\in\pushbut.paa"];
	} else {
		_heli setobjecttexture [1194,""];
		_e2fire = 0;
	};
	if("fza_ah64_apu_fire" in _mags) then
	{
		_heli setobjecttexture [1196,"\fza_ah64_us\tex\in\pushbut.paa"];
	} else {
		_heli setobjecttexture [1196,""];
		_apufire = 0;
	};
	if("fza_ah64_firepdisch" in _mags || "fza_ah64_firepdisch" in _magsg) then
	{
		_heli setobjecttexture [1198,"\fza_ah64_us\tex\in\pushbut.paa"];
	};
	if("fza_ah64_firerdisch" in _mags || "fza_ah64_firerdisch" in _magsg) then
	{
		_heli setobjecttexture [1199,"\fza_ah64_us\tex\in\pushbut.paa"];
	};
///engine starts///

	if(_heli animationphase "plt_eng1_start" > 0 && _heli animationphase "plt_eng1_throttle" < 0.25 && _e1start == 0) then
	{
		_advlist = _advlist + ["\fza_ah64_us\tex\UFD\ENG1START_A_co.paa"];
		_advlist set [(count _advlist - 1),"\fza_ah64_us\tex\UFD\ENG1START_A_co.paa"];
		_e1start = 1;
	};
	if(_heli animationphase "plt_eng1_start" < 1 || _heli animationphase "plt_eng1_throttle" > 0.25) then
	{
		_advlist = _advlist - ["\fza_ah64_us\tex\UFD\ENG1START_A_co.paa"];
		_e1start = 0;
	};

	if(_heli animationphase "plt_eng2_start" > 0 && _heli animationphase "plt_eng2_throttle" < 0.25 && _e2start == 0) then
	{
		_advlist = _advlist + ["\fza_ah64_us\tex\UFD\ENG2START_A_co.paa"];
		_advlist set [(count _advlist - 1),"\fza_ah64_us\tex\UFD\ENG2START_A_co.paa"];
		_e2start = 1;
	};
	if(_heli animationphase "plt_eng2_start" < 1 || _heli animationphase "plt_eng2_throttle" > 0.25) then
	{
		_advlist = _advlist - ["\fza_ah64_us\tex\UFD\ENG2START_A_co.paa"];
		_e2start = 0;
	};

///jammer oheats///
	if(fza_ah64_irjammer > 55 && _irjoheat == 0) then
	{
		_advlist = _advlist + ["\fza_ah64_us\tex\UFD\IRJAMOHEAT_A_co.paa"];
		_advlist set [(count _advlist - 1),"\fza_ah64_us\tex\UFD\IRJAMOHEAT_A_co.paa"];
		_irjoheat = 1;
	};
	if(fza_ah64_irjammer < 5 && _irjoheat == 1) then
	{
		_advlist = _advlist - ["\fza_ah64_us\tex\UFD\IRJAMOHEAT_A_co.paa"];
		_irjoheat = 0;
	};
	if(fza_ah64_rfjammer > 55 && _rfjoheat == 0) then
	{
		_advlist = _advlist + ["\fza_ah64_us\tex\UFD\RFJOHEAT_A_co.paa"];
		_advlist set [(count _advlist - 1),"\fza_ah64_us\tex\UFD\RFJOHEAT_A_co.paa"];
		_rfjoheat = 1;
	};
	if(fza_ah64_rfjammer < 5 && _rfjoheat == 1) then
	{
		_advlist = _advlist - ["\fza_ah64_us\tex\UFD\RFJOHEAT_A_co.paa"];
		_rfjoheat = 0;
	};
//jammer fails
	if("fza_ah64_irjamfail" in _mags && _irjfail == 0) then
	{
		_caulist = _caulist + ["\fza_ah64_us\tex\UFD\IRJAMFAIL_C_co.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\IRJAMFAIL_C_co.paa"];
		_irjfail = 1;
	};
	if(!("fza_ah64_irjamfail" in _mags) && _irjfail == 1) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\IRJAMFAIL_C_co.paa"];
		_irjfail = 0;
	};
	if("fza_ah64_rfjamfail" in _mags && _rfjfail == 0) then
	{
		_caulist = _caulist + ["\fza_ah64_us\tex\UFD\RFJFAIL_C_co.paa"];
		_caulist set [(count _caulist - 1),"\fza_ah64_us\tex\UFD\RFJFAIL_C_co.paa"];
		_rfjfail = 1;
	};
	if(!("fza_ah64_rfjamfail" in _mags) && _rfjfail == 1) then
	{
		_caulist = _caulist - ["\fza_ah64_us\tex\UFD\RFJFAIL_C_co.paa"];
		_rfjfail = 0;
	};
///EWCA//
//pilot
if(fza_ah64_apuon == 1 || fza_ah64_pwron == 1 || isengineon _heli || _heli animationphase "plt_eng1_start" > 0 || _heli animationphase "plt_eng2_start" > 0 || !(fza_ah64_cem)) then
{
_heli setobjecttexture [432,"\fza_ah64_us\tex\in\ufdon.paa"];
_heli setobjecttexture [1018,_secformat2];
_heli setobjecttexture [1019,_secformat1];
_heli setobjecttexture [1020,_minformat2];
_heli setobjecttexture [1021,_minformat1];
_heli setobjecttexture [1022,_hourformat2];
_heli setobjecttexture [1023,_hourformat1];
_heli setobjecttexture [1024,_intfuelformat4];
_heli setobjecttexture [1025,_intfuelformat3];
_heli setobjecttexture [1026,_intfuelformat2];
_heli setobjecttexture [1027,_intfuelformat1];
//advisories//
		_a = [_heli,1028,1032,_advlist] call _wcacall;
//cautions//
		_c = [_heli,1033,1037,_caulist] call _wcacall;
//warnings//
		_w = [_heli,1038,1042,_wrnlist] call _wcacall;
//gunner
_heli setobjecttexture [1043,_secformat2];
_heli setobjecttexture [1044,_secformat1];
_heli setobjecttexture [1045,_minformat2];
_heli setobjecttexture [1046,_minformat1];
_heli setobjecttexture [1047,_hourformat2];
_heli setobjecttexture [1048,_hourformat1];
_heli setobjecttexture [1049,_intfuelformat4];
_heli setobjecttexture [1050,_intfuelformat3];
_heli setobjecttexture [1051,_intfuelformat2];
_heli setobjecttexture [1052,_intfuelformat1];
//advisories//
		_a = [_heli,1053,1057,_advlist] call _wcacall;
//cautions//
		_c = [_heli,1058,1062,_caulist] call _wcacall;
//warnings//
		_w = [_heli,1063,1067,_wrnlist] call _wcacall;
} else {
_heli setobjecttexture [432,""];
_heli setobjecttexture [1018,""];
_heli setobjecttexture [1019,""];
_heli setobjecttexture [1020,""];
_heli setobjecttexture [1021,""];
_heli setobjecttexture [1022,""];
_heli setobjecttexture [1023,""];
_heli setobjecttexture [1024,""];
_heli setobjecttexture [1025,""];
_heli setobjecttexture [1026,""];
_heli setobjecttexture [1027,""];
//advisories//
		_a = [_heli,1028,1032,[]] call _wcacall;
//cautions//
		_c = [_heli,1033,1037,[]] call _wcacall;
//warnings//
		_w = [_heli,1038,1042,[]] call _wcacall;
//gunner
_heli setobjecttexture [1043,""];
_heli setobjecttexture [1044,""];
_heli setobjecttexture [1045,""];
_heli setobjecttexture [1046,""];
_heli setobjecttexture [1047,""];
_heli setobjecttexture [1048,""];
_heli setobjecttexture [1049,""];
_heli setobjecttexture [1050,""];
_heli setobjecttexture [1051,""];
_heli setobjecttexture [1052,""];
//advisories//
		_a = [_heli,1053,1057,[]] call _wcacall;
//cautions//
		_c = [_heli,1058,1062,[]] call _wcacall;
//warnings//
		_w = [_heli,1063,1067,[]] call _wcacall;
};
sleep 0.1;
};