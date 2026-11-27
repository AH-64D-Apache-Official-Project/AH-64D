class CfgFunctions
{
    class fza_mplanner
    {
        class missionplanner
        {
            file = "fza_ah64_missionplanner\functions";
            class open {};
            class onLoad {};
            class onUnload {};
            class saveConfig {};
            class deleteConfig {};
            class pushMissionConfig {};
            class seedSaves {};
            class seedHelisimData {};
            class seedCurrentConfig {};
            class applyConfig {};
            class applyRun {};
            class pageEvent {};
            class sources {};
            class supply {};
        };
        class dtc
        {
            file = "fza_ah64_missionplanner\functions\dtc";
            class dtcDelete {};
            class dtcMap {};
            class dtcMapDraw {};
            class dtcSave {};
            class dtcSeed {};
            class dtcStage {};
        };
    };
};
