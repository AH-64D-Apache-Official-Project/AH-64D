///this script tracks fuel associated functions
#include "\fza_ah64_controls\headers\selections.h"
if (!(isNil "fza_ah64_nofuel")) exitwith {};
_heli = _this select 0;
_iafs100qty = 0.27;
_iafs130qty = 0.35;
_waux230qty_1 = 0.62;
_waux230qty_2 = 0.62;
_waux230qty_3 = 0.62;
_waux230qty_4 = 0.62;
_activetank = 0;
_fuelweight = 2538;
_totfuelweight = 2538;
_auxfuelweight1 = 1550;
_auxfuelweight2 = 1550;
_auxfuelweight3 = 1550;
_auxfuelweight4 = 1550;
_fwdfuel = 0;
_aftfuel = 0;
_fwdfuelth = 0;
_fwdfuelhu = 0;
_fwdfuelte = 0;
_fwdfuelsi = 0;
_aftfuelth = 0;
_aftfuelhu = 0;
_aftfuelte = 0;
_aftfuelsi = 0;
_fwdfuelformat1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_fwdfuelformat2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_fwdfuelformat3 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_fwdfuelformat4 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_aftfuelformat1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_aftfuelformat2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_aftfuelformat3 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_aftfuelformat4 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_iafsfuel = 0;
_iafsfuelhu = 0;
_iafsfuelte = 0;
_iafsfuelsi = 0;
_iafsformat1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_iafsformat2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_iafsformat3 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
_intfuelth = 0;
_intfuelhu = 0;
_intfuelte = 0;
_intfuelsi = 0;
_intfuelweight = 0;
_totfuelend = 0;
_burnrate = 0;
_curwaux1 = "";
_curwaux2 = "";
_curwaux3 = "";
_curwaux4 = "";
_fueltrigger = false;
_basefuel = fuel _heli;
fza_ah64_fuelsave = 1;

sleep 1;

