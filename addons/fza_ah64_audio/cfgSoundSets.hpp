class CfgSoundSets {
    // Not positional, not muffled by what is between it and the listener, and as loud anywhere in its range
    class fza_ah64_rJamStatic_SoundSet {
        soundShaders[]        = {"fza_ah64_rJamStatic_SoundShader"};
        volumeFactor          = 1;
        volumeCurve           = "Constant1Curve";
        sound3DProcessingType = "VehicleExt_3DProcessingType";
        spatial               = 0;
        doppler               = 0;
        speedOfSound          = 0;
        loop                  = 1;
        occlusionObstruction  = 0;
        occlusionFactor       = 0;
        obstructionFactor     = 0;
        soundShadersLimit     = 1;
    };
};
