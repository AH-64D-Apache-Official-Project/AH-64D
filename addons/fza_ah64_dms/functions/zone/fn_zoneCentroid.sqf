params ["_pts"];

private _sum = [0, 0, 0];
{_sum = _sum vectorAdd [_x # 0, _x # 1, 0]} forEach _pts;
_sum vectorMultiply (1 / (count _pts max 1))
