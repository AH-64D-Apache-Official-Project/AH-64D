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

// The AH-64Ds, looked for once a second; transmitting while their refresh is fresh (fza_ase_fnc_rJam), and still
// heard while they fade out
if (diag_tickTime >= fza_ase_commsListAt) then {
    fza_ase_commsListAt  = diag_tickTime + 1;
    fza_ase_commsJammers = entities "fza_ah64base";
};
private _transmitting = {CBA_missionTime - (_this getVariable ["fza_ah64_ase_rJamXmitStamp", -1e9]) < ASE_RJAM_COMMS_STALE};
private _jammers = fza_ase_commsJammers select {
    (_x call _transmitting) || {((_x getVariable ["fza_ase_commsLos", [0]]) select 0) > 0}
};

private _strength = 0;
if (_jammers isNotEqualTo [] && {alive _unit}) then {
    private _eye = eyePos _unit;
    {
        if (!alive _x || {objectParent _unit isEqualTo _x}) then {continue;};
        private _distance = _x distance _unit;
        private _bearing  = [_x getRelDir _unit] call CBA_fnc_simplifyAngle180;
        if (_distance >= ASE_RJAM_COMMS_RANGE || {abs _bearing > ASE_RJAM_CONE_DEG}) then {continue;};

        // From above its model centre: getPosASL is the ground contact, below the terrain's surface when landed
        private _blocked = !(_x call _transmitting) || {terrainIntersectASL [(_x modelToWorldVisualWorld [0, 0, 0]) vectorAdd [0, 0, 1], _eye]};
        // Fades in and out over ASE_RJAM_COMMS_FADE. Older than a second, as when it starts transmitting again, it counts
        // up from nothing.
        (_x getVariable ["fza_ase_commsLos", [0, -1e9]]) params ["_los", "_at"];
        if (diag_tickTime - _at > 1) then {_los = 0; _at = diag_tickTime;};
        private _step = (diag_tickTime - _at) max 0;
        _los = [(_los + _step / ASE_RJAM_COMMS_FADE) min 1, (_los - _step / ASE_RJAM_COMMS_FADE) max 0] select _blocked;
        _x setVariable ["fza_ase_commsLos", [_los, diag_tickTime]];

        _strength = _strength max (_los * linearConversion [ASE_RJAM_COMMS_FULL, ASE_RJAM_COMMS_RANGE, _distance, 1, 0, true]);
    } forEach _jammers;
    _strength = round (_strength * 20) / 20;
};

// Theirs for everyone's chat, in quarters so a fade sends only a few, and only when it changes
fza_ase_commsJam     = _strength;
fza_ase_commsAcreJam = [0, [110 * _strength, 200] select (_strength >= 1)] select (_strength > 0);
private _published   = round (_strength * 4) / 4;
if ((player getVariable ["fza_ah64_commsJam", 0]) != _published) then {
    player setVariable ["fza_ah64_commsJam", _published, true];
};
// The static is told what to play at every check and fades out on its own if they stop (fza_ase_fnc_rJamStatic); one
// that stopped being played is cleared, so it can't be left on or never start again
if (_strength == 0) then {fza_ase_commsStaticTarget = [0, 0, CBA_missionTime];};
if (!isNil "fza_ase_commsStaticHandle" && {CBA_missionTime - fza_ase_commsStaticBeat > 1}) then {
    [fza_ase_commsStaticHandle] call CBA_fnc_removePerFrameHandler;
    deleteVehicle (fza_ase_commsStatic param [0, objNull, [objNull]]);
    fza_ase_commsStatic       = [];
    fza_ase_commsStaticHandle = nil;
};

// ACRE: a weaker received signal while jammed, from our signal function wrapped round whatever function was there
// before, another mod's included (fza_ase_fnc_rJamAcreSignal). Wrapped again if one is put over it, and taken off
// once the jamming ends if it is still on top.
if (!isNil "acre_api_fnc_setCustomSignalFunc" && {!isNil "acre_sys_signal_fnc_getSignalCore"}) then {
    private _ours = {(missionNamespace getVariable ["acre_sys_signal_customSignalFunc", {}]) isEqualTo fza_ase_commsAcreWrapper};
    if (_strength > 0) then {
        if (!call _ours) then {
            fza_ase_commsAcreBase = missionNamespace getVariable "acre_sys_signal_customSignalFunc";
            [fza_ase_commsAcreWrapper] call acre_api_fnc_setCustomSignalFunc;
        };
        fza_ase_commsAcreOn = true;
    } else {
        if (fza_ase_commsAcreOn) then {
            fza_ase_commsAcreOn = false;
            if (call _ours) then {
                [missionNamespace getVariable ["fza_ase_commsAcreBase", {}]] call acre_api_fnc_setCustomSignalFunc;
                fza_ase_commsAcreBase = nil;
            };
        };
    };
};

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

// Static over the squelch while a radio is on, as loud as the strength and the loudest radio that is on. What the
// radio mods return goes through param, so a nil can't stop these checks (and leave the static as it was).
private _radio = 0;
if (_strength > 0) then {
    switch (true) do {
        case (!isNil "TFAR_fnc_activeSwRadio"): {
            private _sw = [call TFAR_fnc_activeSwRadio] param [0, "", [""]];
            if (_sw != "" && {([[_sw] call TFAR_fnc_RadioOn] param [0, false]) isEqualTo true}) then {
                _radio = _radio max (([_sw call TFAR_fnc_getSwVolume] param [0, 0, [0]]) / 10);
            };
            private _lr = [call TFAR_fnc_activeLrRadio] param [0, [], [[]]];
            if (_lr isNotEqualTo [] && {([[_lr] call TFAR_fnc_RadioOn] param [0, false]) isEqualTo true}) then {
                _radio = _radio max (([_lr call TFAR_fnc_getLrVolume] param [0, 0, [0]]) / 10);
            };
        };
        case (!isNil "acre_api_fnc_getCurrentRadioList"): {
            {
                if (([[_x] call acre_api_fnc_getRadioOnOffState] param [0, 0]) in [1, true]) then {
                    private _level = if (isNil "acre_api_fnc_getRadioVolume") then {1} else {[[_x] call acre_api_fnc_getRadioVolume] param [0, 0, [0]]};
                    _radio = _radio max _level;
                };
            } forEach ([[] call acre_api_fnc_getCurrentRadioList] param [0, [], [[]]]);
            // A lowered headset plays its radios at ACRE's 0.15
            if ((missionNamespace getVariable ["acre_sys_core_lowered", false]) isEqualTo true) then {_radio = _radio * 0.15;};
        };
        default {
            if ((assignedItems _unit) findIf {_x isKindOf ["ItemRadio", configFile >> "CfgWeapons"]} >= 0) then {_radio = 1;};
        };
    };
    _radio = _radio min 1;
};

// Played every frame while it's on (fza_ase_fnc_rJamStatic)
fza_ase_commsStaticTarget = [_strength, _radio, CBA_missionTime];
if (_strength > 0 && {_radio > 0} && {isNil "fza_ase_commsStaticHandle"}) then {
    fza_ase_commsStaticBeat   = CBA_missionTime;
    fza_ase_commsStaticHandle = [{_this call fza_ase_fnc_rJamStatic}, 0] call CBA_fnc_addPerFrameHandler;
};
