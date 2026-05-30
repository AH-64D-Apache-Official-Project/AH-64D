params [
    ["_legacyJson", "", [""]],
    ["_cannonRds", -1, [0]],
    ["_desiredFcr", -1, [0]],
    ["_tailNum", "00000", [""]],
    ["_msnEquip", "US", [""]]
];

if (_legacyJson isEqualTo "") exitWith {false};

private _heli = uiNamespace getVariable ["fza_mplanner_target", objNull];
if (isNull _heli || {!(_heli isKindOf "Helicopter")}) then {
    _heli = vehicle player;
};
if (isNull _heli) exitWith {false};
if !(_heli isKindOf "Helicopter") exitWith {false};

[_heli, _legacyJson, _cannonRds, _desiredFcr, _tailNum, _msnEquip] spawn {
    params ["_heli", "_legacyJson", "_cannonRds", "_desiredFcr", "_tailNum", "_msnEquip"];

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
                    ["fza_275_pod"] call _assignMagazine;
                    {
                        private _zoneKey = _x;
                        private _ammoName = _pylonInfo getVariable [_zoneKey, ""];
                        if (_ammoName in _nameCheck) then {
                            private _magName = "fza_275_" + _ammoName + "_" + _zoneKey;
                            [_magName] call _assignMagazine;
                        } else {
                            ["fza_275_pod"] call _assignMagazine;
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
                            ["fza_agm114_rail"] call _assignMagazine;
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

        // Treat empty-structure magazines (count=0 placeholder) as equivalent to ""
        // so we don't trigger unnecessary rearms when only the placeholder differs.
        private _normaliseSlot = {
            params ["_mag"];
            if (_mag isEqualTo "") exitWith { "" };
            private _cnt = getNumber (configFile >> "CfgMagazines" >> _mag >> "count");
            if (_cnt == 0) exitWith { "" };
            _mag
        };
        for "_i" from 0 to ((count _targetPylonMagazines) - 1) do {
            private _desired = [_targetPylonMagazines # _i] call _normaliseSlot;
            private _current = [(getPylonMagazines _heli) # _i] call _normaliseSlot;
            if (_desired != _current) then {
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

        _heli setVariable ["fza_mplanner_rearming", true, true];

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
                        private _count = if (_targetMagazine != "") then {
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

            _heli setVariable ["fza_mplanner_rearming", false, true];
            [_heli] call fza_fnc_weaponPylonCheckValid;
            systemChat "Mission Planner: pylon application complete.";
        };
    };

    // ── STEP 1: CANNON + IAFS (before pylons, direction-aware) ───────────────
    private _aceRearmDelay = missionNamespace getVariable ["ace_rearm_loadTime", 5];
    if !(_aceRearmDelay isEqualType 0) then { _aceRearmDelay = 5 };

    private _currentIafsInstalled = _heli getVariable ["fza_ah64_IAFSInstalled", true];

    if (_needsCenterStore && _iafsInstalled && !_currentIafsInstalled) then {
        // magazine → IAFS: unload cannon first (if loaded), then swap
        if (_curCannonRds > 0) then {
            private _unloadDuration = (_curCannonRds / 50.0) * _aceRearmDelay;
            private _unloadStatus = [false, false];
            [
                _unloadDuration max 0.1,
                [_heli, _curCannonRds, _unloadStatus],
                {
                    params [["_args", []]];
                    _args params ["_heli", "_startRds", "_unloadStatus"];
                    _heli setAmmo ["fza_m230", 0];
                    _unloadStatus set [1, true];
                    _unloadStatus set [0, true];
                },
                {
                    params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                    _args params ["_heli", "_startRds", "_unloadStatus"];
                    private _partial = if (_total > 0) then { _elapsed / _total } else { 0 };
                    _heli setAmmo ["fza_m230", (_startRds * (1 - _partial)) max 0];
                    _unloadStatus set [1, false];
                    _unloadStatus set [0, true];
                },
                "Mission Planner - Unloading Cannon (before IAFS install)",
                {
                    params [["_args", []]];
                    _args params ["_heli"];
                    player distanceSqr _heli <= (15 ^ 2)
                },
                ["isNotInside"]
            ] call ace_common_fnc_progressBar;
            waitUntil { uiSleep 0.1; _unloadStatus # 0 };
        };
        [_heli, _iafsPhase] call fza_fnc_weaponSwapM230Mag;
        _needsCenterStore = false;
    };

    if (_needsCenterStore) then {
        // IAFS → magazine: swap first, then cannon rearm follows below
        [_heli, _iafsPhase] call fza_fnc_weaponSwapM230Mag;
        _needsCenterStore = false;
    };

    if (_needsCannon) then {
        private _postSwapRds = _heli ammo "fza_m230";
        private _cannonDeltaPost = abs (_targetCannonRds - _postSwapRds);
        if (_cannonDeltaPost > 0) then {
            private _cannonDuration = (_cannonDeltaPost / 50.0) * _aceRearmDelay;
            private _cannonStatus = [false, false];
            [
                _cannonDuration,
                [_heli, _postSwapRds, _targetCannonRds, _cannonStatus],
                {
                    params [["_args", []]];
                    _args params ["_heli", "_startRds", "_targetRds", "_cannonStatus"];
                    _heli setAmmo ["fza_m230", _targetRds];
                    systemChat format ["Mission Planner: cannon at %1 rds.", _targetRds];
                    _cannonStatus set [1, true];
                    _cannonStatus set [0, true];
                },
                {
                    params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                    _args params ["_heli", "_startRds", "_targetRds", "_cannonStatus"];
                    private _partial = if (_total > 0) then { _elapsed / _total } else { 0 };
                    private _actualRds = _startRds + round ((_targetRds - _startRds) * _partial);
                    _heli setAmmo ["fza_m230", _actualRds max 0];
                    systemChat format ["Mission Planner: cannon partial load %1 rds (cancelled).", _actualRds max 0];
                    _cannonStatus set [1, false];
                    _cannonStatus set [0, true];
                },
                format ["Mission Planner - %1 Cannon (%2%3 rds)", (["Unloading","Loading"] select (_targetCannonRds > _postSwapRds)), (["-","+"] select (_targetCannonRds > _postSwapRds)), _cannonDeltaPost],
                {
                    params [["_args", []]];
                    _args params ["_heli"];
                    player distanceSqr _heli <= (15 ^ 2)
                },
                ["isNotInside"]
            ] call ace_common_fnc_progressBar;
            waitUntil { uiSleep 0.1; _cannonStatus # 0 };
        };
    };

    // ── STEP 2: PYLONS ───────────────────────────────────────────────────────
    private _prevPylonMags = getPylonMagazines _heli;
    private _prevCannonRds = _heli ammo "fza_m230";

    if (_needsPylons) then {
        call _applyPylons;
    };

    waitUntil { uiSleep 0.1; !(_heli getVariable ["fza_mplanner_rearming", false]) };

    // ── STEP 3: AMMO TRACKING ────────────────────────────────────────────────
    private _ammoTrackKeys = ["AGM114K","AGM114L","AGM114K2A","AGM114FA","AGM114N","M151","M261","M255A1","M257","M278","M230"];
    private _ammoTrackPrefixMap = [
        ["fza_agm114k_",    "AGM114K"],
        ["fza_agm114l_",    "AGM114L"],
        ["fza_agm114k2a_",  "AGM114K2A"],
        ["fza_agm114fa_",   "AGM114FA"],
        ["fza_agm114n_",    "AGM114N"],
        ["fza_275_m151_",   "M151"],
        ["fza_275_m261_",   "M261"],
        ["fza_275_m255a1_", "M255A1"],
        ["fza_275_m257_",   "M257"],
        ["fza_275_m278_",   "M278"]
    ];
    private _getMagKey = {
        params ["_mag"];
        private _result = "";
        private _magLower = toLower _mag;
        { if (_magLower find (_x # 0) == 0) exitWith { _result = _x # 1; }; } forEach _ammoTrackPrefixMap;
        _result
    };
    private _countMagAmmo = {
        params ["_mags"];
        private _counts = _ammoTrackKeys apply {0};
        {
            private _mag = _x;
            if (_mag isNotEqualTo "") then {
                private _cnt = getNumber (configFile >> "CfgMagazines" >> _mag >> "count");
                if (_cnt > 0) then {
                    private _key = [_mag] call _getMagKey;
                    if (_key isNotEqualTo "") then {
                        private _idx = _ammoTrackKeys find _key;
                        if (_idx >= 0) then {
                            _counts set [_idx, (_counts # _idx) + _cnt];
                        };
                    };
                };
            };
        } forEach _mags;
        _counts
    };
    private _prevAmmo = [_prevPylonMags] call _countMagAmmo;
    _prevAmmo set [_ammoTrackKeys find "M230", _prevCannonRds];
    private _newAmmo = [getPylonMagazines _heli] call _countMagAmmo;
    _newAmmo set [_ammoTrackKeys find "M230", _heli ammo "fza_m230"];
    {
        private _delta = (_newAmmo # _forEachIndex) - (_prevAmmo # _forEachIndex);
        if (_delta != 0) then {
            private _varName = "fza_mplanner_ammo_" + (_ammoTrackKeys # _forEachIndex);
            private _supply = missionNamespace getVariable [_varName, -1];
            if (_supply >= 0) then {
                missionNamespace setVariable [_varName, (_supply - _delta) max 0, true];
            };
        };
    } forEach _ammoTrackKeys;

    // ── STEP 4: FUEL ─────────────────────────────────────────────────────────
    if (_needsFuel) then {
        private _currentFuelRatio = fuel _heli;
        private _deltaRatio = _targetFuelPct - _currentFuelRatio;

        if (_deltaRatio > 0) then {
            // Use SFM+ mass delta converted to liters (Jet-A density ~0.8 kg/L)
            private _requiredLiters = _fuelDeltaKg / 0.8;

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

            // ACE refuel rate in L/s; mission override → ace_refuel_rate → 1
            private _aceRefuelRate = if (isNil "ace_refuel_rate") then {1} else {ace_refuel_rate};
            if !(_aceRefuelRate isEqualType 0 && {_aceRefuelRate > 0}) then { _aceRefuelRate = 1 };
            private _fuelRateL = missionNamespace getVariable ["fza_mplanner_fuelRate", _aceRefuelRate];
            if !(_fuelRateL isEqualType 0 && {_fuelRateL > 0}) then { _fuelRateL = _aceRefuelRate };
            private _fuelDuration = _transferLiters / _fuelRateL;

            // Proportion of requested fuel that can actually be transferred
            private _transferFraction = _transferLiters / (_requiredLiters max 0.001);
            private _actualTargetRatio = (_currentFuelRatio + ((_targetFuelPct - _currentFuelRatio) * _transferFraction)) min 1;

            private _status = [false, false];
            [
                _fuelDuration max 0.5,
                [_heli, _currentFuelRatio, _actualTargetRatio, _source, _sourceFuel, _sourceCapacity, _transferLiters, _status],
                {
                    params [["_args", []]];
                    _args params ["_heli", "_curRatio", "_targetRatio", "_source", "_srcFuel", "_srcCap", "_litres", "_status"];
                    _heli setFuel _targetRatio;
                    [_heli] call fza_sfmplus_fnc_fuelSet;
                    if (_srcCap != -10) then {
                        [_source, (_srcFuel - _litres) max 0] call ace_refuel_fnc_setFuel;
                    };
                    systemChat format ["Mission Planner: refueled %1 L.", round _litres];
                    _status set [1, true];
                    _status set [0, true];
                },
                {
                    params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                    _args params ["_heli", "_curRatio", "_targetRatio", "_source", "_srcFuel", "_srcCap", "_litres", "_status"];
                    private _partial = if (_total > 0) then { _elapsed / _total } else { 0 };
                    private _partialRatio = (_curRatio + ((_targetRatio - _curRatio) * _partial)) min 1;
                    private _partialLitres = _litres * _partial;
                    if (_partial > 0.01) then {
                        _heli setFuel _partialRatio;
                        [_heli] call fza_sfmplus_fnc_fuelSet;
                        if (_srcCap != -10) then {
                            [_source, (_srcFuel - _partialLitres) max 0] call ace_refuel_fnc_setFuel;
                        };
                        systemChat format ["Mission Planner: partial refuel %1 L (cancelled).", round _partialLitres];
                    };
                    _status set [1, false];
                    _status set [0, true];
                },
                format ["Mission Planner - Refueling (%1 L)", round _transferLiters],
                {
                    params [["_args", []]];
                    _args params ["_heli"];
                    player distanceSqr _heli <= (15 ^ 2)
                },
                ["isNotInside"]
            ] call ace_common_fnc_progressBar;

            waitUntil {uiSleep 0.1; _status # 0};
        } else {
            _heli setFuel _targetFuelPct;
            [_heli] call fza_sfmplus_fnc_fuelSet;
        };
    };

    // ── STEP 5: FCR (300s) ───────────────────────────────────────────────────
    if (_needsFcr) then {
        private _fcrStatus = [false, false];
        [
            300,
            [_heli, _desiredFcrState, _fcrStatus],
            {
                params [["_args", []]];
                _args params ["_heli", "_fcrState", "_fcrStatus"];
                _heli animateSource ["fcr_enable", _fcrState];
                _fcrStatus set [1, true];
                _fcrStatus set [0, true];
            },
            {
                params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                _args params ["_heli", "_fcrState", "_fcrStatus"];
                _heli animateSource ["fcr_enable", _fcrState];
                _fcrStatus set [1, false];
                _fcrStatus set [0, true];
            },
            format ["Mission Planner - %1 FCR", (["Uninstalling", "Installing"] select _desiredFcrState)],
            {
                params [["_args", []]];
                _args params ["_heli"];
                player distanceSqr _heli <= (15 ^ 2)
            },
            ["isNotInside"]
        ] call ace_common_fnc_progressBar;
        waitUntil { uiSleep 0.1; _fcrStatus # 0 };
    };

    // ── STEP 6: MASS UPDATE ──────────────────────────────────────────────────
    [_heli] call fza_sfmplus_fnc_massUpdate;

    // ── STEP 7: MSN EQUIP (30s progress bar) ────────────────────────────────
    private _isUK = _msnEquip isEqualTo "UK";
    private _isUS = _msnEquip isEqualTo "US";
    private _curIsUK = (_heli animationPhase "msn_equip_british")  > 0.5;
    private _curIsUS = (_heli animationPhase "msn_equip_american") > 0.5;
    if ((_isUK != _curIsUK) || (_isUS != _curIsUS)) then {
        private _msnStatus = [false, false];
        [
            30,
            [_heli, _isUK, _isUS, _msnStatus],
            {
                params [["_args", []]];
                _args params ["_heli", "_isUK", "_isUS", "_msnStatus"];
                _heli animateSource ["msn_equip_american", [0, 1] select _isUS, true];
                _heli animateSource ["msn_equip_british",  [0, 1] select _isUK, true];
                _msnStatus set [1, true];
                _msnStatus set [0, true];
            },
            {
                params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                _args params ["_heli", "_isUK", "_isUS", "_msnStatus"];
                _msnStatus set [1, false];
                _msnStatus set [0, true];
            },
            format ["Mission Planner - Fitting MSN Equipment (%1)", _msnEquip],
            {
                params [["_args", []]];
                _args params ["_heli"];
                player distanceSqr _heli <= (15 ^ 2)
            },
            ["isNotInside"]
        ] call ace_common_fnc_progressBar;
        waitUntil { uiSleep 0.1; _msnStatus # 0 };
    } else {
        _heli animateSource ["msn_equip_american", [0, 1] select _isUS, true];
        _heli animateSource ["msn_equip_british",  [0, 1] select _isUK, true];
    };

    // ── STEP 8: TAIL NUMBER (10s progress bar) ───────────────────────────────
    if (_tailNum isNotEqualTo "") then {
        private _currentTailNum = _heli getVariable ["fza_ah64_tailNumber", ""];
        if (_tailNum isNotEqualTo _currentTailNum) then {
            private _tailStatus = [false, false];
            [
                10,
                [_heli, _tailNum, _tailStatus],
                {
                    params [["_args", []]];
                    _args params ["_heli", "_tailNum", "_tailStatus"];
                    [_heli, _tailNum] call fza_customise_fnc_setTailNumber;
                    _heli setVariable ["fza_ah64_tailNumber", _tailNum, true];
                    _tailStatus set [1, true];
                    _tailStatus set [0, true];
                },
                {
                    params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                    _args params ["_heli", "_tailNum", "_tailStatus"];
                    _tailStatus set [1, false];
                    _tailStatus set [0, true];
                },
                "Mission Planner - Painting Tail Number",
                {
                    params [["_args", []]];
                    _args params ["_heli"];
                    player distanceSqr _heli <= (15 ^ 2)
                },
                ["isNotInside"]
            ] call ace_common_fnc_progressBar;
            waitUntil { uiSleep 0.1; _tailStatus # 0 };
        } else {
            [_heli, _tailNum] call fza_customise_fnc_setTailNumber;
            _heli setVariable ["fza_ah64_tailNumber", _tailNum, true];
        };
    };

    systemChat "Mission Planner apply complete.";
};

true;
