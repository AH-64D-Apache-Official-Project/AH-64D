params ["_heli", "_state"];

#define SCALE_METERS_FEET 3.28084

private _freeTextCallback = {

    params ["_input", "_state"];
    _state set ["wptAddFree", _input];
    private _gridCallback = {

        params ["_input", "_state"];
        _state set ["wptAddGrid", _input];
        private _altitudeCallback = {
            params ["_input", "_state", "_heli"];
            private _alt = _input / SCALE_METERS_FEET;
            [_heli, _state, _state get "wptAddFree", _state get "wptAddGrid", _alt] call (_state get "wptEnterCallback");
        };
        systemChat format ["DefaultHeight %1", (_state get "wptDefaultHeight")];
        private _alt = _state getOrDefault ["wptDefaultHeight", getTerrainHeightASL _input max 0];
        [_heli, "ALTITUDE", _altitudeCallback, fza_ku_fnc_checkerInteger, _state, str round (_alt * SCALE_METERS_FEET), "point add"] call fza_ku_fnc_addPrompt;
    };
    [_heli, "GRID", _gridCallback, fza_ku_fnc_checkerGrid, _state, _state get "wptDefaultGrid", "point add"] call fza_ku_fnc_addPrompt;
};
[_heli, "FREE", _freeTextCallback, fza_ku_fnc_checkerFree, _state, _state get "wptDefaultFree", "point add"] call fza_ku_fnc_addPrompt;