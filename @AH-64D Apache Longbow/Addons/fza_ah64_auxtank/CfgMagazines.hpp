class CfgMagazines {
    class VehicleMagazine;

    #define AUXTANK_MAGAZINE_CONFIG(ammoname, disp, dispShort) \
        class ammoname##: VehicleMagazine { \
            scope=public;\
            ammo = ammoname; \
            displayName = disp; \
            descriptionShort = dispShort; \
            model = \fza_ah64_us\fza_ah64_auxtank.p3d; \
            count = 1; \
            hardpoints[] = {"fza_auxTank"}; \
            reloadSound[] = {"A3\sounds_f\dummysound", 0.000316228, 1}; \
            weight = 762.5; \
            fza_pylonType = "auxTank"; \
        }; \
    
    AUXTANK_MAGAZINE_CONFIG(fza_230gal_auxTank, "230gal Aux Tank", "An unarmored external fuel tank that provides 230gal (1,541lbs) of fuel. Total additional weight is 1681lbs");
};

//fza_hydra70_zone_AC