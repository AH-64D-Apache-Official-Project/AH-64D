_heli = _this select 0;
_neartarget = objNull;

_laser = "LaserTargetW";

if(side player == east) then {_laser = "LaserTargetE";};

_lasertarget = createVehicle [_laser, position player, [], 0, "NONE"];

while {(alive _heli && fza_ah64_laser == 1 && gunner _heli == player)} do
{
_curpos = screentoworld [0.5,0.5];
_lasetargobjs = nearestobjects [_curpos,["building","house","AllVehicles"],50];
_lasetargobjs = _lasetargobjs - [_lasertarget];
if(count _lasetargobjs < 1) then
{
detach _lasertarget;
_lasertarget setpos _curpos;
} else {
_neartarget = _lasetargobjs select 0;
_lasertarget attachto [_neartarget,[0,0,0],"zamerny"];
};
sleep 0.03;
};

deletevehicle _lasertarget;