/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_shotIdentFromFcrData

Description:
    Builds a DMS shot ident string from a single FCR target data row.

Parameters:
    _fcrData - [_pos, _type, _moving, _target, _aziAngle, _elevAngle, _range]

Returns:
    Ident string, e.g. "FCR_WHEEL_LOBL"

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_fcrData"];

if (_fcrData isEqualTo [] || {count _fcrData < 7}) exitWith {"FCR_UNK_LOAL"};

_fcrData params ["", "_type", "_moving", "", "", "", "_range"];

private _unitType = "UNK";
switch (_type) do {
    case FCR_TYPE_UNKNOWN:    { _unitType = "UNK";   };
    case FCR_TYPE_WHEELED:    { _unitType = "WHEEL"; };
    case FCR_TYPE_HELICOPTER: { _unitType = "HELI";  };
    case FCR_TYPE_FLYER:      { _unitType = "FLYER"; };
    case FCR_TYPE_TRACKED:    { _unitType = "TRACK"; };
    case FCR_TYPE_ADU:        { _unitType = "ADU";   };
};

private _unitStatus = "LOAL";
if ((_moving && (_range >= FCR_LIMIT_MIN_RANGE && _range <= FCR_LIMIT_MOVING_RANGE)) || _unitType == "FLYER") then {
    _unitStatus = "MOVE";
} else {
    if (_range >= FCR_LIMIT_MIN_RANGE && _range <= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) then {
        _unitStatus = "LOBL";
    };
    if (_range > FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE && _range <= FCR_LIMIT_STATIONARY_RANGE) then {
        _unitStatus = "LOAL";
    };
};

["FCR", _unitType, _unitStatus] joinString "_"
