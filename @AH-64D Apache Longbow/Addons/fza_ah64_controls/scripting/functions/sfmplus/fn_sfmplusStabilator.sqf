/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusStabilator

Description:

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:


Examples:


Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _collOut = _heli getVariable "fza_ah64d_collectiveOutput";

private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
	params ["_heli", "_p1", "_p2", "_col"];
	drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _objCtr  = getCenterOfMass _heli;
private _stabPos = [0.0, -8.783, -0.50];	//this needs to come from the config...
private _stabPvt = _objCtr vectorAdd _stabPos;

//--------------------------Coll---30-----50-----57.5---60-----80-----82.5---90-----117.5---120----150---160---165---180
private _stabSchedTable = [[0.00, -25.0,   2.5,   5.0,   5.0,   5.0,   5.0,   5.0,   5.0,   5.0,   5.0,  5.0,  5.0,  5.0],
						   [0.25, -25.0,  -5.0,  -0.5,   0.0,   4.5,   5.0,   5.0,   5.0,   5.0,   5.0,  5.0,  5.0,  5.0],
						   [0.50, -25.0, -12.6,  -8.0,  -7.5,  -3.1,  -2.6,  -1.0,   5.0,   5.0,   5.0,  5.0,  5.0,  5.0],
						   [0.75, -25.0, -20.0, -15.5, -14.9, -10.5, -10.0,  -8.3,  -2.2,  -1.7,   5.0,  5.0,  5.0,  5.0], 
						   [1.00, -25.0, -27.5, -23.0, -22.4, -17.8, -17.3, -15.5,  -9.2,  -8.7,  -1.8,  0.5,  0.5,  0.5]];

private _intStabSched = [_stabSchedTable, _collOut] call fza_fnc_linearInterp;

//---------------------------A/S----Theta
private _stabOutputTable = [[15.43, _intStabSched select 1],
                            [25.72, _intStabSched select 2],
							[29.58, _intStabSched select 3],
							[30.86, _intStabSched select 4],
							[41.15, _intStabSched select 5],
							[42.44, _intStabSched select 6],
							[46.30, _intStabSched select 7],
							[60.44, _intStabSched select 8],
							[61.73, _intStabSched select 9],
							[77.16, _intStabSched select 10],
							[82.31, _intStabSched select 11],
							[84.88, _intStabSched select 12],
							[92.60, _intStabSched select 13]];

private _V_mps = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
private _theta = [_stabOutputTable, _V_mps] call fza_fnc_linearInterp select 1;
//_heli animateSource ["hstab", -_theta];

//Stab coords    |     |
//               |-----|
//    A-------------H-------------B
//    |             |             |
//    E-------------G-------------F
//    |             |             |
//    D-------------I-------------C
private _width  = _heli getVariable "fza_ah64d_stabWidth";
private _length = _heli getVariable "fza_ah64d_stabLength";

private _halfWidth = _width / 2;

private _A = _stabPvt vectorAdd [-_halfWidth, 0, 0];
private _B = _stabPvt vectorAdd [_halfWidth, 0, 0];
private _C = _stabPvt vectorAdd [_halfWidth, cos _theta * (-_length), sin _theta * _length];
private _D = _stabPvt vectorAdd [-_halfWidth, cos _theta * (-_length), sin _theta * _length];

private _E = (_A vectorAdd _D) vectorMultiply 0.5;
private _F = (_B vectorAdd _C) vectorMultiply 0.5;
private _G = (_E vectorAdd _F) vectorMultiply 0.5;

private _H = (_A vectorAdd _B) vectorMultiply 0.5;
private _I = (_D vectorAdd _C) vectorMultiply 0.5;

private _liftLine  = _E vectorDiff _F;
private _chordLine = _H vectorDiff _I;

private _liftVec = vectorNormalized (_chordLine vectorCrossProduct _liftLine);
_liftVec = _liftVec;

private _stabLine = vectorNormalized _chordLine;
_stabLine = _stabLine;

private _relWind = vectornormalized(_heli vectorWorldToModel (velocity _heli));
_relWind = _relWind;

