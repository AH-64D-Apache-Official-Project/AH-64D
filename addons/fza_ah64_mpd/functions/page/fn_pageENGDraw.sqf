#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
params ["_heli", "_mpdIndex"];


private _rotorRpm = ([_heli] call bmkhs_fnc_stateRtrRpm) * 100;

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_NR), round _rotorRpm];
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NR), _rotorRpm toFixed 0];

// Limits come from HeliSim's engine config, the single engine sets once one engine carries the load.
// Below 90% Nr torque is limited to 70%, and below 50% Nr to 30%.
private _engines   = _heli getVariable "bmkhs_engines";
private _singleEng = _heli getVariable ["bmkhs_isSingleEng", false];
private _tqLowNr   = switch (true) do {
    case (_rotorRpm < 50): {[[0.30, 0]]};
    case (_rotorRpm < 90): {[[0.70, 0]]};
    default {[]};
};
private _tqLimits  = {
    params ["_engine"];
    [_engine get (["tqLimits", "tqLimitsSe"] select _singleEng), _tqLowNr] select (_tqLowNr isNotEqualTo [])
};
private _tgtKey    = ["tgtLimits", "tgtLimitsSe"] select _singleEng;

// 0 up to a set's first limit, 2 past its last, 1 between
private _range = {
    params ["_value", "_limits"];
    if (_value > ((_limits select -1) # 0)) exitWith {2};
    [0, 1] select (_value > ((_limits # 0) # 0))
};
// Time left in a timed range as M:SS, blank outside one
private _timer = {
    params ["_left"];
    if (_left < 0) exitWith {""};
    private _s = ceil _left;
    format ["%1:%2", floor (_s / 60), [_s mod 60, 2] call CBA_fnc_formatNumber]
};

private _np          = _heli getVariable "bmkhs_engPctNp";
private _ng          = _heli getVariable "bmkhs_engPctNg";
private _tgt         = _heli getVariable "bmkhs_engTgt";
private _tq          = _heli getVariable "bmkhs_engPctTq";
private _oil         = _heli getVariable "bmkhs_engOilPsi";
private _engStates   = _heli getVariable "bmkhs_engState";
private _limitTimers = _heli getVariable "bmkhs_engLimitTimers";
private _tqTimers    = _heli getVariable "bmkhs_engTqTimer";

for "_i" from 0 to 1 do {
    private _engine = _engines # _i;
    private _engNp  = (_np # _i) * 100;
    private _engNg  = (_ng # _i) * 100;
    private _engTgt = _tgt # _i;
    private _engTq  = [(_tq # _i) * 100, 0] select (_engNp <= 37);

    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TORQUE_1 + _i), round _engTq];
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_TORQUE_1 + _i), _engTq toFixed 0];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TORQUE_RANGE_1 + _i), [_engTq / 100, [_engine] call _tqLimits] call _range];

    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TGT_1 + _i), round _engTgt];
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_TGT_1 + _i), _engTgt toFixed 0];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TGT_RANGE_1 + _i), [_engTgt, _engine get _tgtKey] call _range];

    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_NP_1 + _i), round _engNp];
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NP_1 + _i), _engNp toFixed 0];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_NP_RANGE_1 + _i), [_engNp / 100, _engine get "npLimits"] call _range];

    // Ng is also red below its minimum while the engine runs
    private _ngRange = [[_engNg / 100, _engine get "ngLimits"] call _range, 2] select ((_engStates # _i) == "ON" && {_engNg / 100 < (_engine get "ngMin")});
    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NG_1 + _i), _engNg toFixed 1];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_NG_RANGE_1 + _i), _ngRange];

    _heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_OIL_PSI_1 + _i), ((_oil # _i) * 100) toFixed 0];
};

// Torque, TGT and Ng have one timer each. It takes the place of the engine number under the engine that is over its
// limit, or sits between the two showing the shorter time when both are. Np has a timer for each engine.
private _engTimers = {
    params ["_left1", "_left2"];
    ([0, 1] select (_left1 >= 0)) + ([0, 2] select (_left2 >= 0))
};
{
    _x params ["_left1", "_left2", "_atInd", "_textInd"];
    private _at = [_left1, _left2] call _engTimers;
    _heli setUserMFDValue [_atInd, _at];
    _heli setUserMFDText  [MFD_INDEX_OFFSET(_textInd), [[-1, _left1, _left2, _left1 min _left2] # _at] call _timer];
} forEach [
    [_tqTimers # 0, _tqTimers # 1, MFD_IND_ENG_TORQUE_TIMER_AT, MFD_TEXT_IND_ENG_TORQUE_TIMER],
    [(_limitTimers # 0) # 2, (_limitTimers # 1) # 2, MFD_IND_ENG_TGT_TIMER_AT, MFD_TEXT_IND_ENG_TGT_TIMER],
    [(_limitTimers # 0) # 1, (_limitTimers # 1) # 1, MFD_IND_ENG_NG_TIMER_AT, MFD_TEXT_IND_ENG_NG_TIMER]
];
_heli setUserMFDValue [MFD_IND_ENG_NP_TIMER_AT, [(_limitTimers # 0) # 0, (_limitTimers # 1) # 0] call _engTimers];
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NP_TIMER_1), [(_limitTimers # 0) # 0] call _timer];
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_NP_TIMER_2), [(_limitTimers # 1) # 0] call _timer];

// The red bar marks a set's maximum; a yellow bar marks where each timed range below it starts
private _tqMarks  = [_engines # 0] call _tqLimits;
private _tgtMarks = (_engines # 0) get _tgtKey;
private _starts   = {
    params ["_limits"];
    ((_limits select [0, count _limits - 1]) select {(_x # 1) > 0}) apply {_x # 0}
};
private _tqStarts  = [_tqMarks] call _starts;
private _tgtStarts = [_tgtMarks] call _starts;
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TORQUE_BAR), ((_tqMarks select -1) # 0) * 100];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TGT_BAR), (_tgtMarks select -1) # 0];
for "_i" from 0 to 1 do {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TORQUE_SUB_1 + _i), (_tqStarts param [_i, 0]) * 100];
};
for "_i" from 0 to 3 do {
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_TGT_SUB_1 + _i), _tgtStarts param [_i, 0]];
};

private _engineStarted = 0;

if (_engStates # 0 in ["STARTING", "STARTED"]) then {
    _engineStarted = 1;
};

if (_engStates # 1 in ["STARTING", "STARTED"]) then {
    _engineStarted = 2;
};

private _pagemode = [2,1] select ([_heli] call bmkhs_fnc_stateOnGround);
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_START), _engineStarted];
private _wcas = [_heli] call fza_fnc_coreGetWCAs;
_wcas = _wcas select {!(WCA_ADVISORY in _x)};
private _procedure = [_heli, (_wcas select {_x # 0 == WCA_WARNING}) apply {_x # 1}] call fza_mpd_fnc_pageENGProcedure;
_wcas resize [5, [0," "]];
if (_wcas#0#1 isNotEqualTo " ") then {_pagemode = 3;};
if (_procedure isNotEqualTo []) then {
    _pagemode = 4;
    _procedure params ["_title", "_steps"];
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_EMER_TITLE), _title];
    _heli setUserMFDValue [MFD_IND_ENG_EMER_TITLE_LEN, count _title];
    for "_i" from 0 to 6 do {
        _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_EMER_1 + _i), _steps param [_i, ""]];
    };
};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_MODE), _pagemode];
for "_x" from 0 to 4 do {
    _heli setUserMFDText [MFD_INDEX_OFFSET(MFD_IND_ENG_WCA_1 + _x), _wcas#_x#1];
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ENG_WCA_1 + _x), _wcas#_x#0];
};

//Hydraulics
private _priHydPSI       = round(_heli getVariable "bmkhs_priHydPsi");
private _priHydPSI_text  = format["%1", [str _priHydPSI, 4] call fza_fnc_padString];
private _utilHydPSI      = round(_heli getVariable "bmkhs_utilHydPsi");
private _utilHydPSI_text = format["%1", [str _utilHydPSI, 4] call fza_fnc_padString];
private _accHydPSI       = round((_heli getVariable "bmkhs_accHydPsi") / 10) * 10;
private _accHydPSI_text  = format["%1", [str _accHydPSI, 4] call fza_fnc_padString];

_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_PRI_HYD_PSI),  _priHydPSI_text];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_UTIL_HYD_PSI), _utilHydPSI_text];
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_ENG_ACC_HYD_PSI),  _accHydPSI_text];

[_heli, _mpdIndex, MFD_IND_ENG_ACQ_BOX, MFD_TEXT_IND_ENG_ACQ_SRC] call fza_mpd_fnc_acqDraw;
