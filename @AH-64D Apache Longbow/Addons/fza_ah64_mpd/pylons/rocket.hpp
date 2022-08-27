class fza_ah64_rocket {
    class Bones {};
    class Draw
    {
        class BackgroundGroup
        {
            color[] = { 0.0, 0.0, 0.0, 1.0 };
            class Background
            {
                type = polygon;
                points[] =
                {
                    {
                        { {-0.0375,-0.0975}, 1 },
                        { {0.0375, -0.0975}, 1 },
                        { {0.0375,  0.0975}, 1 },
                        { {-0.0375, 0.0975}, 1 }
                    };
                };
            };
        };
        class Lines {
            type = line;
            width=3;
            #define MFD_PYLON_ROCKET_CAP(posX, posY) \
                { {posX-0.00375, posY}, 1 }, \
                { {posX-0.0068, posY-0.0031}, 1 }, \
                { {posX-0.0050, posY-0.0056}, 1 }, \
                { {posX, posY-0.0075}, 1 }, \
                { {posX+0.0050, posY-0.0056}, 1 }, \
                { {posX+0.0068, posY-0.0031}, 1 }, \
                { {posX+0.00375, posY}, 1 }
            points[] = 
            {
                { {-0.0375, 0.0975}, 1 },
                { {-0.0375, -0.09}, 1 },
                { {0.0375, -0.09}, 1 },
                { {0.0375, 0.0975}, 1 },
                { {-0.0375, 0.0975}, 1 }, {},
                MFD_PYLON_ROCKET_CAP(-0.03,-0.09),
                MFD_PYLON_ROCKET_CAP(-0.015,-0.09),
                MFD_PYLON_ROCKET_CAP(0.00,-0.09),
                MFD_PYLON_ROCKET_CAP(0.015,-0.09),
                MFD_PYLON_ROCKET_CAP(0.03,-0.09)
            };
        };
    };
};

#define MFD_PYLON_ROCKET_CAP_INVERSE(posX, posY) \
{\
    { {posX-0.00375, posY}, 1 }, \
    { {posX-0.0068, posY-0.0031}, 1 }, \
    { {posX, posY}, 1 }, \
}, {\
    { {posX-0.0068, posY-0.0031}, 1 }, \
    { {posX-0.0050, posY-0.0056}, 1 }, \
    { {posX, posY}, 1 }, \
}, {\
    { {posX-0.0050, posY-0.0056}, 1 }, \
    { {posX, posY-0.0075}, 1 }, \
    { {posX, posY}, 1 }, \
}, {\
    { {posX+0.00375, posY}, 1 }, \
    { {posX+0.0068, posY-0.0031}, 1 }, \
    { {posX, posY}, 1 }, \
}, {\
    { {posX+0.0068, posY-0.0031}, 1 }, \
    { {posX+0.0050, posY-0.0056}, 1 }, \
    { {posX, posY}, 1 }, \
}, {\
    { {posX+0.0050, posY-0.0056}, 1 }, \
    { {posX, posY-0.0075}, 1 }, \
    { {posX, posY}, 1 }, \
}

class fza_ah64_rocket_inverse {
        class Bones {};
        class Draw{
            class Background {
                type = polygon;
                points[] =
                {
                    {
                        { {-0.0375,-0.090}, 1 },
                        { {0.0375, -0.090}, 1 },
                        { {0.0375,  0.0975}, 1 },
                        { {-0.0375, 0.0975}, 1 }
                    },
                    MFD_PYLON_ROCKET_CAP_INVERSE(-0.03,-0.09),
                    MFD_PYLON_ROCKET_CAP_INVERSE(-0.015,-0.09),
                    MFD_PYLON_ROCKET_CAP_INVERSE(0.00,-0.09),
                    MFD_PYLON_ROCKET_CAP_INVERSE(0.015,-0.09),
                    MFD_PYLON_ROCKET_CAP_INVERSE(0.03,-0.09)
                };
            };
        };
    };