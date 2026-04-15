params ["_heli", "_state"];

#define SCALE_METERS_FEET 3.28084

private _identChecker = {
    params ["_input", "_state"];
    [_state get "addType", _input] call fza_dms_fnc_pointIsValidIdent;
};

private _identCallback = {
    params ["_input", "_state"];
    _state set ["addIdent", _input];
    private _freeTextCallback = {
        params ["_input", "_state"];
        _state set ["addFree", _input];
        private _gridCallback = {

            params ["_input", "_state"];
            _state set ["addGrid", _input];
            private _altitudeCallback = {
                params ["_input", "_state", "_heli"];
                private _alt = _input / SCALE_METERS_FEET;
                [_heli, _state, _state get "addIdent", _state get "addFree", _state get "addGrid", _alt] call (_state get "enterCallback");
                [] call fza_ku_fnc_stopInput;
            };
            private _alt = _state getOrDefault ["defaultHeight", getTerrainHeightASL _input max 0];
            [_heli, "ALTITUDE", _altitudeCallback, fza_ku_fnc_checkerInteger, _state, str round (_alt * SCALE_METERS_FEET), "point add"] call fza_ku_fnc_addPrompt;
        };
        [_heli, "GRID", _gridCallback, fza_ku_fnc_checkerGrid, _state, _state get "defaultGrid", "point add"] call fza_ku_fnc_addPrompt;
    };
    [_heli, "FREE", _freeTextCallback, fza_ku_fnc_checkerFree, _state, _state get "defaultFree", "point add"] call fza_ku_fnc_addPrompt;
};
[_heli, "IDENT", _identCallback, _identChecker, _state, _state get "defaultIdent", "point add"] call fza_ku_fnc_addPrompt;
