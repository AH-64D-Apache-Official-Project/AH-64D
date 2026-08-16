
class lines_show {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_LINE_SHOW), 1));
    class lines_continuous {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_TYPE), FCR_MODE_ON_CONTINUOUS));
        class line {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMBar", {0, 0.0203}, 1},
                {"Fcr_ATMBar", {0, 0.325}, 1}
            };
        };
    };
    class lines_single : lines_continuous {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_TYPE), FCR_MODE_ON_SINGLE));
        color[] = {1,1,1,1};
        class line {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMBar", {0, 0.0203}, 1},
                {"Fcr_ATMBar", {0, 0.325}, 1}
            };
        };
    };
};
class ScanningBlockedOut {
    condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_ATM_BLOCK), 1));
    class blockoutbox {
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {{0.4937, 0.5193}, 1},
                {{0.4160, 0.8140}, 1},
                {{0.5840, 0.8140}, 1},
                {{0.5063, 0.5193}, 1}, {},
                
                {{0.4160, 0.8140}, 1},
                {{0.5610, 0.7200}, 1}, {},
                
                {{0.5840, 0.8140}, 1},
                {{0.4390, 0.7200}, 1}, {},

            };
        };
    };
};
// TM 4.35.10a: outer ring = selected sector outline (full intensity across the scanned span,
// remainder partial); 2/4/6 km rings partial intensity, confined to the selected sector;
// azimuth tics at 90 deg increments partial intensity. Center (0.5, 0.5), 0.040625/km.
class atmRings {
    class outerRingWide {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 0));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {{0.5000, 0.1750}, 1}, {{0.5564, 0.1799}, 1}, {{0.6112, 0.1946}, 1}, {{0.6625, 0.2185}, 1}, {{0.7089, 0.2510}, 1}, {{0.7490, 0.2911}, 1}, {{0.7815, 0.3375}, 1}, {{0.8054, 0.3888}, 1}, {{0.8201, 0.4436}, 1}, {{0.8250, 0.5000}, 1}, {{0.8201, 0.5564}, 1}, {{0.8054, 0.6112}, 1}, {{0.7815, 0.6625}, 1}, {{0.7490, 0.7089}, 1}, {{0.7089, 0.7490}, 1}, {{0.6625, 0.7815}, 1}, {{0.6112, 0.8054}, 1}, {{0.5564, 0.8201}, 1}, {{0.5000, 0.8250}, 1}, {{0.4436, 0.8201}, 1}, {{0.3888, 0.8054}, 1}, {{0.3375, 0.7815}, 1}, {{0.2911, 0.7490}, 1}, {{0.2510, 0.7089}, 1}, {{0.2185, 0.6625}, 1}, {{0.1946, 0.6112}, 1}, {{0.1799, 0.5564}, 1}, {{0.1750, 0.5000}, 1}, {{0.1799, 0.4436}, 1}, {{0.1946, 0.3888}, 1}, {{0.2185, 0.3375}, 1}, {{0.2510, 0.2911}, 1}, {{0.2911, 0.2510}, 1}, {{0.3375, 0.2185}, 1}, {{0.3888, 0.1946}, 1}, {{0.4436, 0.1799}, 1}, {{0.5000, 0.1750}, 1}, {},
            };
        };
    };
    class outerRingLargerPartial {
        condition = C_COND(C_MORE(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 0));
        color[] = {0.05, 0.25, 0, 1};
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {{0.5000, 0.1750}, 1}, {{0.5564, 0.1799}, 1}, {{0.6112, 0.1946}, 1}, {{0.6625, 0.2185}, 1}, {{0.7089, 0.2510}, 1}, {{0.7490, 0.2911}, 1}, {{0.7815, 0.3375}, 1}, {{0.8054, 0.3888}, 1}, {{0.8201, 0.4436}, 1}, {{0.8250, 0.5000}, 1}, {{0.8201, 0.5564}, 1}, {{0.8054, 0.6112}, 1}, {{0.7815, 0.6625}, 1}, {{0.7490, 0.7089}, 1}, {{0.7089, 0.7490}, 1}, {{0.6625, 0.7815}, 1}, {{0.6112, 0.8054}, 1}, {{0.5564, 0.8201}, 1}, {{0.5000, 0.8250}, 1}, {{0.4436, 0.8201}, 1}, {{0.3888, 0.8054}, 1}, {{0.3375, 0.7815}, 1}, {{0.2911, 0.7490}, 1}, {{0.2510, 0.7089}, 1}, {{0.2185, 0.6625}, 1}, {{0.1946, 0.6112}, 1}, {{0.1799, 0.5564}, 1}, {{0.1750, 0.5000}, 1}, {{0.1799, 0.4436}, 1}, {{0.1946, 0.3888}, 1}, {{0.2185, 0.3375}, 1}, {{0.2510, 0.2911}, 1}, {{0.2911, 0.2510}, 1}, {{0.3375, 0.2185}, 1}, {{0.3888, 0.1946}, 1}, {{0.4436, 0.1799}, 1}, {{0.5000, 0.1750}, 1}, {},
            };
        };
    };
    class outerArcMed {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 1));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.3250, 0.0000}, 1}, {"Fcr_ATMSector", {-0.3139, -0.0841}, 1}, {"Fcr_ATMSector", {-0.2815, -0.1625}, 1}, {"Fcr_ATMSector", {-0.2298, -0.2298}, 1}, {"Fcr_ATMSector", {-0.1625, -0.2815}, 1}, {"Fcr_ATMSector", {-0.0841, -0.3139}, 1}, {"Fcr_ATMSector", {0.0000, -0.3250}, 1}, {"Fcr_ATMSector", {0.0841, -0.3139}, 1}, {"Fcr_ATMSector", {0.1625, -0.2815}, 1}, {"Fcr_ATMSector", {0.2298, -0.2298}, 1}, {"Fcr_ATMSector", {0.2815, -0.1625}, 1}, {"Fcr_ATMSector", {0.3139, -0.0841}, 1}, {"Fcr_ATMSector", {0.3250, 0.0000}, 1}, {},
            };
        };
    };
    class outerArcNrw {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 2));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.2298, -0.2298}, 1}, {"Fcr_ATMSector", {-0.1806, -0.2702}, 1}, {"Fcr_ATMSector", {-0.1244, -0.3003}, 1}, {"Fcr_ATMSector", {-0.0634, -0.3188}, 1}, {"Fcr_ATMSector", {0.0000, -0.3250}, 1}, {"Fcr_ATMSector", {0.0634, -0.3188}, 1}, {"Fcr_ATMSector", {0.1244, -0.3003}, 1}, {"Fcr_ATMSector", {0.1806, -0.2702}, 1}, {"Fcr_ATMSector", {0.2298, -0.2298}, 1}, {},
            };
        };
    };
    class outerArcZoom {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 3));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.1244, -0.3003}, 1}, {"Fcr_ATMSector", {-0.0841, -0.3139}, 1}, {"Fcr_ATMSector", {-0.0424, -0.3222}, 1}, {"Fcr_ATMSector", {0.0000, -0.3250}, 1}, {"Fcr_ATMSector", {0.0424, -0.3222}, 1}, {"Fcr_ATMSector", {0.0841, -0.3139}, 1}, {"Fcr_ATMSector", {0.1244, -0.3003}, 1}, {},
            };
        };
    };
    class ringsWide {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 0));
        color[] = {0.05, 0.25, 0, 1};
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {{0.5000, 0.4188}, 1}, {{0.5210, 0.4215}, 1}, {{0.5406, 0.4296}, 1}, {{0.5575, 0.4425}, 1}, {{0.5704, 0.4594}, 1}, {{0.5785, 0.4790}, 1}, {{0.5813, 0.5000}, 1}, {{0.5785, 0.5210}, 1}, {{0.5704, 0.5406}, 1}, {{0.5575, 0.5575}, 1}, {{0.5406, 0.5704}, 1}, {{0.5210, 0.5785}, 1}, {{0.5000, 0.5813}, 1}, {{0.4790, 0.5785}, 1}, {{0.4594, 0.5704}, 1}, {{0.4425, 0.5575}, 1}, {{0.4296, 0.5406}, 1}, {{0.4215, 0.5210}, 1}, {{0.4188, 0.5000}, 1}, {{0.4215, 0.4790}, 1}, {{0.4296, 0.4594}, 1}, {{0.4425, 0.4425}, 1}, {{0.4594, 0.4296}, 1}, {{0.4790, 0.4215}, 1}, {{0.5000, 0.4188}, 1}, {},
                {{0.5000, 0.3375}, 1}, {{0.5362, 0.3416}, 1}, {{0.5705, 0.3536}, 1}, {{0.6013, 0.3730}, 1}, {{0.6270, 0.3987}, 1}, {{0.6464, 0.4295}, 1}, {{0.6584, 0.4638}, 1}, {{0.6625, 0.5000}, 1}, {{0.6584, 0.5362}, 1}, {{0.6464, 0.5705}, 1}, {{0.6270, 0.6013}, 1}, {{0.6013, 0.6270}, 1}, {{0.5705, 0.6464}, 1}, {{0.5362, 0.6584}, 1}, {{0.5000, 0.6625}, 1}, {{0.4638, 0.6584}, 1}, {{0.4295, 0.6464}, 1}, {{0.3987, 0.6270}, 1}, {{0.3730, 0.6013}, 1}, {{0.3536, 0.5705}, 1}, {{0.3416, 0.5362}, 1}, {{0.3375, 0.5000}, 1}, {{0.3416, 0.4638}, 1}, {{0.3536, 0.4295}, 1}, {{0.3730, 0.3987}, 1}, {{0.3987, 0.3730}, 1}, {{0.4295, 0.3536}, 1}, {{0.4638, 0.3416}, 1}, {{0.5000, 0.3375}, 1}, {},
                {{0.5000, 0.2563}, 1}, {{0.5476, 0.2609}, 1}, {{0.5933, 0.2748}, 1}, {{0.6354, 0.2973}, 1}, {{0.6724, 0.3276}, 1}, {{0.7027, 0.3646}, 1}, {{0.7252, 0.4067}, 1}, {{0.7391, 0.4524}, 1}, {{0.7438, 0.5000}, 1}, {{0.7391, 0.5476}, 1}, {{0.7252, 0.5933}, 1}, {{0.7027, 0.6354}, 1}, {{0.6724, 0.6724}, 1}, {{0.6354, 0.7027}, 1}, {{0.5933, 0.7252}, 1}, {{0.5476, 0.7391}, 1}, {{0.5000, 0.7438}, 1}, {{0.4524, 0.7391}, 1}, {{0.4067, 0.7252}, 1}, {{0.3646, 0.7027}, 1}, {{0.3276, 0.6724}, 1}, {{0.2973, 0.6354}, 1}, {{0.2748, 0.5933}, 1}, {{0.2609, 0.5476}, 1}, {{0.2563, 0.5000}, 1}, {{0.2609, 0.4524}, 1}, {{0.2748, 0.4067}, 1}, {{0.2973, 0.3646}, 1}, {{0.3276, 0.3276}, 1}, {{0.3646, 0.2973}, 1}, {{0.4067, 0.2748}, 1}, {{0.4524, 0.2609}, 1}, {{0.5000, 0.2563}, 1}, {},
            };
        };
    };
    class ringsMed {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 1));
        color[] = {0.05, 0.25, 0, 1};
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.0812, 0.0000}, 1}, {"Fcr_ATMSector", {-0.0785, -0.0210}, 1}, {"Fcr_ATMSector", {-0.0704, -0.0406}, 1}, {"Fcr_ATMSector", {-0.0575, -0.0575}, 1}, {"Fcr_ATMSector", {-0.0406, -0.0704}, 1}, {"Fcr_ATMSector", {-0.0210, -0.0785}, 1}, {"Fcr_ATMSector", {0.0000, -0.0812}, 1}, {"Fcr_ATMSector", {0.0210, -0.0785}, 1}, {"Fcr_ATMSector", {0.0406, -0.0704}, 1}, {"Fcr_ATMSector", {0.0575, -0.0575}, 1}, {"Fcr_ATMSector", {0.0704, -0.0406}, 1}, {"Fcr_ATMSector", {0.0785, -0.0210}, 1}, {"Fcr_ATMSector", {0.0813, 0.0000}, 1}, {},
                {"Fcr_ATMSector", {-0.1625, 0.0000}, 1}, {"Fcr_ATMSector", {-0.1570, -0.0421}, 1}, {"Fcr_ATMSector", {-0.1407, -0.0812}, 1}, {"Fcr_ATMSector", {-0.1149, -0.1149}, 1}, {"Fcr_ATMSector", {-0.0812, -0.1407}, 1}, {"Fcr_ATMSector", {-0.0421, -0.1570}, 1}, {"Fcr_ATMSector", {0.0000, -0.1625}, 1}, {"Fcr_ATMSector", {0.0421, -0.1570}, 1}, {"Fcr_ATMSector", {0.0813, -0.1407}, 1}, {"Fcr_ATMSector", {0.1149, -0.1149}, 1}, {"Fcr_ATMSector", {0.1407, -0.0812}, 1}, {"Fcr_ATMSector", {0.1570, -0.0421}, 1}, {"Fcr_ATMSector", {0.1625, 0.0000}, 1}, {},
                {"Fcr_ATMSector", {-0.2437, 0.0000}, 1}, {"Fcr_ATMSector", {-0.2354, -0.0631}, 1}, {"Fcr_ATMSector", {-0.2111, -0.1219}, 1}, {"Fcr_ATMSector", {-0.1724, -0.1724}, 1}, {"Fcr_ATMSector", {-0.1219, -0.2111}, 1}, {"Fcr_ATMSector", {-0.0631, -0.2354}, 1}, {"Fcr_ATMSector", {0.0000, -0.2437}, 1}, {"Fcr_ATMSector", {0.0631, -0.2354}, 1}, {"Fcr_ATMSector", {0.1219, -0.2111}, 1}, {"Fcr_ATMSector", {0.1724, -0.1724}, 1}, {"Fcr_ATMSector", {0.2111, -0.1219}, 1}, {"Fcr_ATMSector", {0.2354, -0.0631}, 1}, {"Fcr_ATMSector", {0.2438, 0.0000}, 1}, {},
            };
        };
    };
    class ringsNrw {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 2));
        color[] = {0.05, 0.25, 0, 1};
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.0575, -0.0575}, 1}, {"Fcr_ATMSector", {-0.0451, -0.0676}, 1}, {"Fcr_ATMSector", {-0.0311, -0.0751}, 1}, {"Fcr_ATMSector", {-0.0159, -0.0797}, 1}, {"Fcr_ATMSector", {0.0000, -0.0812}, 1}, {"Fcr_ATMSector", {0.0159, -0.0797}, 1}, {"Fcr_ATMSector", {0.0311, -0.0751}, 1}, {"Fcr_ATMSector", {0.0451, -0.0676}, 1}, {"Fcr_ATMSector", {0.0575, -0.0575}, 1}, {},
                {"Fcr_ATMSector", {-0.1149, -0.1149}, 1}, {"Fcr_ATMSector", {-0.0903, -0.1351}, 1}, {"Fcr_ATMSector", {-0.0622, -0.1501}, 1}, {"Fcr_ATMSector", {-0.0317, -0.1594}, 1}, {"Fcr_ATMSector", {0.0000, -0.1625}, 1}, {"Fcr_ATMSector", {0.0317, -0.1594}, 1}, {"Fcr_ATMSector", {0.0622, -0.1501}, 1}, {"Fcr_ATMSector", {0.0903, -0.1351}, 1}, {"Fcr_ATMSector", {0.1149, -0.1149}, 1}, {},
                {"Fcr_ATMSector", {-0.1724, -0.1724}, 1}, {"Fcr_ATMSector", {-0.1354, -0.2027}, 1}, {"Fcr_ATMSector", {-0.0933, -0.2252}, 1}, {"Fcr_ATMSector", {-0.0476, -0.2391}, 1}, {"Fcr_ATMSector", {0.0000, -0.2437}, 1}, {"Fcr_ATMSector", {0.0476, -0.2391}, 1}, {"Fcr_ATMSector", {0.0933, -0.2252}, 1}, {"Fcr_ATMSector", {0.1354, -0.2027}, 1}, {"Fcr_ATMSector", {0.1724, -0.1724}, 1}, {},
            };
        };
    };
    class ringsZoom {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 3));
        color[] = {0.05, 0.25, 0, 1};
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.0311, -0.0751}, 1}, {"Fcr_ATMSector", {-0.0210, -0.0785}, 1}, {"Fcr_ATMSector", {-0.0106, -0.0806}, 1}, {"Fcr_ATMSector", {0.0000, -0.0812}, 1}, {"Fcr_ATMSector", {0.0106, -0.0806}, 1}, {"Fcr_ATMSector", {0.0210, -0.0785}, 1}, {"Fcr_ATMSector", {0.0311, -0.0751}, 1}, {},
                {"Fcr_ATMSector", {-0.0622, -0.1501}, 1}, {"Fcr_ATMSector", {-0.0421, -0.1570}, 1}, {"Fcr_ATMSector", {-0.0212, -0.1611}, 1}, {"Fcr_ATMSector", {0.0000, -0.1625}, 1}, {"Fcr_ATMSector", {0.0212, -0.1611}, 1}, {"Fcr_ATMSector", {0.0421, -0.1570}, 1}, {"Fcr_ATMSector", {0.0622, -0.1501}, 1}, {},
                {"Fcr_ATMSector", {-0.0933, -0.2252}, 1}, {"Fcr_ATMSector", {-0.0631, -0.2354}, 1}, {"Fcr_ATMSector", {-0.0318, -0.2417}, 1}, {"Fcr_ATMSector", {0.0000, -0.2437}, 1}, {"Fcr_ATMSector", {0.0318, -0.2417}, 1}, {"Fcr_ATMSector", {0.0631, -0.2354}, 1}, {"Fcr_ATMSector", {0.0933, -0.2252}, 1}, {},
            };
        };
    };
    class azTics90 {
        color[] = {0.05, 0.25, 0, 1};
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {{0.5000, 0.1750}, 1}, {{0.5000, 0.2150}, 1}, {},
                {{0.8250, 0.5000}, 1}, {{0.7850, 0.5000}, 1}, {},
                {{0.5000, 0.8250}, 1}, {{0.5000, 0.7850}, 1}, {},
                {{0.1750, 0.5000}, 1}, {{0.2150, 0.5000}, 1}, {},
            };
        };
    };
};
class ATM_Circle_500M {
    class lines {
        type = "line";
        width = 3;
        points[] = {
            {{0.4797, 0.5000}, 1},
            {{0.4836, 0.5119}, 1},
            {{0.4937, 0.5193}, 1},
            {{0.5063, 0.5193}, 1},
            {{0.5164, 0.5119}, 1},
            {{0.5203, 0.5000}, 1},
            {{0.5164, 0.4881}, 1},
            {{0.5063, 0.4807}, 1},
            {{0.4937, 0.4807}, 1},
            {{0.4836, 0.4881}, 1},
            {{0.4797, 0.5000}, 1},{},
        };
    };
};
// TM 4.35.10a: ATM sectors W 360 / M 180 / N 90 / Z 45 — selected full intensity, larger partial
class atmSectorSides {
    class medFull {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 1));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.0203, 0.0000}, 1}, {"Fcr_ATMSector", {-0.3250, 0.0000}, 1}, {},
                {"Fcr_ATMSector", {0.0203, 0.0000}, 1}, {"Fcr_ATMSector", {0.3250, 0.0000}, 1}, {},
            };
        };
    };
    class medPartial {
        condition = C_COND(C_MORE(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 1));
        color[] = {0.05, 0.25, 0, 1};
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.0203, 0.0000}, 1}, {"Fcr_ATMSector", {-0.3250, 0.0000}, 1}, {},
                {"Fcr_ATMSector", {0.0203, 0.0000}, 1}, {"Fcr_ATMSector", {0.3250, 0.0000}, 1}, {},
            };
        };
    };
    class nrwFull {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 2));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.0144, -0.0144}, 1}, {"Fcr_ATMSector", {-0.2298, -0.2298}, 1}, {},
                {"Fcr_ATMSector", {0.0144, -0.0144}, 1}, {"Fcr_ATMSector", {0.2298, -0.2298}, 1}, {},
            };
        };
    };
    class nrwPartial {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 3));
        color[] = {0.05, 0.25, 0, 1};
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.0144, -0.0144}, 1}, {"Fcr_ATMSector", {-0.2298, -0.2298}, 1}, {},
                {"Fcr_ATMSector", {0.0144, -0.0144}, 1}, {"Fcr_ATMSector", {0.2298, -0.2298}, 1}, {},
            };
        };
    };
    class zoomFull {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 3));
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {-0.0078, -0.0188}, 1}, {"Fcr_ATMSector", {-0.1244, -0.3003}, 1}, {},
                {"Fcr_ATMSector", {0.0078, -0.0188}, 1}, {"Fcr_ATMSector", {0.1244, -0.3003}, 1}, {},
            };
        };
    };
    // TM 4.43.2: ATM centerline symbol, partial-intensity line first arc to outer arc, M/N/Z only
    class centerlineSymbol {
        condition = C_COND(C_MORE(C_MPD_USER(MFD_IND_FCR_SCAN_SIZE), 0));
        color[] = {0.05, 0.25, 0, 1};
        class lines {
            type = "line";
            width = 3;
            points[] = {
                {"Fcr_ATMSector", {0.0000, -0.0203}, 1}, {"Fcr_ATMSector", {0.0000, -0.3250}, 1}, {},
            };
        };
    };
};
