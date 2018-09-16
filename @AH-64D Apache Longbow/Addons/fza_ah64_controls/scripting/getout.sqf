_array = _this;
_heli = _this select 0;
_position = _this select 1;
_unit = _this select 2;
_isHeliDriver = !(player isEqualTo driver objectParent player);
_isHeliGunner = !(player isEqualTo gunner objectParent player);


if(!(vehicle player isKindOf "fza_ah64base")) then
{
	1 cuttext ["", "PLAIN",0.1];
	2 cuttext ["", "PLAIN",0.1];
	3 cuttext ["", "PLAIN",0.1];
	4 cuttext ["", "PLAIN",0.1];
	
	if(!(isNil "fza_ah64_bweff")) then
	{
		fza_ah64_bweff ppEffectEnable false;
		fza_ah64_fgeff ppEffectEnable false;
	};
};