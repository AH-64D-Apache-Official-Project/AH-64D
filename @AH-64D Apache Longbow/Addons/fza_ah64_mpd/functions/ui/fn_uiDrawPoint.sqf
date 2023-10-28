#include "\fza_ah64_dms\headers\constants.h"
#define TEXT_HEIGHT 0.035
disableSerialization;
params
    ["_heli"
    , "_display"
    , "_dmsPoint"
    , "_ctrlPoint"
    , ["_scale", -1]
    , ["_heliCtr", [0.5, 0.75]]
    , ["_heading", direction (_this # 0)]
    , ["_heliPos", getPosASL (_this # 0)]
    ];

private _getOrCreateCtrl = {
    params ["_display", "_ctrlPoint", "_key", "_class"];

    if (!(_key in _ctrlPoint)) then {
        _ctrlPoint set [_key, _display ctrlCreate [_class, -1]];
    };

    if (ctrlClassName (_ctrlPoint get _key) != _class) then {
        ctrlDelete (_ctrlPoint get _key);
        _ctrlPoint set [_key, _display ctrlCreate [_class, -1]];
    };

    _ctrlPoint get _key
};

([_dmsPoint # POINT_GET_IDENT] call fza_dms_fnc_pointGetIdentDetails)
    params ["_iconTex", "_iconTex2", "_iconSize", "_color", "_textA", "_textB"];

//Arma pos
private _armaPos = _dmsPoint # POINT_GET_ARMA_POS;
private _uiCtr   = _armaPos;
if (_dmsPoint # 0 == MPD_POSMODE_WORLD) then {
    private _theta = [_heli, _heliPos # 0, _heliPos # 1,  _armaPos # 0, _armaPos # 1, _heading] call fza_fnc_relativeDirection;
    private _r = _heliPos distance2D _armaPos;
    private _x = _heliCtr # 0 + sin _theta * (_r * _scale);
    private _y = _heliCtr # 1 - cos _theta * (_r * _scale);
    _uiCtr = [_x, _y];
};
private _uiTop = [_uiCtr # 0 - (0.5*_iconSize), _uiCtr # 1 - (0.5*_iconSize)];

// Draw icons
private _iconCtrl = [_display, _ctrlPoint, "icon", "RscPicture"] call _getOrCreateCtrl;
_iconCtrl ctrlSetPosition [_uiTop # 0, _uiTop # 1, _iconSize, _iconSize];
_iconCtrl ctrlSetTextColor _color;
_iconCtrl ctrlSetText (_iconTex);
_iconCtrl ctrlCommit 0;

private _iconCtrl2 = [_display, _ctrlPoint, "icon2", "RscPicture"] call _getOrCreateCtrl;
_iconCtrl2 ctrlSetPosition [_uiTop # 0, _uiTop # 1, _iconSize, _iconSize];
_iconCtrl2 ctrlSetTextColor _color;
_iconCtrl2 ctrlSetText (_iconTex2);
_iconCtrl2 ctrlCommit 0;

private _drawText = {
    params ["_textPrefix", "_textData"];
    _textData params ["_text", "_textOffset", "_textXAlign", "_textYAlign"];
    private _textClass = "FzaMpdRscText" + _textXAlign;
    private _textCtrl = [_display, _ctrlPoint, _textPrefix, _textClass] call _getOrCreateCtrl;
    private _xOffset = 0;
    switch _textXAlign do {
        case "right": {_xOffset = -1;};
        case "center": {_xOffset = -0.5};
    };
    private _textYOffset = 0;
    switch _textYAlign do {
        case "top": {_textYOffset = TEXT_HEIGHT * 0.5};
        case "bottom": {_textYOffset = TEXT_HEIGHT * -0.5};
    };
    _textCtrl ctrlSetPosition
        [ _uiTop # 0 + (_textOffset # 0 * _iconSize) + _xOffset
        , (_uiTop # 1 + (_textOffset # 1 * _iconSize) + _textYOffset - 0.5)
        , 1
        , 1
        ];
    _textCtrl ctrlSetTextColor _color;
    _textCtrl ctrlSetFontHeight TEXT_HEIGHT;
    _textCtrl ctrlSetText ([_dmsPoint, _text] call fza_dms_fnc_pointFillIconText);
    _textCtrl ctrlCommit 0;
};

["textA", _textA] call _drawText;
["textB", _textB] call _drawText;
