params ["_heli", "_phase"];

systemChat str _this;

if (_phase == _heli getVariable "fza_ah64_magazineAddLastValue") exitwith {};

if (_phase > 0.5) then {
    //Should have 1200rnds, no IAFS
    _heli removeMagazineTurret ["fza_m230_300", [0]];
    _heli addMagazineTurret ["fza_m230_1200", [0]];
    _heli setVariable ["fza_ah64_IAFSInstalled", false, true];
} else {
    //Should have 300rnds with IAFS
    _heli removeMagazineTurret ["fza_m230_1200", [0]];
    _heli addMagazineTurret ["fza_m230_300", [0]];
    _heli setVariable ["fza_ah64_IAFSInstalled", true, true];
};

[_heli] call fza_sfmplus_fnc_coreConfig;

_heli setVariable ["fza_ah64_magazineAddLastValue", _phase, true];