params ["_heli"];
if !(_heli getvariable "fza_systems_battBusOn") exitwith {};
sleep 0.5;
{
    _x params ["_pylon", "_position"];
    private _pylonDummyMain = "fza_ah64_pylon_base" createVehicle [0,0,0];
    private _ammo = _heli ammoOnPylon (_pylon);
    private _magazine = (getPylonMagazines _heli) # (_pylon - 1);
    _pylonDummyMain setPylonLoadOut [1, _magazine, false, []];
    _heli setPylonLoadOut [_pylon, "", false, []];
    _pylonDummyMain setAmmoOnPylon [1, _ammo];
    _pylonDummyMain allowDamage false;
    private _pylons = [];
    _pylons pushback _pylonDummyMain;


    for "_i" from 1 to 3 do {
        private _pylonDummy = "fza_ah64_pylon_base" createVehicle [0,0,0];
        _pylonDummy attachTo [_pylonDummyMain, [0,0,0]];

        private _ammo = _heli ammoOnPylon (_pylon + _i);
        private _magazine = (getPylonMagazines _heli) # (_pylon - 1 + _i);
        _pylonDummy setPylonLoadOut [1, _magazine, false, []];
        _heli setPylonLoadOut [(_pylon + _i), "", false, []];
        _pylonDummy setAmmoOnPylon [1, _ammo];
        _pylonDummy allowDamage false;
        _pylons pushback _pylonDummy;
    };

    private _stationFuelmass = ["fza_sfmplus_stn1FuelMass", "fza_sfmplus_stn2FuelMass", "fza_sfmplus_stn3FuelMass", "fza_sfmplus_stn4FuelMass"] # _foreachindex;
    private _pylonmass = [_heli,  (_pylon - 1),  _pylon,  (_pylon + 3), _stationFuelmass] call fza_sfmplus_fnc_massUpdateStation;
    _pylonDummyMain setMass _pylonmass;
    _pylonDummyMain attachTo [_heli, _position];
    detach _pylonDummyMain;

    [_pylonDummyMain, _pylons] spawn {
        params ["_pylonDummyMain", "_pylons"];
        waituntil {(getpos _pylonDummyMain)#2 < 10 || (vectormagnitude (velocity _pylonDummyMain)) < 0.3};
        sleep 30;
        {
            _x setPhysicsCollisionFlag false;
        } forEach _pylons;
        
        waituntil {(getpos _pylonDummyMain)#2 < -1};
        {
            deleteVehicle _x;
        } forEach _pylons;
    };
} forEach [
    [1, [-2.37995,2.79,-0.975]],
    [5, [-1.66295,2.79,-0.975]],
    [9, [1.65505,2.79,-0.975]],
    [13, [2.37705,2.79,-0.975]]
];