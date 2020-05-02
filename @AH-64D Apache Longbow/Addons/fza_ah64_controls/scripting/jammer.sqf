_veh1 = createvehicle ["fza_ah64_jammer",[0,0,0],[],5,"FLY"];
_veh2 = createvehicle ["fza_ah64_jammer",[0,0,0],[],5,"FLY"];
_veh3 = createvehicle ["fza_ah64_jammer",[0,0,0],[],5,"FLY"];

createvehiclecrew _veh1;
createvehiclecrew _veh2;
createvehiclecrew _veh3;

while {(alive (vehicle player) && fza_ah64_rfjon == 1)} do
{
_pos1 = [(getposatl (vehicle player) select 0)+(random 500)+(random -500),(getposatl (vehicle player) select 1)+(random 500)+(random -500),(getposatl (vehicle player) select 2)+100+(random 50)+(random -50)];
_pos2 = [(getposatl (vehicle player) select 0)+(random 500)+(random -500),(getposatl (vehicle player) select 1)+(random 500)+(random -500),(getposatl (vehicle player) select 2)+100+(random 50)+(random -50)];
_pos3 = [(getposatl (vehicle player) select 0)+(random 500)+(random -500),(getposatl (vehicle player) select 1)+(random 500)+(random -500),(getposatl (vehicle player) select 2)+100+(random 50)+(random -50)];

_veh1 setposatl _pos1;
_veh2 setposatl _pos2;
_veh3 setposatl _pos3;

_veh1 setdammage 0;
_veh2 setdammage 0;
_veh3 setdammage 0;

sleep 1;
};

{deletevehicle _x;} foreach [_veh1,_veh2,_veh3];
