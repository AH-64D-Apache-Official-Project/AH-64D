class AnimationSources
{
    ////////RADAR///////
    class fcr_enable
    {
        displayName = "Install FCR";
        author = "Apache mod development team";
        onPhaseChanged = "_this # 0 enableVehicleSensor [""ActiveRadarSensorComponent"",_this # 1 == 1];";
        source = "user";
        initPhase = 1;
        animPeriod = 0.001;
    };
    class msn_equip_american
    {
        displayName = "Install American Mission Equipment";
        author = "Apache mod development team";
        source = "user";
        forceAnimatePhase = 1;
        forceAnimate[] = {"msn_equip_british", 0};
        initPhase = 1;
        animPeriod = 0.001;
    };
    class msn_equip_british
    {
        displayName = "Install British Mission Equipment";
        author = "Apache mod development team";
        source = "user";
        forceAnimatePhase = 1;
        onPhaseChanged =    "_this remoteExec [""fza_ase_fnc_swapFlares"",_this # 0];";
        forceAnimate[] = {"msn_equip_american", 0,"fcr_enable", 1};
        initPhase = 0;
        animPeriod = 0.001;
    };
    class mast
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=1;
    };
    class magazine_set_1200
    {
        displayName = "Swap IAFS for 1200rnd magazine";
        author = "Apache mod development team";
        onPhaseChanged = "_this remoteExec [""fza_fnc_weaponSwapM230Mag"",_this # 0];";
        source = "user";
        initPhase = 0;
        animPeriod = 0.001;
    };
    class hstab
    {
        source = "user";
        animPeriod = 0.01;
        initPhase  = -5.5;
    };
    class pnvs
    {
        source = "user";
        animPeriod = 0.01;
        initPhase=0;
    };
    class pnvs_vert
    {
        source = "user";
        animPeriod = 0.01;
        initPhase=0;
    };
    class tads_stow
    {
        source = "user";
        animPeriod = 1;
        initPhase  = 1;
        onPhaseChanged = "[_this # 0, ""fza_ah64_tadsStow"", ""tads_stow""] call fza_fnc_animReset";
    };
    class m230_recoil
    {
        source = "reload";
        weapon = "fza_m230";
    };
    class mainTurret
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class maingun
    {
        source = "user";
        animPeriod = 0.1;
        initPhase  = 0.298;
    };
    class pylon1
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class pylon2
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class pylon3
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class pylon4
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swashplate_up_tns
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swashplate_up_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swashplate_up_bank
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swashplate_dn_tns
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swashplate_dn_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swashplate_dn_bank
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class mr_act_tns
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swup_arm1
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swup_arm1_t
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swup_arm2
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swup_arm3
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swup_arm3_t
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class swup_arm4
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class trsw
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class tr_blade1_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class tr_blade2_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class tr_blade3_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class tr_blade4_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class blade1_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class blade1_flap
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class blade2_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class blade2_flap
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class blade3_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class blade3_flap
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class blade4_pitch
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    class blade4_flap
    {
        source = "user";
        animPeriod = 0.1;
        initPhase=0;
    };
    //////weapons///////////
    class pod_m260_1
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class pod_m260_2
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class pod_m260_3
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class pod_m260_4
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class rail_m299_1
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class rail_m299_2
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class rail_m299_3
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class rail_m299_4
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    ////////////////////////////////
    ///////////COCKPIT//////////////
    ////////////////////////////////
    class plt_eng1_start
    {
        source = "user";
        animPeriod = 0.15;
        initPhase=0;
        sound = "eng1_start_sound";
    };
    class plt_eng2_start
    {
        source = "user";
        animPeriod = 0.15;
        initPhase=0;
        sound = "eng2_start_sound";
    };
    class plt_rtrbrake
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
        onPhaseChanged = "[_this # 0, ""fza_ah64_rtrbrake"", ""plt_rtrbrake""] call fza_fnc_animReset";
    };
    class plt_anticollision
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
        onPhaseChanged = "[_this # 0, ""fza_ah64_anticollision"", ""plt_anticollision""] call fza_fnc_animReset";
    };
    class plt_firesw
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0.5;
    };
    class cpg_firesw
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0.5;
    };
    class plt_nvsmode
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class cpg_nvsmode
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class cpg_ihadss_brt
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class plt_eng1_throttle
    {
        source = "user";
        animPeriod = 1;
        initPhase=0;
        onPhaseChanged = "[_this # 0, ""fza_ah64_powerLever1"", ""plt_eng1_throttle""] call fza_fnc_animReset";
    };
    class plt_eng2_throttle
    {
        source = "user";
        animPeriod = 1;
        initPhase=0;
        onPhaseChanged = "[_this # 0, ""fza_ah64_powerLever2"", ""plt_eng2_throttle""] call fza_fnc_animReset";
    };
    //////////////DOORS//////////////////
    class pdoor
    {
        displayName = "Open Pilot door";
        author = "Apache mod development team";
        source = "user";
        animPeriod = 1;
        initPhase=0;
    };
    class gdoor
    {
        displayName = "Open Gunner door";
        author = "Apache mod development team";
        source = "user";
        animPeriod = 1;
        initPhase=0;
    };
    ///////////////ADS//////////////////
    class l_ads_p
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class l_ads_b : l_ads_p
    {
        source = "user";
    };
    class l_ads_y : l_ads_p
    {
        source = "user";
    };
    class r_ads_p
    {
        source = "user";
        animPeriod = 0.001;
        initPhase=0;
    };
    class r_ads_b : r_ads_p
    {
        source = "user";
    };
    class r_ads_y : r_ads_p
    {
        source = "user";
    };
};