//COCKPIT_CONTROL(pilot_mempoint, gunner_mempoint, system, system_name, control, sensitivity, control_name, moving point)

COCKPIT_CONTROL("ctrlref_p_doorhandle", "ctrlref_g_doorhandle",door, "Door",handle, 0.09, "Pilot Door Handle", true) COCKPIT_CONTROL_SEP

//COCKPIT_CONTROL("ctrlref_p_ihadss_brt", "ctrlref_g_ihadss_brt",ihadss, "IHADSS",brt, 0.03, "IHADSS Brightness") COCKPIT_CONTROL_SEP
COCKPIT_CONTROL("ctrlref_p_monocle", "ctrlref_g_monocle",ihadss, "IHADSS",stow, 0.1, "IHADSS Monocle", false) COCKPIT_CONTROL_SEP

COCKPIT_CONTROL("nvs_mode_sw", "nvs_mode_swg",nvs, "NVS",mode, 0.04, "NVS Mode", false) COCKPIT_CONTROL_SEP

COCKPIT_CONTROL("plt_flood", "cpg_flood",light, "Lighting",floodlight, 0.04, "Floodlight", false) COCKPIT_CONTROL_SEP
COCKPIT_CONTROL("plt_anticollision", "",light, "Lighting",anticollision, 0.04, "Anti-Collision Light", false) COCKPIT_CONTROL_SEP
COCKPIT_CONTROL("plt_ku_ctr", "cpg_ku_ctr",ku, "Keyboard Unit",activate, 0.15, "Activate KU input", false) COCKPIT_CONTROL_SEP

COCKPIT_CONTROL("plt_btn_arm_safe", "cpg_btn_arm_safe",armSafeBtn, "Armament Panel",armSafe, 0.04, "ARM/SAFE Button", false) COCKPIT_CONTROL_SEP
COCKPIT_CONTROL("plt_btn_gnd_oride", "cpg_btn_gnd_oride",gndOrideBtn, "Armament Panel",gndOride, 0.04, "GND ORIDE Button", false) COCKPIT_CONTROL_SEP

COCKPIT_CONTROL("plt_btn_emer_hyd", "cpg_btn_emer_hyd",emerHydBtn, "Emergency Panel",emerHyd, 0.04, "EMER HYD Button", false) COCKPIT_CONTROL_SEP

COCKPIT_CONTROL("plt_btn_mstr_caut", "cpg_btn_mstr_caut",mstrCautBtn, "Master Warning/Caution Panel",mstrCaut, 0.04, "MSTR CAUT Button", false) COCKPIT_CONTROL_SEP
COCKPIT_CONTROL("plt_btn_mstr_warn", "cpg_btn_mstr_warn",mstrWarnBtn, "Master Warning/Caution Panel",mstrWarn, 0.04, "MSTR WARN Button", false)
