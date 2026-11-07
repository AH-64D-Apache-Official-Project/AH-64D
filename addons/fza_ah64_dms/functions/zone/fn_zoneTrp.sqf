// Four squares about the centre: upper left, upper right, lower right, lower left
params ["_centre", "_side", "_heading"];

private _c = [_centre # 0, _centre # 1, 0];
private _up = [sin _heading, cos _heading, 0] vectorMultiply _side;
private _right = [cos _heading, -sin _heading, 0] vectorMultiply _side;
[[-1, 0], [0, 0], [0, -1], [-1, -1]] apply {
    private _o = _c vectorAdd (_right vectorMultiply (_x # 0)) vectorAdd (_up vectorMultiply (_x # 1));
    [_o, _o vectorAdd _up, _o vectorAdd _up vectorAdd _right, _o vectorAdd _right]
}
