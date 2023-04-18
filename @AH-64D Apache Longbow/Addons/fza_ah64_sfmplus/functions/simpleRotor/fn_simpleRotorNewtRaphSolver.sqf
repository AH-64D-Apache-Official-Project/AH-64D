/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_simpleRotorNewtRaphSolver

Description:
	This newton raphson solver calculates the true induced flow of the simple 
    rotor.

Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_w", "_u", "_n"];

private _epsilon = 0.0005;

func1 = {
    params ["_w", "_u", "_n"];

    private _return = _w^2 * (_u^2 + (_w - _n)^2) - 1;
    _return;
};

func2 = {
    params ["_w", "_u", "_n"];
    
    private _return = (2 * _w) * (2 * _w^2 - 3 * _n * _w + _u^2 + _n^2);
    _return;
};

private _delta = 0;
_delta         = ([_w, _u, _n] call func1) / ([_w, _u, _n] call func2);

while { (abs _delta) >= _epsilon } do {
    _delta = ([_w, _u, _n] call func1) / ([_w, _u, _n] call func2);
    _w     = _w - _delta;
};

_w;