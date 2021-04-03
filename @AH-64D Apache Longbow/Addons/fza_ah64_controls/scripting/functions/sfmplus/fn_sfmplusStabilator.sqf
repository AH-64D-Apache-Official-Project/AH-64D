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
params ["_heli", "_width", "_length"];

private _colRed = [1,0,0,1]; private _colorGreen = [0, 1, 0, 1];

DRAW_LINE = {
	params ["_heli", "_p1", "_p2", "_col"];
	drawLine3D [_heli modelToWorld _p1, _heli modelToWorld _p2, _col];
};

private _objCtr  = getCenterOfMass _heli;
private _stabPos = [0.0, -8.783, -.50];	//this needs to come from the config...
private _stabPvt = _objCtr vectorAdd _stabPos;

//                  |
//                  |
//    A-------------+-------------B
//    |             |             |
//    E-------------G-------------F
//    |             |             |
//    D-------------+-------------C

_halfWidth = _width / 2;

private _pvt_x = _stabPvt select 0;
private _pvt_y = _stabPvt select 1;
private _pvt_z = _stabPvt select 2;

private _A = [_pvt_x - _halfWidth, _pvt_y, _pvt_z];
private _B = [_pvt_x + _halfWidth, _pvt_y, _pvt_z];
private _C = [_B select 0, _pvt_y - _length, _pvt_z];
private _D = [_A select 0, _pvt_y - _length, _pvt_z];

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


