params ["_heli"];
if !(_heli getVariable "bmkhs_battBusOn") exitWith {};
sleep 0.5;

//Where each wing station's stores leave the airframe, in station order. Model space - these
//are drop points, not the CG-space arms the mass model uses for the same stations.
private _dropPoints = [
    [-2.37995, 2.79, -0.975],
    [-1.66295, 2.79, -0.975],
    [ 1.65505, 2.79, -0.975],
    [ 2.37705, 2.79, -0.975]
];

//The stations and their pylons come from HeliSim's mass table, the same one it weighs them
//from, so nothing here assumes which pylon indices a station carries.
{
    private _pylons    = _x get "pylons";
    private _stationNo = _forEachIndex + 1;
    private _position  = _dropPoints select _forEachIndex;
    private _pylonMags = getPylonMagazines _heli;

    //Nothing fitted, nothing to drop.
    if ((_pylons findIf {(_pylonMags param [_x - 1, ""]) != ""}) < 0) then { continue };

    //Weighed BEFORE anything is cleared - once the pylons are empty there is no store left
    //for HeliSim to match, and the station weighs nothing.
    private _stationMass = [_heli, _pylons, _stationNo] call bmkhs_fnc_massUpdateStation;

    //One dummy per pylon, the rest riding on the first so the station falls as one piece.
    private _dummies = [];
    {
        private _dummy = "fza_ah64_pylon_base" createVehicle [0,0,0];
        private _ammo  = _heli ammoOnPylon _x;
        _dummy setPylonLoadout [1, _pylonMags select (_x - 1), false, []];
        [_heli, [_x, "", false, []]] remoteExec ["setPylonLoadOut", crew _heli];
        _dummy setAmmoOnPylon [1, _ammo];
        _dummy allowDamage false;
        if (_dummies isNotEqualTo []) then { _dummy attachTo [_dummies select 0, [0,0,0]] };
        _dummies pushBack _dummy;
    } forEach _pylons;

    private _dummyMain = _dummies select 0;
    _dummyMain setMass _stationMass;
    _dummyMain attachTo [_heli, _position];
    detach _dummyMain;

    [_dummyMain, _dummies] spawn {
        params ["_dummyMain", "_dummies"];
        waitUntil {(getPos _dummyMain)#2 < 10 || (vectorMagnitude (velocity _dummyMain)) < 0.3};
        sleep 30;
        {
            _x setPhysicsCollisionFlag false;
        } forEach _dummies;

        waitUntil {(getPos _dummyMain)#2 < -1};
        {
            deleteVehicle _x;
        } forEach _dummies;
    };
} forEach (_heli getVariable "bmkhs_stations");
