params [
    ["_legacyJson", "", [""]],
    ["_cannonRds", -1, [0]],
    ["_desiredFcr", -1, [0]]
];

if (_legacyJson isEqualTo "") exitWith {false};

private _heli = vehicle player;
if (isNull _heli) exitWith {false};
if !(_heli isKindOf "Helicopter") exitWith {false};

[_heli, _legacyJson, _cannonRds, _desiredFcr] spawn {
    params ["_heli", "_legacyJson", "_cannonRds", "_desiredFcr"];

    if (isNull _heli) exitWith {};

    private _settings = [_legacyJson] call CBA_fnc_parseJSON;
    if (isNil "_settings") exitWith {
        systemChat "Mission Planner apply failed: invalid payload.";
    };

    private _nameCheck = ["M151", "M255", "M257", "M261", "M278", "AGM114FA", "AGM114k", "AGM114K2A", "AGM114L", "AGM114N"];
    private _pylonArraycheck = ["pylon1", "pylon2", "pylon3", "pylon4"];
    private _pylonRktCheck = ["zoneE", "zoneB", "zoneA"];
    private _pylonMslCheck = ["lr", "ll", "ur", "ul"];

    private _iafsInstalled = _settings getVariable ["iafsInstalled", true];
    private _iafsPhase = [1, 0] select _iafsInstalled;
    private _desiredFcrState = _desiredFcr;
    if (_desiredFcrState < 0) then {
        _desiredFcrState = [0, 1] select (_settings getVariable ["fcrInstalled", false]);
    };
    _desiredFcrState = _desiredFcrState max 0 min 1;

    private _targetFuelKg = _settings getVariable ["fuel", 0];
    private _targetFuelKgClamped = _targetFuelKg max 0;

    [_heli] call fza_sfmplus_fnc_coreConfig;
    private _sfmPlusCfg = configOf _heli >> "Fza_SfmPlus";
    private _ctrEnabled = [0, 1] select _iafsInstalled;
    private _tankCapacityKg =
        getNumber (_sfmPlusCfg >> "maxFwdFuelMass") +
        getNumber (_sfmPlusCfg >> "maxAftFuelMass") +
        (_ctrEnabled * getNumber (_sfmPlusCfg >> "maxCtrFuelMass"));

    private _targetFuelPct = if (_tankCapacityKg > 0) then { (_targetFuelKgClamped / _tankCapacityKg) max 0 min 1 } else { fuel _heli };

    private _curFuelKg = _heli getVariable ["fza_sfmplus_totFuelMass", 0];
    private _fuelDeltaKg = abs (_targetFuelKgClamped - _curFuelKg);
    private _fuelDeltaLbs = _fuelDeltaKg * 2.20462;

    private _curCannonRds = _heli ammo "fza_m230";
    private _maxCannon = [1200, 300] select _iafsInstalled;
    private _targetCannonRds = _cannonRds;
    if (_targetCannonRds < 0) then {
        _targetCannonRds = _curCannonRds;
    };
    _targetCannonRds = _targetCannonRds max 0 min _maxCannon;
    private _cannonDelta = abs (_targetCannonRds - _curCannonRds);

    private _currentFcrState = [0, 1] select ((_heli animationPhase "fcr_enable") > 0.5);
    private _needsFcr = _desiredFcrState != _currentFcrState;
    private _needsCenterStore = (_heli getVariable ["fza_ah64_IAFSInstalled", true]) != _iafsInstalled;
    private _needsFuel = _fuelDeltaKg > 1;
    private _needsCannon = _cannonDelta > 0;
    private _needsPylons = true;

    private _applyPylons = {
        private _targetPylonMagazines = +getPylonMagazines _heli;
        private _configureQueue = [];
        private _magazineIndex = 16;

        {
            private _pylonKey = _x;
            private _pylonInfo = _settings getVariable [_pylonKey, [] call CBA_fnc_createNamespace];
            private _pylonType = _pylonInfo getVariable ["type", "none"];

            private _assignMagazine = {
                params ["_magazineName"];
                _targetPylonMagazines set [_magazineIndex - 1, _magazineName];
                _magazineIndex = _magazineIndex - 1;
            };

            switch _pylonType do {
                case "none": {
                    for "_i" from 0 to 3 do {
                        [""] call _assignMagazine;
                    };
                };
                case "aux": {
                    ["fza_230gal_auxTank"] call _assignMagazine;
                    for "_i" from 1 to 3 do {
                        [""] call _assignMagazine;
                    };
                };
                case "rocket": {
                    [""] call _assignMagazine;
                    {
                        private _zoneKey = _x;
                        private _ammoName = _pylonInfo getVariable [_zoneKey, ""];
                        if (_ammoName in _nameCheck) then {
                            private _magName = "fza_275_" + _ammoName + "_" + _zoneKey;
                            [_magName] call _assignMagazine;
                        } else {
                            [""] call _assignMagazine;
                        };
                    } forEach _pylonRktCheck;
                };
                case "hellfire": {
                    {
                        private _railKey = _x;
                        private _ammoName = _pylonInfo getVariable [_railKey, ""];
                        _ammoName = [_ammoName] call BIS_fnc_filterString;
                        if (_ammoName in _nameCheck) then {
                            private _magName = "fza_" + _ammoName + "_" + _railKey;
                            [_magName] call _assignMagazine;
                        } else {
                            [""] call _assignMagazine;
                        };
                    } forEach _pylonMslCheck;
                };
                default {
                    for "_i" from 0 to 3 do {
                        [""] call _assignMagazine;
                    };
                };
            };
        } forEach _pylonArraycheck;

        for "_i" from 0 to ((count _targetPylonMagazines) - 1) do {
            if ((_targetPylonMagazines # _i) != ((getPylonMagazines _heli) # _i)) then {
                _configureQueue pushBack _i;
            };
        };

        if (_configureQueue isEqualTo []) exitWith {
            [_heli] call fza_fnc_weaponPylonCheckValid;
        };

        private _timePerPylon = missionNamespace getVariable ["ace_pylons_timePerPylon", 5];
        if !(_timePerPylon isEqualType 0) then {
            _timePerPylon = 5;
        };

        private _searchDistance = missionNamespace getVariable ["ace_pylons_searchDistance", 15];
        if !(_searchDistance isEqualType 0) then {
            _searchDistance = 15;
        };

        private _rearmNewPylons = missionNamespace getVariable ["ace_pylons_rearmNewPylons", false];
        if !(_rearmNewPylons isEqualType true) then {
            _rearmNewPylons = false;
        };

        [_heli, _configureQueue, _targetPylonMagazines, _timePerPylon, _searchDistance, _rearmNewPylons] spawn {
            params ["_heli", "_queue", "_targetPylonMagazines", "_timePerPylon", "_searchDistance", "_rearmNewPylons"];

            {
                private _pylonIndex = _x;
                private _targetMagazine = _targetPylonMagazines select _pylonIndex;
                private _status = [false, false]; // [done, ok]

                private _weaponToRemove = "";
                private _currentPylonMagazine = (getPylonMagazines _heli) select _pylonIndex;
                if (_currentPylonMagazine != "") then {
                    private _allPylonWeapons = (getPylonMagazines _heli) apply {
                        getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon")
                    };
                    private _pylonWeapon = _allPylonWeapons select _pylonIndex;
                    if (({_x == _pylonWeapon} count _allPylonWeapons) == 1) then {
                        _weaponToRemove = _pylonWeapon;
                    };
                };

                [
                    _timePerPylon max 0.1,
                    [_heli, _pylonIndex, _targetMagazine, _status, _rearmNewPylons, _weaponToRemove, _searchDistance],
                    {
                        params [["_args", []]];
                        _args params ["_heli", "_pylonIndex", "_targetMagazine", "_status", "_rearmNewPylons", "_weaponToRemove"];
                        ["ace_pylons_setPylonLoadOutEvent", [_heli, _pylonIndex + 1, _targetMagazine, [], _weaponToRemove]] call CBA_fnc_globalEvent;
                        private _count = if (_rearmNewPylons && {_targetMagazine != ""}) then {
                            getNumber (configFile >> "CfgMagazines" >> _targetMagazine >> "count")
                        } else {
                            0
                        };
                        ["ace_pylons_setAmmoOnPylonEvent", [_heli, _pylonIndex + 1, _count], _heli] call CBA_fnc_targetEvent;
                        _status set [1, true];
                        _status set [0, true];
                    },
                    {
                        params [["_args", []]];
                        _args params ["_heli", "_pylonIndex", "_targetMagazine", "_status"];
                        _status set [1, false];
                        _status set [0, true];
                    },
                    format ["Mission Planner - Replacing Pylon %1/%2", _forEachIndex + 1, count _queue],
                    {
                        params [["_args", []]];
                        _args params ["_heli", "_pylonIndex", "_targetMagazine", "_status", "_rearmNewPylons", "_weaponToRemove", "_searchDistance"];
                        player distanceSqr _heli <= (_searchDistance ^ 2)
                    },
                    ["isNotInside"]
                ] call ace_common_fnc_progressBar;

                waitUntil {uiSleep 0.05; _status # 0};
                if !(_status # 1) exitWith {
                    systemChat format ["Mission Planner: pylon %1 application cancelled.", _pylonIndex + 1];
                };
            } forEach _queue;

            [_heli] call fza_fnc_weaponPylonCheckValid;
            systemChat "Mission Planner: pylon application complete.";
        };
    };

    if (_needsPylons) then {
        call _applyPylons;
    };

    if (_needsCenterStore) then {
        [_heli, _iafsPhase] call fza_fnc_weaponSwapM230Mag;
    };

    if (_needsCannon) then {
        _heli setAmmo ["fza_m230", _targetCannonRds];
    };

    if (_needsFuel) then {
        private _currentFuelRatio = fuel _heli;
        private _deltaRatio = _targetFuelPct - _currentFuelRatio;

        if (_deltaRatio > 0) then {
            // Vanilla fuelCapacity (liters) gives the helicopter tank size ACE uses for source math
            private _heliCapacityL = getNumber (configOf _heli >> "fuelCapacity");
            if (_heliCapacityL <= 0) then {
                _heliCapacityL = _tankCapacityKg * 1.25; // fallback: ~0.8 kg/L Jet-A
            };
            private _requiredLiters = _deltaRatio * _heliCapacityL;

            private _maxRange = missionNamespace getVariable ["ace_refuel_hoseLength", 12];
            if !(_maxRange isEqualType 0) then {_maxRange = 12};

            private _nearby = nearestObjects [
                getPosATL _heli,
                ["AllVehicles", "House", "House_F", "House_Small_F", "Strategic", "ReammoBox_F", "ThingX"],
                _maxRange
            ];

            private _sources = _nearby select {
                private _src = _x;
                _src != _heli
                && {alive _src}
                && {
                    private _capacity = [_src] call ace_refuel_fnc_getCapacity;
                    _capacity == -10 || {_capacity > 0 && {[_src] call ace_refuel_fnc_getFuel > 0}}
                }
            };

            if (_sources isEqualTo []) exitWith {
                systemChat "Mission Planner: no valid ACE fuel source nearby. Refuel aborted.";
            };

            private _source = _sources # 0;
            private _sourceCapacity = [_source] call ace_refuel_fnc_getCapacity;
            private _sourceFuel = [_source] call ace_refuel_fnc_getFuel;

            private _transferLiters = if (_sourceCapacity == -10) then {
                _requiredLiters
            } else {
                _requiredLiters min _sourceFuel
            };

            if (_transferLiters <= 0) exitWith {
                systemChat "Mission Planner: selected ACE source has no fuel available.";
            };

            private _newFuelRatio = _currentFuelRatio + (_transferLiters / _heliCapacityL);
            _heli setFuel (_newFuelRatio min 1);
            [_heli] call fza_sfmplus_fnc_fuelSet;

            if (_sourceCapacity != -10) then {
                [_source, (_sourceFuel - _transferLiters) max 0] call ace_refuel_fnc_setFuel;
            };

            if (_transferLiters < _requiredLiters) then {
                systemChat format ["Mission Planner: refueled %1L (source limited).", round _transferLiters];
            } else {
                systemChat format ["Mission Planner: refueled %1L.", round _transferLiters];
            };
        } else {
            _heli setFuel _targetFuelPct;
            [_heli] call fza_sfmplus_fnc_fuelSet;
        };
    };

    if (_needsFcr) then {
        _heli animateSource ["fcr_enable", _desiredFcrState];
    };

    [_heli] call fza_sfmplus_fnc_massUpdate;
    systemChat "Mission Planner apply complete.";
};

true;
