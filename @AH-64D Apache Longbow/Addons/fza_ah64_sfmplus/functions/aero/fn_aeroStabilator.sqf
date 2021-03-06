/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_aeroStabilator

Description:
    Creates a stabilator object which automatically schedules as a function of
    collective position and airspeed.

Parameters:
	_heli      - The helicopter to get information from [Unit].
    _deltaTime - Passed delta time from core update.

Returns:
    ...

Examples:
    ...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];

private _collOut = fza_sfmplus_collectiveOutput;

private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
	params ["_heli", "_p1", "_p2", "_col"];
	drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _objCtr  = _heli selectionPosition ["modelCenter", "Memory"];
private _stabPos = _heli getVariable "fza_sfmplus_stabPos";
private _stabPvt = _objCtr vectorAdd _stabPos;

//--------------------Coll----30kts--70kts--90kts--110kts--120kts-150kts
private _stabTable =[[0.00,  -25.00,  2.5,    5.0,   5.0,   5.0,   5.0],  
                     [0.67,  -25.00, -3.2,   -3.2,  -3.2,  -3.2,  -3.2],  
                     [0.71,  -25.00, -6.0,   -6.0,  -6.0,  -6.0,  -6.0],  
                     [0.81,  -25.00, -9.5,   -9.5,  -9.5,  -9.5,  -9.5],  
                     [0.89,  -25.00, -12.2, -12.2, -12.2, -12.2, -12.2],
                     [0.97,  -25.00, -14.5, -14.5, -14.5, -14.5, -14.5]];

/*
Udpated 15Jun21 - SFM+ 
TEMPTABLE = [    
[0.00,  -25.00, 2.5,   5.0,  5.0,  5.0, 5.0],  
[0.67,  -25.00,-3.2,  -3.2, -3.2, -3.2, -3.2],  
[0.71,  -25.00,-6.0,  -6.0, -6.0, -6.0, -6.0],  
[0.81,  -25.00,-9.5,  -9.5, -9.5, -9.5, -9.5],  
[0.89,  -25.00,-12.2,-12.2,-12.2,-12.2,-12.2],
[0.97,  -25.00,-14.5,-14.5,-14.5,-14.5,-14.5]];

HeliSim
TEMPTABLE = [     
[0.00,  -25.00, 2.5,   5.0,  5.0,  5.0, 5.0],   
[0.37,  -25.00,-3.2,  -3.2, -3.2, -3.2, -3.2], 
[0.41,  -25.00,-6.0,  -6.0, -6.0, -6.0, -6.0],  
[0.51,  -25.00,-9.5,  -9.5, -9.5, -9.5, -9.5],  
[0.59,  -25.00,-12.2,-12.2,-12.2,-12.2,-12.2], 
[0.67,  -25.00,-14.5,-14.5,-14.5,-14.5,-14.5]];

private _intStabTable = [TEMPTABLE, _collOut] call fza_fnc_linearInterp;
*/
private _intStabTable = [_stabTable, _collOut] call fza_fnc_linearInterp;

private _stabOutputTable = [[15.43, _intStabTable select 1],  //30kts
							[36.01, _intStabTable select 2],  //70kts
							[46.30, _intStabTable select 3],  //90kts
							[56.59, _intStabTable select 4],  //110kts
							[61.73, _intStabTable select 5],  //120kts
                            [77.17, _intStabTable select 6]]; //150kts


private _V_mps = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
private _theta = [_stabOutputTable, _V_mps] call fza_fnc_linearInterp select 1;

//Stab coords    |     |
//               |-----|
//    A-------------H-------------B
//    |             |             |
//    E-------------G-------------F
//    |             |             |
//    D-------------I-------------C
private _width  = _heli getVariable "fza_sfmplus_stabWidth";
private _length = _heli getVariable "fza_sfmplus_stabLength";

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

private _area = [_A, _B, _C, _D] call fza_sfmplus_fnc_getArea;
private _liftForce = -_CL * 0.5 * 1.225 * _area * (_V_mps * _V_mps);

private _lift = _liftVec vectorMultiply (_liftForce * _deltaTime);
if (local _heli) then {
    _heli addForce[_heli vectorModelToWorld _lift, _G];
};

#ifdef __A3_DEBUG__
/*
hintsilent format ["Collective Out = %1
                   \nStab Pos = %2
                   \nCollective Low = %3
                   \nCollective High = %4", _collOut, _theta, inputAction "HeliCollectiveLowerCont", inputAction "HeliCollectiveRaiseCont"];
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
#endif