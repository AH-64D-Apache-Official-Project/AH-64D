_m261 = _this select 0;
_heli = _this select 1;

sleep 0.5;

if(alive _m261) then
{
_rand = 30;
_offset  = _rand / 2;
_burstdist = 500;
_counter = 0;
_rocketposX = (getpos _m261 select 0);
_rocketposY = (getpos _m261 select 1);
_rocketposZ = (getpos _m261 select 2);
_velm261 = velocity _m261;

if(player in _heli && !(isNull fza_ah64_mycurrenttarget)) then {_burstdist = (fza_ah64_mycurrenttarget distance _heli) - 150;};

waituntil{(_m261 distance _heli > _burstdist)};

_rocketposX = (getpos _m261 select 0);
_rocketposY = (getpos _m261 select 1);
_rocketposZ = (getpos _m261 select 2);
_velm261 = velocity _m261;

while {(_counter < 9)} do
{
_mpsm = "fza_m73mpsm" createVehicle [_rocketposX + ((random 30) + (random -30)),_rocketposY + ((random 30) + (random -30)),_rocketposZ + ((random 5) + (random -5))];
_mpsm setdir (direction _m261);
_mpsm setvelocity _velm261;
_counter = _counter + 1;
sleep 0.03;
};
};

//_mpsm = "fza_m73mpsm" createVehicle [_rocketposX + ((sin ((direction _m261) + 90)) * ((random _rand) - (_offset))),_rocketposY + ((cos ((direction _m261) + 90)) * ((random _rand) - (_offset))),_rocketposZ + (random _rand) - (_offset)];
//_mpsm = "fza_m73mpsm" createVehicle [_rocketposX + ((random 20) + (random -20)),_rocketposY + ((random 20) + (random -20)),_rocketposZ + ((random 20) + (random -20))];
//_mpsm setdir (direction _m261);
//_mpsm setvelocity _velm261;