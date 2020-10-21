_unit = _this select 0;
_str1 = "car";
_str2 = "tank";
_str3 = "ship";
_targxpos = 0;
_targypos = 0;
targhead = 0;
_alt = -5;

_unit setobjecttexture[303, "\fza_ah64_us\tex\mpd_tsd.paa"];

while {
    (alive _unit)
}
do {
    waitUntil {
        (driver _unit == player || gunner _unit == player) && (local _unit);
    };
    if (fza_ah64_agmode == 0) then {
        _str1 = "car";
        _str2 = "tank";
        _str3 = "ship";
        _alt = -5;
    } else {
        _alt = 10;
    };

    _targlist = _unit neartargets 10000;

    _checkarray = [];

    {
        _posobj = nearestobject(_x select 0);
        (driver _unit) reveal _posobj;
        if ((_posobj isKindOf "helicopter" || _posobj isKindOf "plane" || _posobj isKindOf _str1 || _posobj isKindOf _str2 || _posobj isKindOf _str3) && (alive _posobj) && ((getpos _posobj select 2) > (_alt))) then {
            _checkarray = _checkarray + [_posobj];
        };
    }
    foreach _targlist;

    {
        _reldir = ((getposatl _x select 0) - (getposatl _unit select 0)) atan2((getposatl _x select 1) - (getposatl _unit select 1));
        if (_reldir < 0) then {
            _reldir = _reldir + 360;
        };
        _theta = (360 + (_reldir - (direction _unit))) Mod 360;

        ////////MPD//////////
        if (fza_ah64_pr_mpd == "tsd") then {
            _unit setobjecttexture[303, "\fza_ah64_us\tex\mpd_tsd.paa"];
            _targnum = 269;
            _objnum = 0;

            if ((alive _x) && (_theta > 270 || _theta < 90)) then {
                _targnum = _targnum + 1;
                _objnum = _objnum + 1;
                if (_targnum < 302) then {
                    if (_x isKindOf "air" || _x isKindOf "tank" || _x isKindOf "car") then {
                        if (_x isKindOf "helicopter") then {
                            _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_hc.paa"];
                        };
                        if (_x isKindOf "plane") then {
                            _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_ac.paa"];
                        };
                        if (_x isKindOf "tank") then {
                            _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_tnk.paa"];
                        };
                        if (_x isKindOf "car") then {
                            _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_whl.paa"];
                        };
                    } else {
                        _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_gen.paa"];
                    };
                    if (_x == fza_ah64_mycurrenttarget) then {
                        if (_x isKindOf "helicopter") then {
                            _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_hc_trk.paa"];
                        };
                        if (_x isKindOf "plane") then {
                            _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_ac_trk.paa"];
                        };
                        if (_x isKindOf "tank") then {
                            _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_tnk_trk.paa"];
                        };
                        if (_x isKindOf "car") then {
                            _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_whl_trk.paa"];
                        };
                        if (!(_x isKindOf "car" || _x isKindOf "tank" || _x isKindOf "plane" || _x isKindOf "helicopter")) then {
                            _unit setobjecttexture[_targnum, "\fza_ah64_US\tex\ICONS\ah64_gen_trk.paa"];
                        };
                    };
                    _targhead = _theta;
                    if (_theta >= 180) then {
                        _targhead = _theta - 360;
                    } else {
                        _targhead = _theta;
                    };
                    _targxpos = ((sin _targhead) * ((_unit distance _x) * rangesetting)) + 0.5;
                    _targypos = ((cos _targhead) * ((_unit distance _x) * rangesetting)) + 0.1;
                    _objnumformat = format["%1", _objnum];
                    _objstrh = "mpd_pl_obj" + _objnumformat + "_h";
                    _objstrv = "mpd_pl_obj" + _objnumformat + "_v";
                    //player globalchat format ["TARGX %1 TARGY %2 TARG %3",_targxpos,_targypos,_objstrv];
                    _unit animate[_objstrh, _targxpos];
                    _unit animate[_objstrv, _targypos];
                };
            } else {

            };

            if (!(_x in fza_ah64_targetlist)) then {
                fza_ah64_targetlist = fza_ah64_targetlist + [_x];
            };
        };
    }
    foreach _checkarray;

    if (count fza_ah64_targetlist < 32 && fza_ah64_pr_mpd == "tsd") then {
        _targindi = 301;
        while {
            (_targindi > (count fza_ah64_targetlist + 269))
        }
        do {
            _unit setobjecttexture[_targindi, ""];
            _targindi = _targindi - 1;
            sleep 0.01;
        };
    };

    _unitrange = 12000;

    {
        _unitrange = ((_unit distance _x) * rangesetting);

        _reldir = ((getposatl _x select 0) - (getposatl _unit select 0)) atan2((getposatl _x select 1) - (getposatl _unit select 1));
        if (_reldir < 0) then {
            _reldir = _reldir + 360;
        };
        _theta = (360 + (_reldir - (direction _unit))) Mod 360;

        if (_theta > 90 && _theta < 270 && _unitrange > 0.1 || !(alive _x)) then {
            fza_ah64_targetlist = fza_ah64_targetlist - [_x];
        };
    }
    foreach fza_ah64_targetlist;

    ///////////MPD///////////
    if (fza_ah64_pr_mpd == "tsd") then {
        _unit setobjecttexture[303, "\fza_ah64_us\tex\mpd_tsd.paa"];
    } else {
        _targindi = 301;
        while {
            (_targindi > 269)
        }
        do {
            _unit setobjecttexture[_targindi, ""];
            _targindi = _targindi - 1;
            sleep 0.01;
        };
    };
    sleep 0.1;
};