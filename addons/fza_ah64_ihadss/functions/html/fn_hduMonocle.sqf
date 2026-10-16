/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_hduMonocle

Description:
    Places the HDU monocle image with its lens centred on the LOS, using the
    clear lens variant while the PNVS picture is shown.

Parameters:
    _heli      - The helicopter
    _ctrl      - The monocle picture control
    _clearLens - True while the PNVS picture is shown

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _ctrl, true] call fza_ihadss_fnc_hduMonocle
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ihadss\headers\hdu.h"
params ["_heli", "_ctrl", "_clearLens"];

([_heli, false] call fza_ihadss_fnc_formatRect) params ["_rectX", "_rectY", "_rectW", "_rectH"];
private _rect = [_rectX + HDU_IMAGE_X / 640 * _rectW, _rectY + HDU_IMAGE_Y / 480 * _rectH, HDU_IMAGE_SIZE / 640 * _rectW, HDU_IMAGE_SIZE / 480 * _rectH];
if ((_ctrl getVariable ["fza_ihadss_rect", []]) isNotEqualTo _rect) then {
    _ctrl setVariable ["fza_ihadss_rect", _rect];
    _ctrl ctrlSetPosition _rect;
    _ctrl ctrlCommit 0;
    _ctrl ctrlSetTextColor [1, 1, 1, 1];
};

private _tex = ["\fza_ah64_ihadss\data\hdu\ihadss_hdu_ca.paa", "\fza_ah64_ihadss\data\hdu\ihadss_hdu_clear_ca.paa"] select _clearLens;
if (ctrlText _ctrl != _tex) then {_ctrl ctrlSetText _tex};
