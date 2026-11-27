/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_applyRun

Description:
    Applies the planner's loadout to the aircraft one step at a time, and reports
    each step, warning and the result to the planner page. Spawned by
    fza_mplanner_fnc_applyConfig.

    The rearm mode sets the time: none, 30 seconds for the whole change, or a
    time for each item. Cancelling, closing the planner, dying, the aircraft
    being destroyed or another player getting in stops it during the step in
    progress; a gun or fuel step keeps what it had done by then.

    With an ammunition or fuel source required, the nearest source within the
    source distance is used. With ACE rearm's limited supply, items cost the
    source supply points, and removed items give them back.

Parameters:
    _json      - The loadout from the page
    _cannonRds - Planned gun rounds, -1 to keep the current ones
    _fcr       - 1 with the FCR, 0 without, -1 as the loadout says
    _tailNum   - Tail number, "" to keep the current one
    _msnEquip  - "US" or "UK"

Returns:
    Nothing

Examples:
    [_json, 1200, 1, "12345", "US"] spawn fza_mplanner_fnc_applyRun

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_json", "_cannonRds", "_fcr", "_tailNum", "_msnEquip"];
disableSerialization;

private _send = {
    params ["_type", ["_fields", []]];
    [createHashMapFromArray ([["type", _type]] + _fields)] call fza_mplanner_fnc_pageEvent
};
// With the planner closed the page can't show it
private _final = {
    params ["_type", "_fields"];
    if !([_type, _fields] call _send) then {
        hint format ["Mission Planner: %1", (createHashMapFromArray _fields) getOrDefault ["text", ""]];
    };
};
private _warnings = [];
private _warn = {
    params ["_text"];
    _warnings pushBack _text;
    ["log", [["level", "warn"], ["text", _text]]] call _send;
};

// ── Checks ─────────────────────────────────────────────────────────────────
private _heli = uiNamespace getVariable ["fza_mplanner_target", objNull];
if (isNull _heli || {!(_heli isKindOf "Helicopter")}) then {_heli = vehicle player};
if (!alive _heli || {!(_heli isKindOf "Helicopter")} || {count getPylonMagazines _heli != 16}) exitWith {
    ["refused", [["text", "There is no AH-64D to apply the loadout to."]]] call _final;
};

private _others = (crew _heli) select {isPlayer _x && {_x != player}};
if (_others isNotEqualTo []) exitWith {
    ["refused", [["text", format ["%1 must get out first. Applying a loadout with other players aboard desyncs it between machines.", (_others apply {name _x}) joinString ", "]]]] call _final;
};

private _by = _heli getVariable ["fza_mplanner_applyingBy", objNull];
if (alive _by && {_by != player} && {CBA_missionTime < (_heli getVariable ["fza_mplanner_applyUntil", 0])}) exitWith {
    ["refused", [["text", format ["%1 is applying a loadout to this aircraft.", name _by]]]] call _final;
};

private _plan = fromJSON _json;
if (isNil "_plan" || {!(_plan isEqualType createHashMap)}) exitWith {
    ["refused", [["text", "The planner sent a loadout the game could not read. Nothing was changed."]]] call _final;
};

// ── Settings ───────────────────────────────────────────────────────────────
private _setting = {
    params ["_name", "_default"];
    private _value = missionNamespace getVariable [_name, _default];
    [_default, _value] select (_value isEqualType _default)
};
private _mode      = (round (["fza_mplanner_rearmMode", 1] call _setting)) max 0 min 2;
private _noAmmoSrc = ["fza_mplanner_noAmmoSourceRequired", true] call _setting;
private _noFuelSrc = ["fza_mplanner_noFuelSourceRequired", true] call _setting;
private _fuelRate  = (["fza_mplanner_fuelRate", 8] call _setting) max 0.1;
private _range     = ["fza_mplanner_sourceDistance", 25] call _setting;
private _limited   = !_noAmmoSrc && {(["mode"] call fza_mplanner_fnc_supply) isEqualTo 1};

