//////MISSILES EFFECTS//////
class fza_ah64_rocketsmoke
{
	class Light1
	{
		simulation = "light";
		type = "RocketLight";
		position[] = {0,0,0};
		intensity = 0.01;
		interval = 1;
		lifeTime = 1;
	};
	class MissileEffects1
	{
		simulation = "particles";
		type = "Missile1";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
};
class fza_ah64_hellfiresmoke
{
	class Light1
	{
		simulation = "light";
		type = "RocketLight";
		  position[] = {0,0,0};
		  intensity = 0.01;
		  interval = 1;
		  lifeTime = 1;
	};
	class Missile2
	{
		simulation = "particles";
		type = "Missile2";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
};
class fza_ah64_stingersmoke
{
	class Light1
	{
		simulation = "light";
		type = "RocketLight";
		position[] = {0,0,0};
		intensity = 0.01;
		interval = 1;
		lifeTime = 1;
	};
	class Missile3
	{
		simulation = "particles";
		type = "Missile3";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
};
//////END OF MISSILES EFFECTS//////
