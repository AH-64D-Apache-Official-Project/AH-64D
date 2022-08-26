class Components: Components
{
  class SensorsManagerComponent
	{
    class Components
    {
      class ActiveRadarSensorComponent: SensorTemplateActiveRadar
      {
        componentType = "ActiveRadarSensorComponent";
        class AirTarget      // ranges for targets with sky background
        {
            minRange = 500;         // -1 if undef; in meters
            maxRange = 8000;       // -1 if undef; in meter
            viewDistanceLimitCoef = -1;      // -1 if undef; coefficient, multiplies current view distance as set in player's options. -1 means view distance is not used to limit sensor range.
            objectDistanceLimitCoef = -1;    // -1 if undef; coefficient, multiplies current object view distance as set in player's options. -1 means object view distance is not used to limit sensor range.
        };

        class GroundTarget      // ranges for targets with ground background
        {
          minRange = 500;         // -1 if undef; in meters
          maxRange = 8000;       // -1 if undef; in meters
          viewDistanceLimitCoef = -1;      // -1 if undef; coefficient, multiplies current view distance as set in player's options. -1 means view distance is not used to limit sensor range.
          objectDistanceLimitCoef = -1;    // -1 if undef; coefficient, multiplies current object view distance as set in player's options. -1 means object view distance is not used to limit sensor range.
        };

        typeRecognitionDistance = -1;
        angleRangeHorizontal = 360;
        angleRangeVertical = 60;
        nightRangeCoef = 1;
        maxFogSeeThrough= -1;
        groundNoiseDistanceCoef = -1;
        maxGroundNoiseDistance = -1;
        minSpeedThreshold = 0;
        maxSpeedThreshold = 10;
        minTrackableSpeed = -1e10;
        maxTrackableSpeed = 1500;
        minTrackableATL= -1e10;
        maxTrackableATL= 1e10;
        animDirection = "";
        aimDown = 5;
        allowsMarking= 1;
      };
			class PassiveRadarSensorComponent: SensorTemplatePassiveRadar{};
      class LaserSensorComponent: SensorTemplateLaser
      {
        componentType = "LaserSensorComponent";
      };
    };
  };
  class VehicleSystemsDisplayManagerComponentLeft
  {
    componentType = "VehicleSystemsDisplayManager";
    x = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFOLEFT_X"",	(safezoneX + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40))])";
    y = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFOLEFT_Y"",	(safezoneY + safezoneH - 21 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
    left = 1;
    defaultDisplay = "EmptyDisplay";
    class Components
    {
      class EmptyDisplay		// Empty display - hide panel
      {
        componentType = "EmptyDisplayComponent";
      };
      class MinimapDisplay	// GPS
      {
        componentType = "MinimapDisplayComponent";
        resource = "RscCustomInfoAirborneMiniMap"; //gives you the airborne nav version with coloured altitude display
      };
    };
  };
  class VehicleSystemsDisplayManagerComponentRight : VehicleSystemsDisplayManagerComponentLeft {
    left = 0;
    right = 1;
    x = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFORIGHT_X"",((safezoneX + safezoneW) - ((10 * (((safezoneW / safezoneH) min 1.2) / 40)) + 0.5 * (((safezoneW / safezoneH) min 1.2) / 40)))])";
    y = "(profilenamespace getvariable [""IGUI_GRID_CUSTOMINFORIGHT_Y"",(safezoneY + safezoneH - 21 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25))])";
  };
};
