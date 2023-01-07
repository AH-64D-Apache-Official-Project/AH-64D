params ["_heli", "_deltaTime", "_altitude", "_temperature", "_rho"];

private _aerodynamicCenter  = _heli getVariable "fza_sfmplus_aerodynamicCenter"; //m

private _fuselageAreaFront  = _heli getVariable "fza_sfmplus_fuselageAreaFront";
private _fuselageAreaSide   = _heli getVariable "fza_sfmplus_fuselageAreaSide";
private _fuselageAreaBottom = _heli getVariable "fza_sfmplus_fuselageAreaBottom";

private _fuselageDragCoefX    = 1.5;
private _fuselageDragCoefZ    = 0.5;
//                                  PA   -40     0    40
private _dragCoefTableY       = [[   0, 0.54, 0.60, 0.60],   //ft 
                                 [2000, 0.80, 0.70, 0.55],   //ft
                                 [4000, 1.02, 0.92, 0.85],   //ft
                                 [6000, 1.20, 1.00, 1.06],   //ft
                                 [8000, 1.65, 1.25, 1.70]];  //ft
private _interpDragCoefTableY = [_dragCoefTableY, _altitude] call fza_fnc_linearInterp;
_dragCoefTableY               = [[-40, _interpDragCoefTableY # 1],
                                 [  0, _interpDragCoefTableY # 2],
                                 [ 40, _interpDragCoefTableY # 3]];
_interpDragCoefTableY         = [_dragCoefTableY, _temperature] call fza_fnc_linearInterp;
private _fuselageDragCoefY    = _interpDragCoefTableY # 1;

velocityModelSpace _heli
    params ["_locVelX", "_locVelY", "_locVelZ"];

private _drag = 
            [ _fuselageDragCoefX * _fuselageAreaSide   * (_locVelX * _locVelX)
            , _fuselageDragCoefY * _fuselageAreaFront  * (_locVelY * _locVelY)
            , _fuselageDragCoefZ * _fuselageAreaBottom * (_locVelZ * _locVelZ)
            ] vectorMultiply (-0.5 * _rho * _deltaTime);

_heli addForce[_heli vectorModelToWorld _drag, _aerodynamicCenter];

#ifdef __A3_DEBUG__
private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

private _vecX = [1.0, 0.0, 0.0];
private _vecY = [0.0, 1.0, 0.0];
private _vecZ = [0.0, 0.0, 1.0];

private _DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

//Draw the force vector
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecX, _colorRed] call   _DRAW_LINE;
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecY, _colorGreen] call _DRAW_LINE;
[_heli, _aerodynamicCenter, _aerodynamicCenter vectorAdd _vecZ, _colorBlue] call  _DRAW_LINE;
#endif