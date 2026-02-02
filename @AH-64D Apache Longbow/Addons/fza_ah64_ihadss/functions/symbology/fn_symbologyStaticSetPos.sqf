params ["_ctrl", "_pos"];

private _screenPos = worldToScreen _pos;

if (_screenPos isEqualTo []) exitWith {
    _ctrl ctrlShow false;
};

private _parentPos = ctrlPosition ctrlParentControlsGroup _ctrl;

private _currPos = ctrlPosition _ctrl;

_ctrl ctrlShow true;

_ctrl ctrlSetPosition
    [ _screenPos # 0 - _parentPos # 0 - (_currPos # 2)/2
    , _screenPos # 1 - _parentPos # 1 - (_currPos # 3)/2
    , 0.2
    , 0.1*(4/3)
    ];
_ctrl ctrlCommit 0;