// ── Sources and supply (fza_mplanner_fnc_supply) ───────────────────────────
// [source, distance, amount] of the nearest ammunition (0) or fuel (1) source
private _nearest = {
    params ["_which"];
    (([_heli, _which == 0, _which == 1] call fza_mplanner_fnc_sources) select _which) param [0, [objNull, 0, 0]]
};
private _points = {
    params ["_src"];
    if (!_limited) exitWith {1e9};
    if (isNull _src) exitWith {0};
    (["points", [_src]] call fza_mplanner_fnc_supply) max 0
};
private _charge = {
    params ["_src", "_pts"];
    if (_limited) then {["addPoints", [_src, -_pts]] call fza_mplanner_fnc_supply};
};
private _drawFuel = {
    params ["_src", "_litres"];
    ["drawFuel", [_src, _litres]] call fza_mplanner_fnc_supply;
};

private _gunAmmoClass = getText (configFile >> "CfgMagazines" >> "fza_m230_300" >> "ammo");
private _gunPts = round getNumber (configFile >> "CfgAmmo" >> _gunAmmoClass >> "ACE_caliber");
if (_gunPts <= 0) then {_gunPts = 30};
// Charged per 50 rounds loaded, refunded per 50 unloaded
private _gunCost = {
    params ["_from", "_to"];
    if (_to > _from) exitWith {ceil ((_to - _from) / 50) * _gunPts};
    -(floor ((_from - _to) / 50) * _gunPts)
};
private _slotCost = {
    params ["_mag", "_rounds"];
    if (_mag == "") exitWith {0};
    if (_mag == "fza_230gal_auxTank") exitWith {50};
    switch (getText (configFile >> "CfgMagazines" >> _mag >> "fza_pylonType")) do {
        case "rocket": {5 * (_rounds max 0)};
        case "hellfire": {50 * (_rounds max 0)};
        default {0};
    }
};

// ── Pylons ─────────────────────────────────────────────────────────────────
// Each pylon has four stations, pylon 1 at 12-15 down to pylon 4 at 0-3. Rocket zones A, B and E
// are its first three and hellfire rails UL, UR, LL and LR its four. The first station of an empty
// launcher holds an empty pod or rail, so the pylon still counts as that launcher.
private _rocketAmmo   = ["m151", "m255a1", "m257", "m261", "m278"];
private _hellfireAmmo = ["agm114fa", "agm114k", "agm114k2a", "agm114l", "agm114n"];
private _placeholders = ["fza_agm114_rail", "fza_275_pod"];

private _haveMags   = getPylonMagazines _heli;
private _wantMags   = _haveMags apply {""};
private _wantRounds = _haveMags apply {-1};
{
    private _p = _plan getOrDefault [format ["pylon%1", _x], createHashMap];
    if !(_p isEqualType createHashMap) then {_p = createHashMap};
    private _base = (4 - _x) * 4;
    private _ammoOf = {
        params ["_key"];
        private _v = _p getOrDefault [_key, ""];
        if (_v isEqualType "") then {toLower _v} else {""}
    };
    switch (_p getOrDefault ["type", "none"]) do {
        case "aux": {
            _wantMags set [_base, "fza_230gal_auxTank"];
        };
        case "rocket": {
            {
                _x params ["_key", "_slot"];
                private _ammo = [_key] call _ammoOf;
                if (_ammo in _rocketAmmo) then {
                    _wantMags set [_base + _slot, format ["fza_275_%1_%2", _ammo, toLower _key]];
                    private _n = _p getOrDefault [_key + "Count", -1];
                    _wantRounds set [_base + _slot, if (_n isEqualType 0) then {round _n} else {-1}];
                } else {
                    if (_slot == 0) then {_wantMags set [_base, "fza_275_pod"]};
                };
            } forEach [["zoneA", 0], ["zoneB", 1], ["zoneE", 2]];
        };
        case "hellfire": {
            {
                _x params ["_key", "_slot"];
                private _ammo = [_key] call _ammoOf;
                if (_ammo in _hellfireAmmo) then {
                    _wantMags set [_base + _slot, format ["fza_%1_%2", _ammo, _key]];
                } else {
                    if (_slot == 0) then {_wantMags set [_base, "fza_agm114_rail"]};
                };
            } forEach [["ul", 0], ["ur", 1], ["ll", 2], ["lr", 3]];
        };
    };
} forEach [1, 2, 3, 4];

