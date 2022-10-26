params ["_heli", "_deltaTime", "_altitude", "_temperature", "_rho"];

//MOVE TO CONFIG!
private _aerodynamicCenter  = [0.0, -1.94, -1.73]; //m

//MOVE TO CONFIG!
private _fuselageAreaFront  =  6.254;
private _fuselageAreaSide   = 22.332;
private _fuselageAreaBottom = 33.129;

private _fuselageDragCoefX  = 1.5;

//MOVE TO CONFIG!                PA     -35      0      35
private _dragCoefTableY       = [[    0,  1.2,   1.4,    1.7],   //ft 
                                 [ 2000,  1.8,   1.9,    2.1],   //ft
                                 [ 4000,  2.6,   2.7,    3.1],   //ft
                                 [ 6000,  3.8,   3.8,    4.2],   //ft
                                 [ 8000,  6.5,   5.2,    5.7]];  //ft
private _interpDragCoefTableY = [_dragCoefTableY, _altitude] call fza_fnc_linearInterp;
_dragCoefTableY               = [[-35, _interpDragCoefTableY # 1],
                                 [  0, _interpDragCoefTableY # 2],
                                 [ 35, _interpDragCoefTableY # 3]];
_interpDragCoefTableY         = [_dragCoefTableY, _temperature] call fza_fnc_linearInterp;
private _fuselageDragCoefY    = _interpDragCoefTableY # 1;

private _fuselageDragCoefZ  = 0.5;


private _vecX = [1.0, 0.0, 0.0];
private _vecY = [0.0, 1.0, 0.0];
private _vecZ = [0.0, 0.0, 1.0];

[velocityModelSpace _heli # 0, velocityModelSpace _heli # 1, velocityModelSpace _heli # 2] 
    params ["_locVelX", "_locVelY", "_locVelZ"];

private _dragX = -_fuselageDragCoefX * 0.5 * _rho * _fuselageAreaSide   * (_locVelX * _locVelX);
private _dragY = -_fuselageDragCoefY * 0.5 * _rho * _fuselageAreaFront  * (_locVelY * _locVelY);
private _dragZ = -_fuselageDragCoefZ * 0.5 * _rho * _fuselageAreaBottom * (_locVelZ * _locVelZ);

////////////////////////////////////////////////////////////////////////////////////////////////////
//TESTING     //////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

private _forceX = _vecX vectorMultiply (_dragX * _deltaTime);
private _forceY = _vecY vectorMultiply (_dragY * _deltaTime);
private _forceZ = _vecZ vectorMultiply (_dragZ * _deltaTime);

_heli addForce[_heli vectorModelToWorld _forceX, _aerodynamicCenter];
_heli addForce[_heli vectorModelToWorld _forceY, _aerodynamicCenter];
_heli addForce[_heli vectorModelToWorld _forceZ, _aerodynamicCenter];

#ifdef __A3_DEBUG__
//Draw the force vector
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecX, _colorRed] call DRAW_LINE;
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecY, _colorGreen] call DRAW_LINE;
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecZ, _colorBlue] call DRAW_LINE;
#endif
////////////////////////////////////////////////////////////////////////////////////////////////////
//TESTING     //////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////