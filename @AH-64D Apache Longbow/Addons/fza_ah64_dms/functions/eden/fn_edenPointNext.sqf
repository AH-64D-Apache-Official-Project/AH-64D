#include "\fza_ah64_dms\headers\constants.h"
params ["_entity", "_type"];

private _usedIndex = [];
private _index = -1;
private _fzalogic = allMissionObjects _type;

{
    _x params ["_logic"];
    if (_logic isEqualTo _entity) then {continue;};
    private _logicType = (_logic get3DENAttribute "ItemClass");
    if !(_type in _logictype) then {continue;};
    private _logicPointIndex = (_logic get3DENAttribute "fza_dms_point_index")#0;
    if (_type isEqualTo "fza_dms_point_cm") then {_logicPointIndex = _logicPointIndex - 50;};
    _usedIndex pushback _logicPointIndex;
} foreach _fzalogic;

for "_i" from 1 to 50 do { 
    if !(_i in _usedIndex) exitwith {   
        _index = _i;
    };
};

_index;