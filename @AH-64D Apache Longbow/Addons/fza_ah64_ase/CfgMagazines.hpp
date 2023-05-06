class CfgMagazines {
    class CA_Magazine;
	class 60Rnd_CMFlareMagazine: CA_Magazine
	{
		author = "$STR_A3_Bohemia_Interactive";
		count = 60;
		ammo = "fza_ah64_flare_shot";
		initSpeed = 30;
	};
	class fza_IR_JAMMING: CA_Magazine
	{
		author = "$STR_A3_Bohemia_Interactive";
		count = 99999999;
		ammo = "fza_IR_JAMMING_shot";
		initSpeed = 30;
	};
	class fza_RF_JAMMING:  fza_IR_JAMMING
	{
		ammo = "fza_RF_JAMMING_shot";
	};
};