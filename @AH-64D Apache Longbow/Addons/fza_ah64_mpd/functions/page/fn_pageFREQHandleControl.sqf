params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

#define SET_CHANNEL_CODE(code) private _callback = { \
        params ["_input", "", "_heli"]; \
        (_heli getVariable "fza_ah64_laserChannelIndex") set [code,_input]; \
        _heli setVariable ["fza_ah64_laserChannelIndex", _heli getVariable "fza_ah64_laserChannelIndex", true]; \
    }; \
    [_heli, "CODE", _callback, fza_ku_fnc_checkerCode, _state, ""] call fza_ku_fnc_addPrompt;


switch (_control) do {
    case "t1": {
        [_heli, _mpdIndex, "CHAN"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t4": {
        [_heli, _mpdIndex, "CODE"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t5": {
        [_heli, _mpdIndex, "CODE"] call fza_mpd_fnc_setCurrentPage;
    };

    // Missile channel selections
    case "l1": { SET_CHANNEL_CODE("A") };
    case "l2": { SET_CHANNEL_CODE("B") };
    case "l3": { SET_CHANNEL_CODE("C") };
    case "l4": { SET_CHANNEL_CODE("D") };
    case "l5": { SET_CHANNEL_CODE("E") };
    case "l6": { SET_CHANNEL_CODE("F") };
    case "b2": { SET_CHANNEL_CODE("G") };
    case "b3": { SET_CHANNEL_CODE("H") };
    case "b4": { SET_CHANNEL_CODE("J") };
    case "b5": { SET_CHANNEL_CODE("K") };
    case "r6": { SET_CHANNEL_CODE("L") };
    case "r5": { SET_CHANNEL_CODE("M") };
    case "r4": { SET_CHANNEL_CODE("N") };
    case "r3": { SET_CHANNEL_CODE("P") };
    case "r2": { SET_CHANNEL_CODE("Q") };
    case "r1": { SET_CHANNEL_CODE("R") };

    case "b1": {
        [_heli, _mpdIndex, "WPN"] call fza_mpd_fnc_setCurrentPage;
    };
}