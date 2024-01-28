/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_massUpdateStation

Description:
    Updates the mass and moment of a wing station

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_magIndex", "_pylonIndexStart", "_pylonIndexEnd"];

private _pylonMagazines = getPylonMagazines _heli;
private _stationMass    = 0.0;

//M299 Hellfire Missile Launcher
if (["agm114", _pylonMagazines select _magIndex] call BIS_fnc_inString) then {
    private _m299launcherMass = 64.9;   //kg
    private _agm114Mass       = 46.71;  //kg - 103lbs (99lbs to 106lbs, average of 102.5lbs = 103lbs)
    private _magAmmo          = 0;

    for "_i" from _pylonIndexStart to _pylonIndexEnd do {
        private _magName = _pylonMagazines select (_i - 1);
        if (_magName == "") then {
            _magAmmo = _magAmmo;
        } else {
            _magAmmo = _magAmmo + (_heli ammoOnPylon format["pylons%1",_i]);
        };
    };
    _stationMass = _m299launcherMass + (_magAmmo * _agm114Mass);
    //systemChat format ["Mag Ammo = %1 -- Station 1 Mass = %2", _magAmmo, _stationMass];
};

//M261 Rocket Pod
if (["275", _pylonMagazines select _magIndex] call BIS_fnc_inString) then {
    private _m261launcherMass = 39.4;   //kg
    private _hydraMass        = 10.4;   //kg - 23lbs (10.4kg) for the M151, 27.5lbs for M255A1, 27.4lbs for M261, 24.3lbs for M257/M278
    private _magAmmo          = 0;

    for "_i" from _pylonIndexStart to _pylonIndexEnd do {
        private _magName = _pylonMagazines select (_i - 1);
        if (_magName == "") then {
            _magAmmo = _magAmmo;
        } else {
            _magAmmo = _magAmmo + (_heli ammoOnPylon format["pylons%1",_i]);
        };
    };
    _stationMass = _m261launcherMass + (_magAmmo * _hydraMass);
    //systemChat format ["Mag Ammo = %1 -- Station 1 Mass = %2", _magAmmo, _stationMass];
};

//230-gal Auxiliary Tanks

_stationMass;