#include "\fza_ah64_controls\headers\selections.h"
if (!(isNil "fza_ah64_noase")) exitwith {};
_heli = _this select 0;
_targnumcpg = 1076;
_cc1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_cc2 = "\fza_ah64_us\tex\char\g0_ca.paa";

while {
    (time > -1)
}
do {
    waituntil {
        (vehicle player) iskindof "fza_ah64base"
    };
    _heli = vehicle player;
    waitUntil {
        ((driver(vehicle player) == player || gunner(vehicle player) == player))
    };
    fza_ah64_asethreats = fza_ah64_targetlist; {
        _i = _x;
        fza_ah64_asethreats = fza_ah64_asethreats - [_i];
        fza_ah64_asethreats = fza_ah64_asethreats - allDead; {
            if (_i iskindof _x) then {
                fza_ah64_asethreats = fza_ah64_asethreats + [_i];
                if ((_heli == assignedTarget _i || _i AimedAtTarget[_heli] > 0.5) && (alive _i) && !(_i in fza_ah64_threattracking)) then {
                    fza_ah64_threattracking = fza_ah64_threattracking + [_i];
                    if (_i iskindof "ZSU_Base") then {
                        ["fza_ah64_bt_zsu23", 2.3, "fza_ah64_bt_tracking", 0.65] spawn fza_fnc_playAudio;
                    };
                    if (_i iskindof "2S6M_Tunguska") then {
                        ["fza_ah64_bt_sa19", 1.6, "fza_ah64_bt_tracking", 0.65] spawn fza_fnc_playAudio;
                    };
                    if !((_i iskindof "ZSU_Base") || (_i iskindof "2S6M_Tunguska")) then {
                        ["fza_ah64_bt_tracking", 0.65] spawn fza_fnc_playAudio;
                    };
                    if (fza_ah64_aseautopage == 1) then {
                        fza_ah64_pr_mpd = "ase";
                        if (fza_ah64_rfjstate == 1 && fza_ah64_rfjon == 0) then {
                            _rfjammerscript = [(vehicle player)] execvm "\fza_ah64_controls\scripting\rf_jammer.sqf";
                        };
                        if (fza_ah64_irjstate == 1 && fza_ah64_irjon == 0) then {
                            _irjammerscript = [(vehicle player)] execvm "\fza_ah64_controls\scripting\ir_jammer.sqf";
                        };
                    };
                };
            };
        }
        foreach fza_ah64_ada_units;
        if (side _i == side _heli) then {
            fza_ah64_asethreats = fza_ah64_asethreats - [_i];
        };
    }
    foreach fza_ah64_asethreats;
    if (fza_ah64_pr_mpd == "ase") then {
        _heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_us\tex\mpd\ase.paa"];
        if (fza_ah64_cmsel < 2) then {
            _cc1 = [fza_ah64_chaffcount, "\fza_ah64_us\tex\char\g"] call fza_ah64_digit;
            _cc2 = [fza_ah64_chaffcount, "\fza_ah64_us\tex\char\g"] call fza_ah64_digitten;
            _heli setobjecttexture [SEL_MPD_PR_ASE_CSEL, "\fza_ah64_us\tex\mpd\chaff.paa"];
            _heli setobjecttexture [SEL_MPD_PR_ASE_CC1, _cc1];
            _heli setobjecttexture [SEL_MPD_PR_ASE_CC2, _cc2];
            if (fza_ah64_cmsel == 1) then {
                _heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, "\fza_ah64_us\tex\char\g4_ca.paa"];
            } else {
                _heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, "\fza_ah64_us\tex\char\g1_ca.paa"];
            };
        };
        if (fza_ah64_cmsel > 1) then {
            _cc1 = [fza_ah64_flarecount, "\fza_ah64_us\tex\char\g"] call fza_ah64_digit;
            _cc2 = [fza_ah64_flarecount, "\fza_ah64_us\tex\char\g"] call fza_ah64_digitten;
            _heli setobjecttexture [SEL_MPD_PR_ASE_CSEL, ""];
            _heli setobjecttexture [SEL_MPD_PR_ASE_CC1, _cc1];
            _heli setobjecttexture [SEL_MPD_PR_ASE_CC2, _cc2];
            if (fza_ah64_cmsel == 3) then {
                _heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, "\fza_ah64_us\tex\char\g4_ca.paa"];
            } else {
                _heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, "\fza_ah64_us\tex\char\g1_ca.paa"];
            };
        };
        _hdgformat3 = [(round getdir _heli), "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
        _hdgformat2 = [(round getdir _heli), "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
        _hdgformat1 = [(round getdir _heli), "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;
        _heli setobjecttexture [SEL_MPD_PR_TSD_HDG1, _hdgformat1];
        _heli setobjecttexture [SEL_MPD_PR_TSD_HDG2, _hdgformat2];
        _heli setobjecttexture [SEL_MPD_PR_TSD_HDG3, _hdgformat3];
        _aserange = (abs(1 / fza_ah64_rangesetting)) * 0.001;
        _aserformat2 = [_aserange, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
        _aserformat1 = [_aserange, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;
        _heli setobjecttexture [SEL_MPD_PR_ASE_DIST1, _aserformat1];
        _heli setobjecttexture [SEL_MPD_PR_ASE_DIST2, _aserformat2];
        _aseautopage = "\fza_ah64_us\tex\mpd\ase_off.paa";
        if (fza_ah64_aseautopage == 1) then {
            _aseautopage = "\fza_ah64_us\tex\mpd\ase_track.paa";
        };
        if (fza_ah64_aseautopage == 2) then {
            _aseautopage = "\fza_ah64_us\tex\mpd\ase_launch.paa";
        };
        _heli setobjecttexture [SEL_MPD_PR_ASE_AUTPG, _aseautopage];
        if (fza_ah64_rfjon == 0) then {
            _heli setobjecttexture [SEL_MPD_PR_ASE_RJOFF, "\fza_ah64_us\tex\mpd\OFF.paa"];
        } else {
            _heli setobjecttexture [SEL_MPD_PR_ASE_RJOFF, ""];
        };
        if (fza_ah64_irjon == 0) then {
            _heli setobjecttexture [SEL_MPD_PR_ASE_IJOFF, "\fza_ah64_us\tex\mpd\OFF.paa"];
        } else {
            _heli setobjecttexture [SEL_MPD_PR_ASE_IJOFF, ""];
        };
        if (fza_ah64_rfjstate == 1) then {
            _heli setobjecttexture [SEL_MPD_PR_ASE_RJAUT, "\fza_ah64_us\tex\mpd\stby.paa"];
        } else {
            _heli setobjecttexture [SEL_MPD_PR_ASE_RJAUT, ""];
        };
        if (fza_ah64_irjstate == 1) then {
            _heli setobjecttexture [SEL_MPD_PR_ASE_IJAUT, "\fza_ah64_us\tex\mpd\stby.paa"];
        } else {
            _heli setobjecttexture [SEL_MPD_PR_ASE_IJAUT, ""];
        };
        if (fza_ah64_rfjon == 1) then {
            _heli setobjecttexture [SEL_MPD_PR_ASE_RJON, "\fza_ah64_us\tex\mpd\OPER.paa"];
        } else {
            _heli setobjecttexture [SEL_MPD_PR_ASE_RJON, ""];
        };
        if (fza_ah64_irjon == 1) then {
            _heli setobjecttexture [SEL_MPD_PR_ASE_IJON, "\fza_ah64_us\tex\mpd\OPER.paa"];
        } else {
            _heli setobjecttexture [SEL_MPD_PR_ASE_IJON, ""];
        };
        //////////////////////////////////////////////////////////////////////////////////////
        _targnum = 269;
        _targnumcpg = 1076;
        _objnum = 0; {
            if (_targnum < 302) then {
                _targnum = _targnum + 1;
                _targnumcpg = _targnum + 806;
                _objnum = _objnum + 1;
                _targzpos = 0;
                _i = _x;
                _iconformat = "\fza_ah64_US\tex\ICONS\U";
                _iconsuffix = "D.paa";
                if (_i iskindof "ZSU_Base") then {
                    _iconformat = "\fza_ah64_US\tex\ICONS\23";
                };
                if (_i iskindof "2S6M_Tunguska") then {
                    _iconformat = "\fza_ah64_US\tex\ICONS\19";
                };
                if (_heli == assignedTarget _x || _x AimedAtTarget[_heli] > 0.5) then {
                    _iconsuffix = "T.paa";
                };
                if (_x in fza_ah64_threatfiring) then {
                    _iconsuffix = "L.paa";
                    _targzpos = 1;
                };

                _heli setobjecttexture[_targnum, (_iconformat + _iconsuffix)];
                _heli setobjecttexture[_targnumcpg, (_iconformat + _iconsuffix)];

                _theta = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _x select 0), (getposatl _x select 1)] call fza_ah64_reldir;

                _targhead = _theta;

                if (_theta >= 180) then {
                    _targhead = _theta - 360;
                } else {
                    _targhead = _theta;
                };

                _targxpos = ((sin _targhead) * (((_heli distance _x) * fza_ah64_rangesetting) * 0.4)) + 0.5;
                _targypos = ((cos _targhead) * (((_heli distance _x) * fza_ah64_rangesetting) * 0.4)) + 0.5;

                if (_targxpos > 0.9) then {
                    _targxpos = 0.9;
                };
                if (_targxpos < 0.1) then {
                    _targxpos = 0.1;
                };

                if (_targypos > 0.9) then {
                    _targypos = 0.9;
                };
                if (_targypos < 0.1) then {
                    _targypos = 0.1;
                };

                _objnumformat = format["%1", _objnum];
                _objstrh = "mpd_pl_obj" + _objnumformat + "_h";
                _objstrv = "mpd_pl_obj" + _objnumformat + "_v";
                _objstrz = "mpd_pl_obj" + _objnumformat + "_z";
                if (driver _heli == player) then {
                    _heli animate[_objstrh, _targxpos];
                    _heli animate[_objstrv, _targypos];
                    _heli animate[_objstrz, _targzpos];
                };
                if (gunner _heli == player) then {
                    _objstrh = "mpd_gr_obj" + _objnumformat + "_h";
                    _objstrv = "mpd_gr_obj" + _objnumformat + "_v";
                    _objstrz = "mpd_gr_obj" + _objnumformat + "_z";
                    _heli animate[_objstrh, _targxpos];
                    _heli animate[_objstrv, _targypos];
                    _heli animate[_objstrz, _targzpos];
                };
            };
        }
        foreach fza_ah64_asethreats;
        _targindi = _targnum + 1;
        while {
            (_targindi < 302 && fza_ah64_pr_mpd == "ase")
        }
        do {
            _heli setobjecttexture[_targindi, ""];
            _heli setobjecttexture[(_targindi + 806), ""];
            _targindi = _targindi + 1;
        };
        //////////////////////////////////////////////////////////////////////////////////////
    } else {
        _heli setobjecttexture [SEL_MPD_PR_ASE_AUTPG, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_CC1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_CC2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_CSEL, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_DIST1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_DIST2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_IJAUT, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_IJOFF, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_IJON, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_RJAUT, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_RJOFF, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_RJON, ""];
        _heli setobjecttexture [SEL_MPD_PR_ASE_SALVO, ""];
    };
    sleep 0.03;
};