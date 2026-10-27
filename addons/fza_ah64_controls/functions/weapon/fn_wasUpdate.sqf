/* ----------------------------------------------------------------------------
Function: fza_fnc_wasUpdate

Description:
    Works out the aircraft's weapon and the crew stations holding it from the
    two crew stations' WAS records (fza_fnc_weaponActionSwitch), the same on
    every machine, so a late record can only delay a change. Run every frame
    and on each WAS.

    The last WAS wins: a crew station holds its weapon unless the other took
    one since, except that both hold rockets together. Taken at the same
    instant, the CPG's wins.

    COOP: rockets held by both crew stations, the CPG's sight TADS and the
    pilot's HMD. The crew station driving the weapon is the one holding it;
    the CPG in COOP, otherwise the one that took rockets last.

    Writes, locally:
        fza_ah64_was       - the aircraft's weapon, WAS_WEAPON_xxx
        fza_ah64_wasSeats  - the crew stations holding it, of "plt"/"cpg"
        fza_ah64_wasDriver - the crew station driving it, "plt"/"cpg", "" with none
        fza_ah64_wasCoop   - true in COOP

    A change of weapon is applied to the turret where it is local
    (fza_fnc_weaponUpdateSelected). The pilot fires the turret's weapon by
    manual fire while holding it, or always without a player CPG; the CPG can
    still fire under it, which is left to crew discipline outside COOP.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _none = [WAS_WEAPON_NONE, -1, WAS_WEAPON_NONE, -1];
(_heli getVariable ["fza_ah64_wasRec_plt", _none]) params ["_pltWeapon", "", "_pltTakeWeapon", "_pltTakeTime"];
(_heli getVariable ["fza_ah64_wasRec_cpg", _none]) params ["_cpgWeapon", "", "_cpgTakeWeapon", "_cpgTakeTime"];

private _pltHolds = _pltWeapon != WAS_WEAPON_NONE
    && {_cpgTakeTime < _pltTakeTime || {_cpgTakeWeapon == WAS_WEAPON_RKT && _pltWeapon == WAS_WEAPON_RKT}};
private _cpgHolds = _cpgWeapon != WAS_WEAPON_NONE
    && {_pltTakeTime <= _cpgTakeTime || {_pltTakeWeapon == WAS_WEAPON_RKT && _cpgWeapon == WAS_WEAPON_RKT}};

private _seats = [];
if (_pltHolds) then {_seats pushBack "plt"};
if (_cpgHolds) then {_seats pushBack "cpg"};
private _was = if (_cpgHolds) then {_cpgWeapon} else {[WAS_WEAPON_NONE, _pltWeapon] select _pltHolds};

private _coop = _was == WAS_WEAPON_RKT && {count _seats == 2
    && {([_heli, "fza_ah64_sight", "cpg"] call fza_fnc_getSeatVariable) == SIGHT_TADS
    && {([_heli, "fza_ah64_sight", "plt"] call fza_fnc_getSeatVariable) == SIGHT_HMD}}};
private _driver = switch (true) do {
    case (_seats isEqualTo []):  {""};
    case (count _seats == 1):    {_seats # 0};
    case (_coop):                {"cpg"};
    default {["cpg", "plt"] select (_pltTakeTime > _cpgTakeTime)};
};

private _changed = _was != (_heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE]);
_heli setVariable ["fza_ah64_was", _was];
_heli setVariable ["fza_ah64_wasSeats", _seats];
_heli setVariable ["fza_ah64_wasDriver", _driver];
_heli setVariable ["fza_ah64_wasCoop", _coop];
if (_changed) then {[_heli] call fza_fnc_weaponUpdateSelected};

// Manual fire, set by the pilot: on while the pilot holds the weapon or there is no player CPG. Asked for at most twice a
// second, as the engine takes a moment to report it changed.
if (player == driver _heli) then {
    private _manual = !isPlayer gunner _heli || {"plt" in _seats};
    if (_manual != isManualFire _heli && {CBA_missionTime - (_heli getVariable ["fza_ah64_manualFireAsked", -1]) > 0.5}) then {
        _heli setVariable ["fza_ah64_manualFireAsked", CBA_missionTime];
        player action [["ManualFireCancel", "ManualFire"] select _manual, _heli];
    };
};
