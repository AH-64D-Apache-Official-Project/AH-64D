params ["_a", "_b", "_heading"];

private _up = [sin _heading, cos _heading, 0];
private _right = [cos _heading, -sin _heading, 0];
private _d = _b vectorDiff _a;
private _du = _d vectorDotProduct _right;
private _dv = _d vectorDotProduct _up;
private _ll = _a vectorAdd (_right vectorMultiply (_du min 0)) vectorAdd (_up vectorMultiply (_dv min 0));
_ll set [2, 0];
private _w = _right vectorMultiply abs _du;
private _h = _up vectorMultiply abs _dv;
[_ll, _ll vectorAdd _h, _ll vectorAdd _h vectorAdd _w, _ll vectorAdd _w]
