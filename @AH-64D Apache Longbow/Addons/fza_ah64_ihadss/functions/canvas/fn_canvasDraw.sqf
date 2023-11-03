params ["_ctrl"];

private _heli = vehicle player;

if ((driver _heli != player && gunner _heli != player) || !(_heli iskindof "fza_ah64base")) exitwith {};

private _ctrlPos = ctrlPosition _ctrl;
private _ctrlPosCenter = _ctrl ctrlMapScreenToWorld [_ctrlPos#0+(_ctrlPos#2)*0.5, _ctrlPos#1+(_ctrlPos#3)*0.5];
private _ctrlPosBottomRight = _ctrl ctrlMapScreenToWorld [_ctrlPos#0+_ctrlPos#2, _ctrlPos#1+_ctrlPos#3];

_ctrl ctrlMapSetPosition [];
_ctrl ctrlMapAnimAdd [0, 0.000, [-1000,-1000]];
ctrlMapAnimCommit _ctrl;
_ctrl ctrlSetPositionW 0.5;
_ctrl ctrlSetPositionH 0.5;
_ctrl ctrlCommit 0;

private _ctrlCenter = _ctrlPosCenter;
private _ctrlVect = _ctrlPosBottomRight vectorDiff _ctrlPosCenter;
_ctrlVect set [0, _ctrlVect # 0 / 4 * 3];

private _defaultColor = [[0.1,1,0,1], [1,1,1,1]] select (cameraView == "GUNNER");

private _canvas = [_ctrl, _ctrlCenter, _ctrlVect, _defaultColor];

private _mode = _heli getVariable "fza_ah64_hmdfsmode";
if (cameraView == "GUNNER") then {
    _mode = "weapons";
};

[_heli, _canvas, _mode] call fza_ihadss_fnc_flightVelocityVector;