// Loaded magazines in lower case, an unloaded magazine class as empty
private _norm = {
    params ["_mag"];
    private _lower = toLower _mag;
    if (_lower == "" || {_lower in _placeholders}) exitWith {_lower};
    if (getNumber (configFile >> "CfgMagazines" >> _mag >> "count") == 0) exitWith {""};
    _lower
};
private _roundsFor = {
    params ["_slot"];
    private _full = getNumber (configFile >> "CfgMagazines" >> (_wantMags # _slot) >> "count");
    private _n = _wantRounds # _slot;
    if (_n < 0) then {_full} else {(_n min _full) max 0}
};
private _slotLabel = {
    params ["_slot"];
    private _mag = _wantMags # _slot;
    private _what = "emptying a station";
    if (_mag != "") then {
        _what = getText (configFile >> "CfgMagazines" >> _mag >> "displayName");
        if (getText (configFile >> "CfgMagazines" >> _mag >> "fza_pylonType") == "rocket" && {!(toLower _mag in _placeholders)}) then {
            _what = format ["%1 x%2", _what, [_slot] call _roundsFor];
        };
    };
    format ["Pylon %1: %2", 4 - floor (_slot / 4), _what]
};

private _queue = [];
for "_i" from 0 to 15 do {
    private _want = [_wantMags # _i] call _norm;
    private _have = [_haveMags # _i] call _norm;
    private _rounds = _heli ammoOnPylon (_i + 1);
    private _loaded = _want != "" && {!(_want in _placeholders)};
    // An emptied magazine is only reloaded when the plan has rounds for it
    if (_want != _have
        || {_loaded && {_rounds == 0} && {([_i] call _roundsFor) > 0}}
        || {_loaded && {(_wantRounds # _i) >= 0} && {_rounds != ([_i] call _roundsFor)}}
    ) then {
        _queue pushBack _i;
    };
};
// Removals first, so with limited supply their points are back before new items are charged
_queue = (_queue select {(_haveMags # _x) != ""}) + (_queue select {(_haveMags # _x) == ""});

// ── Gun, IAFS, FCR, fuel, equipment ────────────────────────────────────────
private _iafsWant = _plan getOrDefault ["iafsInstalled", true];
if !(_iafsWant isEqualType true) then {_iafsWant = true};
private _iafsHave = _heli getVariable ["bmkhs_ctrTankInstalled", true];
private _iafsChange = _iafsWant isNotEqualTo _iafsHave;

private _gunHave = _heli ammo "fza_m230";
private _gunWant = [_cannonRds, _gunHave] select (_cannonRds < 0);
_gunWant = round ((_gunWant max 0) min ([1200, 300] select _iafsWant));
// The new magazine is fitted empty, then loaded
private _gunFrom = [_gunHave, 0] select _iafsChange;

private _fcrHave = (_heli animationPhase "fcr_enable") > 0.5;
private _fcrWant = if (_fcr < 0) then {
    private _v = _plan getOrDefault ["fcrInstalled", false];
    _v isEqualType true && {_v}
} else {
    _fcr > 0
};

// HeliSim only keeps the tank masses up to date where the aircraft is local; elsewhere they're rebuilt from its fuel
if (!local _heli) then {[_heli] call bmkhs_fnc_fuelSet};
private _fuelHaveKg = _heli getVariable ["bmkhs_totFuelMass", 0];
// -1 when the planner's tanks weren't changed
private _fuelWantKg = _plan getOrDefault ["fuel", -1];
if (!(_fuelWantKg isEqualType 0) || {_fuelWantKg < 0}) then {_fuelWantKg = _fuelHaveKg};
private _fuelLitres = abs (_fuelWantKg - _fuelHaveKg) / 0.8;

private _isUK = _msnEquip == "UK";
private _isUS = _msnEquip == "US";
private _msnChange = (_isUK isNotEqualTo ((_heli animationPhase "msn_equip_british") > 0.5))
    || {_isUS isNotEqualTo ((_heli animationPhase "msn_equip_american") > 0.5)};
private _tailChange = _tailNum isNotEqualTo "" && {_tailNum isNotEqualTo (_heli getVariable ["fza_ah64_tailNumber", ""])};

// ── Steps ──────────────────────────────────────────────────────────────────
// [kind, label, seconds for each item, data, needs an ammunition source]
private _ammoNow = _noAmmoSrc || {!isNull (([0] call _nearest) # 0)};
private _ammoDropped = false;
private _steps = [];
private _addStep = {
    params ["_kind", "_label", "_seconds", ["_data", []], ["_needsAmmo", false]];
    if (_needsAmmo && {!_ammoNow}) exitWith {_ammoDropped = true};
    _steps pushBack [_kind, _label, _seconds, _data, _needsAmmo];
};

if (_fcrHave && {!_fcrWant}) then {["fcrOff", "Removing the FCR", 300] call _addStep};
if (_iafsChange) then {
    if (_iafsWant && {_gunHave > 0}) then {
        ["gunEmpty", format ["Unloading the gun (%1 rounds)", _gunHave], _gunHave / 10, [_gunHave], true] call _addStep;
    };
    ["iafs", ["Removing the IAFS", "Fitting the IAFS"] select _iafsWant, 300, [], true] call _addStep;
};
if (_gunWant != _gunFrom) then {
    ["gun", format [["Unloading the gun to %1 rounds", "Loading the gun to %1 rounds"] select (_gunWant > _gunFrom), _gunWant], abs (_gunWant - _gunFrom) / 10, [_gunFrom, _gunWant], true] call _addStep;
};
{
    private _want = [_wantMags # _x] call _norm;
    private _have = [_haveMags # _x] call _norm;
    private _isRocket = "rocket" in [getText (configFile >> "CfgMagazines" >> (_wantMags # _x) >> "fza_pylonType"), getText (configFile >> "CfgMagazines" >> (_haveMags # _x) >> "fza_pylonType")];
    private _seconds = 5;
    if (_isRocket) then {
        private _haveRounds = (_heli ammoOnPylon (_x + 1)) max 0;
        private _wantRoundsNow = [_x] call _roundsFor;
        _seconds = ([_haveRounds + _wantRoundsNow, abs (_wantRoundsNow - _haveRounds)] select (_want == _have)) max 1;
    };
    ["pylon", [_x] call _slotLabel, _seconds, [_x], true] call _addStep;
} forEach _queue;
if (_fuelLitres > 1.25) then {
    if (_fuelWantKg > _fuelHaveKg && {!_noFuelSrc} && {isNull (([1] call _nearest) # 0)}) exitWith {
        [format ["No fuel source within %1 m: refuelling skipped.", _range]] call _warn;
    };
    ["fuel", format [["Defuelling (%1 L)", "Refuelling (%1 L)"] select (_fuelWantKg > _fuelHaveKg), round _fuelLitres], _fuelLitres / _fuelRate] call _addStep;
};
if (!_fcrHave && {_fcrWant}) then {["fcrOn", "Fitting the FCR", 300] call _addStep};
if (_msnChange) then {["msn", format ["Fitting %1 mission equipment", _msnEquip], 30] call _addStep};
if (_tailChange) then {["tail", format ["Painting tail number %1", _tailNum], 10] call _addStep};

if (_ammoDropped) then {
    [format ["No ammunition source within %1 m: pylon and gun changes skipped.", _range]] call _warn;
};

private _count = count _steps;
{
    _x set [2, [0, 30 / _count, _x # 2] select _mode];
} forEach _steps;

// ── Run ────────────────────────────────────────────────────────────────────
_heli setVariable ["fza_mplanner_applyingBy", player, true];
_heli setVariable ["fza_mplanner_applyUntil", CBA_missionTime + 60, true];
_heli setVariable ["bmkhs_inputLockout", true, true];
_heli setVariable ["fza_mplanner_rearming", true, true];

["start", [["count", _count]]] call _send;

private _abortReason = {
    if (uiNamespace getVariable ["fza_mplanner_applyCancel", false]) exitWith {"Cancelled."};
    if (isNull (uiNamespace getVariable ["fza_mplanner_display", displayNull])) exitWith {"Stopped: the planner was closed."};
    if (!alive player) exitWith {"Stopped: you were killed."};
    if (!alive _heli) exitWith {"Stopped: the aircraft was destroyed."};
    private _boarded = (crew _heli) select {isPlayer _x && {_x != player}};
    if (_boarded isNotEqualTo []) exitWith {
        format ["Stopped: %1 got in. Applying a loadout with other players aboard desyncs it.", (_boarded apply {name _x}) joinString ", "]
    };
    ""
};
// Kept here rather than read back, as a remote aircraft's rounds take a moment to update
private _gunNow = _gunHave;
private _gunMax = [1200, 300] select _iafsHave;
private _setGun = {
    params ["_to", "_done", "_src"];
    private _rounds = round (_gunNow + (_to - _gunNow) * _done);
    ["fza_mplanner_setGunAmmo", [_heli, _rounds], _heli] call CBA_fnc_targetEvent;
    [_src, [_gunNow, _rounds] call _gunCost] call _charge;
    _gunNow = _rounds;
};

// The source in use is kept while it is still a source in range, rather than searched for each step
private _ammoSrc = objNull;
private _ammoSource = {
    if (isNull _ammoSrc || {_heli distance _ammoSrc > _range} || {!(["isAmmo", [_ammoSrc]] call fza_mplanner_fnc_supply)}) then {
        _ammoSrc = ([0] call _nearest) # 0;
    };
    _ammoSrc
};

private _result = "complete";
private _stopText = "";
private _ammoGone = false;
private _changesSent = false;
{
    _x params ["_kind", "_label", "_seconds", "_data", "_needsAmmo"];

    private _src = objNull;
    if (!_noAmmoSrc && {_needsAmmo || {_kind in ["fcrOn", "fcrOff"]}}) then {
        _src = call _ammoSource;
    };
    if (_needsAmmo && {!_noAmmoSrc} && {isNull _src}) then {
        if (!_ammoGone) then {
            [format ["No ammunition source within %1 m any more: the remaining pylon and gun changes were skipped.", _range]] call _warn;
            _ammoGone = true;
        };
        continue;
    };

    private _cost = switch (_kind) do {
        case "fcrOff": {-100};
        case "fcrOn": {100};
        case "iafs": {100 + ([_gunNow, 0] call _gunCost)};
        case "gunEmpty": {[_gunNow, 0] call _gunCost};
        case "gun": {[_gunNow, (_data # 1) min _gunMax] call _gunCost};
        case "pylon": {
            private _slot = _data # 0;
            ([_wantMags # _slot, [_slot] call _roundsFor] call _slotCost)
                - ([(getPylonMagazines _heli) # _slot, _heli ammoOnPylon (_slot + 1)] call _slotCost)
        };
        default {0};
    };
    if (_limited && {_cost > 0}) then {
        private _pts = [_src] call _points;
        if (_cost > _pts) then {
            [if (isNull _src) then {
                format ["%1 skipped: it needs %2 supply points and there is no ammunition source within %3 m.", _label, _cost, _range]
            } else {
                format ["%1 skipped: it needs %2 supply points and the source has %3.", _label, _cost, _pts]
            }] call _warn;
            continue;
        };
    };

    // What the fitted tanks can take is only known once the IAFS and aux tanks are in. A remote aircraft's
    // changes take a moment to arrive here, and its tank masses are rebuilt from its fuel.
    private _fuelPlan = [];
    if (_kind isEqualTo "fuel") then {
        if (!local _heli) then {
            if (_changesSent) then {uiSleep 1};
            [_heli] call bmkhs_fnc_fuelSet;
        };
        private _capKg = [_heli] call fza_ah64_helisim_fnc_fuelCapacity;
        private _from = _heli getVariable ["bmkhs_totFuelMass", 0];
        private _to = if (_capKg > 0) then {(_fuelWantKg min _capKg) max 0} else {_from};
        private _litres = abs (_to - _from) / 0.8;
        private _fsrc = objNull;
        if (_to > _from && {!_noFuelSrc}) then {
            ([1] call _nearest) params ["_s", "", "_l"];
            _fsrc = _s;
            if (!isNull _s && {_l >= 0} && {_l < _litres}) then {
                [format ["The fuel source holds %1 L, so the aircraft gets that much.", round _l]] call _warn;
                _to = _from + _l * 0.8;
                _litres = _l;
            };
        };
        _fuelPlan = [_from, _to, _fsrc, _litres];
        if (_mode == 2) then {_seconds = _litres / _fuelRate};
        _label = format [["Defuelling (%1 L)", "Refuelling (%1 L)"] select (_to > _from), round _litres];
    };
    if (_kind isEqualTo "fuel" && {(_fuelPlan # 1) > (_fuelPlan # 0)} && {!_noFuelSrc} && {isNull (_fuelPlan # 2)}) then {
        [format ["No fuel source within %1 m any more: refuelling skipped.", _range]] call _warn;
        continue;
    };

    _heli setVariable ["fza_mplanner_applyUntil", CBA_missionTime + _seconds + 30, true];
    ["step", [["index", _forEachIndex + 1], ["count", _count], ["label", _label], ["duration", _seconds]]] call _send;

    private _t0 = diag_tickTime;
    private _stop = call _abortReason;
    if (_stop isEqualTo "" && {_seconds > 0}) then {
        waitUntil {
            uiSleep 0.1;
            _stop = call _abortReason;
            _stop isNotEqualTo "" || {diag_tickTime - _t0 >= _seconds}
        };
    };
    private _done = [((diag_tickTime - _t0) / (_seconds max 0.001)) min 1, 1] select (_stop isEqualTo "");

    if (_done >= 1 || {_kind in ["gunEmpty", "gun", "fuel"]}) then {
        switch (_kind) do {
            case "fcrOff": {
                ["fza_mplanner_animate", [_heli, "fcr_enable", 0], _heli] call CBA_fnc_targetEvent;
                [_src, _cost] call _charge;
            };
            case "fcrOn": {
                ["fza_mplanner_animate", [_heli, "fcr_enable", 1], _heli] call CBA_fnc_targetEvent;
                [_src, _cost] call _charge;
            };
            case "iafs": {
                // The swap fits a full magazine; once it shows here it is emptied, and the gun step loads it
                ["fza_mplanner_swapGunMag", [_heli, [1, 0] select _iafsWant], _heli] call CBA_fnc_targetEvent;
                private _sent = diag_tickTime;
                waitUntil {
                    uiSleep 0.1;
                    (_heli getVariable ["bmkhs_ctrTankInstalled", true]) isEqualTo _iafsWant || {diag_tickTime - _sent > 5}
                };
                if ((_heli getVariable ["bmkhs_ctrTankInstalled", true]) isNotEqualTo _iafsWant) then {
                    [format ["%1 did not show on the aircraft within 5 seconds.", _label]] call _warn;
                };
                ["fza_mplanner_setGunAmmo", [_heli, 0], _heli] call CBA_fnc_targetEvent;
                [_src, _cost] call _charge;
                _gunNow = 0;
                _gunMax = [1200, 300] select _iafsWant;
            };
            case "gunEmpty": {
                [0, _done, _src] call _setGun;
            };
            case "gun": {
                [(_data # 1) min _gunMax, _done, _src] call _setGun;
            };
            case "pylon": {
                private _slot = _data # 0;
                ["fza_mplanner_setPylon", [_heli, _slot + 1, _wantMags # _slot, [_slot] call _roundsFor], _heli] call CBA_fnc_targetEvent;
                [_src, _cost] call _charge;
            };
            case "fuel": {
                _fuelPlan params ["_from", "_to", "_fsrc", "_litres"];
                ["fza_mplanner_setFuel", [_heli, _to, _done], _heli] call CBA_fnc_targetEvent;
                if (!isNull _fsrc && {_to > _from}) then {[_fsrc, _litres * _done] call _drawFuel};
            };
            case "msn": {
                ["fza_mplanner_animate", [_heli, "msn_equip_american", [0, 1] select _isUS, true], _heli] call CBA_fnc_targetEvent;
                ["fza_mplanner_animate", [_heli, "msn_equip_british", [0, 1] select _isUK, true], _heli] call CBA_fnc_targetEvent;
            };
            case "tail": {
                [_heli, _tailNum] call fza_customise_fnc_setTailNumber;
                _heli setVariable ["fza_ah64_tailNumber", _tailNum, true];
            };
        };
        _changesSent = true;
    };

    if (_stop isNotEqualTo "") exitWith {
        _result = "cancelled";
        _stopText = _stop;
    };
} forEach _steps;

// ── Finish ─────────────────────────────────────────────────────────────────
_heli setVariable ["fza_mplanner_rearming", false, true];
["fza_mplanner_finish", [_heli, _result isEqualTo "complete"], _heli] call CBA_fnc_targetEvent;
_heli setVariable ["fza_mplanner_applyingBy", objNull, true];
_heli setVariable ["fza_mplanner_applyUntil", 0, true];
_heli setVariable ["bmkhs_inputLockout", false, true];

private _text = _stopText;
if (_result isEqualTo "complete") then {
    _text = switch (true) do {
        case (_count == 0): {"Nothing needed changing. Countermeasures restocked."};
        case (_warnings isNotEqualTo []): {"Applied, apart from the warnings above."};
        default {"The aircraft has the planned loadout."};
    };
};
["done", [["status", _result], ["text", _text]]] call _final;

// A remote aircraft's changes take a moment to come back
uiSleep ([1.5, 0.2] select (local _heli));
[_result isNotEqualTo "complete" || {_warnings isNotEqualTo []}] call fza_mplanner_fnc_seedCurrentConfig;
[] call fza_mplanner_fnc_seedSaves;
