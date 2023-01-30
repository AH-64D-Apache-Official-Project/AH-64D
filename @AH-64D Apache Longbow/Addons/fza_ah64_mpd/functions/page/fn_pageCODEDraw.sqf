#include "\fza_ah64_mpd\headers\chan.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli", "_mpdIndex", "_state", "_persistState"];

private _varMapping = createHashMapFromArray
    [ ["LRFD", "fza_ah64_laserLRFDCode"]
    , ["LST" , "fza_ah64_laserLSTCode"]
    ];

private _varName = _varMapping get (_persistState get "set");

private _codeToDisplay = _heli getVariable _varName;

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_CODE_SELECTED), CODES find _codeToDisplay];

private _set = switch (_persistState get "set") do {
    case "LRFD": {0};
    case "LST": {1};
};

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_CODE_SET), _set];

[_heli, _mpdIndex] call fza_mpd_fnc_chanShowFrequencies;