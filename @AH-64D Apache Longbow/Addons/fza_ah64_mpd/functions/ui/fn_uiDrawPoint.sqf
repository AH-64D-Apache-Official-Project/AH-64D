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

private _yScale = (4/3) / (getResolution # 4);
private _yOffset = (1-_yScale)/2;

if (_heli turretLocal [-1]) then {
    _heli animateSource ["plt_uiscale", _yScale];
};
if (_heli turretLocal [0]) then {
    _heli animateSource ["cpg_uiscale", _yScale];
};

private _iconType = _dmsPoint # POINT_GET_ICON_TYPE;
// If an icon is now a different type, wipe the existing ctrls to rebuild
if (!("type" in _ctrlPoint) || {_iconType isNotEqualTo (_ctrlPoint get "type")}) then {
    {if (typeName _y == "CONTROL") then {ctrlDelete _y; _ctrlPoint deleteAt _x};} forEach _ctrlPoint;
    _ctrlPoint set ["type", _iconType];
};

([_dmsPoint # POINT_GET_IDENT] call fza_dms_fnc_pointGetIdentDetails)
    params ["_iconTex", "_iconTex2", "_iconSize", "_iconColor", "_textA", "_textB"];

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

private _colorMap = createHashMapFromArray
    [ [MPD_ICON_COLOR_GREEN,  [0.0, 1.0, 0.5, 1]]
    , [MPD_ICON_COLOR_BLUE,   [0.4, 0.6, 1.0, 1]]
    , [MPD_ICON_COLOR_YELLOW, [1.0, 1.0, 0.0, 1]]
    , [MPD_ICON_COLOR_RED,    [1.0, 0.0, 0.2, 1]]
    ];

private _color = _colorMap get _iconColor;

// Draw icons
private _iconCtrl = [_display, _ctrlPoint, "icon", "RscPicture"] call _getOrCreateCtrl;
hintSilent format ["_armaPos %4
                    \n_uiCtr %5
                    \n_iconSize %6
                    \n_uiTop %1
                    \n_yOffset %2
                    \n_yScale %3", _uiTop, _yOffset, _yScale, _armaPos, _uiCtr, _iconSize];
_iconCtrl ctrlSetPosition [_uiTop # 0, _yOffset + _uiTop # 1 * _yScale, _iconSize, _iconSize * _yScale];
_iconCtrl ctrlSetTextColor _color;
_iconCtrl ctrlSetText (_iconTex);
_iconCtrl ctrlCommit 0;

private _iconCtrl2 = [_display, _ctrlPoint, "icon2", "RscPicture"] call _getOrCreateCtrl;
_iconCtrl2 ctrlSetPosition [_uiTop # 0, _yOffset + _uiTop # 1 * _yScale, _iconSize, _iconSize * _yScale];
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
        , _yOffset + (_uiTop # 1 + (_textOffset # 1 * _iconSize) + _textYOffset - 0.5) * _yScale
        , 1
        , 1 * _yScale
        ];
    _textCtrl ctrlSetTextColor _color;
    _textCtrl ctrlSetFontHeight (TEXT_HEIGHT*_yScale);
    _textCtrl ctrlSetText ([_dmsPoint, _text] call fza_dms_fnc_pointFillIconText);
    _textCtrl ctrlCommit 0;
};

["textA", _textA] call _drawText;
["textB", _textB] call _drawText;
