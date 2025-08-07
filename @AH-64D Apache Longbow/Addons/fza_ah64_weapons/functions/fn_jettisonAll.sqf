params ["_heli"];
_heli = vehicle player;
{
    _x params ["_pylon", "_position"];
    private _pylonDummyMain = "fza_ah64_pylon_base" createVehicle [0,0,0];
    private _ammo = _heli ammoOnPylon (_pylon);
    private _magazine = (getPylonMagazines _heli) # (_pylon - 1);
    _pylonDummyMain setPylonLoadOut [1, _magazine, false, []];
    _heli setPylonLoadOut [_pylon, "", false, []];
    _pylonDummyMain setAmmoOnPylon [1, _ammo];
    _pylonDummyMain disableCollisionWith _heli;
    //_pylonDummyMain setPhysicsCollisionFlag false;
    _pylonDummyMain allowDamage false;


    for "_i" from 1 to 3 do {
        private _pylonDummy = "fza_ah64_pylon_base" createVehicle [0,0,0];
        _pylonDummy attachTo [_pylonDummyMain, [0,0,0]];

        private _ammo = _heli ammoOnPylon (_pylon + _i);
        private _magazine = (getPylonMagazines _heli) # (_pylon - 1 + _i);
        _pylonDummy setPylonLoadOut [1, _magazine, false, []];
        _heli setPylonLoadOut [(_pylon + _i), "", false, []];
        _pylonDummy setAmmoOnPylon [1, _ammo];
        _pylonDummy disableCollisionWith _heli;
        //_pylonDummy setPhysicsCollisionFlag false;
        _pylonDummy allowDamage false;
    };

    private _stationFuelmass = ["fza_sfmplus_stn1FuelMass", "fza_sfmplus_stn2FuelMass", "fza_sfmplus_stn3FuelMass", "fza_sfmplus_stn4FuelMass"] # _foreachindex;
    private _pylonmass = [_heli,  (_pylon - 1),  _pylon,  (_pylon + 3), _stationFuelmass] call fza_sfmplus_fnc_massUpdateStation;
    _pylonDummyMain setMass _pylonmass;

    _pylonDummyMain attachTo [_heli, _position];
    detach _pylonDummyMain;
} forEach [
    [1, [-2.37995,2.79,-0.975]],
    [5, [-1.66295,2.79,-0.975]],
    [9, [1.65505,2.79,-0.975]],
    [13, [2.37705,2.79,-0.975]]
];