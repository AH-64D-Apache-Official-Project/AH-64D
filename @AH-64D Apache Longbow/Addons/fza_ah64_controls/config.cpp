#include "BIS_AddonInfo.hpp"
class CfgPatches
{
	class fza_ah64_US
	{
		units[] = {"fza_ah64base","fza_ah64d_b2e","fza_ah64d_b2e_nr"};
		author = "Franze, Nodunit, Sacha 'Voodooflies' Oropeza, Keplager & Community";
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Air_F_Beta","A3_Sounds_F","A3_Data_F"};
	};
};

#include "config\defines.hpp"
#include "config\misc.hpp"
#include "config\CfgAnimationSourceSounds.hpp"
#include "config\CfgSounds.hpp"
#include "config\CfgRadio.hpp"
#include "config\effects.hpp"
#include "config\CfgMoves.hpp"
#include "config\CfgAmmo.hpp"
#include "config\CfgWeapons.hpp"
#include "config\CfgMagazines.hpp"
#include "config\CfgVehicles.hpp"

#include "uiConfig\defines.hpp"
#include "uiConfig\baseClasses.hpp"
#include "uiConfig\loadout2.hpp"
#include "uiConfig\skinMenu.hpp"
#include "uiConfig\monocle.hpp"
#include "uiConfig\rscTitles.hpp"

/*
 class SensorTemplateIR;
 class SensorTemplateVisual;
 class SensorTemplateActiveRadar;
 class SensorTemplatePassiveRadar;
 class SensorTemplateLaser;
 class SensorTemplateNV;

class DefaultVehicleSystemsDisplayManagerLeft {
		class Components;
};

class DefaultVehicleSystemsDisplayManagerRight {
		class Components;
};
*/

