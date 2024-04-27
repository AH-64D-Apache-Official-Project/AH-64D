
params ["_type"];

private _return = 50;
private _index  = -1;
switch (_type) do {
    case "waypointsHazards": {
        _waypointsHazards = missionnamespace getVariable "fza_dms_waypointsHazards";
        _index = _waypointsHazards findIf {_x isequalto -1};
    };
    case "controlMeasures": {
        _controlMeasures = missionnamespace getVariable "fza_dms_controlMeasures";
        _index = _controlMeasures findIf {_x isequalto -1};
    };
    case "targetsThreats": {
        _targets = missionnamespace getVariable "fza_dms_targetsThreats";
        _index = _targets findIf {_x isequalto -1};
    };
};

if (_index isNotEqualTo -1) then {_return = _index;};
_return;