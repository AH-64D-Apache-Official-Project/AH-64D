params ["_heli", "_disp"];

_ctrl = _disp displayCtrl 960;

if (isNull _ctrl) exitWith {};

private _crewStation = "plt";
if (driver vehicle player == player) then { _crewStation = "plt"; systemChat format ["%1", _crewStation]; };
if (gunner vehicle player == player) then { _crewStation = "cpg"; systemChat format ["%1", _crewStation]; };

private _isHeadsDown = false;
if (cameraView == "GUNNER" && player == gunner _heli) then { _isHeadsDown = true; };

systemChat format ["%1", [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable];

private _model = createHashMapFromArray
    [   ["base", createHashMapFromArray
            [ ["crewStation",    _crewStation]
            , ["sightSelect",    [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable]
            , ["nvsModeNorm",    _heli getVariable "fza_ah64_nvsModeSwitchNorm"]
            , ["selSymb",        _heli getVariable "fza_ah64_hmdfsmode"]
            , ["wpnWas",         _heli getVariable "fza_ah64_was"]
            , ["heading",        direction _heli]
            , ["gndSpd",         _heli getVariable "fza_sfmplus_gndSpeed"]
            , ["radAlt",         ([_heli] call fza_sfmplus_fnc_getAltitude) select 1]
            , ["ownerCue",       "-OWNER-CUE-"]
            , ["wpnInhibit",     "WEAPON-INHIB"]
            , ["sightStatus",    "SIGHT-STATUS"]
            , ["rngAndRngSrc",   1234]
            , ["wpnControl",     "WPNCT"]
            , ["acqSelStatus",   "ACQS"]
            , ["wpnStatus",      "WEAPONSTATUS"]
        ]]
    ,   ["flightFormat", createHashMapFromArray
            [ ["pitchBias", 5]
            , ["vel",       [(_heli getVariable "fza_sfmplus_velModelSpaceNoWind") select 0, (_heli getVariable "fza_sfmplus_velModelSpaceNoWind") select 1]]
            , ["accel",     [_heli getVariable "fza_sfmplus_accelX", _heli getVariable "fza_sfmplus_accelY"]]
            , ["fpv",       [worldToScreen aslToAgl(aglToAsl positionCameraToWorld[0,0,0] vectorAdd (_heli getVariable "fza_sfmplus_velWorldSpaceNoWind"))]]
            , ["pitch",     (_heli call BIS_fnc_getPitchBank) select 0]
            , ["roll",      (_heli call BIS_fnc_getPitchBank) select 1]
            , ["sideslip",  fza_ah64_sideslip]
            , ["roc",       _heli getVariable "fza_sfmplus_velClimb"]
            , ["tas",       _heli getVariable "fza_sfmplus_vel3D"]
            , ["baroAlt",   ([_heli] call fza_sfmplus_fnc_getAltitude) select 0]
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
    ,   [ "gunnerFormat", createHashMapFromArray
            [ ["isHeadsDown",   _isHeadsDown]
            , ["sensorSelect",  _heli getVariable "fza_ah64_tadsSelectedSensor"]    //"FLIR", "DTV", "DVO"
            , ["fov",           _heli getVariable "fza_ah64_tadsSelectedFov"]       //0 = W, 1 = M, 2 = N, 3 = Z
        ]]
    ,   ["sensor", createHashMapFromArray
        [
        ]]
    ];
_ctrl ctrlWebBrowserAction ["ExecJS", Format ["updateModel(%1)", toJSON _model]];

private _headTrackerPos = _heli modelToWorldVisual [0, 1000000, 0];

if (isNull (_disp getVariable ["fza_ihadss_icon_headtracker", controlNull])) then {
    _disp setVariable ["fza_ihadss_icon_headtracker", [_disp, "headtracker"] call fza_ihadss_fnc_symbologyStaticCreate];
};

private _headTrackerCtrl = _disp getVariable "fza_ihadss_icon_headtracker";

[_headTrackerCtrl, _headTrackerPos] call fza_ihadss_fnc_symbologyStaticSetPos;
