
class GTM {
    class 5km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 5000));
        class continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 1));
            class lines {
                type = line;
                width = 3;
                points[] = {
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.764, -0.704}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.017, 00.000}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.764, -0.704}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.017, -0.000}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.764, -0.704}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.684, -0.774}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.598, -0.836}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.508, -0.894}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.412, -0.938}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.316, -0.974}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.212, -1.000}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.106, -1.016}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.000, -1.200}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.106, -1.016}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.212, -1.000}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.316, -0.974}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.412, -0.938}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.508, -0.894}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.598, -0.836}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.684, -0.774}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.764, -0.704}, 1}
                };
            };
        };
        class single: continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 3));
            color[] = {1,1,1,1};
            class Lines: Lines {};
        };
    };
    class 10km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 10000));
        class continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 1));
            class lines {
                type = line;
                width = 3;
                points[] = {
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.382, -0.352}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.017, 00.000}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.382, -0.352}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.017, -0.000}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.382, -0.352}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.342, -0.387}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.299, -0.418}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.254, -0.447}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.206, -0.469}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.158, -0.487}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.106, -0.500}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.053, -0.508}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.000, -0.510}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.053, -0.508}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.106, -0.500}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.158, -0.487}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.206, -0.469}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.254, -0.447}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.299, -0.418}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.342, -0.387}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.382, -0.352}, 1}
                };
            };
        };
        class single: continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 3));
            color[] = {1,1,1,1};
            class Lines: Lines {};
        };
    };
    class 25km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 25000));
        class continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 1));
            class lines {
                type = line;
                width = 3;
                points[] = {
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.153, -0.141}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.017, 00.000}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.153, -0.141}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.017, -0.000}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.153, -0.141}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.137, -0.155}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.120, -0.167}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.102, -0.179}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.082, -0.188}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.063, -0.195}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.042, -0.200}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.021, -0.203}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.000, -0.204}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.021, -0.203}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.042, -0.200}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.063, -0.195}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.082, -0.188}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.102, -0.179}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.120, -0.167}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.137, -0.155}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.153, -0.141}, 1}
                };
            };
        };
        class single: continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 3));
            color[] = {1,1,1,1};
            class Lines: Lines {};
        };
    };
    class 50km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 50000));
        class continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 1));
            class lines {
                type = line;
                width = 3;
                points[] = {
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.076, -0.070}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.017, 00.000}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.076, -0.070}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.017, -0.000}, 1},
                    {},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.076, -0.070}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.068, -0.077}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.060, -0.084}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.051, -0.089}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.041, -0.094}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.032, -0.097}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.021, -0.100}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.011, -0.102}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.000, -0.102}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.011, -0.102}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.021, -0.100}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.032, -0.097}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.041, -0.094}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.051, -0.089}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.060, -0.084}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.068, -0.077}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {00.076, -0.070}, 1}
                };
            };
        };
        class single: continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 3));
            color[] = {1,1,1,1};
            class Lines: Lines {};
        };
    };
};
class ATM {
    class 5km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 10000));
        class continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 2));
            class Lines {
                type = line;
                width = 3;
                points[] = {
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {1.020, 0.000}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {1.017, 0.081}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {1.007, 0.162}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.991, 0.241}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.969, 0.319}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.940, 0.395}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.906, 0.468}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.866, 0.539}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.820, 0.606}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.770, 0.669}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.714, 0.728}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.654, 0.783}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.590, 0.832}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.522, 0.877}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.450, 0.915}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.376, 0.948}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.300, 0.975}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.221, 0.996}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.142, 1.010}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.061, 1.018}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.020, 1.020}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.101, 1.015}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.182, 1.004}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.261, 0.986}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.338, 0.962}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.414, 0.932}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.486, 0.897}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.556, 0.855}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.622, 0.808}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.685, 0.756}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.742, 0.699}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.796, 0.638}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.844, 0.573}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.887, 0.504}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.924, 0.432}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.955, 0.357}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.981, 0.280}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-1.000, 0.201}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-1.013, 0.121}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-1.019, 0.041}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-1.019, -0.041}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-1.013, -0.121}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-1.000, -0.201}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.981, -0.280}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.955, -0.357}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.924, -0.432}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.887, -0.504}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.844, -0.573}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.796, -0.638}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.742, -0.699}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.685, -0.756}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.622, -0.808}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.556, -0.855}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.486, -0.897}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.414, -0.932}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.338, -0.962}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.261, -0.986}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.182, -1.004}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.101, -1.015}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.020, -1.020}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.061, -1.018}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.142, -1.010}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.221, -0.996}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.300, -0.975}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.376, -0.948}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.450, -0.915}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.522, -0.877}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.590, -0.832}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.654, -0.783}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.714, -0.728}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.770, -0.669}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.820, -0.606}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.866, -0.539}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.906, -0.468}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.940, -0.395}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.969, -0.319}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.991, -0.241}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {1.007, -0.162}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {1.017, -0.081}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {1.020, -0.000}, 1},
                };
            };
        };
        class single: continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 4));
            color[] = {1,1,1,1};
            class Lines: Lines {};
        };
    };
    class 10km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 10000));
        class continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 2));
            class Lines {
                type = line;
                width = 3;
                points[] = {
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.510, 0.000}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.508, 0.041}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.504, 0.081}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.496, 0.121}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.484, 0.160}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.470, 0.198}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.453, 0.234}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.433, 0.269}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.410, 0.303}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.385, 0.335}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.357, 0.364}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.327, 0.391}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.295, 0.416}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.261, 0.438}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.225, 0.458}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.188, 0.474}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.150, 0.487}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.111, 0.498}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.071, 0.505}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.030, 0.509}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.010, 0.510}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.051, 0.507}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.091, 0.502}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.130, 0.493}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.169, 0.481}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.207, 0.466}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.243, 0.448}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.278, 0.428}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.311, 0.404}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.342, 0.378}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.371, 0.350}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.398, 0.319}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.422, 0.286}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.443, 0.252}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.462, 0.216}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.478, 0.179}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.490, 0.140}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.500, 0.101}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.506, 0.061}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.510, 0.020}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.510, -0.020}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.506, -0.061}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.500, -0.101}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.490, -0.140}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.478, -0.179}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.462, -0.216}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.443, -0.252}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.422, -0.286}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.398, -0.319}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.371, -0.350}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.342, -0.378}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.311, -0.404}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.278, -0.428}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.243, -0.448}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.207, -0.466}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.169, -0.481}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.130, -0.493}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.091, -0.502}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.051, -0.507}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.010, -0.510}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.030, -0.509}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.071, -0.505}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.111, -0.498}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.150, -0.487}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.188, -0.474}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.225, -0.458}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.261, -0.438}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.295, -0.416}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.327, -0.391}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.357, -0.364}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.385, -0.335}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.410, -0.303}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.433, -0.269}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.453, -0.234}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.470, -0.198}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.484, -0.160}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.496, -0.121}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.504, -0.081}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.508, -0.041}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.510, -0.000}, 1},
                };
            };
        };
        class single: continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 4));
            color[] = {1,1,1,1};
            class Lines: Lines {};
        };
    };
    class 25km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 25000));
        class continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 2));
            class Lines {
                type = line;
                width = 3;
                points[] = {
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.204, 0.000}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.203, 0.016}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.201, 0.032}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.198, 0.048}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.194, 0.064}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.188, 0.079}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.181, 0.094}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.173, 0.108}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.164, 0.121}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.154, 0.134}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.143, 0.146}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.131, 0.157}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.118, 0.166}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.104, 0.175}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.090, 0.183}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.075, 0.190}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.060, 0.195}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.044, 0.199}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.028, 0.202}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.012, 0.204}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.004, 0.204}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.020, 0.203}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.036, 0.201}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.052, 0.197}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.068, 0.192}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.083, 0.186}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.097, 0.179}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.111, 0.171}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.124, 0.162}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.137, 0.151}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.148, 0.140}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.159, 0.128}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.169, 0.115}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.177, 0.101}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.185, 0.086}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.191, 0.071}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.196, 0.056}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.200, 0.040}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.203, 0.024}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.204, 0.008}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.204, -0.008}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.203, -0.024}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.200, -0.040}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.196, -0.056}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.191, -0.071}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.185, -0.086}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.177, -0.101}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.169, -0.115}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.159, -0.128}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.148, -0.140}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.137, -0.151}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.124, -0.162}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.111, -0.171}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.097, -0.179}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.083, -0.186}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.068, -0.192}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.052, -0.197}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.036, -0.201}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.020, -0.203}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.004, -0.204}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.012, -0.204}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.028, -0.202}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.044, -0.199}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.060, -0.195}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.075, -0.190}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.090, -0.183}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.104, -0.175}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.118, -0.166}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.131, -0.157}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.143, -0.146}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.154, -0.134}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.164, -0.121}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.173, -0.108}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.181, -0.094}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.188, -0.079}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.194, -0.064}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.198, -0.048}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.201, -0.032}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.203, -0.016}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.204, -0.000}, 1},
                };
            };
        };
        class single: continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 4));
            color[] = {1,1,1,1};
            class Lines: Lines {};
        };
    };
    class 50km {
        condition = C_COND(C_EQ(C_MPD_USER(MFD_IND_TSD_SCALE_BOXES), 50000));
        class continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 2));
            class Lines {
                type = line;
                width = 3;
                points[] = {
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.102, 0.000}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.102, 0.008}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.101, 0.016}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.099, 0.024}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.097, 0.032}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.094, 0.040}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.091, 0.047}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.087, 0.054}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.082, 0.061}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.077, 0.067}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.071, 0.073}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.065, 0.078}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.059, 0.083}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.052, 0.088}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.045, 0.092}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.038, 0.095}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.030, 0.097}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.022, 0.100}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.014, 0.101}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.006, 0.102}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.002, 0.102}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.010, 0.101}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.018, 0.100}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.026, 0.099}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.034, 0.096}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.041, 0.093}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.049, 0.090}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.056, 0.086}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.062, 0.081}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.068, 0.076}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.074, 0.070}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.080, 0.064}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.084, 0.057}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.089, 0.050}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.092, 0.043}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.096, 0.036}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.098, 0.028}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.100, 0.020}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.101, 0.012}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.102, 0.004}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.102, -0.004}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.101, -0.012}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.100, -0.020}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.098, -0.028}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.096, -0.036}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.092, -0.043}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.089, -0.050}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.084, -0.057}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.080, -0.064}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.074, -0.070}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.068, -0.076}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.062, -0.081}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.056, -0.086}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.049, -0.090}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.041, -0.093}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.034, -0.096}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.026, -0.099}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.018, -0.100}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.010, -0.101}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {-0.002, -0.102}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.006, -0.102}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.014, -0.101}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.022, -0.100}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.030, -0.097}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.038, -0.095}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.045, -0.092}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.052, -0.088}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.059, -0.083}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.065, -0.078}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.071, -0.073}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.077, -0.067}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.082, -0.061}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.087, -0.054}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.091, -0.047}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.094, -0.040}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.097, -0.032}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.099, -0.024}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.101, -0.016}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.102, -0.008}, 1},
                    {"Tsd_Ownship_Offset", 1, "Tsd_Ownship", {0.102, -0.000}, 1},
                };
            };
        };
        class single: continuous {
            condition = C_COND(C_EQ(C_MPD_USER(MFD_TEXT_IND_TSD_ROOT_FCR), 4));
            color[] = {1,1,1,1};
            class Lines: Lines {};
        };
    };
};