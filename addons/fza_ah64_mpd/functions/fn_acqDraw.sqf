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
