/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_seedCurrentConfig

Description:
    Reads the current helicopter state (fuel, ammo, pylons, FCR, IAFS) and
    sends it to the browser as a planner state object so the UI opens with
    the aircraft's actual current configuration.

Parameters:
    None

Returns:
    true / false

Author:
    FZA Missionplanner
---------------------------------------------------------------------------- */
disableSerialization;

private _display = uiNamespace getVariable ["fza_mplanner_display", displayNull];
if (isNull _display) exitWith { false };

private _browser = _display displayCtrl 100;
if (isNull _browser) exitWith { false };

private _heli = uiNamespace getVariable ["fza_mplanner_target", vehicle player];
if (isNull _heli || !(_heli isKindOf "Helicopter")) then {
    _heli = vehicle player;
};
if (isNull _heli) exitWith { false };
if !(_heli isKindOf "Helicopter") exitWith { false };

private _jsEscape = {
    params ["_text"];
    private _chars = [];
    {
        switch (_x) do {
            case 39: {_chars append [92, 39]};
            case 92: {_chars append [92, 92]};
            case 10: {_chars append [92, 110]};
            case 13: {};
            default {_chars pushBack _x};
        };
    } forEach toArray _text;
    toString _chars
};

// ── Tail number ───────────────────────────────────────────────────────────────
private _tailNum = _heli getVariable ["fza_ah64_tailNumber", ""];
if !(_tailNum isEqualType "") then { _tailNum = "00000" };

// ── FCR / IAFS ──────────────────────────────────────────────────────────────
private _fcrActive = (_heli animationPhase "fcr_enable") > 0.5;
private _fcrJson = ["false", "true"] select (_fcrActive);
private _iafsInstalled = _heli getVariable ["fza_ah64_IAFSInstalled", true];
private _robbieMode = ["magazine", "iafs"] select _iafsInstalled;

// ── Cannon ───────────────────────────────────────────────────────────────────
private _cannonRds = _heli ammo "fza_m230";

// ── Fuel (per-tank kg → gallons) ─────────────────────────────────────────────
// Max kg values come from vehicle variables set by fza_sfmplus_fnc_coreConfig.
// Fallback to typical Apache values if not yet set.
private _maxFwdKg = _heli getVariable ["fza_sfmplus_maxFwdFuelMass", 473.1];
private _maxAftKg = _heli getVariable ["fza_sfmplus_maxAftFuelMass", 668.5];
private _maxCtrKg = _heli getVariable ["fza_sfmplus_maxCtrFuelMass", 300.7];

private _fwdKg = _heli getVariable ["fza_sfmplus_fwdFuelMass", 0];
private _aftKg = _heli getVariable ["fza_sfmplus_aftFuelMass", 0];
private _ctrKg = _heli getVariable ["fza_sfmplus_ctrFuelMass", 0];

private _fwdGal = if (_maxFwdKg > 0) then { (round (_fwdKg / _maxFwdKg * 155)) min 155 max 0 } else { 0 };
private _aftGal = if (_maxAftKg > 0) then { (round (_aftKg / _maxAftKg * 220)) min 220 max 0 } else { 0 };
private _ctrGal = if (_maxCtrKg > 0) then { (round (_ctrKg / _maxCtrKg * 100)) min 100 max 0 } else { 0 };

// ── Pylons ────────────────────────────────────────────────────────────────────
// Magazine slot layout (0-based index in getPylonMagazines):
//   Pylon 1: 12-15  |  Pylon 2: 8-11  |  Pylon 3: 4-7  |  Pylon 4: 0-3
// Within each 4-slot group (base = (4-pylonNum)*4):
//   base+0 = zoneA / ul-hellfire    base+1 = zoneB / ur-hellfire
//   base+2 = zoneE / ll-hellfire    base+3 = empty(rkt) / lr-hellfire / aux
private _mags = getPylonMagazines _heli;

// Ammo class (toLower) → UI code maps
private _rktAmmoMap = [
    ["fza_275_m151",   "6PD"],
    ["fza_275_m255a1", "6FL"],
    ["fza_275_m257",   "6IL"],
    ["fza_275_m261",   "6MP"],
    ["fza_275_m278",   "6IR"]
];
private _hfAmmoMap = [
    ["fza_agm114fa",  "FA"],
    ["fza_agm114k",   "K"],
    ["fza_agm114k2a", "K2A"],
    ["fza_agm114l",   "L"],
    ["fza_agm114n",   "N"]
];

