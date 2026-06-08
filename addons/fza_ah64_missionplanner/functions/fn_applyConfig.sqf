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

    // 0=Instant, 1=30 Seconds (default), 2=ACE Settings
    private _rearmMode = if (!isNil "fza_mplanner_rearmMode") then { fza_mplanner_rearmMode } else { 1 };
    if !(_rearmMode isEqualType 0) then { _rearmMode = 1 };
    _rearmMode = _rearmMode max 0 min 2;

    private _noAmmoSourceRequired = if (!isNil "fza_mplanner_noAmmoSourceRequired") then { fza_mplanner_noAmmoSourceRequired } else { true };
    if !(_noAmmoSourceRequired isEqualType true) then { _noAmmoSourceRequired = true };

    private _noFuelSourceRequired = if (!isNil "fza_mplanner_noFuelSourceRequired") then { fza_mplanner_noFuelSourceRequired } else { true };
    if !(_noFuelSourceRequired isEqualType true) then { _noFuelSourceRequired = true };

    private _nameCheck = ["M151", "m255a1", "M257", "M261", "M278", "AGM114FA", "AGM114k", "AGM114K2A", "AGM114L", "AGM114N"];
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
    // ACE rearm supply mode (0=unlimited, 1=caliber pool, 2=magazine-inventory)
    private _supplyMode = missionNamespace getVariable ["ace_rearm_supply", 0];
    if !(_supplyMode isEqualType 0) then { _supplyMode = 0 };
    _supplyMode = _supplyMode max 0 min 2;

    // Supply cost (caliber pts) of a magazine class; 0 = no cost / not tracked
    private _fnMagCaliberCost = {
        params ["_magClass"];
        if (_magClass isEqualTo "") exitWith { 0 };
        if (_magClass isEqualTo "fza_230gal_auxTank") exitWith { 50 };
        private _count = getNumber (configFile >> "CfgMagazines" >> _magClass >> "count");
        if (_count == 0) exitWith { 0 };
        private _ammo = getText (configFile >> "CfgMagazines" >> _magClass >> "ammo");
        if (_ammo isEqualTo "") exitWith { 0 };
        private _cal = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ace_caliber");
        if (_cal <= 0) then { _cal = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_caliber"); };
        if (_cal == 20) exitWith { _count * 5 }; // rocket pod: charge per round at 5 pts each
        if (_cal == 100) exitWith { 50 };           // hellfire: half the ACE default rate
        _cal
    };

    // Find the nearest ACE supply truck (source vehicle for caliber deduction)
    private _fnFindSupplyTruck = {
        private _truckSearchDist = missionNamespace getVariable ["ace_pylons_searchDistance", 15];
        if !(_truckSearchDist isEqualType 0) then { _truckSearchDist = 15 };
        private _nearby = nearestObjects [getPosATL _heli, ["AllVehicles"], _truckSearchDist];
        private _found = objNull;
        {
            if (_x == _heli || {!alive _x}) then {continue};
            private _isSource = _x getVariable ["ace_rearm_isSupplyVehicle", false];
            if !(_isSource) then {
                _isSource = getNumber (configOf _x >> "ace_rearm_defaultSupply") > 0;
            };
            if (_isSource) exitWith { _found = _x; };
        } forEach _nearby;
        _found
    };

    // Mirrors ACE's ace_rearm_fnc_getSupplyCount: the currentSupply variable is only set on
    // the truck after the first ACE manual rearm. Until then, fall back to the config value
    // (ace_rearm_defaultSupply), then 1200. Returning 0 means the truck has no supply.
    private _fnGetTruckSupply = {
        params ["_truck"];
        private _supply = _truck getVariable ["ace_rearm_currentSupply", -1];
        if (_supply < 0) then {
            if (isNumber (configOf _truck >> "ace_rearm_defaultSupply")) then {
                _supply = getNumber (configOf _truck >> "ace_rearm_defaultSupply");
            } else {
                _supply = 1200;
            };
        };
        _supply max 0
    };

    // Read once here so post-loop deduction can also access it (private inside _applyPylons
    // would be out of scope after call returns)
    private _rearmNewPylons = missionNamespace getVariable ["ace_pylons_rearmNewPylons", false];
    if !(_rearmNewPylons isEqualType true) then { _rearmNewPylons = false; };

    // Caliber cost per 50-round cannon batch (ACE_caliber from CfgAmmo)
    private _cannonCaliberCost = round (getNumber (configFile >> "CfgAmmo" >> "fza_30x113" >> "ACE_caliber"));
    if (_cannonCaliberCost <= 0) then { _cannonCaliberCost = 30 };

    // In rearmNewPylons=false mode only allow unloading cannon; loading is left to ACE manual rearm
    if (!_rearmNewPylons && _targetCannonRds > _curCannonRds) then {
        _targetCannonRds = _curCannonRds;
        _needsCannon = false;
    };

    private _applyPylons = {
        private _targetPylonMagazines = +getPylonMagazines _heli;
        private _targetPylonAmmos = _targetPylonMagazines apply { -1 };
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
            private _assignMagazineCount = {
                params ["_magazineName", "_ammoCount"];
                _targetPylonMagazines set [_magazineIndex - 1, _magazineName];
                _targetPylonAmmos set [_magazineIndex - 1, _ammoCount];
                _magazineIndex = _magazineIndex - 1;
            };

            switch _pylonType do {
                case "none": {
                    for "_i" from 0 to 3 do {
                        [""] call _assignMagazine;
                    };
                };
                case "aux": {
                    // fza_railzone hardpoint (required for aux tank) only exists on the
                    // first sub-slot of each 4-slot pylon group (e.g. pylons1/5/9/13).
                    // _assignMagazine fills from the highest index downward, so the aux
                    // tank must be assigned LAST to land in that first (lowest-index) sub-slot.
                    for "_i" from 0 to 2 do {
                        [""] call _assignMagazine;
                    };
                    ["fza_230gal_auxTank"] call _assignMagazine;
                };
                case "rocket": {
                    ["fza_275_pod"] call _assignMagazine;
                    {
                        private _zoneKey = _x;
                        private _ammoName = _pylonInfo getVariable [_zoneKey, ""];
                        private _zoneCount = _pylonInfo getVariable [_zoneKey + "Count", -1];
                        if (_ammoName in _nameCheck) then {
                            private _magName = toLower ("fza_275_" + _ammoName + "_" + _zoneKey);
                            [_magName, _zoneCount] call _assignMagazineCount;
                        } else {
                            ["fza_275_pod"] call _assignMagazine;
                        };
                    } forEach _pylonRktCheck;
                };
                case "hellfire": {
                    {
                        private _railKey = _x;
                        private _ammoName = _pylonInfo getVariable [_railKey, ""];
                        if (_ammoName in _nameCheck) then {
                            private _magName = toLower ("fza_" + _ammoName + "_" + _railKey);
                            [_magName] call _assignMagazine;
                        } else {
                            // ul is the primary slot: fza_agm114_rail (fza_pylonType="hellfire",
                            // count=0) marks the pylon as hellfire so weaponPylonCheckValid does
                            // not clear it when other rails are loaded. Non-primary empty slots
                            // can be "" — only the primary slot is checked for pylon type.
                            [["", "fza_agm114_rail"] select (_railKey isEqualTo "ul")] call _assignMagazine;
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

        // Collapse count=0 structural pod placeholders to "" so unchanged rocket pylons
        // don't get re-queued. fza_agm114_rail is intentionally excluded: it must be
        // explicitly loaded on every empty hellfire rail slot so the pylon passes
        // fza_fnc_weaponPylonCheckValid (which clears any pylon with a raw "" slot).
        private _normaliseSlot = {
            params ["_mag"];
            if (_mag isEqualTo "" || {_mag isEqualTo "fza_agm114_rail"}) exitWith { _mag };
            private _cnt = getNumber (configFile >> "CfgMagazines" >> _mag >> "count");
            if (_cnt == 0) exitWith { "" };
            toLower _mag
        };
        private _currentPylonMags = getPylonMagazines _heli;
        for "_i" from 0 to ((count _targetPylonMagazines) - 1) do {
            private _desired = [_targetPylonMagazines # _i] call _normaliseSlot;
            private _current = [_currentPylonMags # _i] call _normaliseSlot;
            private _currentAmmo = _heli ammoOnPylon (_i + 1);
            private _desiredAmmoHint = _targetPylonAmmos # _i;
            // Queue if classname changed, slot was fired, or user-specified ammo count differs
            if (_desired != _current
                || {_desired != "" && {_desired != "fza_agm114_rail"} && {_currentAmmo == 0}}
                || {_desired != "" && {_desired != "fza_agm114_rail"} && {_desiredAmmoHint >= 0} && {_currentAmmo != _desiredAmmoHint}}
            ) then {
                _configureQueue pushBack _i;
            };
        };

        // Recycle-source slots (those replacing an existing magazine) must run before
        // pure new-load slots. This ensures refund credits are banked in the truck
        // before new items are charged, so a cancel mid-rearm cannot leave a player
        // with both the original magazines and the newly loaded ones.
        private _recycleSlots = [];
        private _newLoadSlots = [];
        {
            if (_currentPylonMags select _x != "") then {
                _recycleSlots pushBack _x;
            } else {
                _newLoadSlots pushBack _x;
            };
        } forEach _configureQueue;
        _configureQueue = _recycleSlots + _newLoadSlots;

        if (_configureQueue isEqualTo []) exitWith {
            [_heli] call fza_fnc_weaponPylonCheckValid;
        };

        private _targetMagCosts = _targetPylonMagazines apply { ([_x] call _fnMagCaliberCost) max 0 };
        private _currentMagCosts = _currentPylonMags apply { ([_x] call _fnMagCaliberCost) max 0 };

        // ── SUPPLY PRE-CHECK: trim pylon queue to what we can afford ─────────
        // Runs before spawning the progress-bar loop so we never start a pylon
        // rearm that would exceed the available caliber pool.
        if (_rearmNewPylons && { _supplyMode == 1 } && { !(!isNil "fza_mplanner_noAmmoSourceRequired" && { fza_mplanner_noAmmoSourceRequired }) }) then {
            private _truck = call _fnFindSupplyTruck;
            if (!isNull _truck) then {
                private _available = [_truck] call _fnGetTruckSupply;
                // Reserve points already committed by cannon loading in STEP 1
                private _cannonLoadRds = (_targetCannonRds - _curCannonRds) max 0;
                private _cannonReserve = ceil (_cannonLoadRds / 50) * _cannonCaliberCost;
                private _budget = (_available - _cannonReserve) max 0;
                // Pre-credit recycled magazines so in-place swaps (e.g. hellfires→rockets)
                // don't exhaust the budget before reaching the slots being replaced.
                {
                    _budget = _budget + (_currentMagCosts select _x);
                } forEach _configureQueue;
                private _trimmedQueue = [];
                {
                    private _cost = _targetMagCosts select _x;
                    if (_budget >= _cost || { _cost == 0 }) then {
                        _trimmedQueue pushBack _x;
                        _budget = _budget - _cost;
                    } else {
                        systemChat format ["Mission Planner: skipping pylon %1 - needs %2 pts, only %3 remain.", _x + 1, _cost, _budget];
                    };
                } forEach _configureQueue;
                _configureQueue = _trimmedQueue;
            };
        };

        // If ace_pylons_enabledfromammotrucks is set, pylon changes require a supply truck nearby.
        private _pylonsNeedTruck = missionNamespace getVariable ["ace_pylons_enabledfromammotrucks", false];
        if !(_pylonsNeedTruck isEqualType true) then { _pylonsNeedTruck = false; };
        private _noAmmoSrcNow = !isNil "fza_mplanner_noAmmoSourceRequired" && { fza_mplanner_noAmmoSourceRequired };
        if (_pylonsNeedTruck && (_configureQueue isNotEqualTo []) && { !_noAmmoSrcNow }) then {
            private _pylonTruck = call _fnFindSupplyTruck;
            if (isNull _pylonTruck) then {
                systemChat "Mission Planner: pylon changes require an ammo truck nearby (ace_pylons_enabledfromammotrucks). Pylon changes skipped.";
                _configureQueue = [];
            };
        };

        // _rearmMode and _mode1TimePerOp accessible via call (shared scope).
        private _rearmModeNow = _rearmMode;
        // Mode 0: instant. Mode 1: each slot gets its proportional share of the 30s budget.
        // Mode 2 (ACE Settings): use ACE's configured time per pylon.
        private _timePerPylon = switch (_rearmModeNow max 0 min 2) do {
            case 0: { 0 };
            case 1: { _mode1TimePerOp };
            default {
                private _t = missionNamespace getVariable ["ace_pylons_timePerPylon", 5];
                if !(_t isEqualType 0) then { _t = 5 };
                _t
            };
        };

        private _searchDistance = missionNamespace getVariable ["ace_pylons_searchDistance", 15];
        if !(_searchDistance isEqualType 0) then {
            _searchDistance = 15;
        };

        _heli setVariable ["fza_mplanner_rearming", true, true];

        [_heli, _configureQueue, _targetPylonMagazines, _targetPylonAmmos, _timePerPylon, _searchDistance, _rearmNewPylons, _supplyMode, _fnMagCaliberCost, _fnFindSupplyTruck, _fnGetTruckSupply, _currentPylonMags, _targetMagCosts, _currentMagCosts, _noAmmoSrcNow, _rearmModeNow] spawn {
            params ["_heli", "_queue", "_targetPylonMagazines", "_targetPylonAmmos", "_timePerPylon", "_searchDistance", "_rearmNewPylons", "_supplyMode", "_fnMagCaliberCost", "_fnFindSupplyTruck", "_fnGetTruckSupply", "_currentPylonMags", "_targetMagCosts", "_currentMagCosts", "_noAmmoSrcNow", "_rearmModeNow"];

            private _allPylonWeapons = _currentPylonMags apply { getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon") };
            private _supplyTruck = if (_rearmNewPylons && { _supplyMode == 1 } && { !_noAmmoSrcNow }) then { call _fnFindSupplyTruck } else { objNull };
            {
                private _pylonIndex = _x;
                private _targetMagazine = _targetPylonMagazines select _pylonIndex;
                private _status = [false, false]; // [done, ok]

                private _weaponToRemove = "";
                private _currentPylonMagazine = _currentPylonMags select _pylonIndex;
                private _currentPylonAmmo = _heli ammoOnPylon (_pylonIndex + 1);
                if (_currentPylonMagazine != "") then {
                    private _pylonWeapon = _allPylonWeapons select _pylonIndex;
                    if (({_x == _pylonWeapon} count _allPylonWeapons) == 1) then {
                        _weaponToRemove = _pylonWeapon;
                    };
                };

                private _desiredCount = _targetPylonAmmos select _pylonIndex;
                // Mode 0: instant. Mode 1: flat proportional share (_timePerPylon = _mode1TimePerOp).
                // Mode 2 (ACE Settings): rocket zones use 1s/rocket scaled by ace_pylons_timePerPylon/5.
                private _slotDuration = if (_rearmModeNow == 0) then {
                    0.01
                } else {
                    if (_rearmModeNow == 1) then {
                        _timePerPylon max 0.01
                    } else {
                        if (_desiredCount >= 0) then {
                            private _rktBase = missionNamespace getVariable ["ace_pylons_timePerPylon", 5];
                            if !(_rktBase isEqualType 0) then { _rktBase = 5 };
                            private _curAmmo = _heli ammoOnPylon (_pylonIndex + 1);
                            ((abs (_desiredCount - _curAmmo)) * ((_rktBase / 5) max 0.1)) max 0.1
                        } else {
                            _timePerPylon max 0.1
                        }
                    }
                };
                // Re-check truck before each slot — exits forEach if it moved out of range
                if (_rearmNewPylons && { _supplyMode == 1 } && { !_noAmmoSrcNow }) then {
                    _supplyTruck = call _fnFindSupplyTruck;
                };
                if (_rearmNewPylons && { _supplyMode == 1 } && { !_noAmmoSrcNow } && { isNull _supplyTruck }) exitWith {
                    systemChat format ["Mission Planner: supply truck out of range — rearm aborted at pylon %1.", _pylonIndex + 1];
                };
                [
                    _slotDuration,
                    [_heli, _pylonIndex, _targetMagazine, _status, _rearmNewPylons, _weaponToRemove, _searchDistance, _desiredCount],
                    {
                        params [["_args", []]];
                        _args params ["_heli", "_pylonIndex", "_targetMagazine", "_status", "_rearmNewPylons", "_weaponToRemove", "_searchDistance", "_desiredCount"];
                        ["ace_pylons_setPylonLoadOutEvent", [_heli, _pylonIndex + 1, _targetMagazine, [], _weaponToRemove]] call CBA_fnc_globalEvent;
                        private _count = if (_rearmNewPylons && {_targetMagazine != ""}) then {
                            if (_desiredCount >= 0) then { _desiredCount } else {
                                getNumber (configFile >> "CfgMagazines" >> _targetMagazine >> "count")
                            }
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
                        (vehicle player == _heli) || {player distanceSqr _heli <= (_searchDistance ^ 2)}
                    },
                    ["isNotInside"]
                ] call ace_common_fnc_progressBar;

                waitUntil {uiSleep 0.05; _status # 0};
                if !(_status # 1) exitWith {
                    systemChat format ["Mission Planner: pylon %1 application cancelled.", _pylonIndex + 1];
                };

                // Deduct immediately after each successful slot so a disconnect cannot
                // leave a player holding both the recycled source magazines and the newly
                // loaded ones without paying for them.
                if (_rearmNewPylons && { _supplyMode == 1 } && { !_noAmmoSrcNow }) then {
                    private _slotCost = if (_targetMagazine != _currentPylonMagazine) then {
                        (_targetMagCosts select _pylonIndex) - (_currentMagCosts select _pylonIndex)
                    } else {
                        // Same classname: charge only if it was fired (ammo=0 before apply)
                        if (_currentPylonAmmo == 0 && { _targetMagazine != "" }) then {
                            _targetMagCosts select _pylonIndex
                        } else { 0 }
                    };
                    if (_slotCost != 0 && { !isNull _supplyTruck }) then {
                        private _curSupply = [_supplyTruck] call _fnGetTruckSupply;
                        _supplyTruck setVariable ["ace_rearm_currentSupply", (_curSupply - _slotCost) max 0, true];
                    };
                };
            } forEach _queue;

            _heli setVariable ["fza_mplanner_rearming", false, true];
            [_heli] call fza_fnc_weaponPylonCheckValid;
            systemChat "Mission Planner: pylon application complete.";
        };
    };

    // ── PRE-COUNT: estimate total operation count for mode-1 time distribution ─
    // Each distinct operation (pylon slot, cannon, FCR, IAFS, MSN, tail, fuel) counts as 1.
    // 30 seconds is divided evenly so the full config change completes in ~30s total.
    private _mode1TimePerOp = 0;
    if (_rearmMode == 1) then {
        private _preCount = 0;
        if (_needsFcr) then { _preCount = _preCount + 1 };
        if (_needsCenterStore) then { _preCount = _preCount + 1 };
        if (_needsCannon) then { _preCount = _preCount + 1 };
        if (_needsFuel) then { _preCount = _preCount + 1 };
        private _preIsUK = _msnEquip isEqualTo "UK";
        private _preIsUS = _msnEquip isEqualTo "US";
        if ((_preIsUK != ((_heli animationPhase "msn_equip_british") > 0.5)) || (_preIsUS != ((_heli animationPhase "msn_equip_american") > 0.5))) then {
            _preCount = _preCount + 1
        };
        if (_tailNum isNotEqualTo "" && {_tailNum isNotEqualTo (_heli getVariable ["fza_ah64_tailNumber", ""])}) then {
            _preCount = _preCount + 1
        };
        // Pylon slot count: mirror _applyPylons queue-building logic
        private _qCurMags = getPylonMagazines _heli;
        private _qTgtMags = +_qCurMags;
        private _qTgtAmmos = _qTgtMags apply { -1 };
        private _qIdx = 16;
        {
            private _pKey = _x;
            private _pInfo = _settings getVariable [_pKey, [] call CBA_fnc_createNamespace];
            switch (_pInfo getVariable ["type", "none"]) do {
                case "none": { for "_s" from 0 to 3 do { _qTgtMags set [_qIdx - 1, ""]; _qIdx = _qIdx - 1 }; };
                case "aux": {
                    for "_s" from 0 to 2 do { _qTgtMags set [_qIdx - 1, ""]; _qIdx = _qIdx - 1 };
                    _qTgtMags set [_qIdx - 1, "fza_230gal_auxTank"]; _qIdx = _qIdx - 1;
                };
                case "rocket": {
                    _qTgtMags set [_qIdx - 1, "fza_275_pod"]; _qIdx = _qIdx - 1;
                    {
                        private _zKey = _x;
                        private _zA = _pInfo getVariable [_zKey, ""];
                        private _zC = _pInfo getVariable [_zKey + "Count", -1];
                        if (_zA in _nameCheck) then {
                            _qTgtMags set [_qIdx - 1, toLower ("fza_275_" + _zA + "_" + _zKey)];
                            _qTgtAmmos set [_qIdx - 1, _zC];
                        } else {
                            _qTgtMags set [_qIdx - 1, "fza_275_pod"];
                        };
                        _qIdx = _qIdx - 1;
                    } forEach _pylonRktCheck;
                };
                case "hellfire": {
                    {
                        private _rKey = _x;
                        private _rA = _pInfo getVariable [_rKey, ""];
                        _qTgtMags set [_qIdx - 1, if (_rA in _nameCheck) then {toLower ("fza_" + _rA + "_" + _rKey)} else {["", "fza_agm114_rail"] select (_rKey isEqualTo "ul")}];
                        _qIdx = _qIdx - 1;
                    } forEach _pylonMslCheck;
                };
                default { for "_s" from 0 to 3 do { _qTgtMags set [_qIdx - 1, ""]; _qIdx = _qIdx - 1 }; };
            };
        } forEach _pylonArraycheck;
        private _qNorm = {
            params ["_m"];
            if (_m isEqualTo "" || {_m isEqualTo "fza_agm114_rail"}) exitWith { _m };
            if (getNumber (configFile >> "CfgMagazines" >> _m >> "count") == 0) exitWith { "" };
            toLower _m
        };
        for "_qi" from 0 to ((count _qTgtMags) - 1) do {
            private _qD = [_qTgtMags # _qi] call _qNorm;
            private _qC = [_qCurMags # _qi] call _qNorm;
            private _qA = _heli ammoOnPylon (_qi + 1);
            private _qDH = _qTgtAmmos # _qi;
            if (_qD != _qC
                || {_qD != "" && {_qD != "fza_agm114_rail"} && {_qA == 0}}
                || {_qD != "" && {_qD != "fza_agm114_rail"} && {_qDH >= 0} && {_qA != _qDH}}
            ) then {
                _preCount = _preCount + 1;
            };
        };
        _mode1TimePerOp = 30 / (_preCount max 1);
    };

    // ── FCR PRE-REMOVAL (before pylons so refund is in pool for pylon budget) ──
    // FCR installation is deferred to STEP 5; only removal runs here.
    if (_needsFcr && _desiredFcrState == 0) then {
        private _fcrPreDuration = if (_rearmMode == 0) then { 0.01 } else { if (_rearmMode == 1) then { _mode1TimePerOp max 0.01 } else { 300 } };
        private _fcrPreStatus = [false, false];
        [
            _fcrPreDuration,
            [_heli, _currentFcrState, _fcrPreStatus],
            {
                params [["_args", []]];
                _args params ["_heli", "_origFcrState", "_fcrPreStatus"];
                _heli animateSource ["fcr_enable", 0];
                _fcrPreStatus set [1, true]; _fcrPreStatus set [0, true];
            },
            {
                params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                _args params ["_heli", "_origFcrState", "_fcrPreStatus"];
                _heli animateSource ["fcr_enable", _origFcrState];
                _fcrPreStatus set [1, false]; _fcrPreStatus set [0, true];
            },
            "Mission Planner - Uninstalling FCR",
            {
                params [["_args", []]];
                _args params ["_heli"];
                (vehicle player == _heli) || {player distanceSqr _heli <= (15 ^ 2)}
            },
            ["isNotInside"]
        ] call ace_common_fnc_progressBar;
        waitUntil { uiSleep 0.1; _fcrPreStatus # 0 };
        if !(_fcrPreStatus # 1) exitWith {
            systemChat "Mission Planner: FCR uninstall cancelled.";
        };
        // Refund 100 pts — points are now available for the pylon pre-check below
        if (_supplyMode == 1 && { !_noAmmoSourceRequired }) then {
            private _fcrRefundTruck = call _fnFindSupplyTruck;
            if (!isNull _fcrRefundTruck) then {
                _fcrRefundTruck setVariable ["ace_rearm_currentSupply", ([_fcrRefundTruck] call _fnGetTruckSupply) + 100, true];
            };
        };
        _needsFcr = false;
    };

    // ── STEP 1: CANNON + IAFS (before pylons, direction-aware) ───────────────
    private _aceRearmDelay = switch _rearmMode do {
        case 0: { 0 };
        case 1: { 0 }; // cannon uses _mode1TimePerOp duration directly (see _cannonDuration override below)
        default {
            private _d = missionNamespace getVariable ["ace_rearm_loadTime", 5];
            if !(_d isEqualType 0) then { _d = 5 };
            _d
        };
    };

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
                    (vehicle player == _heli) || {player distanceSqr _heli <= (15 ^ 2)}
                },
                ["isNotInside"]
            ] call ace_common_fnc_progressBar;
            waitUntil { uiSleep 0.1; _unloadStatus # 0 };
            if !(_unloadStatus # 1) exitWith {
                systemChat "Mission Planner: IAFS install cancelled (cannon unload incomplete).";
            };
        };
        [_heli, _iafsPhase] call fza_fnc_weaponSwapM230Mag;
        // IAFS change supply deduction (100 pts)
        if (_supplyMode == 1 && { !_noAmmoSourceRequired }) then {
            private _iafsTruck = call _fnFindSupplyTruck;
            if (!isNull _iafsTruck) then {
                _iafsTruck setVariable ["ace_rearm_currentSupply", (([_iafsTruck] call _fnGetTruckSupply) - 100) max 0, true];
            };
        };
        _needsCenterStore = false;
    };

    if (_needsCenterStore) then {
        // IAFS → magazine: swap first, then cannon rearm follows below
        [_heli, _iafsPhase] call fza_fnc_weaponSwapM230Mag;
        // IAFS change supply deduction (100 pts)
        if (_supplyMode == 1 && { !_noAmmoSourceRequired }) then {
            private _iafsTruck2 = call _fnFindSupplyTruck;
            if (!isNull _iafsTruck2) then {
                _iafsTruck2 setVariable ["ace_rearm_currentSupply", (([_iafsTruck2] call _fnGetTruckSupply) - 100) max 0, true];
            };
        };
        _needsCenterStore = false;
    };

    if (_needsCannon) then {
        private _postSwapRds = _heli ammo "fza_m230";
        private _cannonDeltaPost = abs (_targetCannonRds - _postSwapRds);
        if (_cannonDeltaPost > 0) then {
            // Mode 1 (30s distributed): cannon takes its proportional share; mode 2: rate-based
            private _cannonDuration = if (_rearmMode == 1) then {
                _mode1TimePerOp max 0.01
            } else {
                (_cannonDeltaPost / 50.0) * _aceRearmDelay
            };
            if (_rearmNewPylons && { _supplyMode == 1 } && { !_noAmmoSourceRequired } && { isNull (call _fnFindSupplyTruck) }) exitWith {
                systemChat "Mission Planner: supply truck out of range — cannon load aborted.";
            };
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
                    if (_partial > 0.01) then {
                        private _actualRds = (_startRds + round ((_targetRds - _startRds) * _partial)) max 0;
                        _heli setAmmo ["fza_m230", _actualRds];
                        private _direction = ["unloading", "loading"] select (_targetRds > _startRds);
                        systemChat format ["Mission Planner: cannon %1 stopped at %2 rds.", _direction, _actualRds];
                    };
                    _cannonStatus set [1, false];
                    _cannonStatus set [0, true];
                },
                format ["Mission Planner - %1 Cannon (%2%3 rds)", (["Unloading","Loading"] select (_targetCannonRds > _postSwapRds)), (["-","+"] select (_targetCannonRds > _postSwapRds)), _cannonDeltaPost],
                {
                    params [["_args", []]];
                    _args params ["_heli"];
                    (vehicle player == _heli) || {player distanceSqr _heli <= (15 ^ 2)}
                },
                ["isNotInside"]
            ] call ace_common_fnc_progressBar;
            waitUntil { uiSleep 0.1; _cannonStatus # 0 };
        };
    };

    // ── STEP 2: PYLONS ───────────────────────────────────────────────────────
    private _prevPylonMags = getPylonMagazines _heli;
    private _prevCannonRds = _heli ammo "fza_m230";
    // Capture ammo counts before apply; needed to detect same-classname refills
    private _prevPylonAmmos = [];
    for "_ai" from 0 to 15 do { _prevPylonAmmos pushBack (_heli ammoOnPylon (_ai + 1)) };

    call _applyPylons;

    private _rearmStart = diag_tickTime;
    waitUntil {
        uiSleep 0.1;
        !(_heli getVariable ["fza_mplanner_rearming", false]) || { (diag_tickTime - _rearmStart) > 600 }
    };
    if (_heli getVariable ["fza_mplanner_rearming", false]) then {
        _heli setVariable ["fza_mplanner_rearming", false, true];
        systemChat "Mission Planner: pylon rearm timed out — flag cleared.";
    };

    // ── SUPPLY DEDUCTION: cannon only ────────────────────────────────────────
    // Pylon costs are charged per-slot inside _applyPylons as each slot completes.
    if (_rearmNewPylons && { _supplyMode == 1 } && { !_noAmmoSourceRequired }) then {
        private _cannonNewRds = (_prevCannonRds - _curCannonRds) max 0;
        if (_cannonNewRds > 0) then {
            private _truck = call _fnFindSupplyTruck;
            if (!isNull _truck) then {
                private _truckSupply = [_truck] call _fnGetTruckSupply;
                private _cannonCost = ceil (_cannonNewRds / 50) * _cannonCaliberCost;
                _truck setVariable ["ace_rearm_currentSupply", (_truckSupply - _cannonCost) max 0, true];
            };
        };
    };

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
        // Liters and rate computed once; used by both loading and unloading bars
        private _fuelLiters = _fuelDeltaKg / 0.8;
        private _aceRefuelRateF = if (isNil "ace_refuel_rate") then {1} else {ace_refuel_rate};
        if !(_aceRefuelRateF isEqualType 0 && {_aceRefuelRateF > 0}) then { _aceRefuelRateF = 1 };
        private _fuelRateLF = missionNamespace getVariable ["fza_mplanner_fuelRate", _aceRefuelRateF];
        if !(_fuelRateLF isEqualType 0 && {_fuelRateLF > 0}) then { _fuelRateLF = _aceRefuelRateF };
        // Per-mode bar duration helper: instant / proportional share / ACE rate-based
        private _fuelBarDuration = if (_rearmMode == 0) then { 0.01 }
            else { if (_rearmMode == 1) then { _mode1TimePerOp max 0.5 }
            else { (_fuelLiters / _fuelRateLF) max 0.5 } };

        if (_deltaRatio > 0) then {
            private _requiredLiters = _fuelLiters;

            if (_noFuelSourceRequired) exitWith {
                // No source required: show a timed bar using the mode-based duration
                private _noSrcDuration = _fuelBarDuration;
                private _noSrcStatus = [false, false];
                [
                    _noSrcDuration,
                    [_heli, _currentFuelRatio, _targetFuelPct, _noSrcStatus],
                    {
                        params [["_args", []]];
                        _args params ["_heli", "_curRatio", "_targetRatio", "_noSrcStatus"];
                        _heli setFuel _targetRatio;
                        [_heli] call fza_sfmplus_fnc_fuelSet;
                        systemChat "Mission Planner: fuel loaded.";
                        _noSrcStatus set [1, true]; _noSrcStatus set [0, true];
                    },
                    {
                        params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                        _args params ["_heli", "_curRatio", "_targetRatio", "_noSrcStatus"];
                        private _partial = if (_total > 0) then { _elapsed / _total } else { 0 };
                        if (_partial > 0.01) then {
                            _heli setFuel (_curRatio + ((_targetRatio - _curRatio) * _partial)) min 1;
                            [_heli] call fza_sfmplus_fnc_fuelSet;
                        };
                        _noSrcStatus set [1, false]; _noSrcStatus set [0, true];
                    },
                    format ["Mission Planner - Refueling (%1 L)", round _requiredLiters],
                    {
                        params [["_args", []]];
                        _args params ["_heli"];
                        (vehicle player == _heli) || {player distanceSqr _heli <= (15 ^ 2)}
                    },
                    ["isNotInside"]
                ] call ace_common_fnc_progressBar;
                waitUntil { uiSleep 0.1; _noSrcStatus # 0 };
            };

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

            // Mode 1: proportional; Mode 2: rate-based; Mode 0: instant (via _fuelBarDuration)
            private _fuelDuration = if (_rearmMode == 1 || _rearmMode == 0) then { _fuelBarDuration } else { (_transferLiters / _fuelRateLF) max 0.5 };

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
                    (vehicle player == _heli) || {player distanceSqr _heli <= (15 ^ 2)}
                },
                ["isNotInside"]
            ] call ace_common_fnc_progressBar;

            waitUntil {uiSleep 0.1; _status # 0};
        } else {
            // Decreasing fuel (defuel): show a timed bar, mode-based duration
            private _defuelStatus = [false, false];
            [
                _fuelBarDuration,
                [_heli, _currentFuelRatio, _targetFuelPct, _defuelStatus, _fuelLiters],
                {
                    params [["_args", []]];
                    _args params ["_heli", "_curRatio", "_targetRatio", "_defuelStatus", "_liters"];
                    _heli setFuel _targetRatio;
                    [_heli] call fza_sfmplus_fnc_fuelSet;
                    systemChat format ["Mission Planner: defueled %1 L.", round _liters];
                    _defuelStatus set [1, true]; _defuelStatus set [0, true];
                },
                {
                    params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                    _args params ["_heli", "_curRatio", "_targetRatio", "_defuelStatus", "_liters"];
                    private _partial = if (_total > 0) then { _elapsed / _total } else { 0 };
                    if (_partial > 0.01) then {
                        _heli setFuel (_curRatio + ((_targetRatio - _curRatio) * _partial)) max 0;
                        [_heli] call fza_sfmplus_fnc_fuelSet;
                    };
                    _defuelStatus set [1, false]; _defuelStatus set [0, true];
                },
                format ["Mission Planner - Defueling (%1 L)", round _fuelLiters],
                {
                    params [["_args", []]];
                    _args params ["_heli"];
                    (vehicle player == _heli) || {player distanceSqr _heli <= (15 ^ 2)}
                },
                ["isNotInside"]
            ] call ace_common_fnc_progressBar;
            waitUntil { uiSleep 0.1; _defuelStatus # 0 };
        };
    };

    // ── STEP 5: FCR INSTALLATION (300s in ACE mode, proportional in 30s mode) ──
    // FCR removal is handled before STEP 1; this block only fires for installation.
    if (_needsFcr) then {
        if (_supplyMode == 1 && { !_noAmmoSourceRequired } && { isNull (call _fnFindSupplyTruck) }) exitWith {
            systemChat "Mission Planner: supply truck out of range — FCR install aborted.";
        };
        private _fcrDuration = if (_rearmMode == 0) then { 0.01 } else { if (_rearmMode == 1) then { _mode1TimePerOp max 0.01 } else { 300 } };
        private _fcrStatus = [false, false];
        [
            _fcrDuration,
            [_heli, _desiredFcrState, _currentFcrState, _fcrStatus],
            {
                params [["_args", []]];
                _args params ["_heli", "_desiredFcrState", "_originalFcrState", "_fcrStatus"];
                _heli animateSource ["fcr_enable", _desiredFcrState];
                _fcrStatus set [1, true];
                _fcrStatus set [0, true];
            },
            {
                params [["_args", []], ["_elapsed", 0, [0]], ["_total", 1, [0]]];
                _args params ["_heli", "_desiredFcrState", "_originalFcrState", "_fcrStatus"];
                _heli animateSource ["fcr_enable", _originalFcrState];
                _fcrStatus set [1, false];
                _fcrStatus set [0, true];
            },
            "Mission Planner - Installing FCR",
            {
                params [["_args", []]];
                _args params ["_heli"];
                (vehicle player == _heli) || {player distanceSqr _heli <= (15 ^ 2)}
            },
            ["isNotInside"]
        ] call ace_common_fnc_progressBar;
        waitUntil { uiSleep 0.1; _fcrStatus # 0 };
        // FCR change supply deduction (100 pts) on successful completion
        if ((_fcrStatus # 1) && { _supplyMode == 1 } && { !_noAmmoSourceRequired }) then {
            private _fcrTruck = call _fnFindSupplyTruck;
            if (!isNull _fcrTruck) then {
                _fcrTruck setVariable ["ace_rearm_currentSupply", (([_fcrTruck] call _fnGetTruckSupply) - 100) max 0, true];
            };
        };
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
            (if (_rearmMode == 0) then { 0.01 } else { if (_rearmMode == 1) then { _mode1TimePerOp max 0.01 } else { 30 } }),
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
                (vehicle player == _heli) || {player distanceSqr _heli <= (15 ^ 2)}
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
                (if (_rearmMode == 0) then { 0.01 } else { if (_rearmMode == 1) then { _mode1TimePerOp max 0.01 } else { 10 } }),
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
                    (vehicle player == _heli) || {player distanceSqr _heli <= (15 ^ 2)}
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
