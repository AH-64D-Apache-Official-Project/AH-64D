_heli = _this select 0;

_veh1 = createvehicle ["fza_ah64_jammer",[0,0,0],[],5,"FLY"];
_veh2 = createvehicle ["fza_ah64_jammer",[0,0,0],[],5,"FLY"];
_veh3 = createvehicle ["fza_ah64_jammer",[0,0,0],[],5,"FLY"];
_veh4 = createvehicle ["fza_ah64_jammer",[0,0,0],[],5,"FLY"];
_veh5 = createvehicle ["fza_ah64_jammer",[0,0,0],[],5,"FLY"];
_veh6 = createvehicle ["fza_ah64_jammer",[0,0,0],[],5,"FLY"];
createvehiclecrew _veh1;
createvehiclecrew _veh2;
createvehiclecrew _veh3;
createvehiclecrew _veh4;
createvehiclecrew _veh5;
createvehiclecrew _veh6;

while {(alive _heli && fza_ah64_rfjon == 1)} do
{
_pos1 = [(getposatl _heli select 0)+(random 500)+(random -500),(getposatl _heli select 1)+(random 500)+(random -500),(getposatl _heli select 2)+100+(random 50)+(random -50)];
_pos2 = [(getposatl _heli select 0)+(random 500)+(random -500),(getposatl _heli select 1)+(random 500)+(random -500),(getposatl _heli select 2)+100+(random 50)+(random -50)];
_pos3 = [(getposatl _heli select 0)+(random 500)+(random -500),(getposatl _heli select 1)+(random 500)+(random -500),(getposatl _heli select 2)+100+(random 50)+(random -50)];
_pos4 = [(getposatl _heli select 0)+(random 500)+(random -500),(getposatl _heli select 1)+(random 500)+(random -500),(getposatl _heli select 2)+100+(random 50)+(random -50)];
_pos5 = [(getposatl _heli select 0)+(random 500)+(random -500),(getposatl _heli select 1)+(random 500)+(random -500),(getposatl _heli select 2)+100+(random 50)+(random -50)];
_pos6 = [(getposatl _heli select 0)+(random 500)+(random -500),(getposatl _heli select 1)+(random 500)+(random -500),(getposatl _heli select 2)+100+(random 50)+(random -50)];
_veh1 setposatl _pos1;
_veh2 setposatl _pos2;
_veh3 setposatl _pos3;
_veh4 setposatl _pos4;
_veh5 setposatl _pos5;
_veh6 setposatl _pos6;
_veh1 setdammage 0;
_veh2 setdammage 0;
_veh3 setdammage 0;
_veh4 setdammage 0;
_veh5 setdammage 0;
_veh6 setdammage 0;
sleep 1;
};

{deletevehicle _x;} foreach [_veh1,_veh2,_veh3,_veh4,_veh5,_veh6];
