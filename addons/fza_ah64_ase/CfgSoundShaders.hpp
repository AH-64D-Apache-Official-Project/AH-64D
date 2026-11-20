class CfgSoundShaders {
    // Radio jamming static (fza_ase_fnc_rJamStatic): seamless loops, one picked each time it starts, as loud as
    // CustomSoundController1 on its sound source
    class fza_ah64_rJamStatic_SoundShader {
        samples[] = {
            {"\fza_ah64_ase\data\audio\rjam_static_1.ogg", 1},
            {"\fza_ah64_ase\data\audio\rjam_static_2.ogg", 1},
            {"\fza_ah64_ase\data\audio\rjam_static_3.ogg", 1},
            {"\fza_ah64_ase\data\audio\rjam_static_4.ogg", 1}
        };
        volume    = "CustomSoundController1";
        frequency = 1;
        range     = 100;
    };
};
