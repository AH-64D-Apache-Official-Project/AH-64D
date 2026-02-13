params ["_heli", "_disp"];

_ctrl = _disp displayCtrl 960;

if (isNull _ctrl) exitWith {};

private _model = createHashMapFromArray
    [ ["flight", createHashMapFromArray
        [ ["pitchBias", 5]
        , ["selSymb",   _heli getVariable "fza_ah64_hmdfsmode"]
        , ["vel",       [(_heli getVariable "fza_sfmplus_velModelSpaceNoWind") select 0, (_heli getVariable "fza_sfmplus_velModelSpaceNoWind") select 1]]
        , ["accel",     [_heli getVariable "fza_sfmplus_accelX", _heli getVariable "fza_sfmplus_accelY"]]
        , ["fpv",       [worldToScreen aslToAgl(aglToAsl positionCameraToWorld[0,0,0] vectorAdd (_heli getVariable "fza_sfmplus_velWorldSpaceNoWind"))]]
        , ["pitch",     (_heli call BIS_fnc_getPitchBank) select 0]
        , ["roll",      (_heli call BIS_fnc_getPitchBank) select 1]
        , ["heading",   direction _heli]
        , ["sideslip",  fza_ah64_sideslip]
        , ["roc",       _heli getVariable "fza_sfmplus_velClimb"]
        , ["tas",       _heli getVariable "fza_sfmplus_vel3D"]
        , ["gndSpd",    _heli getVariable "fza_sfmplus_gndSpeed"]
        , ["baroAlt",   ([_heli] call fza_sfmplus_fnc_getAltitude) select 0]
        , ["radAlt",    ([_heli] call fza_sfmplus_fnc_getAltitude) select 1]
        , ["engTq",     ((_heli getVariable "fza_sfmplus_engPctTQ" select 0) * 100) max ((_heli getVariable "fza_sfmplus_engPctTQ" select 1) * 100)]
        , ["engTgt",    (_heli getVariable "fza_sfmplus_engTGT" select 0) max (_heli getVariable "fza_sfmplus_engTGT" select 1)]
        , ["curWpt",    ([_heli] call fza_mpd_fnc_tsdWaypointStatusText) select 0]
        , ["dstToWpt",  ([_heli] call fza_mpd_fnc_tsdWaypointStatusText) select 2]
        , ["timeToWpt", ([_heli] call fza_mpd_fnc_tsdWaypointStatusText) select 3]
        , ["attHoldAct", _heli getVariable "fza_ah64_attHoldActive"]
        , ["altHoldAct", _heli getVariable "fza_ah64_altHoldActive"]
        , ["loAltWarn",  33]
        , ["hiAltWarn",  200]
        ]]
    , ["sensor", createHashMapFromArray
       [
       ]]
    , ["ihadssHadFields", createHashMapFromArray
       [ ["ownerCue",       "-OWNER-CUE-"]
       , ["wpnInhibit",     "WEAPON-INHIB"]
       , ["sightSelStatus", "SSS--L"]
       , ["sighStatus",     "SIGHT-STATUS"]
       , ["rngAndRngSrc",   1000]
       , ["wpnControl",     "WPNCT"]
       , ["acqSelStatus",   "ACQS"]
       , ["wpnStatus",      "WEAPONSTATUS"]
       ]]
    ];
_ctrl ctrlWebBrowserAction ["ExecJS", Format ["updateModel(%1)", toJSON _model]];

private _headTrackerPos = _heli modelToWorldVisual [0, 1000000, 0];

if (isNull (_disp getVariable ["fza_ihadss_icon_headtracker", controlNull])) then {
    _disp setVariable ["fza_ihadss_icon_headtracker", [_disp, "headtracker"] call fza_ihadss_fnc_symbologyStaticCreate];
};

private _headTrackerCtrl = _disp getVariable "fza_ihadss_icon_headtracker";

[_headTrackerCtrl, _headTrackerPos] call fza_ihadss_fnc_symbologyStaticSetPos;
