params ["_heli", "_phase"];

if (!local _heli) exitwith {};

_heli removeMagazineTurret ["fza_m230_300", [0]];
_heli removeMagazineTurret ["fza_m230_1200", [0]];

if (_phase > 0.5) then {
    //Should have 1200rnds, no IAFS
    _heli addMagazineTurret ["fza_m230_1200", [0]];
    _heli setVariable ["fza_ah64_IAFSInstalled", false, true];
} else {
    //Should have 300rnds with IAFS
    _heli addMagazineTurret ["fza_m230_300", [0]];
    _heli setVariable ["fza_ah64_IAFSInstalled", true, true];
};

[_heli] call fza_sfmplus_fnc_coreConfig;