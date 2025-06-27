params ["_heli", "_ctrl"];


private _model = createHashMapFromArray
    [ ["flight", createHashMapFromArray
        [ ["trim", fza_ah64_sideslip]
        , ["vel", [0,0]]
        , ["accel", [0,0]]
        ]]
    , ["sensor", createHashMapFromArray
        [ ["headTracker", [_ctrl, _heli modelToWorldVisual [0, 1000000, 0]] call fza_ihadss_fnc_symbologyPosCoord]
        ]]
    ];

_ctrl ctrlWebBrowserAction ["ExecJS", Format ["updateModel(%1)", toJSON _model]];