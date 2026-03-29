params ["_from", "_to"];

#define COPY(name) _to setVariable [#name, _from getVariable #name, true];

COPY(fza_dms_routeNext)
COPY(fza_dms_waypointsHazards)
COPY(fza_dms_controlMeasures)
COPY(fza_dms_targetsThreats)
COPY(fza_dms_shotAt)