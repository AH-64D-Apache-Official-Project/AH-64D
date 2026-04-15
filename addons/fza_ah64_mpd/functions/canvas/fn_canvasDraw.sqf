params ["_p", "_side"];
_p params ["_ctrl"];

private _heli = vehicle player;

if ((driver _heli != player && gunner _heli != player) || !(_heli iskindof "fza_ah64base")) exitwith {};

private _xOffset = [0,0.5] select (_side == "right");

_ctrl ctrlMapSetPosition [_xOffset,0,0.5,0.5];
_ctrl ctrlMapAnimAdd [0, 0.000, [-1000,-1000]];
ctrlMapAnimCommit _ctrl;
_ctrl ctrlCommit 0;

private _ctrlPos = ctrlPosition _ctrl;
private _ctrlPosTopLeft = _ctrl ctrlMapScreenToWorld [_ctrlPos#0, _ctrlPos#1];
private _ctrlPosBottomRight = _ctrl ctrlMapScreenToWorld [_ctrlPos#0+_ctrlPos#2, _ctrlPos#1+_ctrlPos#3];

private _ctrlVect = _ctrlPosBottomRight vectorDiff _ctrlPosTopLeft;

private _idx = [0,1] select (_side == "right");

(_heli getVariable "fza_mpd_mpdState") # _idx params ["_page", "", "", "_drawCanvas", "_state", "_persistState"];

private _canvas = [_ctrl, _ctrlPosTopLeft, _ctrlVect];

[_heli, _canvas, _idx, _state, _persistState get _page] call _drawCanvas;
