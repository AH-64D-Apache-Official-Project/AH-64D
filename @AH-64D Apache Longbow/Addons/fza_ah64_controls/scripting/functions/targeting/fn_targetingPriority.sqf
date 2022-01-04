/*----------------------------------------------------------------------------
Function: fza_fnc_targetingPriority

Description:
    Takes the information and prioritises the list for 16 targets to be displayed

Parameters:
	_heli - the heli to act upon
	_Radartargets - Input from Fcr script

Returns:
    Nothing
    
Examples:
    [_heli, _fcrTargets] spawn fza_fnc_targetingPriority;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli","_Radartargets"];

//needs Mp testing to ensure when passed to foreach it goes through list in order
_Radartargets = [_Radartargets, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;

Private _p1 = [];
Private _p2 = [];
Private _p3 = [];
Private _p4 = [];
Private _p5 = [];
Private _p6 = [];
Private _p7 = [];
Private _p8 = [];
Private _p9 = [];

{
    _distance = _heli distance2d _x;
    if ([_x] call fza_fnc_targetIsADA) then {
		_P1 pushBackUnique _x;
		continue;
	};
    if (_x isKindOf "plane") then {
		_P2 pushBackUnique _x;
		continue;
	};
    if ((_x isKindOf "tank") && (_distance < 4000)) then {
		_P3 pushBackUnique _x;
		continue;
	};
    if ((_x isKindOf "Helicopter") && (_distance < 6000)) then {
		_P4 pushBackUnique _x;
		continue;
	};
    if ((_x isKindOf "car") && (_distance < 4000)) then {
		_P5 pushBackUnique _x;
		continue;
	};
    if !(_x isKindOf "car" || _x isKindOf "tank" || _x isKindOf "plane" || _x isKindOf "helicopter") then {
		_P6 pushBackUnique _x;
		continue;
	};
    if (_x isKindOf "tank") then {
		_P7 pushBackUnique _x;
		continue;
	};
    if (_x isKindOf "Helicopter") then {
		_P8 pushBackUnique _x;
		continue;
	};
    if (_x isKindOf "car") then {
		_P9 pushBackUnique _x;
		continue;
	};
	sleep 0.05;
} foreach _Radartargets;

/*_p1 = [_p1, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
_p2 = [_p2, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
_p3 = [_p3, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
_p4 = [_p4, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
_p5 = [_p5, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
_p6 = [_p6, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
_p7 = [_p7, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
_p8 = [_p8, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
_p9 = [_p9, [_heli], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;*/

fza_ah64_fcrlist = _P1 + _P2 + _P3 + _P4 + _P5 + _P6 + _P7 + _P8 + _P9;