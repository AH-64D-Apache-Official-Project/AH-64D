if(!(isNil "fza_ah64_noflt")) exitwith {};
_heli = _this select 0;
//658 to 833
_hilimit = "\fza_ah64_us\tex\mpd\hi.paa";
_lolimit = "\fza_ah64_us\tex\mpd\lo.paa";
_baroalt = 0;
_radalt = 0;
_collective = 0;
_wpr = 0;
_helidir = 0;
_curwpdir = 0;
_hiden = "\fza_ah64_us\tex\mpd\flt_ca.paa";
_hidep = "\fza_ah64_us\tex\mpd\flt_ca.paa";
_vertvect = 0.5;
_horvect = 0.5;
_dps = 0;
_slip = 0;
_vertvect1 = 0;
_vertvect2 = 0;
_horvect1 = 0;
_horvect2 = 0;
_trq = 0;

while {(time > -1)} do
{
waituntil{(vehicle player) iskindof "fza_ah64base"};
_heli = vehicle player;
waitUntil {((driver (vehicle player) == player || gunner (vehicle player) == player))};
if(fza_ah64_pl_mpd == "flt" || fza_ah64_pr_mpd == "flt") then
{
_hilimit = "";
_lolimit = "";
if(getpos _heli select 2 > 304.8) then {_hilimit = "\fza_ah64_us\tex\mpd\hi.paa";};
if(getpos _heli select 2 < 6.1) then {_lolimit = "\fza_ah64_us\tex\mpd\lo.paa";};

_baroalt = round((getposasl _heli select 2)*0.328084);
if(_baroalt < 0) then {_baroalt = 0;};
_baroaltformat1 = [_baroalt,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitthou;
_baroaltformat2 = [_baroalt,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
_baroaltformat3 = [_baroalt,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_baroaltformat4 = [_baroalt,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

_radalt = round((getpos _heli select 2)*3.28084);
if(_radalt < 0) then {_radalt = 0;};
_radaltformat1 = [_radalt,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitthou;
_radaltformat2 = [_radalt,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
_radaltformat3 = [_radalt,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_radaltformat4 = [_radalt,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

_aspd = round(1.94*(sqrt(((velocity _heli select 0) + (0.836*(abs(wind select 0)^1.5)))^2 + ((velocity _heli select 1) + (0.836*(abs(wind select 2)^1.5)))^2 + ((velocity _heli select 2) + (0.836*(abs(wind select 1)^1.5)))^2)));
_aspdformat2 = [_aspd,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
_aspdformat3 = [_aspd,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_aspdformat4 = [_aspd,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

_gspd = round(0.53996*(abs(speed _heli)));
_gspdformat2 = [_gspd,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
_gspdformat3 = [_gspd,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_gspdformat4 = [_gspd,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

if (!difficultyEnabledRTD) then 
{
_trq = round(100*((0.25*(2-(inputAction "HeliCollectiveLowerCont" + inputAction "heliThrottleNeg" + inputAction "heliDown"))) + (0.25*(inputAction "HeliCollectiveRaiseCont" + inputAction "heliUp" + inputAction "heliThrottlePos"))));
}; 

if (difficultyEnabledRTD && count (enginesTorqueRTD _heli) > 0) then {_trq = round((enginesTorqueRTD _heli select 0) / 5.6);};

//if((format ["%1",round (((enginesTorqueRTD _heli select 0) + (enginesTorqueRTD _heli select 1)) / 35)]) == "scalar") then {_trq = 0;};
_trqformat2 = [_trq,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
_trqformat3 = [_trq,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_trqformat4 = [_trq,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

_wpr = ([(fza_ah64_curwp select 0),(fza_ah64_curwp select 1),0] distance [(getpos _heli select 0),(getpos _heli select 1),0]) * 0.001;
_wprtk = round(floor(_wpr * 0.1));
_wprk = round(floor(10*((_wpr * 0.1) - floor(_wpr * 0.1))));
_wprdk = round(10*(_wpr - (round(floor _wpr))));
if(_wprdk > 9) then {_wprdk = 9;};
_wprformat1 = "\fza_ah64_us\tex\CHAR\G" + (format ["%1",_wprtk]) + "_ca.paa";
_wprformat2 = "\fza_ah64_us\tex\CHAR\G" + (format ["%1",_wprk]) + "_ca.paa";
_wprformat3 = "\fza_ah64_us\tex\CHAR\G" + (format ["%1",_wprdk]) + "_ca.paa";

_helidir = (direction _heli);
_hdgformat1 = [_helidir,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
_hdgformat2 = [_helidir,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
_hdgformat3 = [_helidir,"\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

_hiden = "\fza_ah64_us\tex\mpd\flt_ca.paa";
_hidep = "\fza_ah64_us\tex\mpd\flt_ca.paa";
if(_heli animationphase "mpd_pr_flt_bank" > 0.6) then {_hidep = "";};
if(_heli animationphase "mpd_pr_flt_bank" < -0.6) then {_hiden = "";};

_theta = [_heli,(getposatl _heli select 0),(getposatl _heli select 1),(fza_ah64_curwp select 0),(fza_ah64_curwp select 1)] call fza_ah64_reldir;

_targhead = _theta;

if (_theta >= 180) then {_targhead = _theta - 360;} else {_targhead = _theta;};
_curwpdir = _targhead;

_vvect = [_heli] call fza_ah64_velvect;

_vertvect = (_vvect select 0) + 0.5;
_horvect = (_vvect select 1) + 0.6;

_dps = direction _heli;

_wpdistr = [(fza_ah64_curwp select 0),(fza_ah64_curwp select 1),0] distance [(getpos _heli select 0),(getpos _heli select 1),0];

sleep 0.03;

_wpdistr = (_wpdistr - ([(fza_ah64_curwp select 0),(fza_ah64_curwp select 1),0] distance [(getpos _heli select 0),(getpos _heli select 1),0]))*33;

if(_wpdistr < 1) then {_wpdistr = 1;};

_wptime = ([(fza_ah64_curwp select 0),(fza_ah64_curwp select 1),0] distance [(getpos _heli select 0),(getpos _heli select 1),0]) / _wpdistr;
if(_wptime > 32400) then {_wptime = 32400;};

_wptimhr = round(floor(_wptime*0.0002778));
_wptim = round(60*((_wptime * 0.0002778) - floor(_wptime * 0.0002778)));
_wptimtm = round(10*(((floor(_wptim * 0.1)) * 0.1) - floor((floor(_wptim * 0.1)) * 0.1)));
_wptimsm = round(10*((_wptim * 0.1) - floor(_wptim * 0.1)));
if(_wptime < 60) then
{
_wptimtm = round(floor (_wptime*0.1));
_wptimsm = round(10*((_wptime*0.1) - (floor (_wptime*0.1))));
if(_wptimtm > 9) then {_wptimtm = 9;};
if(_wptimsm > 9) then {_wptimsm = 9;};
};

_wptimdformat1 = "\fza_ah64_us\tex\CHAR\G" + (format ["%1",_wptimhr]) + "_ca.paa";
_wptimdformat2 = "\fza_ah64_us\tex\CHAR\G" + (format ["%1",_wptimtm]) + "_ca.paa";
_wptimdformat3 = "\fza_ah64_us\tex\CHAR\G" + (format ["%1",_wptimsm]) + "_ca.paa";

_dps = (_dps - direction _heli)*33;

_turn = (_dps*-0.052083)+0.5;

if(_turn > 0.75) then {_turn = 0.75;};
if(_turn < 0.25) then {_turn = 0.25;};

_slip = (fza_ah64_slip * 1.2)+0.5;

if(_slip > 0.7) then {_slip = 0.7;};
if(_slip < 0.3) then {_slip = 0.3;};

if(fza_ah64_pr_mpd == "flt") then
{
_heli setobjecttexture [303,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
if(local _heli) then
{
_heli animate ["mpd_pr_flt_wbear",(_curwpdir * 0.00476)+0.5];
_heli animate ["mpd_pr_flt_wp_h",(_curwpdir * 0.00476)+0.625];
_heli animate ["mpd_pr_flt_wp_v",_vertvect];
_heli animate ["mpd_pr_flt_vvi_v",_vertvect];
_heli animate ["mpd_pr_flt_vvi_h",_horvect];
_heli animate ["mpd_pr_flt_rdr",((_heli animationphase "longbow")*2)+0.5];
_heli animate ["mpd_pr_flt_turn",_turn];
_heli animate ["mpd_pr_flt_slip",_slip];
};
_heli setobjecttexture [658,_baroaltformat4];
_heli setobjecttexture [659,_baroaltformat3];
_heli setobjecttexture [660,_baroaltformat2];
_heli setobjecttexture [661,_baroaltformat1];
_heli setobjecttexture [662,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
_heli setobjecttexture [663,_gspdformat4];
_heli setobjecttexture [664,_gspdformat3];
_heli setobjecttexture [665,_gspdformat2];
_heli setobjecttexture [666,"\fza_ah64_us\tex\mpd\hdg_ca.paa"];
_heli setobjecttexture [667,"\fza_ah64_us\tex\mpd\hdg_ca.paa"];
_heli setobjecttexture [668,_hilimit];
_heli setobjecttexture [669,"\fza_ah64_us\tex\mpd\ladder_ca.paa"];
_heli setobjecttexture [670,_lolimit];
_heli setobjecttexture [671,_hiden];
_heli setobjecttexture [672,_hidep];
_heli setobjecttexture [673,_radaltformat4];
_heli setobjecttexture [674,_radaltformat3];
_heli setobjecttexture [675,_radaltformat2];
_heli setobjecttexture [676,"\fza_ah64_us\tex\mpd\gtape.paa"];
_heli setobjecttexture [677,"\fza_ah64_us\tex\mpd\rdrbear_ca.paa"];
_heli setobjecttexture [678,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
_heli setobjecttexture [679,_aspdformat4];
_heli setobjecttexture [680,_aspdformat3];
_heli setobjecttexture [681,_aspdformat2];
_heli setobjecttexture [682,_trqformat4];
_heli setobjecttexture [683,_trqformat3];
_heli setobjecttexture [684,_trqformat2];
_heli setobjecttexture [685,_wptimdformat3];
_heli setobjecttexture [686,_wptimdformat2];
_heli setobjecttexture [687,_wptimdformat1];
_heli setobjecttexture [688,""];
_heli setobjecttexture [689,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
_heli setobjecttexture [690,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
_heli setobjecttexture [691,"\fza_ah64_us\tex\mpd\cue_ca.paa"];
_heli setobjecttexture [692,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
_heli setobjecttexture [693,"\fza_ah64_us\tex\mpd\cmdbear_ca.paa"];
_heli setobjecttexture [694,"\fza_ah64_us\tex\mpd\wp_ca.paa"];
_heli setobjecttexture [695,_wprformat3];
_heli setobjecttexture [696,_wprformat2];
_heli setobjecttexture [697,_wprformat1];
_heli setobjecttexture [818,_hdgformat3];
_heli setobjecttexture [819,_hdgformat2];
_heli setobjecttexture [820,_hdgformat1];
_heli setobjecttexture [821,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
} else {
_heli setobjecttexture [658,""];
_heli setobjecttexture [659,""];
_heli setobjecttexture [660,""];
_heli setobjecttexture [661,""];
_heli setobjecttexture [662,""];
_heli setobjecttexture [663,""];
_heli setobjecttexture [664,""];
_heli setobjecttexture [665,""];
_heli setobjecttexture [666,""];
_heli setobjecttexture [667,""];
_heli setobjecttexture [668,""];
_heli setobjecttexture [669,""];
_heli setobjecttexture [670,""];
_heli setobjecttexture [671,""];
_heli setobjecttexture [672,""];
_heli setobjecttexture [673,""];
_heli setobjecttexture [674,""];
_heli setobjecttexture [675,""];
_heli setobjecttexture [676,""];
_heli setobjecttexture [677,""];
_heli setobjecttexture [678,""];
_heli setobjecttexture [679,""];
_heli setobjecttexture [680,""];
_heli setobjecttexture [681,""];
_heli setobjecttexture [682,""];
_heli setobjecttexture [683,""];
_heli setobjecttexture [684,""];
_heli setobjecttexture [685,""];
_heli setobjecttexture [686,""];
_heli setobjecttexture [687,""];
_heli setobjecttexture [688,""];
_heli setobjecttexture [689,""];
_heli setobjecttexture [690,""];
_heli setobjecttexture [691,""];
_heli setobjecttexture [692,""];
_heli setobjecttexture [693,""];
_heli setobjecttexture [694,""];
_heli setobjecttexture [695,""];
_heli setobjecttexture [696,""];
_heli setobjecttexture [697,""];
_heli setobjecttexture [818,""];
_heli setobjecttexture [819,""];
_heli setobjecttexture [820,""];
_heli setobjecttexture [821,""];
};
if(fza_ah64_pl_mpd == "flt") then
{
_heli setobjecttexture [302,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
if(local _heli) then
{
_heli animate ["mpd_pl_flt_wbear",(_curwpdir * 0.00476)+0.5];
_heli animate ["mpd_pl_flt_wp_h",(_curwpdir * 0.00476)+0.625];
_heli animate ["mpd_pl_flt_wp_v",_vertvect];
_heli animate ["mpd_pl_flt_vvi_v",_vertvect];
_heli animate ["mpd_pl_flt_vvi_h",_horvect];
_heli animate ["mpd_pl_flt_rdr",((_heli animationphase "longbow")*2)+0.5];
_heli animate ["mpd_pl_flt_turn",_turn];
_heli animate ["mpd_pl_flt_slip",_slip];
};
_heli setobjecttexture [698,_baroaltformat4];
_heli setobjecttexture [699,_baroaltformat3];
_heli setobjecttexture [700,_baroaltformat2];
_heli setobjecttexture [701,_baroaltformat1];
_heli setobjecttexture [702,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
_heli setobjecttexture [703,_gspdformat4];
_heli setobjecttexture [704,_gspdformat3];
_heli setobjecttexture [705,_gspdformat2];
_heli setobjecttexture [706,"\fza_ah64_us\tex\mpd\hdg_ca.paa"];
_heli setobjecttexture [707,"\fza_ah64_us\tex\mpd\hdg_ca.paa"];
_heli setobjecttexture [708,_hilimit];
_heli setobjecttexture [709,"\fza_ah64_us\tex\mpd\ladder_ca.paa"];
_heli setobjecttexture [710,_lolimit];
_heli setobjecttexture [711,_hiden];
_heli setobjecttexture [712,_hidep];
_heli setobjecttexture [713,_radaltformat4];
_heli setobjecttexture [714,_radaltformat3];
_heli setobjecttexture [715,_radaltformat2];
_heli setobjecttexture [716,"\fza_ah64_us\tex\mpd\gtape.paa"];
_heli setobjecttexture [717,"\fza_ah64_us\tex\mpd\rdrbear_ca.paa"];
_heli setobjecttexture [718,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
_heli setobjecttexture [719,_aspdformat4];
_heli setobjecttexture [720,_aspdformat3];
_heli setobjecttexture [721,_aspdformat2];
_heli setobjecttexture [722,_trqformat4];
_heli setobjecttexture [723,_trqformat3];
_heli setobjecttexture [724,_trqformat2];
_heli setobjecttexture [725,_wptimdformat3];
_heli setobjecttexture [726,_wptimdformat2];
_heli setobjecttexture [727,_wptimdformat1];
_heli setobjecttexture [728,""];
_heli setobjecttexture [729,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
_heli setobjecttexture [730,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
if(speed _heli > 5) then
{
	_heli setobjecttexture [731,"\fza_ah64_us\tex\mpd\cue_ca.paa"];
	_heli setobjecttexture [734,"\fza_ah64_us\tex\mpd\wp_ca.paa"];
} else {
	_heli setobjecttexture [731,""];
	_heli setobjecttexture [734,""];
};
_heli setobjecttexture [732,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
_heli setobjecttexture [733,"\fza_ah64_us\tex\mpd\cmdbear_ca.paa"];
///
_heli setobjecttexture [735,_wprformat3];
_heli setobjecttexture [736,_wprformat2];
_heli setobjecttexture [737,_wprformat1];
_heli setobjecttexture [822,_hdgformat3];
_heli setobjecttexture [823,_hdgformat2];
_heli setobjecttexture [824,_hdgformat1];
_heli setobjecttexture [825,"\fza_ah64_us\tex\mpd\flt_ca.paa"];
} else {
_heli setobjecttexture [698,""];
_heli setobjecttexture [699,""];
_heli setobjecttexture [700,""];
_heli setobjecttexture [701,""];
_heli setobjecttexture [702,""];
_heli setobjecttexture [703,""];
_heli setobjecttexture [704,""];
_heli setobjecttexture [705,""];
_heli setobjecttexture [706,""];
_heli setobjecttexture [707,""];
_heli setobjecttexture [708,""];
_heli setobjecttexture [709,""];
_heli setobjecttexture [710,""];
_heli setobjecttexture [711,""];
_heli setobjecttexture [712,""];
_heli setobjecttexture [713,""];
_heli setobjecttexture [714,""];
_heli setobjecttexture [715,""];
_heli setobjecttexture [716,""];
_heli setobjecttexture [717,""];
_heli setobjecttexture [718,""];
_heli setobjecttexture [719,""];
_heli setobjecttexture [720,""];
_heli setobjecttexture [721,""];
_heli setobjecttexture [722,""];
_heli setobjecttexture [723,""];
_heli setobjecttexture [724,""];
_heli setobjecttexture [725,""];
_heli setobjecttexture [726,""];
_heli setobjecttexture [727,""];
_heli setobjecttexture [728,""];
_heli setobjecttexture [729,""];
_heli setobjecttexture [730,""];
_heli setobjecttexture [731,""];
_heli setobjecttexture [732,""];
_heli setobjecttexture [733,""];
_heli setobjecttexture [734,""];
_heli setobjecttexture [735,""];
_heli setobjecttexture [736,""];
_heli setobjecttexture [737,""];
_heli setobjecttexture [822,""];
_heli setobjecttexture [823,""];
_heli setobjecttexture [824,""];
_heli setobjecttexture [825,""];
};
} else {
_heli setobjecttexture [658,""];
_heli setobjecttexture [659,""];
_heli setobjecttexture [660,""];
_heli setobjecttexture [661,""];
_heli setobjecttexture [662,""];
_heli setobjecttexture [663,""];
_heli setobjecttexture [664,""];
_heli setobjecttexture [665,""];
_heli setobjecttexture [666,""];
_heli setobjecttexture [667,""];
_heli setobjecttexture [668,""];
_heli setobjecttexture [669,""];
_heli setobjecttexture [670,""];
_heli setobjecttexture [671,""];
_heli setobjecttexture [672,""];
_heli setobjecttexture [673,""];
_heli setobjecttexture [674,""];
_heli setobjecttexture [675,""];
_heli setobjecttexture [676,""];
_heli setobjecttexture [677,""];
_heli setobjecttexture [678,""];
_heli setobjecttexture [679,""];
_heli setobjecttexture [680,""];
_heli setobjecttexture [681,""];
_heli setobjecttexture [682,""];
_heli setobjecttexture [683,""];
_heli setobjecttexture [684,""];
_heli setobjecttexture [685,""];
_heli setobjecttexture [686,""];
_heli setobjecttexture [687,""];
_heli setobjecttexture [688,""];
_heli setobjecttexture [689,""];
_heli setobjecttexture [690,""];
_heli setobjecttexture [691,""];
_heli setobjecttexture [692,""];
_heli setobjecttexture [693,""];
_heli setobjecttexture [694,""];
_heli setobjecttexture [695,""];
_heli setobjecttexture [696,""];
_heli setobjecttexture [697,""];
_heli setobjecttexture [698,""];
_heli setobjecttexture [699,""];
_heli setobjecttexture [700,""];
_heli setobjecttexture [701,""];
_heli setobjecttexture [702,""];
_heli setobjecttexture [703,""];
_heli setobjecttexture [704,""];
_heli setobjecttexture [705,""];
_heli setobjecttexture [706,""];
_heli setobjecttexture [707,""];
_heli setobjecttexture [708,""];
_heli setobjecttexture [709,""];
_heli setobjecttexture [710,""];
_heli setobjecttexture [711,""];
_heli setobjecttexture [712,""];
_heli setobjecttexture [713,""];
_heli setobjecttexture [714,""];
_heli setobjecttexture [715,""];
_heli setobjecttexture [716,""];
_heli setobjecttexture [717,""];
_heli setobjecttexture [718,""];
_heli setobjecttexture [719,""];
_heli setobjecttexture [720,""];
_heli setobjecttexture [721,""];
_heli setobjecttexture [722,""];
_heli setobjecttexture [723,""];
_heli setobjecttexture [724,""];
_heli setobjecttexture [725,""];
_heli setobjecttexture [726,""];
_heli setobjecttexture [727,""];
_heli setobjecttexture [728,""];
_heli setobjecttexture [729,""];
_heli setobjecttexture [730,""];
_heli setobjecttexture [731,""];
_heli setobjecttexture [732,""];
_heli setobjecttexture [733,""];
_heli setobjecttexture [734,""];
_heli setobjecttexture [735,""];
_heli setobjecttexture [736,""];
_heli setobjecttexture [737,""];
_heli setobjecttexture [818,""];
_heli setobjecttexture [819,""];
_heli setobjecttexture [820,""];
_heli setobjecttexture [821,""];
_heli setobjecttexture [822,""];
_heli setobjecttexture [823,""];
_heli setobjecttexture [824,""];
_heli setobjecttexture [825,""];
};
sleep 0.03;
};