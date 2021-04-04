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
params ["_heli", "_collOut"];

private _colRed = [1,0,0,1]; private _colorGreen = [0, 1, 0, 1];

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

private _V_mps    = abs vectorMagnitude [velocity _heli select 0, velocity _heli select 1];
private _theta = [_stabOutputTable, _V_mps] call fza_fnc_linearInterp select 1;

//                  |
//                  |
//    A-------------+-------------B
//    |             |             |
//    E-------------G-------------F
//    |             |             |
//    D-------------+-------------C
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

private _area = [_A, _B, _C, _D] call fza_fnc_sfmplusGetArea;

hintSilent format ["Area = %1", _area];

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
[_heli, _objCtr, _stabPvt, _colRed] call DRAW_LINE;

[_heli, _A, _B, _colRed] call DRAW_LINE;
[_heli, _B, _C, _colRed] call DRAW_LINE;
[_heli, _C, _D, _colRed] call DRAW_LINE;
[_heli, _D, _A, _colRed] call DRAW_LINE;

[_heli, _E, _F, _colorGreen] call DRAW_LINE;


