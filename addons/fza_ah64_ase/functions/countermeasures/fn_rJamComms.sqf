/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamComms

Description:
    On a player's machine, 4 times a second: whether their radios are jammed by an AH-64D's
    radar jammer, in the cone off its nose with terrain line of sight while it transmits, at
    full strength close in and fading out with distance. Jammed, the static drowns the
    squelch while a radio is on, TFAR's range or ACRE's signal drops, and their chat is
    scrambled (fza_ase_fnc_rJamChat).

Parameters:
    None

Returns:
    Nothing

Examples:
    [{call fza_ase_fnc_rJamComms}, 0.25] call CBA_fnc_addPerFrameHandler

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"

private _unit = call CBA_fnc_currentUnit;

// The AH-64Ds, looked for once a second; transmitting while their refresh is fresh (fza_ase_fnc_rJam)
if (diag_tickTime >= fza_ase_commsListAt) then {
    fza_ase_commsListAt  = diag_tickTime + 1;
    fza_ase_commsJammers = entities "fza_ah64base";
};
private _jammers = fza_ase_commsJammers select {
    CBA_missionTime - (_x getVariable ["fza_ah64_ase_rJamXmitStamp", -1e9]) < ASE_RJAM_COMMS_STALE
};

private _debug    = missionNamespace getVariable ["fza_ase_rJamDebug", false]
    && {diag_tickTime >= (missionNamespace getVariable ["fza_ase_commsDebugAt", 0])};
private _strength = 0;
if (_jammers isNotEqualTo [] && {alive _unit}) then {
    private _eye = eyePos _unit;
    {
        if (!alive _x || {objectParent _unit isEqualTo _x}) then {continue;};
        private _distance = _x distance _unit;
        private _bearing  = [_x getRelDir _unit] call CBA_fnc_simplifyAngle180;
        if (_distance >= ASE_RJAM_COMMS_RANGE || {abs _bearing > ASE_RJAM_CONE_DEG}) then {continue;};

        // From above its model centre: getPosASL is the ground contact, below the terrain's surface when landed
        private _blocked = terrainIntersectASL [(_x modelToWorldVisualWorld [0, 0, 0]) vectorAdd [0, 0, 1], _eye];
        // Behind terrain it fades out over ASE_RJAM_COMMS_MASK_TIME, and back in over ASE_RJAM_COMMS_UNMASK_TIME. Older
        // than a second, as when it starts transmitting again, it counts up from nothing.
        (_x getVariable ["fza_ase_commsLos", [0, -1e9]]) params ["_los", "_at"];
        if (diag_tickTime - _at > 1) then {_los = 0; _at = diag_tickTime;};
        private _step = (diag_tickTime - _at) max 0;
        _los = [(_los + _step / ASE_RJAM_COMMS_UNMASK_TIME) min 1, (_los - _step / ASE_RJAM_COMMS_MASK_TIME) max 0] select _blocked;
        _x setVariable ["fza_ase_commsLos", [_los, diag_tickTime]];
        if (_debug) then {diag_log format ["fza_ase_rJam comms: %1 at %2 m, bearing %3, terrain blocks %4, in sight %5", typeOf _x, round _distance, round _bearing, _blocked, _los];};

        _strength = _strength max (_los * linearConversion [ASE_RJAM_COMMS_FULL, ASE_RJAM_COMMS_RANGE, _distance, 1, 0, true]);
    } forEach _jammers;
    _strength = round (_strength * 20) / 20;
};
if (_debug) then {
    fza_ase_commsDebugAt = diag_tickTime + 1;
    diag_log format ["fza_ase_rJam comms: %1 AH-64D, %2 transmitting, strength %3", count fza_ase_commsJammers, count _jammers, _strength];
};

// Theirs for everyone's chat, in quarters so a fade sends only a few, and only when it changes
fza_ase_commsJam     = _strength;
fza_ase_commsAcreJam = [0, [110 * _strength, 200] select (_strength >= 1)] select (_strength > 0);
private _published   = round (_strength * 4) / 4;
if ((player getVariable ["fza_ah64_commsJam", 0]) != _published) then {
    player setVariable ["fza_ah64_commsJam", _published, true];
};
if (_strength == 0) then {fza_ase_commsStaticTarget = 0;};
if (_strength == 0 && {count fza_ase_commsWritten == 0}) exitWith {};

