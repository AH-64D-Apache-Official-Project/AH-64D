params ["_heli"];

_heli setVariable ["fza_prestonai_heliState", "OFF"];  //OFF, APU, ON
_heli setVariable ["fza_prestonai_heliMode", "GND"];   //GND (ground), HVR (hover), TRN (transition), CRS (cruise)