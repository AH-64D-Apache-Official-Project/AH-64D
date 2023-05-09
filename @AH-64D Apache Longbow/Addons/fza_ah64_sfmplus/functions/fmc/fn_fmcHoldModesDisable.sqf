params ["_heli"];

//De-activate attitude hold and set the reference back to 0
_heli setVariable ["fza_ah64_attHoldActive",     false];
_heli setVariable ["fza_ah64_attHoldDesiredAtt", 0.0];

//De-activate altitude hold and set the reference back to 0
_heli setVariable ["fza_ah64_altHoldActive",     false];
_heli setVariable ["fza_ah64_altHoldDesiredAlt", 0.0];