params ["_from", "_to"];

#define COPY(name) _to setVariable [#name, +(_from getVariable #name), true];

COPY(fza_dms_routeNext)
COPY(fza_dms_waypointsHazards)
COPY(fza_dms_controlMeasures)
COPY(fza_dms_targetsThreats)
COPY(fza_dms_shotAt)
COPY(fza_dms_lines)
COPY(fza_dms_areas)
COPY(fza_dms_pfZones)
COPY(fza_dms_nfZones)
COPY(fza_dms_zoneState)
