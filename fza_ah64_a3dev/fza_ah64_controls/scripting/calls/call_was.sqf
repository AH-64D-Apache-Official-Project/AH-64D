private ["_heli"];
_heli = _this select 0;

if(!(player in _heli)) exitwith {};

_selectedweapon = 0;
_wpncounter = 1;
_emptywep = "";

_hellfireweps = ["fza_agm114_23_8","fza_agm114_14_8","fza_agm114_1_4","fza_agm114_2_4","fza_agm114_3_4","fza_agm114_4_4","fza_agm114_1_ul","fza_agm114_1_ur","fza_agm114_1_ll","fza_agm114_1_lr","fza_agm114_2_ul","fza_agm114_2_ur","fza_agm114_2_ll","fza_agm114_2_lr","fza_agm114_3_ul","fza_agm114_3_ur","fza_agm114_3_ll","fza_agm114_3_lr","fza_agm114_4_ul","fza_agm114_4_ur","fza_agm114_4_ll","fza_agm114_4_lr"];
_rocketweps = ["fza_m261_1234_zoneE","fza_m261_14","fza_m261_14_zoneA","fza_m261_14_zoneB","fza_m261_14_zoneE","fza_m261_23","fza_m261_23_zoneC","fza_m261_23_zoneD","fza_m261_23_zoneE","fza_m261_1","fza_m261_1_zone1","fza_m261_1_zone2","fza_m261_1_zone3","fza_m261_2","fza_m261_2_zone1","fza_m261_2_zone2","fza_m261_2_zone3","fza_m261_3","fza_m261_3_zone1","fza_m261_3_zone2","fza_m261_3_zone3","fza_m261_4","fza_m261_4_zone1","fza_m261_4_zone2","fza_m261_4_zone3"];

//gun if none
if(_selectedweapon == 0 && !(currentweapon _heli == "fza_m230" || currentweapon _heli == "fza_burstlimiter" || currentweapon _heli in _rocketweps || currentweapon _heli in _hellfireweps || currentweapon _heli == "fza_atas_2")) then
{
if(_heli hasweapon "fza_m230") then {_heli selectweapon "fza_m230";} else {_heli selectweapon "fza_burstlimiter";};
_selectedweapon = 1;
};

//rockets from gun
if((currentweapon _heli == "fza_m230" || currentweapon _heli == "fza_burstlimiter") && _selectedweapon == 0) then
{
{
if(_x in _rocketweps) then {_emptywep = _x;};
if((_x in _rocketweps) && _heli ammo _x > 0 && _selectedweapon == 0) then {_selectedweapon = 1; _heli selectweapon _x;};
if(_selectedweapon == 1) exitwith {};
_wpncounter = _wpncounter + 1;
if(_wpncounter >= count (weapons _heli)) then {_selectedweapon = 1; _heli selectweapon _emptywep;};
} foreach (weapons _heli);
};

_wpncounter = 1;

//missiles from rockets
if(currentweapon _heli in _rocketweps && _selectedweapon == 0) then
{
{
if(_x in _hellfireweps) then {_emptywep = _x;};
if((_x in _hellfireweps) && _heli ammo _x > 0 && _selectedweapon == 0) then {_selectedweapon = 1; _heli selectweapon _x;};
if(_selectedweapon == 1) exitwith {};
_wpncounter = _wpncounter + 1;
if(_wpncounter >= count (weapons _heli)) then {_selectedweapon = 1; _heli selectweapon _emptywep;};
} foreach (weapons _heli);
};

_wpncounter = 1;

//ata from hellfire
if(currentweapon _heli in _hellfireweps && _heli hasweapon "fza_atas_2" && _selectedweapon == 0) then
{
_heli selectweapon "fza_atas_2";
_selectedweapon = 1;
};

//lsr from ata
if(currentweapon _heli == "fza_atas_2" && _heli hasweapon "laserdesignator_mounted" && _selectedweapon == 0) then
{
if(_heli hasweapon "laserdesignator_mounted") then {_heli selectweapon "laserdesignator_mounted";};
_selectedweapon = 1;
};

//lsr from hellfire
if(_selectedweapon == 0 && currentweapon _heli in _hellfireweps && _heli hasweapon "laserdesignator_mounted" && !(_heli hasweapon "fza_atas_2")) then
{
if(_heli hasweapon "laserdesignator_mounted") then {_heli selectweapon "laserdesignator_mounted";};
_selectedweapon = 1;
};

//gun from lsr
if(currentweapon _heli == "laserdesignator_mounted" && _selectedweapon == 0) then
{
if(_heli hasweapon "fza_m230") then {_heli selectweapon "fza_m230";} else {_heli selectweapon "fza_burstlimiter";};
_selectedweapon = 1;
};

//gun from ata
if(currentweapon _heli == "fza_atas_2" && _selectedweapon == 0) then
{
if(_heli hasweapon "fza_m230") then {_heli selectweapon "fza_m230";} else {_heli selectweapon "fza_burstlimiter";};
_selectedweapon = 1;
};

//gun from hellfire
if(_selectedweapon == 0 && currentweapon _heli in _hellfireweps && !(_heli hasweapon "fza_atas_2")) then
{
if(_heli hasweapon "fza_m230") then {_heli selectweapon "fza_m230";} else {_heli selectweapon "fza_burstlimiter";};
_selectedweapon = 1;
};