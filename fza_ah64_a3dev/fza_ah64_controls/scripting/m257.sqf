_m257 = _this select 0;
_heli = _this select 1;

sleep 0.5;

if(alive _m257) then
{
_rand = 30;
_offset  = _rand / 2;
_burstdist = 500;
_counter = 0;
_rocketposX = (getpos _m257 select 0);
_rocketposY = (getpos _m257 select 1);
_rocketposZ = (getpos _m257 select 2);
_velm257 = velocity _m257;

waituntil{(_m257 distance _heli > 3500)};

_rocketposX = (getpos _m257 select 0);
_rocketposY = (getpos _m257 select 1);
_rocketposZ = (getpos _m257 select 2);
_velm257 = velocity _m257;

_mpsm = "fza_m257_flare" createVehicle [_rocketposX,_rocketposY,_rocketposZ + 10];
};