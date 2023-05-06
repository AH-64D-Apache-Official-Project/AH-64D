class Mode_SemiAuto;
class CfgWeapons
{	
	class RocketPods;
	class CannonCore;
	class SmokeLauncher;
	class MissileLauncher;
	class arifle_SPAR_01_blk_F;

	class fza_CMFlareLauncher: SmokeLauncher 
	{
		scope = 2;
		displayName = "$STR_A3_CMFlareLauncher0";
		magazines[] = {"60Rnd_CMFlareMagazine"};
		magazineReloadTime = 0.500000;
		simulation = "cmlauncher";
		modes[] = {"Single","AIBurst"};
		class Single: Mode_SemiAuto
		{
			displayName = "$STR_A3_CMFlareLauncher_weapon_mode_Single_name";
			reloadTime = 0.05;
			useAction = 0;
			useActionTitle = "";
			artilleryDispersion = 0;
			artilleryCharge = 0;
			burst = 1;
			sounds[] = {"StandardSound"};
			class StandardSound {
				begin1[] = {"\fza_ah64_us\audio\Flares.ogg", 1.000000, 1, 300};
				soundBegin[] = {"begin1", 1};
			};
			showToPlayer = 1;
			multiplier = 2;
			soundBurst = 0;
			dispersion = 0.4;
			aiRateOfFire = 1;
			aiRateOfFireDistance = 10;
			minRange = 0;
			minRangeProbab = 0.01;
			midRange = 1;
			midRangeProbab = 0.01;
			maxRange = 2;
			maxRangeProbab = 0.01;
		};
		class AIBurst: Mode_SemiAuto
		{
			burst = 5;
			burstRangeMax = 7;
			showToPlayer = 0;
			soundBurst = 0;
			minRange = 100;
			minRangeProbab = 1;
			midRange = 1000;
			midRangeProbab = 1;
			maxRange = 25000;
			maxRangeProbab = 1;
			sounds[] = {"StandardSound"};
			class StandardSound {
				begin1[] = {"", 1.000000, 1, 300};
				soundBegin[] = {"begin1", 1};
			};
		};
	};
    class fza_AseIRjammer: SmokeLauncher 
	{
		scope = 2;
		displayName = "IRJAM";
		magazines[] = {"fza_IR_JAMMING"};
		magazineReloadTime = 0.500000;
		simulation = "cmlauncher";
		modes[] = {"Single","AIBurst"};
		class Single
		{
			displayName = "$STR_A3_CMFlareLauncher_weapon_mode_Single_name";
			reloadTime = 0.050000;
			useAction = 0;
			useActionTitle = "";
			artilleryDispersion = 0;
			artilleryCharge = 0;
			burst = 1;
			autoFire = 1;
			soundContinuous = 0;
			textureType = "single";
			recoil = "Empty";
			recoilProne = "";
			sounds[] = {"StandardSound"};
			class StandardSound {
				begin1[] = {"", 1.000000, 1, 300};
				soundBegin[] = {"begin1", 1};
			};
			showToPlayer = 0;
			multiplier = 2;
			soundBurst = 0;
			dispersion = 0.400000;
			aiRateOfFire = 1;
			aiRateOfFireDistance = 10;
			minRange = 0;
			minRangeProbab = 0.010000;
			midRange = 1;
			midRangeProbab = 0.010000;
			maxRange = 2;
			maxRangeProbab = 0.010000;
		};
		class AIBurst: Mode_SemiAuto
		{
			burst = 3;
			burstRangeMax = 7;
			showToPlayer = 0;
			soundBurst = 0;
			minRange = 100;
			minRangeProbab = 1;
			midRange = 1000;
			midRangeProbab = 1;
			maxRange = 25000;
			maxRangeProbab = 1;
			sounds[] = {"StandardSound"};
			class StandardSound {
				begin1[] = {"", 1.000000, 1, 300};
				soundBegin[] = {"begin1", 1};
			};
		};
	};
	
	///////////////////////////////////////////////////////////////////////
	//////////////////////////////Crew Weapon//////////////////////////////
	///////////////////////////////////////////////////////////////////////

	class arifle_SPAR_01_blk_MRCO_Flash_F: arifle_SPAR_01_blk_F
	{
		author = "Rosd6(Dryden)";
		_generalMacro = "arifle_SPAR_01_blk_MRCO_Flash_F";
		baseWeapon = "arifle_SPAR_01_blk_F";
		scope = 1;
		class LinkedItems
		{
			class LinkedItemsOptic
			{
				slot = "CowsSlot";
				item = "optic_MRCO";
			};
			class LinkedItemsAcc
			{
				slot = "PointerSlot";
				item = "acc_flashlight";
			};
		};
	};
};