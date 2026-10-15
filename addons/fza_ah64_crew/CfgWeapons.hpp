class CfgWeapons
{
    class H_HelmetB;
    class H_PilotHelmetHeli_B: H_HelmetB {
        class ItemInfo;
    };
    class fza_ah64_ihadss: H_PilotHelmetHeli_B
    {
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
        scope = 2;
        displayName = "$STR_FZA_AH64_IHADSS_HELMET";
        picture = "\fza_ah64_crew\data\icon_ihadss_ca.paa";
        model = "\fza_ah64_crew\data\ihadss.p3d";
        hiddenSelections[] = {"camo", "hdu"};
        hiddenSelectionsTextures[] = {"\fza_ah64_crew\data\ihadss_co.paa", ""};
        fza_ah64_hduOff = "fza_ah64_ihadss";
        fza_ah64_hduOn = "fza_ah64_ihadss_hdu";
        class ItemInfo: ItemInfo
        {
            uniformModel = "\fza_ah64_crew\data\ihadss.p3d";
            modelSides[] = {0, 1, 2, 3};
            hiddenSelections[] = {"camo", "hdu"};
        };
    };
    class fza_ah64_ihadss_hdu: fza_ah64_ihadss
    {
        scope = 1;
        hiddenSelections[] = {"camo"};
        hiddenSelectionsTextures[] = {"\fza_ah64_crew\data\ihadss_co.paa"};
        class ItemInfo: ItemInfo
        {
            hiddenSelections[] = {"camo"};
        };
    };
    class arifle_SPAR_01_blk_F;
    class arifle_SPAR_01_blk_MRCO_Flash_F: arifle_SPAR_01_blk_F
    {
        author = "$STR_FZA_AH64_DEVELOPMENT_TEAM";
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
