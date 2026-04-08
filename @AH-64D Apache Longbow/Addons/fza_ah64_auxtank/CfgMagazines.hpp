class CfgMagazines {
    class VehicleMagazine;

    #define AUXTANK_MAGAZINE_CONFIG(ammoname, disp, dispShort) \
        class ammoname##: VehicleMagazine { \
            scope=public;\
            ammo = ammoname; \
            displayName = disp; \
            descriptionShort = dispShort; \
            model = \fza_ah64_auxtank\fza_ah64_auxtank.p3d; \
            count = 1; \
            hardpoints[] = {"fza_railzone"}; \
            reloadSound[] = {"A3\sounds_f\dummysound", 0.000316228, 1}; \
            weight = 762.5; \
            fza_pylonType = "auxTank"; \
        }; \
    
    AUXTANK_MAGAZINE_CONFIG(fza_230gal_auxTank, "$STR_FZA_AH64_230GAL_AUX_TANK", "An unarmored external fuel tank that provides 230gal (1,541lbs) of fuel. Total additional weight is 1681lbs");
};