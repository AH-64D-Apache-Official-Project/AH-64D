_heli = _this select 0;
_ammocount = _this select 1;
_ammotype = _this select 2;
_pylonwep = _this select 3;
_basewep = _this select 4;
_side = _this select 5;

if(_side == "right") then
{
if(_ammocount > 0) then {_heli removeweapon _basewep};
//_heli vehiclechat "WEAPON FAULT. REINITIALIZING.";
//sleep 2;
if(_ammocount == 8) then {_heli addmagazine [_ammotype, 4]; _heli addweapon _pylonwep;};
if(_ammocount == 7) then {_heli addmagazine [_ammotype, 4]; _heli addweapon _pylonwep;};
if(_ammocount == 6) then {_heli addmagazine [_ammotype, 3]; _heli addweapon _pylonwep;};
if(_ammocount == 5) then {_heli addmagazine [_ammotype, 3]; _heli addweapon _pylonwep;};
if(_ammocount == 4) then {_heli addmagazine [_ammotype, 2]; _heli addweapon _pylonwep;};
if(_ammocount == 3) then {_heli addmagazine [_ammotype, 2]; _heli addweapon _pylonwep;};
if(_ammocount == 2) then {_heli addmagazine [_ammotype, 1]; _heli addweapon _pylonwep;};
if(_ammocount == 1) then {_heli addmagazine [_ammotype, 1]; _heli addweapon _pylonwep;};
};

if(_side == "left") then
{
if(_ammocount > 1) then {_heli removeweapon _basewep};
//_heli vehiclechat "WEAPON FAULT. REINITIALIZING.";
//sleep 2;
if(_ammocount == 8) then {_heli addmagazine [_ammotype, 4]; _heli addweapon _pylonwep;};
if(_ammocount == 7) then {_heli addmagazine [_ammotype, 3]; _heli addweapon _pylonwep;};
if(_ammocount == 6) then {_heli addmagazine [_ammotype, 3]; _heli addweapon _pylonwep;};
if(_ammocount == 5) then {_heli addmagazine [_ammotype, 2]; _heli addweapon _pylonwep;};
if(_ammocount == 4) then {_heli addmagazine [_ammotype, 2]; _heli addweapon _pylonwep;};
if(_ammocount == 3) then {_heli addmagazine [_ammotype, 1]; _heli addweapon _pylonwep;};
if(_ammocount == 2) then {_heli addmagazine [_ammotype, 1]; _heli addweapon _pylonwep;};
};

if(_side == "rocketsright") then
{
_ammocount = round(ceil(_ammocount * 0.5));
if(_ammocount > 0) then
{
_heli removeweapon _basewep;
_heli vehiclechat "WEAPON FAULT. REINITIALIZING.";
_heli removeweapon "fza_m230";
sleep 2;
_heli addmagazine [_ammotype, _ammocount];
_heli addweapon _pylonwep;
_heli addweapon "fza_m230";
};
};

if(_side == "rocketsleft") then
{
_ammocount = round(floor(_ammocount * 0.5));
if(_ammocount > 1) then
{
_heli removeweapon _basewep;
_heli vehiclechat "WEAPON FAULT. REINITIALIZING.";
_heli removeweapon "fza_m230";
sleep 2;
_heli addmagazine [_ammotype, _ammocount];
_heli addweapon _pylonwep;
_heli addweapon "fza_m230";
};
};