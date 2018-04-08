_heli = _this select 0;
_angle = 0;
_pitch = 0;
_cone1 = createVehicle ["fza_ah64_ic", [0,0,0], [], 0, "NONE"];
_cone2 = createVehicle ["fza_ah64_ic", [0,0,0], [], 0, "NONE"];
if(fza_ah64_wheelbrake == 0) then
{
fza_ah64_wheelbrake = 1;
_heli vehiclechat "Wheel brakes ON.";
}
else
{
fza_ah64_wheelbrake = 0;
_heli vehiclechat "Wheel brakes OFF.";
};
while {alive _heli && fza_ah64_wheelbrake == 0} do
{
_forback = (0.1*(inputAction "HeliForward"))+(-0.1*(inputAction "HeliBack"));
_collective = inputAction "heliUp" + inputAction "heliThrottlePos";
if(_forback > 0.05) then {_forback = 0.05;};
if(_forback < -0.05) then {_forback = -0.05;};
_vel = velocity _heli;
_dir = direction _heli;
if(getpos _heli select 2 < 0.5 && isengineon _heli) then
{
_heli setvelocity [(_vel select 0)+((sin _dir) * _forback),(_vel select 1)+((cos _dir) * _forback),(_vel select 2)];
_worldPos = _heli modelToWorld [0,-10,0];
_worldPos2 = _heli modelToWorld [0,10,0];
_cone1 setPosatl [_worldPos select 0,_worldPos select 1,0];
_cone2 setPosatl [_worldPos2 select 0,_worldPos2 select 1,0];
_cone1 setdir 0;
_cone2 setdir 0;
_pbvar = _heli call fza_ah64_getpb;
_dir = direction _heli;
_pitch = (_pbvar select 1);
//_pitch = (getposasl _cone1 select 2) atan2 (getposasl _cone2 select 2);
_angle = ((getposasl _cone2 select 2) - (getposasl _cone1 select 2)) atan2 ([(getposasl _cone1 select 0),(getposasl _cone1 select 1),0] distance [(getposasl _cone2 select 0),(getposasl _cone2 select 1),0]);
//_angle = _angle + 0.5;
//_angle = (_pbvar select 0);

_vecdx = sin(_dir) * cos(_angle);
_vecdy = cos(_dir) * cos(_angle);
_vecdz = sin(_angle);

_vecux = cos(_dir) * cos(_angle) * sin(_pitch);
_vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
_vecuz = cos(_angle) * cos(_pitch);

_heli setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];
};
//player sidechat format ["%1",((getposasl _cone2 select 2) - (getposasl _cone1 select 2)) atan2 ([(getposasl _cone1 select 0),(getposasl _cone1 select 1),0] distance [(getposasl _cone2 select 0),(getposasl _cone2 select 1),0])];
//player globalchat format ["%1 %2 %3",_forback,_collective,getpos _heli select 2];
sleep 0.03;
}

deletevehicle _cone1;
deletevehicle _cone2;