// A value another mod or the mission set is kept as the base: ours only ever makes it worse, and the base is put back
private _hold = {
    params ["_target", "_var", "_default", "_ours", "_worseIsBigger"];
    private _state  = fza_ase_commsWritten getOrDefault [_var, []];
    _state params [["_was", objNull], ["_base", _default], ["_written", _default]];
    private _active = _state isNotEqualTo [];
    // A new unit, as after a respawn: the old one gets its base back
    if (_active && {_was isNotEqualTo _target}) then {
        if (!isNull _was && {(_was getVariable [_var, _default]) isEqualTo _written}) then {_was setVariable [_var, _base];};
        _active = false;
    };
    private _current = _target getVariable [_var, _default];
    if (!_active || {_current isNotEqualTo _written}) then {_base = _current;};
    if (isNil "_ours") exitWith {
        if (_active && {_current isEqualTo _written}) then {_target setVariable [_var, _base];};
        fza_ase_commsWritten deleteAt _var;
    };
    private _value = [_ours min _base, _ours max _base] select _worseIsBigger;
    if (_value isNotEqualTo _current) then {_target setVariable [_var, _value];};
    fza_ase_commsWritten set [_var, [_target, _base, _value]];
};

// TFAR: a shorter range to receive and send on
if (!isNil "TFAR_fnc_activeSwRadio") then {
    private _tfarUnit = missionNamespace getVariable ["TFAR_currentUnit", player];
    if (_strength > 0) then {
        private _rx = [1 + 19 * _strength, 100] select (_strength >= 1);
        [_tfarUnit, "tf_receivingDistanceMultiplicator", 1, _rx, true] call _hold;
        [_tfarUnit, "tf_sendingDistanceMultiplicator", 1, 1 / ([_rx, 20] select (_strength >= 1)), false] call _hold;
    } else {
        [_tfarUnit, "tf_receivingDistanceMultiplicator", 1, nil, true] call _hold;
        [_tfarUnit, "tf_sendingDistanceMultiplicator", 1, nil, false] call _hold;
    };
};

// ACRE: a weaker received signal, from our signal function wrapped round whatever function was there before, another
// mod's included (fza_ase_fnc_rJamAcreSignal); wrapped again if one is put over it
if (_strength > 0
    && {!isNil "acre_api_fnc_setCustomSignalFunc"}
    && {!isNil "acre_sys_signal_fnc_getSignalCore"}
    && {(missionNamespace getVariable ["acre_sys_signal_customSignalFunc", {}]) isNotEqualTo fza_ase_commsAcreWrapper}) then {
    fza_ase_commsAcreBase = missionNamespace getVariable "acre_sys_signal_customSignalFunc";
    [fza_ase_commsAcreWrapper] call acre_api_fnc_setCustomSignalFunc;
};

// Static over the squelch while a radio is on, as loud as the strength and the loudest radio that is on
private _volume = 0;
if (_strength > 0) then {
    private _radio = 0;
    switch (true) do {
        case (!isNil "TFAR_fnc_activeSwRadio"): {
            private _sw = call TFAR_fnc_activeSwRadio;
            if (!isNil "_sw" && {[_sw] call TFAR_fnc_RadioOn}) then {
                private _level = _sw call TFAR_fnc_getSwVolume;
                if (_level isEqualType 0) then {_radio = _radio max (_level / 10);};
            };
            private _lr = call TFAR_fnc_activeLrRadio;
            if (!isNil "_lr" && {[_lr] call TFAR_fnc_RadioOn}) then {
                private _level = _lr call TFAR_fnc_getLrVolume;
                if (_level isEqualType 0) then {_radio = _radio max (_level / 10);};
            };
        };
        case (!isNil "acre_api_fnc_getCurrentRadioList"): {
            {
                if (([_x] call acre_api_fnc_getRadioOnOffState) in [1, true]) then {
                    private _level = if (isNil "acre_api_fnc_getRadioVolume") then {1} else {[_x] call acre_api_fnc_getRadioVolume};
                    if (_level isEqualType 0) then {_radio = _radio max _level;};
                };
            } forEach ([] call acre_api_fnc_getCurrentRadioList);
        };
        default {
            if ((assignedItems _unit) findIf {_x isKindOf ["ItemRadio", configFile >> "CfgWeapons"]} >= 0) then {_radio = 1;};
        };
    };
    _volume = _strength * (_radio min 1);
    if (_debug) then {diag_log format ["fza_ase_rJam comms: radio %1, static volume %2, playing %3", _radio, _volume, fza_ase_commsStatic];};
};

// Played every frame while it's on, eased between these steps (fza_ase_fnc_rJamStatic)
fza_ase_commsStaticTarget = _volume;
if (_volume > 0 && {isNil "fza_ase_commsStaticHandle"}) then {
    fza_ase_commsStaticHandle = [{_this call fza_ase_fnc_rJamStatic}, 0] call CBA_fnc_addPerFrameHandler;
};