while {
    (alive _heli)
}
do {
    if (fuel _heli > 0) then {
        _basefuel = fuel _heli;
    };
    if (!(player == driver _heli || player == gunner _heli)) then {
        _heli setfuel _basefuel;
    };
    waituntil {
        (player == driver _heli || player == gunner _heli)
    };
    if (isNil "fza_ah64_fuelsave") then {
        fza_ah64_fuelsave = fuel _heli;
    };
    _mags = magazines _heli;
    _curfuel = fuel _heli;
    if (_curfuel > 0 && !(isengineon _heli)) then {
        fza_ah64_fuelsave = fuel _heli;
    };
    if (isengineon _heli && player in _heli) then {
        fza_ah64_fuelsave = fuel _heli;
        _fueltrigger = false;
    };
    if (player == driver _heli) then {
        if ("fza_ah64_fwd_leak" in (_heli magazinesturret[-1]) || "fza_ah64_aft_leak" in (_heli magazinesturret[-1])) then {
            fza_ah64_fuelsave = fza_ah64_fuelsave - 0.0003;
        };
        if (fza_ah64_cem && fuel _heli > 0 && !(fza_ah64_estarted) && !(_fueltrigger)) then {
            _heli setfuel 0;
            _fueltrigger = true;
        };
        if (fza_ah64_cem && !(isengineon _heli) && !(fza_ah64_estarted)) then {
            _heli setfuel 0;
        };
        if (fza_ah64_cem && fza_ah64_estarted && _fueltrigger) then {
            _heli setfuel fza_ah64_fuelsave;
            fza_ah64_fuelsave = fuel _heli;
            _fueltrigger = false;
        };
    };
    if (local _heli && isengineon _heli) then {
        _fuelused = 1 - fza_ah64_fuelsave;
        if ("fza_iafs_130" in _mags && _iafs130qty > 0) then {
            _activetank = 5;
        };
        if ("fza_iafs_100" in _mags && _iafs100qty > 0) then {
            _activetank = 4;
        };
        if ("fza_auxtank_230_4" in _mags && _waux230qty_4 > 0) then {
            _activetank = 3;
        };
        if ("fza_auxtank_230_1" in _mags && _waux230qty_1 > 0) then {
            _activetank = 0;
        };
        if ("fza_auxtank_230_2" in _mags && _waux230qty_2 > 0) then {
            _activetank = 1;
        };
        if ("fza_auxtank_230_3" in _mags && _waux230qty_3 > 0) then {
            _activetank = 2;
        };
        ///////////////WINGAUX//////////////////
        if ("fza_auxtank_230_1" in _mags && _waux230qty_1 > 0 && _activetank == 0) then {
            if (_fuelused > _waux230qty_1) then {
                _heli setfuel(fza_ah64_fuelsave + _waux230qty_1);
            } else {
                _heli setfuel 1;
            };
            _waux230qty_1 = _waux230qty_1 - _fuelused;
        };
        if ("fza_auxtank_230_2" in _mags && _waux230qty_2 > 0 && _activetank == 1) then {
            if (_fuelused > _waux230qty_2) then {
                _heli setfuel(fza_ah64_fuelsave + _waux230qty_2);
            } else {
                _heli setfuel 1;
            };
            _waux230qty_2 = _waux230qty_2 - _fuelused;
        };
        if ("fza_auxtank_230_3" in _mags && _waux230qty_3 > 0 && _activetank == 2) then {
            if (_fuelused > _waux230qty_3) then {
                _heli setfuel(fza_ah64_fuelsave + _waux230qty_3);
            } else {
                _heli setfuel 1;
            };
            _waux230qty_3 = _waux230qty_3 - _fuelused;
        };
        if ("fza_auxtank_230_4" in _mags && _waux230qty_4 > 0 && _activetank == 3) then {
            if (_fuelused > _waux230qty_4) then {
                _heli setfuel(fza_ah64_fuelsave + _waux230qty_4);
            } else {
                _heli setfuel 1;
            };
            _waux230qty_4 = _waux230qty_4 - _fuelused;
        };
        if (!("fza_auxtank_230_1" in _mags)) then {
            _waux230qty_1 = 0.62;
        };
        if (!("fza_auxtank_230_2" in _mags)) then {
            _waux230qty_2 = 0.62;
        };
        if (!("fza_auxtank_230_3" in _mags)) then {
            _waux230qty_3 = 0.62;
        };
        if (!("fza_auxtank_230_4" in _mags)) then {
            _waux230qty_4 = 0.62;
        };
        ///////////////IAFS///////////////
        if ("fza_iafs_100" in _mags && _iafs100qty > 0 && _activetank == 4) then {
            if (_fuelused > _iafs100qty) then {
                _heli setfuel(fza_ah64_fuelsave + _iafs100qty);
            } else {
                _heli setfuel 1;
            };
            _iafs100qty = _iafs100qty - _fuelused;
        };
        if ("fza_iafs_130" in _mags && _iafs130qty > 0 && _activetank == 5) then {
            if (_fuelused > _iafs130qty) then {
                _heli setfuel(fza_ah64_fuelsave + _iafs130qty);
            } else {
                _heli setfuel 1;
            };
            _iafs130qty = _iafs130qty - _fuelused;
        };
        if (!("fza_iafs_100" in _mags)) then {
            _iafs100qty = 0.27;
        };
        if (!("fza_iafs_130" in _mags)) then {
            _iafs130qty = 0.35;
        };
    };

    if (fza_ah64_apuon == 1) then {
        fza_ah64_fuelsave = fza_ah64_fuelsave - 0.000002;
        _burnrate = 0.1875;
        if (_heli animationphase "plt_eng1_start" > 0) then {
            fza_ah64_fuelsave = fza_ah64_fuelsave - 0.000002;
            _burnrate = _burnrate + 0.1875;
        };
        if (_heli animationphase "plt_eng2_start" > 0) then {
            fza_ah64_fuelsave = fza_ah64_fuelsave - 0.000002;
            _burnrate = _burnrate + 0.1875;
        };
    };

    ////////////////////////////////////MPD////////////////////////////
    if (fza_ah64_pl_mpd == "fuel" || fza_ah64_pr_mpd == "fuel") then {
        _fuelweight = round(fza_ah64_fuelsave * 2538);
        _intfuelweight = round(fza_ah64_fuelsave * 2538);
        _fwdfuel = round((_fuelweight / 100) * 41.49);
        _aftfuel = round((_fuelweight / 100) * 58.51);
        _fwdfuelth = round(floor(_fwdfuel * 0.001));
        _fwdfuelhu = round(floor(10 * ((_fwdfuel * 0.001) - floor(_fwdfuel * 0.001))));
        _fwdfuelte = round(10 * (((floor(_fwdfuel * 0.1)) * 0.1) - floor((floor(_fwdfuel * 0.1)) * 0.1)));
        _fwdfuelsi = round(10 * ((_fwdfuel * 0.1) - floor(_fwdfuel * 0.1)));
        _aftfuelth = round(floor(_aftfuel * 0.001));
        _aftfuelhu = round(floor(10 * ((_aftfuel * 0.001) - floor(_aftfuel * 0.001))));
        _aftfuelte = round(10 * (((floor(_aftfuel * 0.1)) * 0.1) - floor((floor(_aftfuel * 0.1)) * 0.1)));
        _aftfuelsi = round(10 * ((_aftfuel * 0.1) - floor(_aftfuel * 0.1)));
        _fwdfuelformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _fwdfuelth]) + "_ca.paa";
        _fwdfuelformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _fwdfuelhu]) + "_ca.paa";
        _fwdfuelformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _fwdfuelte]) + "_ca.paa";
        _fwdfuelformat4 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _fwdfuelsi]) + "_ca.paa";
        _aftfuelformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _aftfuelth]) + "_ca.paa";
        _aftfuelformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _aftfuelhu]) + "_ca.paa";
        _aftfuelformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _aftfuelte]) + "_ca.paa";
        _aftfuelformat4 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _aftfuelsi]) + "_ca.paa";
        if ("fza_iafs_100" in _mags || "fza_iafs_130" in _mags) then {
            _iafsfuel = round(_iafs100qty * 2500);
            if ("fza_iafs_130" in _mags) then {
                _iafsfuel = round(_iafs130qty * 2506);
            };
            _iafsfuelhu = round(floor(10 * ((_iafsfuel * 0.001) - floor(_iafsfuel * 0.001))));
            _iafsfuelte = round(10 * (((floor(_iafsfuel * 0.1)) * 0.1) - floor((floor(_iafsfuel * 0.1)) * 0.1)));
            _iafsfuelsi = round(10 * ((_iafsfuel * 0.1) - floor(_iafsfuel * 0.1)));
            _iafsformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _iafsfuelhu]) + "_ca.paa";
            _iafsformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _iafsfuelte]) + "_ca.paa";
            _iafsformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _iafsfuelsi]) + "_ca.paa";
            _intfuelweight = _intfuelweight + _iafsfuel;
        } else {
            _iafsformat1 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
            _iafsformat2 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
            _iafsformat3 = "\fza_ah64_us\tex\CHAR\G0_ca.paa";
        };
        _intfuelth = round(floor(_intfuelweight * 0.001));
        _intfuelhu = round(floor(10 * ((_intfuelweight * 0.001) - floor(_intfuelweight * 0.001))));
        _intfuelte = round(10 * (((floor(_intfuelweight * 0.1)) * 0.1) - floor((floor(_intfuelweight * 0.1)) * 0.1)));
        _intfuelsi = round(10 * ((_intfuelweight * 0.1) - floor(_intfuelweight * 0.1)));
        _intfuelformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _intfuelth]) + "_ca.paa";
        _intfuelformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _intfuelhu]) + "_ca.paa";
        _intfuelformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _intfuelte]) + "_ca.paa";
        _intfuelformat4 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _intfuelsi]) + "_ca.paa";
        _intfuelend = _intfuelweight * 0.001;
        _intfenhr = round(floor(_intfuelend));
        _intfuelend = round(60 * ((_intfuelweight * 0.001) - floor(_intfuelweight * 0.001)));
        _intfentm = round(10 * (((floor(_intfuelend * 0.1)) * 0.1) - floor((floor(_intfuelend * 0.1)) * 0.1)));
        _intfensm = round(10 * ((_intfuelend * 0.1) - floor(_intfuelend * 0.1)));
        _intfendformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _intfenhr]) + "_ca.paa";
        _intfendformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _intfentm]) + "_ca.paa";
        _intfendformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _intfensm]) + "_ca.paa";
        //0.00015
        if (isengineon _heli) then {
            _burnrate = 1;
        };
        _leburnrate = round(_burnrate * 480);
        _reburnrate = round(_burnrate * 480);
        _totburnrate = round(_burnrate * 960);
        if (_leburnrate > 999) then {
            _leburnrate = 999;
        };
        if (_reburnrate > 999) then {
            _reburnrate = 999;
        };
        if (_totburnrate > 999) then {
            _totburnrate = 999;
        };
        _leburnhu = round(floor(10 * ((_leburnrate * 0.001) - floor(_leburnrate * 0.001))));
        _leburnte = round(10 * (((floor(_leburnrate * 0.1)) * 0.1) - floor((floor(_leburnrate * 0.1)) * 0.1)));
        _leburnsi = round(10 * ((_leburnrate * 0.1) - floor(_leburnrate * 0.1)));
        _leburnformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _leburnhu]) + "_ca.paa";
        _leburnformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _leburnte]) + "_ca.paa";
        _leburnformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _leburnsi]) + "_ca.paa";
        _reburnhu = round(floor(10 * ((_reburnrate * 0.001) - floor(_reburnrate * 0.001))));
        _reburnte = round(10 * (((floor(_reburnrate * 0.1)) * 0.1) - floor((floor(_reburnrate * 0.1)) * 0.1)));
        _reburnsi = round(10 * ((_reburnrate * 0.1) - floor(_reburnrate * 0.1)));
        _reburnformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _reburnhu]) + "_ca.paa";
        _reburnformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _reburnte]) + "_ca.paa";
        _reburnformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _reburnsi]) + "_ca.paa";
        _totburnhu = round(floor(10 * ((_totburnrate * 0.001) - floor(_totburnrate * 0.001))));
        _totburnte = round(10 * (((floor(_totburnrate * 0.1)) * 0.1) - floor((floor(_totburnrate * 0.1)) * 0.1)));
        _totburnsi = round(10 * ((_totburnrate * 0.1) - floor(_totburnrate * 0.1)));
        _totburnformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totburnhu]) + "_ca.paa";
        _totburnformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totburnte]) + "_ca.paa";
        _totburnformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totburnsi]) + "_ca.paa";
        _totfuelweight = _intfuelweight;
        /////aux//////
        if ("fza_auxtank_230_1" in _mags) then {
            if (_waux230qty_1 > 0) then {
                _curwaux1 = "\fza_ah64_us\tex\Ftank_ca.paa";
            };
            if (_waux230qty_1 <= 0) then {
                _curwaux1 = "\fza_ah64_us\tex\Etank_ca.paa";
            };
            _auxfuelweight1 = round(_waux230qty_1 * 2500);
            _totfuelweight = _totfuelweight + _auxfuelweight1;
        } else {
            _curwaux1 = "";
        };
        if ("fza_auxtank_230_2" in _mags) then {
            if (_waux230qty_2 > 0) then {
                _curwaux2 = "\fza_ah64_us\tex\Ftank_ca.paa";
            };
            if (_waux230qty_2 <= 0) then {
                _curwaux2 = "\fza_ah64_us\tex\Etank_ca.paa";
            };
            _auxfuelweight2 = round(_waux230qty_2 * 2500);
            _totfuelweight = _totfuelweight + _auxfuelweight2;
        } else {
            _curwaux2 = "";
        };
        if ("fza_auxtank_230_3" in _mags) then {
            if (_waux230qty_3 > 0) then {
                _curwaux3 = "\fza_ah64_us\tex\Ftank_ca.paa";
            };
            if (_waux230qty_3 <= 0) then {
                _curwaux3 = "\fza_ah64_us\tex\Etank_ca.paa";
            };
            _auxfuelweight3 = round(_waux230qty_3 * 2500);
            _totfuelweight = _totfuelweight + _auxfuelweight3;
        } else {
            _curwaux3 = "";
        };
        if ("fza_auxtank_230_4" in _mags) then {
            if (_waux230qty_4 > 0) then {
                _curwaux4 = "\fza_ah64_us\tex\Ftank_ca.paa";
            };
            if (_waux230qty_4 <= 0) then {
                _curwaux4 = "\fza_ah64_us\tex\Etank_ca.paa";
            };
            _auxfuelweight4 = round(_waux230qty_4 * 2500);
            _totfuelweight = _totfuelweight + _auxfuelweight4;
        } else {
            _curwaux4 = "";
        };
        ////////totalfuel///////
        _totfuelth = round(floor(_totfuelweight * 0.001));
        _totfuelhu = round(floor(10 * ((_totfuelweight * 0.001) - floor(_totfuelweight * 0.001))));
        _totfuelte = round(10 * (((floor(_totfuelweight * 0.1)) * 0.1) - floor((floor(_totfuelweight * 0.1)) * 0.1)));
        _totfuelsi = round(10 * ((_totfuelweight * 0.1) - floor(_totfuelweight * 0.1)));
        _totfuelformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totfuelth]) + "_ca.paa";
        _totfuelformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totfuelhu]) + "_ca.paa";
        _totfuelformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totfuelte]) + "_ca.paa";
        _totfuelformat4 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totfuelsi]) + "_ca.paa";
        /////totalendur//////
        _totfuelend = _totfuelweight * 0.001;
        _totfenhr = round(floor(_totfuelend));
        _totfuelend = round(60 * ((_totfuelweight * 0.001) - floor(_totfuelweight * 0.001)));
        _totfentm = round(10 * (((floor(_totfuelend * 0.1)) * 0.1) - floor((floor(_totfuelend * 0.1)) * 0.1)));
        _totfensm = round(10 * ((_totfuelend * 0.1) - floor(_totfuelend * 0.1)));
        _totfendformat1 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totfenhr]) + "_ca.paa";
        _totfendformat2 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totfentm]) + "_ca.paa";
        _totfendformat3 = "\fza_ah64_us\tex\CHAR\G" + (format["%1", _totfensm]) + "_ca.paa";

        if (fza_ah64_pl_mpd == "fuel") then {
            _heli setobjecttexture [SEL_PL_MPD_BACK, "\fza_ah64_us\tex\fuel.paa"];
            _heli setobjecttexture [SEL_PL_AFT_FUEL_N0, _aftfuelformat1];
            _heli setobjecttexture [SEL_PL_AFT_FUEL_N1, _aftfuelformat2];
            _heli setobjecttexture [SEL_PL_AFT_FUEL_N2, _aftfuelformat3];
            _heli setobjecttexture [SEL_PL_AFT_FUEL_N3, _aftfuelformat4];
            _heli setobjecttexture [SEL_PL_FLOW1_FUEL_N0, _leburnformat1];
            _heli setobjecttexture [SEL_PL_FLOW1_FUEL_N1, _leburnformat2];
            _heli setobjecttexture [SEL_PL_FLOW1_FUEL_N2, _leburnformat3];
            _heli setobjecttexture [SEL_PL_FLOW2_FUEL_N0, _reburnformat1];
            _heli setobjecttexture [SEL_PL_FLOW2_FUEL_N1, _reburnformat2];
            _heli setobjecttexture [SEL_PL_FLOW2_FUEL_N2, _reburnformat3];
            _heli setobjecttexture [SEL_PL_FWD_FUEL_N0, _fwdfuelformat1];
            _heli setobjecttexture [SEL_PL_FWD_FUEL_N1, _fwdfuelformat2];
            _heli setobjecttexture [SEL_PL_FWD_FUEL_N2, _fwdfuelformat3];
            _heli setobjecttexture [SEL_PL_FWD_FUEL_N3, _fwdfuelformat4];
            _heli setobjecttexture [SEL_PL_IAFS_FUEL_N0, _iafsformat1];
            _heli setobjecttexture [SEL_PL_IAFS_FUEL_N1, _iafsformat2];
            _heli setobjecttexture [SEL_PL_IAFS_FUEL_N2, _iafsformat3];
            _heli setobjecttexture [SEL_PL_IEND_FUEL_N0, _intfendformat1];
            _heli setobjecttexture [SEL_PL_IEND_FUEL_N1, _intfendformat2];
            _heli setobjecttexture [SEL_PL_IEND_FUEL_N2, _intfendformat3];
            _heli setobjecttexture [SEL_PL_INT_FUEL_N0, _intfuelformat1];
            _heli setobjecttexture [SEL_PL_INT_FUEL_N1, _intfuelformat2];
            _heli setobjecttexture [SEL_PL_INT_FUEL_N2, _intfuelformat3];
            _heli setobjecttexture [SEL_PL_INT_FUEL_N3, _intfuelformat4];
            _heli setobjecttexture [SEL_PL_TEND_FUEL_N0, _totfendformat1];
            _heli setobjecttexture [SEL_PL_TEND_FUEL_N1, _totfendformat2];
            _heli setobjecttexture [SEL_PL_TEND_FUEL_N2, _totfendformat3];
            _heli setobjecttexture [SEL_PL_TFLOW_FUEL_N0, _totburnformat1];
            _heli setobjecttexture [SEL_PL_TFLOW_FUEL_N1, _totburnformat2];
            _heli setobjecttexture [SEL_PL_TFLOW_FUEL_N2, _totburnformat3];
            _heli setobjecttexture [SEL_PL_TOT_FUEL_N0, _totfuelformat1];
            _heli setobjecttexture [SEL_PL_TOT_FUEL_N1, _totfuelformat2];
            _heli setobjecttexture [SEL_PL_TOT_FUEL_N2, _totfuelformat3];
            _heli setobjecttexture [SEL_PL_TOT_FUEL_N3, _totfuelformat4];
            _heli setobjecttexture [SEL_PL_WAUX1, _curwaux1];
            _heli setobjecttexture [SEL_PL_WAUX2, _curwaux2];
            _heli setobjecttexture [SEL_PL_WAUX3, _curwaux3];
            _heli setobjecttexture [SEL_PL_WAUX4, _curwaux4];
        } else {
            _heli setobjecttexture [SEL_PL_AFT_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_AFT_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_AFT_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_AFT_FUEL_N3, ""];
            _heli setobjecttexture [SEL_PL_AFT_LINE, ""];
            _heli setobjecttexture [SEL_PL_FLOW1_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_FLOW1_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_FLOW1_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_FLOW2_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_FLOW2_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_FLOW2_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_FWD_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_FWD_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_FWD_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_FWD_FUEL_N3, ""];
            _heli setobjecttexture [SEL_PL_FWD_LINE, ""];
            _heli setobjecttexture [SEL_PL_IAFS_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_IAFS_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_IAFS_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_IEND_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_IEND_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_IEND_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_INT_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_INT_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_INT_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_INT_FUEL_N3, ""];
            _heli setobjecttexture [SEL_PL_TEND_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_TEND_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_TEND_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_TFLOW_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_TFLOW_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_TFLOW_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_TOT_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PL_TOT_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PL_TOT_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PL_TOT_FUEL_N3, ""];
            _heli setobjecttexture [SEL_PL_WAUX1, ""];
            _heli setobjecttexture [SEL_PL_WAUX2, ""];
            _heli setobjecttexture [SEL_PL_WAUX3, ""];
            _heli setobjecttexture [SEL_PL_WAUX4, ""];
        };
        if (fza_ah64_pr_mpd == "fuel") then {
            _heli setobjecttexture [SEL_PR_MPD_BACK, "\fza_ah64_us\tex\fuel.paa"];
            _heli setobjecttexture [SEL_PR_AFT_FUEL_N0, _aftfuelformat1];
            _heli setobjecttexture [SEL_PR_AFT_FUEL_N1, _aftfuelformat2];
            _heli setobjecttexture [SEL_PR_AFT_FUEL_N2, _aftfuelformat3];
            _heli setobjecttexture [SEL_PR_AFT_FUEL_N3, _aftfuelformat4];
            _heli setobjecttexture [SEL_PR_FLOW1_FUEL_N0, _leburnformat1];
            _heli setobjecttexture [SEL_PR_FLOW1_FUEL_N1, _leburnformat2];
            _heli setobjecttexture [SEL_PR_FLOW1_FUEL_N2, _leburnformat3];
            _heli setobjecttexture [SEL_PR_FLOW2_FUEL_N0, _reburnformat1];
            _heli setobjecttexture [SEL_PR_FLOW2_FUEL_N1, _reburnformat2];
            _heli setobjecttexture [SEL_PR_FLOW2_FUEL_N2, _reburnformat3];
            _heli setobjecttexture [SEL_PR_FWD_FUEL_N0, _fwdfuelformat1];
            _heli setobjecttexture [SEL_PR_FWD_FUEL_N1, _fwdfuelformat2];
            _heli setobjecttexture [SEL_PR_FWD_FUEL_N2, _fwdfuelformat3];
            _heli setobjecttexture [SEL_PR_FWD_FUEL_N3, _fwdfuelformat4];
            _heli setobjecttexture [SEL_PR_IAFS_FUEL_N0, _iafsformat1];
            _heli setobjecttexture [SEL_PR_IAFS_FUEL_N1, _iafsformat2];
            _heli setobjecttexture [SEL_PR_IAFS_FUEL_N2, _iafsformat3];
            _heli setobjecttexture [SEL_PR_IEND_FUEL_N0, _intfendformat1];
            _heli setobjecttexture [SEL_PR_IEND_FUEL_N1, _intfendformat2];
            _heli setobjecttexture [SEL_PR_IEND_FUEL_N2, _intfendformat3];
            _heli setobjecttexture [SEL_PR_INT_FUEL_N0, _intfuelformat1];
            _heli setobjecttexture [SEL_PR_INT_FUEL_N1, _intfuelformat2];
            _heli setobjecttexture [SEL_PR_INT_FUEL_N2, _intfuelformat3];
            _heli setobjecttexture [SEL_PR_INT_FUEL_N3, _intfuelformat4];
            _heli setobjecttexture [SEL_PR_TEND_FUEL_N0, _totfendformat1];
            _heli setobjecttexture [SEL_PR_TEND_FUEL_N1, _totfendformat2];
            _heli setobjecttexture [SEL_PR_TEND_FUEL_N2, _totfendformat3];
            _heli setobjecttexture [SEL_PR_TFLOW_FUEL_N0, _totburnformat1];
            _heli setobjecttexture [SEL_PR_TFLOW_FUEL_N1, _totburnformat2];
            _heli setobjecttexture [SEL_PR_TFLOW_FUEL_N2, _totburnformat3];
            _heli setobjecttexture [SEL_PR_TOT_FUEL_N0, _totfuelformat1];
            _heli setobjecttexture [SEL_PR_TOT_FUEL_N1, _totfuelformat2];
            _heli setobjecttexture [SEL_PR_TOT_FUEL_N2, _totfuelformat3];
            _heli setobjecttexture [SEL_PR_TOT_FUEL_N3, _totfuelformat4];
            _heli setobjecttexture [SEL_PR_WAUX1, _curwaux1];
            _heli setobjecttexture [SEL_PR_WAUX2, _curwaux2];
            _heli setobjecttexture [SEL_PR_WAUX3, _curwaux3];
            _heli setobjecttexture [SEL_PR_WAUX4, _curwaux4];
        } else {
            _heli setobjecttexture [SEL_PR_AFT_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_AFT_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_AFT_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_AFT_FUEL_N3, ""];
            _heli setobjecttexture [SEL_PR_AFT_LINE, ""];
            _heli setobjecttexture [SEL_PR_FLOW1_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_FLOW1_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_FLOW1_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_FLOW2_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_FLOW2_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_FLOW2_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_FWD_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_FWD_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_FWD_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_FWD_FUEL_N3, ""];
            _heli setobjecttexture [SEL_PR_FWD_LINE, ""];
            _heli setobjecttexture [SEL_PR_IAFS_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_IAFS_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_IAFS_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_IEND_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_IEND_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_IEND_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_INT_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_INT_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_INT_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_INT_FUEL_N3, ""];
            _heli setobjecttexture [SEL_PR_TEND_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_TEND_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_TEND_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_TFLOW_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_TFLOW_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_TFLOW_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_TOT_FUEL_N0, ""];
            _heli setobjecttexture [SEL_PR_TOT_FUEL_N1, ""];
            _heli setobjecttexture [SEL_PR_TOT_FUEL_N2, ""];
            _heli setobjecttexture [SEL_PR_TOT_FUEL_N3, ""];
            _heli setobjecttexture [SEL_PR_WAUX1, ""];
            _heli setobjecttexture [SEL_PR_WAUX2, ""];
            _heli setobjecttexture [SEL_PR_WAUX3, ""];
            _heli setobjecttexture [SEL_PR_WAUX4, ""];
        };
    } else {
        _heli setobjecttexture [SEL_PL_AFT_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_AFT_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_AFT_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_AFT_FUEL_N3, ""];
        _heli setobjecttexture [SEL_PL_AFT_LINE, ""];
        _heli setobjecttexture [SEL_PL_FLOW1_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_FLOW1_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_FLOW1_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_FLOW2_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_FLOW2_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_FLOW2_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_FWD_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_FWD_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_FWD_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_FWD_FUEL_N3, ""];
        _heli setobjecttexture [SEL_PL_FWD_LINE, ""];
        _heli setobjecttexture [SEL_PL_IAFS_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_IAFS_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_IAFS_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_IEND_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_IEND_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_IEND_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_INT_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_INT_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_INT_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_INT_FUEL_N3, ""];
        _heli setobjecttexture [SEL_PL_TEND_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_TEND_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_TEND_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_TFLOW_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_TFLOW_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_TFLOW_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_TOT_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PL_TOT_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PL_TOT_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PL_TOT_FUEL_N3, ""];
        _heli setobjecttexture [SEL_PL_WAUX1, ""];
        _heli setobjecttexture [SEL_PL_WAUX2, ""];
        _heli setobjecttexture [SEL_PL_WAUX3, ""];
        _heli setobjecttexture [SEL_PL_WAUX4, ""];
        _heli setobjecttexture [SEL_PR_AFT_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_AFT_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_AFT_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_AFT_FUEL_N3, ""];
        _heli setobjecttexture [SEL_PR_AFT_LINE, ""];
        _heli setobjecttexture [SEL_PR_FLOW1_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_FLOW1_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_FLOW1_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_FLOW2_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_FLOW2_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_FLOW2_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_FWD_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_FWD_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_FWD_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_FWD_FUEL_N3, ""];
        _heli setobjecttexture [SEL_PR_FWD_LINE, ""];
        _heli setobjecttexture [SEL_PR_IAFS_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_IAFS_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_IAFS_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_IEND_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_IEND_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_IEND_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_INT_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_INT_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_INT_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_INT_FUEL_N3, ""];
        _heli setobjecttexture [SEL_PR_TEND_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_TEND_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_TEND_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_TFLOW_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_TFLOW_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_TFLOW_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_TOT_FUEL_N0, ""];
        _heli setobjecttexture [SEL_PR_TOT_FUEL_N1, ""];
        _heli setobjecttexture [SEL_PR_TOT_FUEL_N2, ""];
        _heli setobjecttexture [SEL_PR_TOT_FUEL_N3, ""];
        _heli setobjecttexture [SEL_PR_WAUX1, ""];
        _heli setobjecttexture [SEL_PR_WAUX2, ""];
        _heli setobjecttexture [SEL_PR_WAUX3, ""];
        _heli setobjecttexture [SEL_PR_WAUX4, ""];
    };
    sleep 0.1;
};