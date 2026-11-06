#include "\fza_ah64_dms\headers\constants.h"
params ["_items"];

private _labels = [];
{
    _x params ["", "", "", "", "_label", "_pos", "_class", "_id", ["_more", []]];
    if (_label == "") then {continue};
    _labels pushBack [MPD_POSMODE_WORLD, _pos, _label, _id # 0, _id, _class];
    {_labels pushBack [MPD_POSMODE_WORLD, _x, _label, _id # 0, [_id # 0, (_id # 1) + 100], _class]} forEach _more;
} forEach _items;
_labels