private _AoA = (_relWind # 2 atan2 _relWind # 1) + _theta;
_AoA = [_AoA] call CBA_fnc_simplifyAngle180;

private _AIRFOILTABLE =
[
//------AoA-[0]----------CL-[1]--------CD-[2]-------------
    [   -180.0,        0.0,           0.0        ],  //0  - DO NOT CHANGE!!
    [   -135.0,        0.5,           0.5        ],  //1  - DO NOT CHANGE!!
    [   -90.0,         0.0,           0.0        ],  //2  - DO NOT CHANGE!!
    [   -18.5,         -1.22580,      0.10236    ],  //3  -
    [   -17.5,         -1.30310,      0.07429    ],  //4  -
    [   -15.75,        -1.38680,      0.03865    ],  //5  -
    [   -10.0,         -1.08070,      0.01499    ],  //6  -
    [   -5.0,          -0.55710,      0.00847    ],  //7  -
    [   0.0,           0.00000,       0.00540    ],  //8  -
    [   5.0,           0.55720,       0.00847    ],  //9  -
    [   10.0,          1.08080,       0.01499    ],  //10 -
    [   15.75,         1.38810,       0.03863    ],  //11 -
    [   17.5,          1.30590,       0.07416    ],  //12 -
    [   18.5,          1.22840,       0.10229    ],  //13 -
    [   90.0,          0.0,           0.0        ],  //14 - DO NOT CHANGE!!
    [   135.0,         -0.5,          -0.5       ],  //15 - DO NOT CHANGE!!
    [   180.0,         0.0,           0.0        ]   //16 - DO NOT CHANGE!!
];

private _intAIRFOILTABLE = [_AIRFOILTABLE, _AoA] call fza_fnc_linearInterp;
private _CL = _intAIRFOILTABLE select 1;

private _area = [_A, _B, _C, _D] call fza_fnc_sfmplusGetArea;

private _liftForce = -_CL * 0.5 * 1.225 * _area * _V_mps;
/*
LIFTMOD = [[ 0.00,  1.00],	//0kts
			[10.29, 1.00],	//24kts
			[20.58, 1.00],	//40kts
			[30.87, 1.00],	//60kts
			[36.01, 1.00],	//70kts
			[46.30, 1.00],	//90kts
			[56.59, 1.00],	//110kts
			[61.73, 1.00],	//120kts
			[72.02, 1.00],	//140kts
			[73.05, 1.00]];	//142kts

LIFTMOD = [[ 0.00,  1.00],
			[10.29, 1.00],
			[20.58, 1.00],
			[30.87, 1.00],
			[36.01, 1.00],
			[46.30, 1.00],
			[56.59, 1.00],
			[61.73, 1.00],
			[72.02, 1.00],
			[73.05, 1.00]];
			
LIFTMOD = [[ 0.00, 1.00], 
           [10.29, 1.00], 
           [20.58, 1.00], 
           [30.87, 1.00], 
           [36.01, 1.00], 
           [46.30, 0.155], 
           [56.59, -0.5], 
           [61.73, -0.42], 
           [72.02, 0.00], 
           [73.05, 0.00]];			
*/
private _liftModOut = [LIFTMOD, _V_mps] call fza_fnc_linearInterp select 1;
_liftForce = _liftForce * _liftModOut;

private _lift = _liftVec vectorMultiply _liftForce;

_heli addForce[_heli vectorModelToWorld _lift, _G];

hintSilent format ["Lift Mod = %1
					\nLift Force = %2", LIFTMOD, _liftForce];
/*
              +Z   +Y
               |   /
               |  / 
	           | / 
	           |/
   -X ---------+--------- +X
              /|
             / |
            /  |
		   /   |
         -Y   -Z                
		 
		                       SRP
				+--------------+ --
				C               \
*/
[_heli, _objCtr, _stabPvt, _colorWhite] call DRAW_LINE;

//Draw the stabilator
[_heli, _A, _B, _colorWhite] call DRAW_LINE;
[_heli, _B, _C, _colorWhite] call DRAW_LINE;
[_heli, _C, _D, _colorWhite] call DRAW_LINE;
[_heli, _D, _A, _colorWhite] call DRAW_LINE;
//Draw the fwd chord line originating from the pivot
[_heli, _H, _H vectorAdd _stabLine, _colorWhite] call DRAW_LINE;
//Draw the lift line
[_heli, _E, _F, _colorGreen] call DRAW_LINE;
//Draw the lift vector
[_heli, _G, _G vectorAdd _liftVec, _colorBlue] call DRAW_LINE;
//Draw the velocity vector
[_heli, _H, _H vectorAdd _relWind, _colorRed] call DRAW_LINE;