if(!(isNil "fza_ah64_noblades")) exitwith {};
_estate = 0;
_heli = _this select 0;
_alt = 0;
_adsp = 0;
_adsp2 = 0;
_smoothrand = 0;
_smoothrand2 = 0;
_smoothrand3 = 0;
_smoothrand4 = 0;
_smoothing1 = 0;
_smoothing2 = 0;
_smoothfactor = 0;
_velfactor = 0;
_weight = 90;

//_fza_ah64_bladescript = [_heli] execvm "\fza_ah64_controls\scripting\bladetracker.sqf";

while {alive _heli} do
{
_rtex = "\fza_ah64_us\tex\ex\rtrs_co.paa";
_trtex = "\fza_ah64_us\tex\ex\rtrs_co.paa";
if("fza_ah64_tailrotor_dam" in (_heli magazinesturret [-1])) then
{
_trtex = "\fza_ah64_us\tex\dam\mdam_Rtrs_co.paa";
};
if("fza_ah64_tailrotor_fail" in (_heli magazinesturret [-1])) then
{
_trtex = "";
_heli setobjecttexture [1249,"\fza_ah64_us\tex\dam\hdam_Rtrs_co.paa"];
} else {
if!("fza_ah64_cdam_tailboom" in (_heli magazinesturret [-1])) then {_heli setobjecttexture [1249,""];};
};
if("fza_ah64_cdam_tailboom" in (_heli magazinesturret [-1])) then {_trtex = ""; _heli setobjecttexture [1249,""];};
if("fza_ah64_rotor_dam" in (_heli magazinesturret [-1])) then {_rtex = "\fza_ah64_us\tex\dam\mdam_Rtrs_co.paa";};
if("fza_ah64_rotor_fail" in (_heli magazinesturret [-1])) then
{
_rtex = "";
_heli setobjecttexture [1250,"\fza_ah64_us\tex\dam\hdam_Rtrs_co.paa"];
} else {
_heli setobjecttexture [1250,""];
};
if(_heli animationphase "blade1_rise1" > 0.5 && !("fza_ah64_tailrotor_fail" in (_heli magazinesturret [-1])) && !("fza_ah64_tailrotor_dam" in (_heli magazinesturret [-1]))) then
{
_heli setobjecttexture [1244,""];
_heli setobjecttexture [1245,_trtex];
} else {
_heli setobjecttexture [1244,_trtex];
_heli setobjecttexture [1245,""];
};
if(_heli animationphase "blade1_rise1" > 0.5 && !("fza_ah64_rotor_fail" in (_heli magazinesturret [-1]))) then
{
_heli setobjecttexture [1246,""];
_heli setobjecttexture [1247,_rtex];
} else {
_heli setobjecttexture [1246,_rtex];
_heli setobjecttexture [1247,""];
};
if(local _heli && player in _heli) then
{

if(_adsp == 0) then {_smoothrand = random 1; _adsp = 1; _smoothrand2 = _smoothrand;};

if(_smoothrand >= 0 && _adsp == 1) then {_smoothrand2 = _smoothrand2 + random 5;};
if(_smoothrand2 > 30) then {_adsp = 2;};
if(_adsp == 2) then {_smoothrand2 = _smoothrand2 - random 5;};
if(_smoothrand2 < 0.1) then {_adsp = 0; _adsp2 = 0;};
if(_adsp2 == 0) then {_smoothrand3 = random 1; _smoothrand4 = random 1; _adsp2 = 1;};
if(_smoothrand3 >= 0.5) then {_smoothrand3 = _smoothrand2;};
if(_smoothrand3 < 0.5) then {_smoothrand3 = _smoothrand2*-1;};
if(_smoothrand4 >= 0.5) then {_smoothrand4 = _smoothrand2;};
if(_smoothrand4 < 0.5) then {_smoothrand4 = _smoothrand2*-1;};

_velair = [(velocity _heli select 0) + (0.836*(abs(wind select 0)^1.5)),(velocity _heli select 1) + (0.836*(abs(wind select 2)^1.5)),(velocity _heli select 2) + (0.836*(abs(wind select 1)^1.5))];
_velmag = sqrt(((velocity _heli select 0) + (0.836*(abs(wind select 0)^1.5)))^2 + ((velocity _heli select 1) + (0.836*(abs(wind select 2)^1.5)))^2 + ((velocity _heli select 2) + (0.836*(abs(wind select 1)^1.5)))^2);
_velfactor = _velmag * 0.05;
if(_velfactor > 1) then {_velfactor = 1;};

_smoothfactor = (20 - _velmag)  * 0.05;
if(_smoothfactor < 0) then {_smoothfactor = 0;};
_smoothing1 = _smoothrand3 * _smoothfactor;
_smoothing2 = _smoothrand4 * _smoothfactor;
_weight = 90;
_weight = _weight * _smoothfactor;

_vertvect = ((_velair select 2) atan2 sqrt(((_velair select 0)*(_velair select 0)) + ((_velair select 1)*(_velair select 1))));
_vertvect = (_vertvect * _velfactor) + _weight;
_helipb = _heli call fza_ah64_getpb;
_vertvect = (_vertvect - (_helipb select 0));
_horveldir = (velocity _heli select 0) atan2 (velocity _heli select 1);
if(_horveldir < 0) then {_horveldir = _horveldir + 360;};
_theta = (360 + (_horveldir - (direction _heli))) Mod 360;
_targhead = _theta;
if (_theta >= 180) then {_targhead = _theta - 360;} else {_targhead = _theta;};
_horvect = (_targhead * _velfactor);

_vertvect1 = (sin(_helipb select 1))*_horvect;
_vertvect2 = (cos(_helipb select 1))*_vertvect;

_horvect1 = (cos(_helipb select 1))*_horvect;
_horvect2 = (sin(_helipb select 1))*_vertvect;

//player globalchat format ["VV %1 HV %2",_vertvect,_horvect];
_heli animate ["l_ads_p",(_vertvect1+_vertvect2+_smoothing1)*0.002778];
_heli animate ["l_ads_y",(_horvect1+_horvect2+_smoothing2)*0.002778];
_heli animate ["r_ads_p",(_vertvect1+_vertvect2+_smoothing2)*0.002778];
_heli animate ["r_ads_y",(_horvect1+_horvect2+_smoothing1)*0.002778];
/*
_estate = 0.11 * (_heli animationphase "blade1_rise1");
if(driver _heli == player) then
{
[_heli,_estate] call fza_ah64_bladerot;
};
*/
};
sleep 0.03;
};