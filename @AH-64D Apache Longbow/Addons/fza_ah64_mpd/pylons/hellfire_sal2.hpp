class fza_ah64_hellfire {
    class Bones {
        class Null {
            type = fixed;
            pos[] = {0, 0};
        };
    };
    class Draw
    {
        class Present {
            condition = "1-pylonMagazineEmpty";
            class BackgroundGroup
            {
                color[] = { 0.0, 0.0, 0.0, 1.0 };
                class Background
                {
                    type = polygon;
                    points[] =
                    {
                        {
                            { {-0.02,-0.062}, 1 },
                            { {0.02,-0.062}, 1 },
                            { {0.02,0.062}, 1 },
                            { {-0.02,0.062}, 1 }
                        };
                    };
                };
            };
            class Lines {
                type = line;
                width=3;
                points[] = 
                {
                    { {-0.02, 0.062}, 1 },
                    { {-0.02, -0.042}, 1 },
                    { {-0.018, -0.05}, 1 },
                    { {-0.013, -0.057}, 1 },
                    { {0.0, -0.062}, 1 },
                    { {0.013, -0.057}, 1 },
                    { {0.018, -0.05}, 1 },
                    { {0.02, -0.042}, 1 },
                    { {0.02, 0.062}, 1 },
                    { {-0.02, 0.062}, 1 }, {},
                    { {-0.02, -0.038}, 1 },
                    { {0.02,  -0.038}, 1 }, {},
                    { {-0.02, -0.024}, 1 },
                    { {0.02,  -0.024}, 1 }
                };
            };
            MPD_TEXT_C(Line2, 0, 0+0.07-2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
        };
    };
};

class fza_ah64_hellfire_inverse {
    class Bones {
        class Null {
            type = fixed;
            pos[] = {0, 0};
        };
    };
    class Draw
    {
        class Present{
            condition = "1-pylonMagazineEmpty";
            class Background
            {
                type = polygon;
                points[] =
                {
                    {
                        { {-0.02,-0.042}, 1 },
                        { {0.02,-0.042}, 1 },
                        { {0.02,0.062}, 1 },
                        { {-0.02,0.062}, 1 }
                    },
                    {
                        { {-0.020, 0.0}, 1 },
                        { {-0.018, -0.05}, 1 },
                        { {0.0, 0.0}, 1 },
                    }, {
                        { {-0.018, -0.05}, 1 },
                        { {-0.013, -0.057}, 1 },
                        { {0.0, 0.0}, 1 },
                    }, {
                        { {-0.013, -0.057}, 1 },
                        { {0.0, -0.062}, 1 },
                        { {0.0, 0.0}, 1 },
                    },  {
                        { {0.013, -0.057}, 1 },
                        { {0.0, -0.062}, 1 },
                        { {0.0, 0.0}, 1 },
                    },  {
                        { {0.018, -0.05}, 1 },
                        { {0.013, -0.057}, 1 },
                        { {0.0, 0.0}, 1 },
                    }, {
                        { {0.020, 0.0}, 1 },
                        { {0.018, -0.05}, 1 },
                        { {0.0, 0.0}, 1 },
                    }
                };
            };

            class LineGroup
            {
                color[] = { 0.0, 0.0, 0.0, 1.0 };

                class Lines {
                    type = line;
                    width=5;
                    points[] = 
                    {
                        { {-0.02, -0.038}, 1 },
                        { {0.02,  -0.038}, 1 }, {},
                        { {-0.02, -0.024}, 1 },
                        { {0.02,  -0.024}, 1 } 
                    };
                };
                MPD_TEXT_C(Line2, 0, 0+0.07-2*MPD_TEXT_HEIGHT, MPD_TEXT_STATIC("L"))
            };
        };
    };
};

class fza_ah64_hellfire_selected {
    class Bones {
        class Null {
            type = fixed;
            pos[] = {0, 0};
        };
    };
    class Draw
    {
        color[] = {1,1,1,1};
        class Present {
            condition = "1-pylonMagazineEmpty";
            class BackgroundGroup
            {
                color[] = { 0.0, 0.0, 0.0, 1.0 };
                class Background
                {
                    type = polygon;
                    points[] =
                    {
                        {
                            { {-0.02,-0.062}, 1 },
                            { {0.02,-0.062}, 1 },
                            { {0.02,0.062}, 1 },
                            { {-0.02,0.062}, 1 }
                        };
                    };
                };
            };
            class Lines {
                type = line;
                width=3;
                points[] = 
                {
                    { {-0.02, 0.062}, 1 },
                    { {-0.02, -0.042}, 1 },
                    { {-0.018, -0.05}, 1 },
                    { {-0.013, -0.057}, 1 },
                    { {0.0, -0.062}, 1 },
                    { {0.013, -0.057}, 1 },
                    { {0.018, -0.05}, 1 },
                    { {0.02, -0.042}, 1 },
                    { {0.02, 0.062}, 1 },
                    { {-0.02, 0.062}, 1 }, {},
                    { {-0.02, -0.038}, 1 },
                    { {0.02,  -0.038}, 1 }, {},
                    { {-0.02, -0.024}, 1 },
                    { {0.02,  -0.024}, 1 }
                };
            };
        };
    };
};

class fza_ah64_M299 {
    class Bones {
        class Null {
            type = fixed;
            pos[] = {0, 0};
        };
    };
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
                        { {-0.0075,-0.062}, 1 },
                        { { 0.0075,-0.062}, 1 },
                        { { 0.0075,0.062}, 1 },
                        { {-0.0075,0.062}, 1 }
                    };
                };
            };
        };
        class Lines {
            type = line;
            width=3;
            points[] = 
            {
                { {-0.0075, -0.062}, 1 },
                { { 0.0075, -0.062}, 1 },
                { { 0.0075,  0.062}, 1 },
                { {-0.0075,  0.062}, 1 },
                { {-0.0075, -0.062}, 1 }
            };
        };
    };
};

class fza_ah64_M299_inverse {
    class Bones {
        class Null {
            type = fixed;
            pos[] = {0, 0};
        };
    };
    class Draw
    {
        class Background
        {
            type = polygon;
            points[] =
            {
                {
                    { {-0.0075,-0.062}, 1 },
                    { {0.0075,-0.062}, 1 },
                    { {0.0075,0.062}, 1 },
                    { {-0.0075,0.062}, 1 }
                },
            };
        };
    };
};

//Empty pylon icon definitions to supress RPT warnings that they are missing
//even though these are for a different type of weapon
class fza_ah64_rocket {
    class Bones{};
    class Draw{};
};
class fza_ah64_rocket_inverse: fza_ah64_rocket {};