private _buildRktZone = {
    params ["_magName", "_slotIdx"];
    if (_magName isEqualTo "") exitWith { '{"count":0,"type":"6PD"}' };
    // Empty pod placeholder — treat as no ammo
    private _cnt0check = getNumber (configFile >> "CfgMagazines" >> _magName >> "count");
    if (_cnt0check == 0) exitWith { '{"count":0,"type":"6PD"}' };
    // Use runtime ammo count so partially-fired pods report correct remaining rounds
    private _runtimeCount = _heli ammoOnPylon _slotIdx;
    if (_runtimeCount == 0) exitWith { '{"count":0,"type":"6PD"}' };
    private _ammoClass = toLower getText (configFile >> "CfgMagazines" >> _magName >> "ammo");
    private _count     = _runtimeCount;
    private _typeCode  = "6PD";
    { if ((_x # 0) isEqualTo _ammoClass) exitWith { _typeCode = _x # 1; }; } forEach _rktAmmoMap;
    format ['{"count":%1,"type":"%2"}', _count, _typeCode]
};

private _buildHfRail = {
    params ["_magName", "_slotIdx"];
    if (_magName isEqualTo "") exitWith { '""' };
    // Check config count (catches unloaded magazine classes that have count=0 in config)
    private _cnt0hf = getNumber (configFile >> "CfgMagazines" >> _magName >> "count");
    if (_cnt0hf == 0) exitWith { '""' };
    // Note: we intentionally do NOT exit on ammoOnPylon==0 here. A fired missile leaves
    // the magazine class in the slot; reporting the type (with 0 ammo) lets the planner
    // display what was loaded and correctly tracks it as a pre-existing rail rather than
    // a new item that would cost supply points.
    private _ammoClass = toLower getText (configFile >> "CfgMagazines" >> _magName >> "ammo");
    private _code = "";
    { if ((_x # 0) isEqualTo _ammoClass) exitWith { _code = _x # 1; }; } forEach _hfAmmoMap;
    format ['"%1"', _code]
};

private _auxGal = 0;
if ("fza_230gal_auxTank" in _mags) then { _auxGal = 230 };

private _pylonJsonArr = [];
{
    private _pylonNum = _forEachIndex + 1;
    private _baseIdx  = (4 - _pylonNum) * 4;

    private _slot0 = _mags # (_baseIdx + 0);  // zoneA / ul
    private _slot1 = _mags # (_baseIdx + 1);  // zoneB / ur
    private _slot2 = _mags # (_baseIdx + 2);  // zoneE / ll
    private _slot3 = _mags # (_baseIdx + 3);  // empty(rkt) / lr / aux

    // Determine pylon type from first non-empty magazine
    private _pylonType = "none";
    {
        if (_x != "") exitWith {
            private _cfgType = getText (configFile >> "CfgMagazines" >> _x >> "fza_pylonType");
            _pylonType = switch _cfgType do {
                case "rocket":   { "rocket"   };
                case "hellfire": { "hellfire" };
                case "auxTank":  { "aux"      };
                default          { "none"     };
            };
        };
    } forEach [_slot0, _slot1, _slot2, _slot3];

    private _pylonJson = "";
    switch _pylonType do {
        case "none": {
            _pylonJson = '{"type":"none"}';
        };
        case "aux": {
            _pylonJson = '{"type":"aux"}';
        };
        case "rocket": {
            // base+0 = zoneA, base+1 = zoneB, base+2 = zoneE
            // Second param = 1-based ammoOnPylon index (0-based slot + 1)
            private _zA = [_slot0, _baseIdx + 1] call _buildRktZone;
            private _zB = [_slot1, _baseIdx + 2] call _buildRktZone;
            private _zE = [_slot2, _baseIdx + 3] call _buildRktZone;
            _pylonJson = format ['{"type":"rocket","zones":[%1,%2,%3]}', _zA, _zB, _zE];
        };
        case "hellfire": {
            // base+0=ul(tl/rails[1]), base+1=ur(tr/rails[0]), base+2=ll(bl/rails[3]), base+3=lr(br/rails[2])
            // Second param = 1-based ammoOnPylon index (0-based slot + 1)
            private _tr = [_slot1, _baseIdx + 2] call _buildHfRail;
            private _tl = [_slot0, _baseIdx + 1] call _buildHfRail;
            private _br = [_slot3, _baseIdx + 4] call _buildHfRail;
            private _bl = [_slot2, _baseIdx + 3] call _buildHfRail;
            // ammoOnPylon per rail: 0 means fired (classname may still be present in slot)
            private _amoTr = _heli ammoOnPylon (_baseIdx + 2);
            private _amoTl = _heli ammoOnPylon (_baseIdx + 1);
            private _amoBr = _heli ammoOnPylon (_baseIdx + 4);
            private _amoBl = _heli ammoOnPylon (_baseIdx + 3);
            _pylonJson = format ['{"type":"hellfire","rails":[%1,%2,%3,%4],"ammos":[%5,%6,%7,%8]}', _tr, _tl, _br, _bl, _amoTr, _amoTl, _amoBr, _amoBl];
        };
    };

    _pylonJsonArr pushBack _pylonJson;
} forEach [1, 2, 3, 4];

// ── ASE Equipment ─────────────────────────────────────────────────────────────
private _msnEquipBritish  = (_heli animationPhase "msn_equip_british")  > 0.5;
private _msnEquipAmerican = (_heli animationPhase "msn_equip_american") > 0.5;
private _msnEquipCode = if (_msnEquipBritish) then {"UK"} else {["none", "US"] select (_msnEquipAmerican)};

private _stateJson = format [
    '{"version":1,"tailNum":"%1","fcrActive":%2,"robbieMode":"%3","cannonRds":%4,"fuel":{"fwd":%5,"aft":%6,"ctr":%7,"aux":%8},"pylons":[%9],"msnEquip":"%10"}',
    _tailNum call _jsEscape,
    _fcrJson,
    _robbieMode,
    _cannonRds,
    _fwdGal,
    _aftGal,
    _ctrGal,
    _auxGal,
    _pylonJsonArr joinString ",",
    _msnEquipCode
];

private _jsCode = format [
    "window.fza_mplanner_receiveCurrentConfig && window.fza_mplanner_receiveCurrentConfig('%1');",
    _stateJson call _jsEscape
];
[_browser, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";

true
