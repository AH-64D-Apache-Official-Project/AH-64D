/////////////////////////////////////////////////////////////////////////////////////////////
// Airfoils //////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
    //Lift and drag against angle of attack, per airfoil section. Rotors and wings name the
    //section they use - rotorAirfoil[] and wingAirfoil[] hold these names - so a config says
    //what an aerofoil IS rather than pointing at a position in a list.
    //
    //  name    - how rotors and wings refer to this section. Must be unique; Core matches on
    //            it exactly, so a name that matches nothing is a config error.
    //  table[] - {AoA deg, CL, CD}, interpolated. The +/-90 and +/-180 rows anchor the curve
    //            through the reversed-flow regions and must not be edited.
    numAirfoils = 2;
    class Airfoils {
        class Airfoil01 {
            name = "NACA 0012";
            table[] =
        {
        //------AoA-{0}----------CL-{1}--------CD-{2}-------------
            {   -180.0,        0.0,           0.0        },  //0  - DO NOT CHANGE!!
            {   -135.0,        0.5,           0.5        },  //1  - DO NOT CHANGE!!
            {   -90.0,         0.0,           0.0        },  //2  - DO NOT CHANGE!!
            {   -18.5,         -1.22580,      0.10236    },  //3  -
            {   -17.5,         -1.30310,      0.07429    },  //4  -
            {   -15.75,        -1.38680,      0.03865    },  //5  -
            {   -10.0,         -1.08070,      0.01499    },  //6  -
            {   -5.0,          -0.55710,      0.00847    },  //7  -
            {   0.0,           0.00000,       0.00540    },  //8  -
            {   5.0,           0.55720,       0.00847    },  //9  -
            {   10.0,          1.08080,       0.01499    },  //10 -
            {   15.75,         1.38810,       0.03863    },  //11 -
            {   17.5,          1.30590,       0.07416    },  //12 -
            {   18.5,          1.22840,       0.10229    },  //13 -
            {   90.0,          0.0,           0.0        },  //14 - DO NOT CHANGE!!
            {   135.0,         -0.5,          -0.5       },  //15 - DO NOT CHANGE!!
            {   180.0,         0.0,           0.0        }   //16 - DO NOT CHANGE!!
        };
        };
        class Airfoil02 {
            name = "NACA 4418";
            table[] =
        {
        //------AoA-{0}----------CL-{1}--------CD-{2}-------------
            {   -180.0,        0.0,           0.0        },  //0  - DO NOT CHANGE!!
            {   -135.0,        0.5,           0.5        },  //1  - DO NOT CHANGE!!
            {   -90.0,         0.0,           0.0        },  //2  - DO NOT CHANGE!!
            {   -19.25,        -0.96520,      0.08741    },  //3  -
            {   -17.5,         -1.09540,      0.04857    },  //4  -
            {   -15.75,        -1.16470,      0.02577    },  //5  -
            {   -10.0,         -0.61210,      0.01214    },  //6  -
            {   -5.0,          -0.06780,      0.00889    },  //7  -
            {   0.0,           0.47990,       0.00817    },  //8  -
            {   5.0,           1.02960,       0.00899    },  //9  -
            {   10.0,          1.41910,       0.01546    },  //10 -
            {   15.75,         1.60280,       0.04913    },  //11 -
            {   17.5,          1.58700,       0.07067    },  //12 -
            {   19.0,          1.55500,       0.09291    },  //13 -
            {   90.0,          0.0,           0.0        },  //14 - DO NOT CHANGE!!
            {   135.0,         -0.5,          -0.5       },  //15 - DO NOT CHANGE!!
            {   180.0,         0.0,           0.0        }   //16 - DO NOT CHANGE!!
        };
        };
    };
