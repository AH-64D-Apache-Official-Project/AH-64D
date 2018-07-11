private ["_heli"];
_array = _this;
_heli = _this select 0;
_selWeapon = currentWeapon (vehicle player);

// M230 SHAKE
if (_selWeapon == "fza_m230") 
then 
{
addCamShake [0.5,2,20];
};

// M230 SMOKE EFFECT
private ["_sh", "_veh", "_weh","_life"];
_veh = _this select 0;

if (count _this > 6) then
{
	_sh = _this select 6;
}
else
{
	_sh = nearestobject [_veh, _this select 4];
};

if ((_veh iskindof "Helicopter") && (isengineOn _veh)) then
	{
	_weh=1;
	_life= 0.8;
	}
	else
	{
	_weh = 0.104;
	_life= 1.3 + random 0.6;
	};

drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 0.5, 1, [0,0,0], [8,-3,-1], 0, 5, 0.5, 0, [1,4], [[0.4,0.4,0.4,0.8],[0.4,0.4,0.4,0.7],[0.4,0.4,0.4,0.6],[0.4,0.4,0.4,0.5],[0,0,0,0]], [0], 0.1, 0.2, "", "", _sh];
drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 0.5, 1, [0,0,0], [-8,-3,-1], 0, 5, 0.5, 0, [1,4], [[0.4,0.4,0.4,0.8],[0.4,0.4,0.4,0.7],[0.4,0.4,0.4,0.6],[0.4,0.4,0.4,0.5],[0,0,0,0]], [0], 0.1, 0.2, "", "", _sh];


