if(!(isNil "fza_ah64_noeng")) exitwith {};
_heli = _this select 0;
_e1addcounter = 0;
_e2addcounter = 0;
_rpmmsg = 0;
_rotorrpm = 0;
_rotorrpmchar = "\fza_ah64_us\tex\char\g";
_rotorrpmformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_rotorrpmformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_rotorrpmformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_rotorrpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e1rpm = 0;
_e2rpm = 0;
_e1rpmchar = "\fza_ah64_us\tex\char\g";
_e1npformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1npformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1npformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1rpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e2rpmchar = "\fza_ah64_us\tex\char\g";
_e2npformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2npformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2npformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2rpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_ofb = "\fza_ah64_us\tex\mpd\eng.paa";
_ifb = "";
_tottorque = 0;
_e1trq = 0;
_e2trq = 0;
_e1trqchar = "\fza_ah64_us\tex\char\g";
_e1trqformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1trqformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1trqformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e2trqchar = "\fza_ah64_us\tex\char\g";
_e2trqformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2trqformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2trqformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_anitrq = 0;
_e1tgt = 0;
_e2tgt = 0;
_e1tgtchar = "\fza_ah64_us\tex\char\g";
_e1tgttape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e1tgtformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1tgtformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1tgtformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2tgtchar = "\fza_ah64_us\tex\char\g";
_e2tgtformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2tgtformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2tgtformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2tgttape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e1opsi = 0;
_e2opsi = 0;
_e1opsichar = "\fza_ah64_us\tex\char\g";
_e1opsiformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1opsiformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1opsiformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1opsitape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e2opsichar = "\fza_ah64_us\tex\char\g";
_e2opsiformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2opsiformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2opsiformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2opsitape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e1ng = 0;
_e2ng = 0;
_e1ngchar = "\fza_ah64_us\tex\char\g";
_e1ngformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1ngformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1ngformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2ngchar = "\fza_ah64_us\tex\char\g";
_e2ngformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2ngformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2ngformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phyd = 0;
_phydformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phydformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phydformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phydformat4 = "\fza_ah64_us\tex\char\g0_ca.paa";
_uhyd = 0;
_uhydformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_uhydformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_uhydformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_uhydformat4 = "\fza_ah64_us\tex\char\g0_ca.paa";
_ahyd = 0;
_ahydformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_ahydformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_ahydformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_ahydformat4 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phyd1format1 = _phydformat1;
_phyd1format2 = _phydformat2;
_phyd1format3 = _phydformat3;
_phyd1format4 = _phydformat4;
_uhyd1format1 = _uhydformat1;
_uhyd1format2 = _uhydformat2;
_uhyd1format3 = _uhydformat3;
_uhyd1format4 = _uhydformat4;
_ahyd1format1 = _ahydformat1;
_ahyd1format2 = _ahydformat2;
_ahyd1format3 = _ahydformat3;
_ahyd1format4 = _ahydformat4;
_e1percent = 0;
_e2percent = 0;
_counter = 0;

