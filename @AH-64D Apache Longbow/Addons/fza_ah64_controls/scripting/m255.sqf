_m255 = _this select 0;
_heli = _this select 1;

sleep 0.5;

if(alive _m255) then
{
_rand = 30;
_offset  = _rand / 2;
_burstdist = 500;
_counter = 0;
_rocketposX = (getpos _m255 select 0);
_rocketposY = (getpos _m255 select 1);
_rocketposZ = (getpos _m255 select 2);
_velm255 = velocity _m255;

if(player in _heli && !(isNull fza_ah64_mycurrenttarget)) then {_burstdist = (fza_ah64_mycurrenttarget distance _heli) - 150;};

waituntil{(_m255 distance _heli > _burstdist)};

_rocketposX = (getpos _m255 select 0);
_rocketposY = (getpos _m255 select 1);
_rocketposZ = (getpos _m255 select 2);
_velm255 = velocity _m255;

drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 0.5, 5, [0,0,0], [0,0,0], 0, 0.7, 0.5, 0, [8,16,24,32,36], [[0.4,0,0,0.8],[0.4,0,0,0.7],[0.4,0,0,0.6],[0.4,0,0,0.5],[0,0,0,0]], [0], 0.1, 0.2, "", "", _m255];

while {(_counter < 20)} do
{
_mpsm = "fza_flec_cluster" createVehicle [_rocketposX + ((random 30) + (random -30)),_rocketposY + ((random 30) + (random -30)),_rocketposZ + ((random 5) + (random -5))];
_mpsm setdir (direction _m255);
_mpsm setvelocity _velm255;
_counter = _counter + 1;
sleep 0.03;
};
};

//_mpsm = "fza_m73mpsm" createVehicle [_rocketposX + ((sin ((direction _m255) + 90)) * ((random _rand) - (_offset))),_rocketposY + ((cos ((direction _m255) + 90)) * ((random _rand) - (_offset))),_rocketposZ + (random _rand) - (_offset)];