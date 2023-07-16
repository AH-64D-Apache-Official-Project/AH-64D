["fza_engineFire", {
    params ["_heli", "_location"];
    [_heli] spawn fza_aiCrew_fnc_fireControl;
}] call CBA_fnc_addEventHandler;

["fza_engineFire", {
    params ["_heli", "_location"];

    //If the effects are already present, don't overwrite
    if (_heli getVariable [format ["fza_ah64_fire_%1_fx", _location], []] isNotEqualTo []) exitWith {};
    private _side = [];
    private _sidef = [];
    private _mag = "";
    private _audio1 = "";
    switch _location do {
        case "right": {
            _side = [1.2, -0.8, -1.25];
            _sidef = [1.2, -0.6, -1.25];
            _mag = "fza_ah64_e2_fire";
        };
        case "left": {
            _side = [-1, -0.8, -1.25];
            _sidef = [-1, -0.6, -1.25];
            _mag = "fza_ah64_e1_fire";
        };
        case "apu": {
            _side = [0, -0.8, -1.25];
            _sidef = [0, 0.2, -1.25];
            _mag = "fza_ah64_apu_fire";
        };
    };

    private _smokefx = "#particlesource" createVehicleLocal getpos _heli;
    _smokefx attachto[_heli, [0, 0, 0]];

    private _firefx = "#particlesource" createVehicleLocal getpos _heli;
    _firefx attachto[_heli, [0, 0, 0]];

    _smokefx setParticleCircle[0, [0, 0, 0]];
    _smokefx setParticleRandom[0, [0.25, 0.25, 0], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
    _smokefx setParticleParams[["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 1, 3, _side, [0, 0, 1], 0, 10, 7.9, 0.066, [2, 3, 4], [
        [0.1, 0.1, 0.1, 1],
        [0.2, 0.2, 0.2, 0.5],
        [0.3, 0.3, 0.3, 0]
    ], [0.125], 1, 0, "", "", _heli];
    _smokefx setDropInterval 0.03;

    _firefx setParticleCircle[0, [0, 0, 0]];
    _firefx setParticleRandom[0.5, [0.25, 0.25, 0.1], [0, 0, 1], 0, 0.5, [0, 0, 0, 0], 0, 0];
    _firefx setDropInterval 0.01;
    _firefx setParticleParams[["\A3\data_f\ParticleEffects\Universal\Universal", 16, 10, 32, 1], "", "Billboard", 1, 0.2, _sidef, [0, 0, 0.5], 5, 1, 0.9, 0.3, [1], [
        [1, 1, 1, 1],
        [1, 1, 1, 0.75],
        [1, 1, 1, 0]
    ], [0.5, 0.5, 0], 0.5, 0.5, "", "", _heli];

    _heli setVariable [format ["fza_ah64_fire_%1_fx", _location], [_smokefx, _firefx]];
}] call CBA_fnc_addEventHandler;

["fza_engineFireOut", {
    params ["_heli", "_location"];

    private _fx = _heli getVariable [format ["fza_ah64_fire_%1_fx", _location], []];
    if (count _fx != 2) exitWith {};

    detach (_fx # 0);
    detach (_fx # 1);

    deletevehicle (_fx # 0);
    deletevehicle (_fx # 1);

    _heli setVariable [format ["fza_ah64_fire_%1_fx", _location], []];
}] call CBA_fnc_addEventHandler;