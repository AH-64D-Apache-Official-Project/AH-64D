params ["_heli", "_deltaTime", "_rho"];

private _aerodynamicCenter  = [0.0, -1.94, -1.73]; //m

private _fuselageDragCoefX  = 1.5;
private _fuselageDragCoefY  = 1.55;//DRAG_COEF_Y;
private _fuselageDragCoefZ  = 0.5;

private _fuselageAreaFront  =  6.254;
private _fuselageAreaSide   = 22.332;
private _fuselageAreaBottom = 33.129;

private _vecX = [1.0, 0.0, 0.0];
private _vecY = [0.0, 1.0, 0.0];
private _vecZ = [0.0, 0.0, 1.0];

[velocityModelSpace _heli # 0, velocityModelSpace _heli # 1, velocityModelSpace _heli # 2] 
    params ["_locVelX", "_locVelY", "_locVelZ"];

private _dragX =  _fuselageDragCoefX * 0.5 * _rho * _fuselageAreaSide   * (_locVelX * _locVelX);
private _dragY = -_fuselageDragCoefY * 0.5 * _rho * _fuselageAreaFront  * (_locVelY * _locVelY);
private _dragZ =  _fuselageDragCoefZ * 0.5 * _rho * _fuselageAreaBottom * (_locVelZ * _locVelZ);

systemChat format ["%1 -- %2 -- %3", _dragX toFixed 0, _dragY toFixed 0, _dragZ toFixed 0];

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