while {(time > -1)} do
{
waituntil{(vehicle player) iskindof "fza_ah64base"};
_heli = vehicle player;
waitUntil {((driver (vehicle player) == player || gunner (vehicle player) == player))};

[_heli] call fza_fnc_engineGovernor;

_e1data = [_heli, 0] call fza_fnc_engineGetData;
_e1percent = (_e1data select 0) / 209.0;
_e1ng = (_e1data select 1) * 10;
_e1tgt = _e1data select 2;
_e1opsi = _e1data select 3;
_e1trq = (_e1data select 4) / 4.81;

_e2data = [_heli, 1] call fza_fnc_engineGetData;
_e2percent = (_e2data select 0) / 209.0;
_e2ng = (_e2data select 1) * 10;
_e2tgt = _e2data select 2;
_e2opsi = _e2data select 3;
_e2trq = (_e2data select 4) / 4.81;

if (fza_ah64_engineStates # 0 # 0 in ["OFF", "OFFIDLE", "IDLEOFF"] || fza_ah64_engineStates # 1 # 0 in ["OFF", "OFFIDLE", "IDLEOFF"]) then {
	_rotorrpm = _e1percent max _e2percent;
} else {
	_rotorrpm = (rotorsRpmRTD _heli # 0) / 2.89;
};

if(fza_ah64_pl_mpd == "eng" || fza_ah64_pr_mpd == "eng") then
{
_rotorrpmchar = "\fza_ah64_us\tex\char\g";
_rotorrpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
if(_rotorrpm < 110) then
{
_rpmmsg = 0;
};
if(_rotorrpm > 110 && isengineon _heli && (getpos _heli select 2) > 5) then
{
_rotorrpmchar = "\fza_ah64_us\tex\char\r";
_rotorrpmtape = "\fza_ah64_us\tex\mpd\Rtape.paa";
	if(_rpmmsg == 0) then
	{
		["fza_ah64_bt_rotorrpm",1.7,"fza_ah64_bt_high",1] execvm "\fza_ah64_controls\scripting\damage\dam_bt_audio.sqf";
		_rpmmsg = 1;
	};
};
if(_rotorrpm < 94) then {_rotorrpmchar = "\fza_ah64_us\tex\char\r"; _rotorrpmtape = "\fza_ah64_us\tex\mpd\Rtape.paa";};
_rotorrpmformat1 = [_rotorrpm,_rotorrpmchar] call fza_ah64_digithun;
_rotorrpmformat2 = [_rotorrpm,_rotorrpmchar] call fza_ah64_digitten;
_rotorrpmformat3 = [_rotorrpm,_rotorrpmchar] call fza_ah64_digit;

_e1trqchar = "\fza_ah64_us\tex\char\g";
_e1trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e2trqchar = "\fza_ah64_us\tex\char\g";
_e2trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";

if(_e1trq > 0 && _e1trq < 100) then {_e1trqchar = "\fza_ah64_us\tex\char\g"; _e1trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";};
if(_e1trq > 101 && _e1trq < 115) then {_e1trqchar = "\fza_ah64_us\tex\char\y"; _e1trqtape = "\fza_ah64_us\tex\mpd\Ytape.paa";};
if(_e1trq > 115) then {_e1trqchar = "\fza_ah64_us\tex\char\r"; _e1trqtape = "\fza_ah64_us\tex\mpd\Rtape.paa";};

if(_e2trq > 0 && _e2trq < 100) then {_e2trqchar = "\fza_ah64_us\tex\char\g"; _e2trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";};
if(_e2trq > 101 && _e2trq < 115) then {_e2trqchar = "\fza_ah64_us\tex\char\y"; _e2trqtape = "\fza_ah64_us\tex\mpd\Ytape.paa";};
if(_e2trq > 115) then {_e2trqchar = "\fza_ah64_us\tex\char\r"; _e2trqtape = "\fza_ah64_us\tex\mpd\Rtape.paa";};





_e1trqformat1 = [_e1trq,_e1trqchar] call fza_ah64_digit;
_e1trqformat2 = [_e1trq,_e1trqchar] call fza_ah64_digitten;
_e1trqformat3 = [_e1trq,_e1trqchar] call fza_ah64_digithun;
_e2trqformat1 = [_e2trq,_e2trqchar] call fza_ah64_digit;
_e2trqformat2 = [_e2trq,_e2trqchar] call fza_ah64_digitten;
_e2trqformat3 = [_e2trq,_e2trqchar] call fza_ah64_digithun;

_e1rpmchar = "\fza_ah64_us\tex\char\g";
_e1rpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";

_e1npformat1 = [_e1percent,_e1rpmchar] call fza_ah64_digithun;
_e1npformat2 = [_e1percent,_e1rpmchar] call fza_ah64_digitten;
_e1npformat3 = [_e1percent,_e1rpmchar] call fza_ah64_digit;

_e2rpmchar = "\fza_ah64_us\tex\char\g";
_e2rpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";

_e2npformat1 = [_e2percent,_e2rpmchar] call fza_ah64_digithun;
_e2npformat2 = [_e2percent,_e2rpmchar] call fza_ah64_digitten;
_e2npformat3 = [_e2percent,_e2rpmchar] call fza_ah64_digit;

_e1tgtpercent = round(_e1tgt);
_e1tgtchar = "\fza_ah64_us\tex\char\g";
_e1tgttape = "\fza_ah64_us\tex\mpd\Gtape.paa";

_e1tgtformat1 = [_e1tgtpercent,_e1tgtchar] call fza_ah64_digithun;
_e1tgtformat2 = [_e1tgtpercent,_e1tgtchar] call fza_ah64_digitten;
_e1tgtformat3 = [_e1tgtpercent,_e1tgtchar] call fza_ah64_digit;

_e2tgtpercent = round(_e2tgt);
_e2tgtchar = "\fza_ah64_us\tex\char\g";
_e2tgttape = "\fza_ah64_us\tex\mpd\Gtape.paa";

_e2tgtformat1 = [_e2tgtpercent,_e2tgtchar] call fza_ah64_digithun;
_e2tgtformat2 = [_e2tgtpercent,_e2tgtchar] call fza_ah64_digitten;
_e2tgtformat3 = [_e2tgtpercent,_e2tgtchar] call fza_ah64_digit;

_e1opsichar = "\fza_ah64_us\tex\char\g";
if(_e1opsi < 20 || _e1opsi > 95) then {_e1opsichar = "\fza_ah64_us\tex\char\r";};
_e1opsiformat1 = [_e1opsi,_e1opsichar] call fza_ah64_digithun;
_e1opsiformat2 = [_e1opsi,_e1opsichar] call fza_ah64_digitten;
_e1opsiformat3 = [_e1opsi,_e1opsichar] call fza_ah64_digit;

_e2opsichar = "\fza_ah64_us\tex\char\g";
if(_e2opsi < 20 || _e2opsi > 95) then {_e2opsichar = "\fza_ah64_us\tex\char\r";};
_e2opsiformat1 = [_e2opsi,_e2opsichar] call fza_ah64_digithun;
_e2opsiformat2 = [_e2opsi,_e2opsichar] call fza_ah64_digitten;
_e2opsiformat3 = [_e2opsi,_e2opsichar] call fza_ah64_digit;
_e1ngchar = "\fza_ah64_us\tex\char\g";
if(_e1ng > 1023 && _e1ng < 1051) then {_e1ngchar = "\fza_ah64_us\tex\char\y"; _e1ngtape = "\fza_ah64_us\tex\mpd\Ytape.paa";};
if(_e1ng < 630 || _e1ng > 1051) then {_e1ngchar = "\fza_ah64_us\tex\char\r"; _e1ngtape = "\fza_ah64_us\tex\mpd\Rtape.paa";};

_e1ngformat1 = [_e1ng,_e1ngchar] call fza_ah64_digithun;
_e1ngformat2 = [_e1ng,_e1ngchar] call fza_ah64_digitten;
_e1ngformat3 = [_e1ng,_e1ngchar] call fza_ah64_digit;
_e2ngchar = "\fza_ah64_us\tex\char\g";
if(_e2ng > 1023 && _e2ng < 1051) then {_e2ngchar = "\fza_ah64_us\tex\char\y"; _e2ngtape = "\fza_ah64_us\tex\mpd\Ytape.paa";};
if(_e2ng < 630 || _e2ng > 1051) then {_e2ngchar = "\fza_ah64_us\tex\char\r"; _e2ngtape = "\fza_ah64_us\tex\mpd\Rtape.paa";};

_e2ngformat1 = [_e2ng,_e2ngchar] call fza_ah64_digithun;
_e2ngformat2 = [_e2ng,_e2ngchar] call fza_ah64_digitten;
_e2ngformat3 = [_e2ng,_e2ngchar] call fza_ah64_digit;

//HYDRAULICS

_phydformat = _phyd * 2970;
_phydformat1 = [_phydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digitthou;
_phydformat2 = [_phydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digithun;
_phydformat3 = [_phydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digitten;
_phydformat4 = [_phydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digit;
_uhydformat = _uhyd * 2970;
_uhydformat1 = [_uhydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digitthou;
_uhydformat2 = [_uhydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digithun;
_uhydformat3 = [_uhydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digitten;
_uhydformat4 = [_uhydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digit;
_ahydformat = _phyd * 3000;
_ahydformat1 = [_ahydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digitthou;
_ahydformat2 = [_ahydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digithun;
_ahydformat3 = [_ahydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digitten;
_ahydformat4 = [_ahydformat,"\fza_ah64_us\tex\char\g"] call fza_ah64_digit;

_phyd1format1 = _phydformat1;
_phyd1format2 = _phydformat2;
_phyd1format3 = _phydformat3;
_phyd1format4 = _phydformat4;
_uhyd1format1 = _uhydformat1;
_uhyd1format2 = _uhydformat2;
_uhyd1format3 = _uhydformat3;
_uhyd1format4 = _uhydformat4;
_ahyd1format1 = _ahydformat1;
_ahyd1format2 = _ahydformat2;
_ahyd1format3 = _ahydformat3;
_ahyd1format4 = _ahydformat4;

if(getpos _heli select 2 > 1) then
{
_ifb = "\fza_ah64_us\tex\mpd\ifbox.paa"; _ofb = "";
_phydformat1 = "";
_phydformat2 = "";
_phydformat3 = "";
_phydformat4 = "";
_uhydformat1 = "";
_uhydformat2 = "";
_uhydformat3 = "";
_uhydformat4 = "";
_ahydformat1 = "";
_ahydformat2 = "";
_ahydformat3 = "";
_ahydformat4 = "";
_e1opsiformat1 = "";
_e1opsiformat2 = "";
_e1opsiformat3 = "";
_e2opsiformat1 = "";
_e2opsiformat2 = "";
_e2opsiformat3 = "";
} else {
_ofb = "\fza_ah64_us\tex\mpd\eng.paa"; _ifb = "";
_phyd1format1 = "";
_phyd1format2 = "";
_phyd1format3 = "";
_phyd1format4 = "";
_uhyd1format1 = "";
_uhyd1format2 = "";
_uhyd1format3 = "";
_uhyd1format4 = "";
_ahyd1format1 = "";
_ahyd1format2 = "";
_ahyd1format3 = "";
_ahyd1format4 = "";
};
};
	if(fza_ah64_pr_mpd == "eng") then
	{
		_heli setobjecttexture [303,""];
		_heli setobjecttexture [1248,"\fza_ah64_us\tex\mpd\eng.paa"];
		_heli setobjecttexture [903,_ofb];
		_heli setobjecttexture [902,_ifb];
		_heli setobjecttexture [834,_e1rpmtape];
		_heli setobjecttexture [839,_e1tgttape];
		_heli setobjecttexture [841,_e2rpmtape];
		_heli setobjecttexture [846,_e2tgttape];
		_heli setobjecttexture [850,_e1trqtape];
		_heli setobjecttexture [854,_e2trqtape];
		_heli setobjecttexture [856,"\fza_ah64_us\tex\mpd\eng.paa"];
		_heli setobjecttexture [904,_rotorrpmtape];
		_heli setobjecttexture [840,"\fza_ah64_us\tex\mpd\eng.paa"];
		_heli setobjecttexture [847,"\fza_ah64_us\tex\mpd\eng.paa"];
		_heli setobjecttexture [851,"\fza_ah64_us\tex\mpd\eng.paa"];
		_heli setobjecttexture [855,"\fza_ah64_us\tex\mpd\eng.paa"];
		_heli setobjecttexture [836,_e1tgtformat3];
		_heli setobjecttexture [837,_e1tgtformat2];
		_heli setobjecttexture [838,_e1tgtformat1];
		_heli setobjecttexture [843,_e2tgtformat3];
		_heli setobjecttexture [844,_e2tgtformat2];
		_heli setobjecttexture [845,_e2tgtformat1];
		_heli setobjecttexture [848,_e1trqformat1];
		_heli setobjecttexture [849,_e1trqformat2];
		_heli setobjecttexture [1252,_e1trqformat3];
		_heli setobjecttexture [852,_e2trqformat1];
		_heli setobjecttexture [853,_e2trqformat2];
		_heli setobjecttexture [1253,_e2trqformat3];
		_heli setobjecttexture [857,_ahydformat4];
		_heli setobjecttexture [858,_ahydformat3];
		_heli setobjecttexture [859,_ahydformat2];
		_heli setobjecttexture [860,_ahydformat1];
		_heli setobjecttexture [861,_uhydformat4];
		_heli setobjecttexture [862,_uhydformat3];
		_heli setobjecttexture [863,_uhydformat2];
		_heli setobjecttexture [864,_uhydformat1];
		_heli setobjecttexture [865,_phydformat4];
		_heli setobjecttexture [866,_phydformat3];
		_heli setobjecttexture [867,_phydformat2];
		_heli setobjecttexture [868,_phydformat1];
		_heli setobjecttexture [869,_e1ngformat3];
		_heli setobjecttexture [870,_e1ngformat2];
		_heli setobjecttexture [871,_e1ngformat1];
		_heli setobjecttexture [872,_e2ngformat3];
		_heli setobjecttexture [873,_e2ngformat2];
		_heli setobjecttexture [874,_e2ngformat1];
		_heli setobjecttexture [875,_e1npformat3];
		_heli setobjecttexture [876,_e1npformat2];
		_heli setobjecttexture [877,_e1npformat1];
		_heli setobjecttexture [878,_e2npformat3];
		_heli setobjecttexture [879,_e2npformat2];
		_heli setobjecttexture [880,_e2npformat1];
		_heli setobjecttexture [881,_e1opsiformat3];
		_heli setobjecttexture [882,_e1opsiformat2];
		_heli setobjecttexture [883,_e1opsiformat1];
		_heli setobjecttexture [884,_e2opsiformat3];
		_heli setobjecttexture [885,_e2opsiformat2];
		_heli setobjecttexture [886,_e2opsiformat1];
		_heli setobjecttexture [887,_rotorrpmformat3];
		_heli setobjecttexture [888,_rotorrpmformat2];
		_heli setobjecttexture [889,_rotorrpmformat1];
		_heli setobjecttexture [914,_ahyd1format4];
		_heli setobjecttexture [915,_ahyd1format3];
		_heli setobjecttexture [916,_ahyd1format2];
		_heli setobjecttexture [917,_ahyd1format1];
		_heli setobjecttexture [918,_uhyd1format4];
		_heli setobjecttexture [919,_uhyd1format3];
		_heli setobjecttexture [920,_uhyd1format2];
		_heli setobjecttexture [921,_uhyd1format1];
		_heli setobjecttexture [922,_phyd1format4];
		_heli setobjecttexture [923,_phyd1format3];
		_heli setobjecttexture [924,_phyd1format2];
		_heli setobjecttexture [925,_phyd1format1];
		if(local _heli) then
		{
		_heli animate ["mpd_pr_eng_e1trq",_e1trq / 130.0];
		_heli animate ["mpd_pr_eng_e2trq",_e2trq / 130.0];
		_heli animate ["mpd_pr_eng_1tgt", _e1tgt / 999.0];
		_heli animate ["mpd_pr_eng_2tgt", _e2tgt / 999.0];
		_heli animate ["mpd_pr_eng_e1np", _e1percent / 100.0];
		_heli animate ["mpd_pr_eng_e2np", _e2percent / 100.0];

		_heli animate ["mpd_pr_eng_rtrrpm", _rotorrpm / 100.0];
		};
	} else {
		_heli setobjecttexture [834,""];
		_heli setobjecttexture [835,""];
		_heli setobjecttexture [836,""];
		_heli setobjecttexture [837,""];
		_heli setobjecttexture [838,""];
		_heli setobjecttexture [839,""];
		_heli setobjecttexture [840,""];
		_heli setobjecttexture [841,""];
		_heli setobjecttexture [842,""];
		_heli setobjecttexture [843,""];
		_heli setobjecttexture [844,""];
		_heli setobjecttexture [845,""];
		_heli setobjecttexture [846,""];
		_heli setobjecttexture [847,""];
		_heli setobjecttexture [848,""];
		_heli setobjecttexture [849,""];
		_heli setobjecttexture [850,""];
		_heli setobjecttexture [851,""];
		_heli setobjecttexture [852,""];
		_heli setobjecttexture [853,""];
		_heli setobjecttexture [854,""];
		_heli setobjecttexture [855,""];
		_heli setobjecttexture [856,""];
		_heli setobjecttexture [857,""];
		_heli setobjecttexture [858,""];
		_heli setobjecttexture [859,""];
		_heli setobjecttexture [860,""];
		_heli setobjecttexture [861,""];
		_heli setobjecttexture [862,""];
		_heli setobjecttexture [863,""];
		_heli setobjecttexture [864,""];
		_heli setobjecttexture [865,""];
		_heli setobjecttexture [866,""];
		_heli setobjecttexture [867,""];
		_heli setobjecttexture [868,""];
		_heli setobjecttexture [869,""];
		_heli setobjecttexture [870,""];
		_heli setobjecttexture [871,""];
		_heli setobjecttexture [872,""];
		_heli setobjecttexture [873,""];
		_heli setobjecttexture [874,""];
		_heli setobjecttexture [875,""];
		_heli setobjecttexture [876,""];
		_heli setobjecttexture [877,""];
		_heli setobjecttexture [878,""];
		_heli setobjecttexture [879,""];
		_heli setobjecttexture [880,""];
		_heli setobjecttexture [881,""];
		_heli setobjecttexture [882,""];
		_heli setobjecttexture [883,""];
		_heli setobjecttexture [884,""];
		_heli setobjecttexture [885,""];
		_heli setobjecttexture [886,""];
		_heli setobjecttexture [887,""];
		_heli setobjecttexture [888,""];
		_heli setobjecttexture [889,""];
		_heli setobjecttexture [890,""];
		_heli setobjecttexture [891,""];
		_heli setobjecttexture [892,""];
		_heli setobjecttexture [893,""];
		_heli setobjecttexture [894,""];
		_heli setobjecttexture [895,""];
		_heli setobjecttexture [896,""];
		_heli setobjecttexture [897,""];
		_heli setobjecttexture [898,""];
		_heli setobjecttexture [899,""];
		_heli setobjecttexture [900,""];
		_heli setobjecttexture [901,""];
		_heli setobjecttexture [902,""];
		_heli setobjecttexture [903,""];
		_heli setobjecttexture [904,""];
		_heli setobjecttexture [905,""];
		_heli setobjecttexture [906,""];
		_heli setobjecttexture [907,""];
		_heli setobjecttexture [908,""];
		_heli setobjecttexture [909,""];
		_heli setobjecttexture [910,""];
		_heli setobjecttexture [911,""];
		_heli setobjecttexture [912,""];
		_heli setobjecttexture [913,""];
		_heli setobjecttexture [914,""];
		_heli setobjecttexture [915,""];
		_heli setobjecttexture [916,""];
		_heli setobjecttexture [917,""];
		_heli setobjecttexture [918,""];
		_heli setobjecttexture [919,""];
		_heli setobjecttexture [920,""];
		_heli setobjecttexture [921,""];
		_heli setobjecttexture [922,""];
		_heli setobjecttexture [923,""];
		_heli setobjecttexture [924,""];
		_heli setobjecttexture [925,""];
		_heli setobjecttexture [1248,""];
	};
sleep 0.03;
};