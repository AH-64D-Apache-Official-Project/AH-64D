class Cfg3DEN {
    class Attributes {
        class Default; // Empty template with pre-defined width and single line height
        class Combo: Default {};
        class fza_dms_ident : Combo {
            attributeLoad = "\
                private _ctrl = _this controlsGroupCtrl 100; \
                private _allowedIconTypes = getArray (_config >> 'fza_point_type'); \
                diag_log format ['Allowed Icon Types: %1, Config: %2', _allowedIconTypes, _config]; \
                { \
                    private _index = _ctrl lbAdd (configName _x regexReplace ['Icon', '']);\
                    _ctrl lbSetPicture [_index, getText (_x >> 'tex')]; \
                    _ctrl lbSetData [_index, configName _x]; \
                    _ctrl lbSetPictureColor [_index, getArray (_x >> 'color')]; \
                } forEach (""getNumber (_x >> 'type') in _allowedIconTypes"" configClasses (configFile >> 'FzaIconTypes')); \
                \
                _ctrl lbSortBy ['TEXT']; \
                for '_i' from 0 to (lbSize _ctrl - 1) do {\
                    if (_value == _ctrl lbText _i) then {_ctrl lbSetCurSel _i;}; \
                }; \
            ";
            attributeSave = "\
                private _ctrl = _this controlsGroupCtrl 100; \
                _ctrl lbData lbcursel _ctrl; \
            ";
        };
    };
};