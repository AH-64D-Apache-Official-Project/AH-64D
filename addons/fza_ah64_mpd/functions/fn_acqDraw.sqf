 /* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_acqDraw

Description:
    Draw the acquisition source details

Parameters:
    _heli - the apache to show the correct values for.
    _mpdIndex - the MPD

Returns:
    Nothing

Author:
    mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_mpdIndex", "_floatIndex", "_stringIndex"];

private _curTurret = [_heli] call fza_fnc_currentTurret;
private _acq = [_heli, _curTurret] call fza_fnc_targetingCurAcq;

_heli setUserMFDText [MFD_INDEX_OFFSET(_stringIndex), _acq];
_heli setUserMFDValue [MFD_INDEX_OFFSET(_floatIndex), count _acq];

// The ACQ list: the sources this crew station can select, the selected one boxed
private _seat    = ["plt", "cpg"] select (_curTurret isEqualTo [0]);
private _options = [_heli, _seat] call fza_fnc_targetingAcqOptions;
{
    _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ACQ_OPT_PHS + _forEachIndex), [0, [1, 2] select (_x == _acq)] select (_x in _options)];
} forEach ["PHS", "GHS", "SKR", "RFI", "FCR", "FXD", "TADS"];
// B4, the crew station's TRN point from CAQ (T55 for the pilot, T56 for the CPG), if it has one
private _trn = [POINT_TYPE_TG, [POINT_INDEX_TG_TRN_PLT, POINT_INDEX_TG_TRN_CPG] select (_seat == "cpg")];
private _hasTrn = !isNil {[_heli, _trn, POINT_GET_TYPE] call fza_dms_fnc_pointGetValue};
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ACQ_OPT_TRN), [0, [1, 2] select ((_trn call fza_dms_fnc_pointToString) == _acq)] select _hasTrn];
// B5, the crew station's coordinate point
private _point = _heli getVariable ["fza_ah64_acqPoint_" + _seat, ACQ_POINT_NONE];
_heli setUserMFDText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ACQ_POINT), _point];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_ACQ_OPT_POINT), [1, 2] select (_point == _acq)];
