class fza_ah64_hellfire {
    class Bones {
        class Null {
            type = fixed;
            pos[] = {0, 0};
        };
    };
    class Draw
    {
        class NotPresent {
            condition = "pylonMagazineEmpty";
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
                    { {-0.0075, -0.062}, 1 },
                };
            };
        };
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
                    { {0.0,   -0.018}, 1 },
                    { {0.02,  -0.038}, 1 },
                };
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
        color[] = { 1.0, 1.0, 1.0, 1.0 };
        class NotPresent {
            condition = "pylonMagazineEmpty";
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
                    { {-0.0075, -0.062}, 1 },
                };
            };
        };
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
                    { {0.0,   -0.018}, 1 },
                    { {0.02,  -0.038}, 1 },
                };
            };
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
      class NotPresent {
            condition = "pylonMagazineEmpty";
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
                        { {-0.020, }, 1 },
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
                    },
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
                        { {0.0,   -0.018}, 1 },
                        { {0.02,  -0.038}, 1 },
                    };
                };
            };
        };
    };
};