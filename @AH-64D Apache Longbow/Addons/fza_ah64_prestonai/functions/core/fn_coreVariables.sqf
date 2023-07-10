params ["_heli"];

_heli setVariable ["fza_prestonai_heliState", "OFF"];  //OFF, APU, ON
_heli setVariable ["fza_prestonai_heliMode", "GND"];   //GND (ground), HVR (hover), TRN (transition), CRS (cruise)

_heli setVariable ["fza_prestonai_setAltAGL", 0.0];
_heli setVariable ["fza_prestonai_altErrAGL", 0.0];

_heli setVariable ["fza_prestonai_setAltASL", 0.0];


_heli setVariable ["fza_prestonai_collOutput",   0.0];
_heli setVariable ["fza_prestonai_pid_hvr_coll", [0.000, 0.000, 0.000] call fza_fnc_pidCreate];