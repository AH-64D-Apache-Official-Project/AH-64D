#include "\fza_ah64_controls\headers\selections.h"
if (!(isNil "fza_ah64_noflt")) exitwith {};
_heli = _this select 0;
//658 to 833
_hilimit = "\fza_ah64_us\tex\mpd\hi.paa";
_lolimit = "\fza_ah64_us\tex\mpd\lo.paa";
_baroalt = 0;
_radalt = 0;
_collective = 0;
_wpr = 0;
_helidir = 0;
_curwpdir = 0;
_hiden = "\fza_ah64_us\tex\mpd\flt_ca.paa";
_hidep = "\fza_ah64_us\tex\mpd\flt_ca.paa";
_vertvect = 0.5;
_horvect = 0.5;
_dps = 0;
_slip = 0;
_vertvect1 = 0;
_vertvect2 = 0;
_horvect1 = 0;
_horvect2 = 0;
_trq = 0;

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
    if (fza_ah64_pl_mpd == "flt" || fza_ah64_pr_mpd == "flt") then {
        _hilimit = "";
        _lolimit = "";
        if (getpos _heli select 2 > 304.8) then {
            _hilimit = "\fza_ah64_us\tex\mpd\hi.paa";
        };
        if (getpos _heli select 2 < 6.1) then {
            _lolimit = "\fza_ah64_us\tex\mpd\lo.paa";
        };

        _baroalt = round((getposasl _heli select 2) * 0.328084);
        if (_baroalt < 0) then {
            _baroalt = 0;
        };
        _baroaltformat1 = [_baroalt, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitthou;
        _baroaltformat2 = [_baroalt, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
        _baroaltformat3 = [_baroalt, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
        _baroaltformat4 = [_baroalt, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

        _radalt = round((getpos _heli select 2) * 3.28084);
        if (_radalt < 0) then {
            _radalt = 0;
        };
        _radaltformat1 = [_radalt, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitthou;
        _radaltformat2 = [_radalt, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
        _radaltformat3 = [_radalt, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
        _radaltformat4 = [_radalt, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

        _aspd = round(1.94 * (sqrt(((velocity _heli select 0) + (0.836 * (abs(wind select 0) ^ 1.5))) ^ 2 + ((velocity _heli select 1) + (0.836 * (abs(wind select 2) ^ 1.5))) ^ 2 + ((velocity _heli select 2) + (0.836 * (abs(wind select 1) ^ 1.5))) ^ 2)));
        _aspdformat2 = [_aspd, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
        _aspdformat3 = [_aspd, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
        _aspdformat4 = [_aspd, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

        _gspd = round(0.53996 * (abs(speed _heli)));
        _gspdformat2 = [_gspd, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
        _gspdformat3 = [_gspd, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
        _gspdformat4 = [_gspd, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

        if (!difficultyEnabledRTD) then {
            _trq = round(100 * ((0.25 * (2 - (inputAction "HeliCollectiveLowerCont" + inputAction "heliThrottleNeg" + inputAction "heliDown"))) + (0.25 * (inputAction "HeliCollectiveRaiseCont" + inputAction "heliUp" + inputAction "heliThrottlePos"))));
        };

        if (difficultyEnabledRTD && count(enginesTorqueRTD _heli) > 0) then {
            _trq = round((enginesTorqueRTD _heli select 0) / 5.6);
        };

        //if((format ["%1",round (((enginesTorqueRTD _heli select 0) + (enginesTorqueRTD _heli select 1)) / 35)]) == "scalar") then {_trq = 0;};
        _trqformat2 = [_trq, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
        _trqformat3 = [_trq, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
        _trqformat4 = [_trq, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

        _wpr = ([(fza_ah64_curwp select 0), (fza_ah64_curwp select 1), 0] distance[(getpos _heli select 0), (getpos _heli select 1), 0]) * 0.001;
        _wprtk = round(floor(_wpr * 0.1));
        _wprk = round(floor(10 * ((_wpr * 0.1) - floor(_wpr * 0.1))));
        _wprdk = round(10 * (_wpr - (round(floor _wpr))));
        if (_wprdk > 9) then {
            _wprdk = 9;
        };
        _wprformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _wprtk]) + "_ca.paa";
        _wprformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _wprk]) + "_ca.paa";
        _wprformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _wprdk]) + "_ca.paa";

        _helidir = (direction _heli);
        _hdgformat1 = [_helidir, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digithun;
        _hdgformat2 = [_helidir, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digitten;
        _hdgformat3 = [_helidir, "\fza_ah64_us\tex\CHAR\G"] call fza_ah64_digit;

        _hiden = "\fza_ah64_us\tex\mpd\flt_ca.paa";
        _hidep = "\fza_ah64_us\tex\mpd\flt_ca.paa";
        if (_heli animationphase "mpd_pr_flt_bank" > 0.6) then {
            _hidep = "";
        };
        if (_heli animationphase "mpd_pr_flt_bank" < -0.6) then {
            _hiden = "";
        };

        _theta = [_heli, (getposatl _heli select 0), (getposatl _heli select 1), (fza_ah64_curwp select 0), (fza_ah64_curwp select 1)] call fza_ah64_reldir;

        _targhead = _theta;

        if (_theta >= 180) then {
            _targhead = _theta - 360;
        } else {
            _targhead = _theta;
        };
        _curwpdir = _targhead;

        _vvect = [_heli] call fza_ah64_velvect;

        _vertvect = (_vvect select 0) + 0.5;
        _horvect = (_vvect select 1) + 0.6;

        _dps = direction _heli;

        _wpdistr = [(fza_ah64_curwp select 0), (fza_ah64_curwp select 1), 0] distance[(getpos _heli select 0), (getpos _heli select 1), 0];

        sleep 0.03;

        _wpdistr = (_wpdistr - ([(fza_ah64_curwp select 0), (fza_ah64_curwp select 1), 0] distance[(getpos _heli select 0), (getpos _heli select 1), 0])) * 33;

        if (_wpdistr < 1) then {
            _wpdistr = 1;
        };

        _wptime = ([(fza_ah64_curwp select 0), (fza_ah64_curwp select 1), 0] distance[(getpos _heli select 0), (getpos _heli select 1), 0]) / _wpdistr;
        if (_wptime > 32400) then {
            _wptime = 32400;
        };

        _wptimhr = round(floor(_wptime * 0.0002778));
        _wptim = round(60 * ((_wptime * 0.0002778) - floor(_wptime * 0.0002778)));
        _wptimtm = round(10 * (((floor(_wptim * 0.1)) * 0.1) - floor((floor(_wptim * 0.1)) * 0.1)));
        _wptimsm = round(10 * ((_wptim * 0.1) - floor(_wptim * 0.1)));
        if (_wptime < 60) then {
            _wptimtm = round(floor(_wptime * 0.1));
            _wptimsm = round(10 * ((_wptime * 0.1) - (floor(_wptime * 0.1))));
            if (_wptimtm > 9) then {
                _wptimtm = 9;
            };
            if (_wptimsm > 9) then {
                _wptimsm = 9;
            };
        };

        _wptimdformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _wptimhr]) + "_ca.paa";
        _wptimdformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _wptimtm]) + "_ca.paa";
        _wptimdformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _wptimsm]) + "_ca.paa";

        _dps = (_dps - direction _heli) * 33;

        _turn = (_dps * -0.052083) + 0.5;

        if (_turn > 0.75) then {
            _turn = 0.75;
        };
        if (_turn < 0.25) then {
            _turn = 0.25;
        };

        _slip = (fza_ah64_slip * 1.2) + 0.5;

        if (_slip > 0.7) then {
            _slip = 0.7;
        };
        if (_slip < 0.3) then {
            _slip = 0.3;
        };

        if (fza_ah64_pr_mpd == "flt") then {
            _heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            if (local _heli) then {
                _heli animate["mpd_pr_flt_wbear", (_curwpdir * 0.00476) + 0.5];
                _heli animate["mpd_pr_flt_wp_h", (_curwpdir * 0.00476) + 0.625];
                _heli animate["mpd_pr_flt_wp_v", _vertvect];
                _heli animate["mpd_pr_flt_vvi_v", _vertvect];
                _heli animate["mpd_pr_flt_vvi_h", _horvect];
                _heli animate["mpd_pr_flt_rdr", ((_heli animationphase "longbow") * 2) + 0.5];
                _heli animate["mpd_pr_flt_turn", _turn];
                _heli animate["mpd_pr_flt_slip", _slip];
            };
            _heli setobjecttexture [SEL_MPD_PR_FLT_BALT1, _baroaltformat4];
            _heli setobjecttexture [SEL_MPD_PR_FLT_BALT2, _baroaltformat3];
            _heli setobjecttexture [SEL_MPD_PR_FLT_BALT3, _baroaltformat2];
            _heli setobjecttexture [SEL_MPD_PR_FLT_BALT4, _baroaltformat1];
            _heli setobjecttexture [SEL_MPD_PR_FLT_BANK, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_GSPD1, _gspdformat4];
            _heli setobjecttexture [SEL_MPD_PR_FLT_GSPD2, _gspdformat3];
            _heli setobjecttexture [SEL_MPD_PR_FLT_GSPD3, _gspdformat2];
            _heli setobjecttexture [SEL_MPD_PR_FLT_HDG, "\fza_ah64_us\tex\mpd\hdg_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_HDG2, "\fza_ah64_us\tex\mpd\hdg_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_HI, _hilimit];
            _heli setobjecttexture [SEL_MPD_PR_FLT_HOR, "\fza_ah64_us\tex\mpd\ladder_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_LO, _lolimit];
            _heli setobjecttexture [SEL_MPD_PR_FLT_N20C, _hiden];
            _heli setobjecttexture [SEL_MPD_PR_FLT_P20C, _hidep];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RALT1, _radaltformat4];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RALT2, _radaltformat3];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RALT3, _radaltformat2];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RALTB, "\fza_ah64_us\tex\mpd\gtape.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RDR, "\fza_ah64_us\tex\mpd\rdrbear_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_SLIP, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_SPD1, _aspdformat4];
            _heli setobjecttexture [SEL_MPD_PR_FLT_SPD2, _aspdformat3];
            _heli setobjecttexture [SEL_MPD_PR_FLT_SPD3, _aspdformat2];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TRQ1, _trqformat4];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TRQ2, _trqformat3];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TRQ3, _trqformat2];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TTG1, _wptimdformat3];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TTG2, _wptimdformat2];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TTG3, _wptimdformat1];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TTG4, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TURN, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_VSI, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_VVI, "\fza_ah64_us\tex\mpd\cue_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_W, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WBEAR, "\fza_ah64_us\tex\mpd\cmdbear_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WP, "\fza_ah64_us\tex\mpd\wp_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WR1, _wprformat3];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WR2, _wprformat2];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WR3, _wprformat1];
            _heli setobjecttexture [SEL_MPD_PR_FLT_DIR1, _hdgformat3];
            _heli setobjecttexture [SEL_MPD_PR_FLT_DIR2, _hdgformat2];
            _heli setobjecttexture [SEL_MPD_PR_FLT_DIR3, _hdgformat1];
            _heli setobjecttexture [SEL_MPD_PR_FLT_DIRB, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
        } else {
            _heli setobjecttexture [SEL_MPD_PR_FLT_BALT1, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_BALT2, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_BALT3, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_BALT4, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_BANK, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_GSPD1, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_GSPD2, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_GSPD3, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_HDG, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_HDG2, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_HI, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_HOR, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_LO, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_N20C, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_P20C, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RALT1, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RALT2, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RALT3, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RALTB, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_RDR, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_SLIP, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_SPD1, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_SPD2, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_SPD3, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TRQ1, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TRQ2, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TRQ3, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TTG1, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TTG2, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TTG3, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TTG4, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_TURN, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_VSI, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_VVI, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_W, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WBEAR, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WP, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WR1, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WR2, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_WR3, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_DIR1, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_DIR2, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_DIR3, ""];
            _heli setobjecttexture [SEL_MPD_PR_FLT_DIRB, ""];
        };
        if (fza_ah64_pl_mpd == "flt") then {
            _heli setobjecttexture [SEL_PL_MPD_BACK, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            if (local _heli) then {
                _heli animate["mpd_pl_flt_wbear", (_curwpdir * 0.00476) + 0.5];
                _heli animate["mpd_pl_flt_wp_h", (_curwpdir * 0.00476) + 0.625];
                _heli animate["mpd_pl_flt_wp_v", _vertvect];
                _heli animate["mpd_pl_flt_vvi_v", _vertvect];
                _heli animate["mpd_pl_flt_vvi_h", _horvect];
                _heli animate["mpd_pl_flt_rdr", ((_heli animationphase "longbow") * 2) + 0.5];
                _heli animate["mpd_pl_flt_turn", _turn];
                _heli animate["mpd_pl_flt_slip", _slip];
            };
            _heli setobjecttexture [SEL_MPD_PL_FLT_BALT1, _baroaltformat4];
            _heli setobjecttexture [SEL_MPD_PL_FLT_BALT2, _baroaltformat3];
            _heli setobjecttexture [SEL_MPD_PL_FLT_BALT3, _baroaltformat2];
            _heli setobjecttexture [SEL_MPD_PL_FLT_BALT4, _baroaltformat1];
            _heli setobjecttexture [SEL_MPD_PL_FLT_BANK, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PL_FLT_GSPD1, _gspdformat4];
            _heli setobjecttexture [SEL_MPD_PL_FLT_GSPD2, _gspdformat3];
            _heli setobjecttexture [SEL_MPD_PL_FLT_GSPD3, _gspdformat2];
            _heli setobjecttexture [SEL_MPD_PL_FLT_HDG, "\fza_ah64_us\tex\mpd\hdg_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PL_FLT_HDG2, "\fza_ah64_us\tex\mpd\hdg_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PL_FLT_HI, _hilimit];
            _heli setobjecttexture [SEL_MPD_PL_FLT_HOR, "\fza_ah64_us\tex\mpd\ladder_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PL_FLT_LO, _lolimit];
            _heli setobjecttexture [SEL_MPD_PL_FLT_N20C, _hiden];
            _heli setobjecttexture [SEL_MPD_PL_FLT_P20C, _hidep];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RALT1, _radaltformat4];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RALT2, _radaltformat3];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RALT3, _radaltformat2];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RALTB, "\fza_ah64_us\tex\mpd\gtape.paa"];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RDR, "\fza_ah64_us\tex\mpd\rdrbear_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PL_FLT_SLIP, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PL_FLT_SPD1, _aspdformat4];
            _heli setobjecttexture [SEL_MPD_PL_FLT_SPD2, _aspdformat3];
            _heli setobjecttexture [SEL_MPD_PL_FLT_SPD3, _aspdformat2];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TRQ1, _trqformat4];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TRQ2, _trqformat3];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TRQ3, _trqformat2];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TTG1, _wptimdformat3];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TTG2, _wptimdformat2];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TTG3, _wptimdformat1];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TTG4, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TURN, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PL_FLT_VSI, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            if (speed _heli > 5) then {
                _heli setobjecttexture [SEL_MPD_PL_FLT_VVI, "\fza_ah64_us\tex\mpd\cue_ca.paa"];
                _heli setobjecttexture [SEL_MPD_PL_FLT_WP, "\fza_ah64_us\tex\mpd\wp_ca.paa"];
            } else {
                _heli setobjecttexture [SEL_MPD_PL_FLT_VVI, ""];
                _heli setobjecttexture [SEL_MPD_PL_FLT_WP, ""];
            };
            _heli setobjecttexture [SEL_MPD_PL_FLT_W, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
            _heli setobjecttexture [SEL_MPD_PL_FLT_WBEAR, "\fza_ah64_us\tex\mpd\cmdbear_ca.paa"];
            ///
            _heli setobjecttexture [SEL_MPD_PL_FLT_WR1, _wprformat3];
            _heli setobjecttexture [SEL_MPD_PL_FLT_WR2, _wprformat2];
            _heli setobjecttexture [SEL_MPD_PL_FLT_WR3, _wprformat1];
            _heli setobjecttexture [SEL_MPD_PL_FLT_DIR1, _hdgformat3];
            _heli setobjecttexture [SEL_MPD_PL_FLT_DIR2, _hdgformat2];
            _heli setobjecttexture [SEL_MPD_PL_FLT_DIR3, _hdgformat1];
            _heli setobjecttexture [SEL_MPD_PL_FLT_DIRB, "\fza_ah64_us\tex\mpd\flt_ca.paa"];
        } else {
            _heli setobjecttexture [SEL_MPD_PL_FLT_BALT1, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_BALT2, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_BALT3, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_BALT4, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_BANK, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_GSPD1, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_GSPD2, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_GSPD3, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_HDG, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_HDG2, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_HI, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_HOR, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_LO, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_N20C, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_P20C, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RALT1, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RALT2, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RALT3, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RALTB, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_RDR, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_SLIP, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_SPD1, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_SPD2, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_SPD3, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TRQ1, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TRQ2, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TRQ3, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TTG1, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TTG2, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TTG3, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TTG4, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_TURN, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_VSI, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_VVI, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_W, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_WBEAR, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_WP, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_WR1, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_WR2, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_WR3, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_DIR1, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_DIR2, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_DIR3, ""];
            _heli setobjecttexture [SEL_MPD_PL_FLT_DIRB, ""];
        };
    } else {
        _heli setobjecttexture [SEL_MPD_PR_FLT_BALT1, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_BALT2, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_BALT3, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_BALT4, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_BANK, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_GSPD1, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_GSPD2, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_GSPD3, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_HDG, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_HDG2, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_HI, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_HOR, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_LO, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_N20C, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_P20C, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_RALT1, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_RALT2, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_RALT3, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_RALTB, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_RDR, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_SLIP, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_SPD1, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_SPD2, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_SPD3, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_TRQ1, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_TRQ2, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_TRQ3, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_TTG1, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_TTG2, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_TTG3, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_TTG4, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_TURN, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_VSI, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_VVI, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_W, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_WBEAR, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_WP, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_WR1, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_WR2, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_WR3, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_BALT1, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_BALT2, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_BALT3, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_BALT4, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_BANK, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_GSPD1, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_GSPD2, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_GSPD3, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_HDG, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_HDG2, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_HI, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_HOR, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_LO, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_N20C, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_P20C, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_RALT1, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_RALT2, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_RALT3, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_RALTB, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_RDR, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_SLIP, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_SPD1, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_SPD2, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_SPD3, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_TRQ1, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_TRQ2, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_TRQ3, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_TTG1, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_TTG2, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_TTG3, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_TTG4, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_TURN, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_VSI, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_VVI, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_W, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_WBEAR, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_WP, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_WR1, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_WR2, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_WR3, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_DIR1, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_DIR2, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_DIR3, ""];
        _heli setobjecttexture [SEL_MPD_PR_FLT_DIRB, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_DIR1, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_DIR2, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_DIR3, ""];
        _heli setobjecttexture [SEL_MPD_PL_FLT_DIRB, ""];
    };
    sleep 0.03;
};