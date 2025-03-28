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

[_heli, MFD_INDEX_OFFSET(_stringIndex), _acq] call fza_mpd_fnc_updateMfdText;
[_heli, MFD_INDEX_OFFSET(_floatIndex), count _acq] call fza_mpd_fnc_updateMfdValue;
