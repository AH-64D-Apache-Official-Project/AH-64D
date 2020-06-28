#include "\fza_ah64_controls\headers\selections.h"
if (!(isNil "fza_ah64_noeng")) exitwith {};
_heli = _this select 0;
_e1addcounter = 0;
_e2addcounter = 0;
_rpmmsg = 0;
_rotorrpm = 0;
_rotorrpmchar = "\fza_ah64_us\tex\char\g";
_rotorrpmformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_rotorrpmformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_rotorrpmformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_rotorrpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e1rpm = 0;
_e2rpm = 0;
_e1rpmchar = "\fza_ah64_us\tex\char\g";
_e1npformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1npformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1npformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1rpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e2rpmchar = "\fza_ah64_us\tex\char\g";
_e2npformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2npformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2npformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2rpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_ofb = "\fza_ah64_us\tex\mpd\eng.paa";
_ifb = "";
_tottorque = 0;
_e1trq = 0;
_e2trq = 0;
_e1trqchar = "\fza_ah64_us\tex\char\g";
_e1trqformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1trqformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1trqformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e2trqchar = "\fza_ah64_us\tex\char\g";
_e2trqformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2trqformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2trqformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_anitrq = 0;
_e1tgt = 0;
_e2tgt = 0;
_e1tgtchar = "\fza_ah64_us\tex\char\g";
_e1tgttape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e1tgtformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1tgtformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1tgtformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2tgtchar = "\fza_ah64_us\tex\char\g";
_e2tgtformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2tgtformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2tgtformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2tgttape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e1opsi = 0;
_e2opsi = 0;
_e1opsichar = "\fza_ah64_us\tex\char\g";
_e1opsiformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1opsiformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1opsiformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1opsitape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e2opsichar = "\fza_ah64_us\tex\char\g";
_e2opsiformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2opsiformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2opsiformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2opsitape = "\fza_ah64_us\tex\mpd\Gtape.paa";
_e1ng = 0;
_e2ng = 0;
_e1ngchar = "\fza_ah64_us\tex\char\g";
_e1ngformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1ngformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e1ngformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2ngchar = "\fza_ah64_us\tex\char\g";
_e2ngformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2ngformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_e2ngformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phyd = 1;
_phydformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phydformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phydformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phydformat4 = "\fza_ah64_us\tex\char\g0_ca.paa";
_uhyd = 1;
_uhydformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_uhydformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_uhydformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_uhydformat4 = "\fza_ah64_us\tex\char\g0_ca.paa";
_ahyd = 1;
_ahydformat1 = "\fza_ah64_us\tex\char\g0_ca.paa";
_ahydformat2 = "\fza_ah64_us\tex\char\g0_ca.paa";
_ahydformat3 = "\fza_ah64_us\tex\char\g0_ca.paa";
_ahydformat4 = "\fza_ah64_us\tex\char\g0_ca.paa";
_phyd1format1 = _phydformat1;
_phyd1format2 = _phydformat2;
_phyd1format3 = _phydformat3;
_phyd1format4 = _phydformat4;
_uhyd1format1 = _uhydformat1;
_uhyd1format2 = _uhydformat2;
_uhyd1format3 = _uhydformat3;
_uhyd1format4 = _uhydformat4;
_ahyd1format1 = _ahydformat1;
_ahyd1format2 = _ahydformat2;
_ahyd1format3 = _ahydformat3;
_ahyd1format4 = _ahydformat4;
_e1percent = 0;
_e2percent = 0;
_counter = 0;

_tgtTapeScaler = [
    [0, 0],
    [400, 0.10],
    [810, 0.60],
    [811, 0.70],
    [999, 1.00]
];
_npTapeScaler = [
    [0, 0],
    [96, 0.43],
    [99, 0.50],
    [100, 0.55],
    [102, 0.61],
    [105, 0.89],
    [120, 1.00]
];

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

    [_heli] call fza_fnc_engineGovernor;

    _e1data = [_heli, 0] call fza_fnc_engineGetData;
    _e1percent = (_e1data select 0) / 209.0;
    _e1ng = (_e1data select 1) * 10;
    _e1tgt = _e1data select 2;
    _e1opsi = _e1data select 3;
    _e1trq = (_e1data select 4) / 4.81;

    _e2data = [_heli, 1] call fza_fnc_engineGetData;
    _e2percent = (_e2data select 0) / 209.0;
    _e2ng = (_e2data select 1) * 10;
    _e2tgt = _e2data select 2;
    _e2opsi = _e2data select 3;
    _e2trq = (_e2data select 4) / 4.81;

    if ((_heli getVariable "fza_ah64_engineStates")# 0# 0 in ["OFF", "OFFSTARTED", "STARTEDOFF", "STARTED", "STARTEDIDLE", "IDLEOFF"] || (_heli getVariable "fza_ah64_engineStates")# 1# 0 in ["OFF", "OFFSTARTED", "STARTEDOFF", "STARTED", "STARTEDIDLE", "IDLEOFF"]) then {
        _rotorrpm = _e1percent max _e2percent;
    } else {
        _rotorrpm = (rotorsRpmRTD _heli# 0) / 2.89;
    };

    if (fza_ah64_pl_mpd == "eng" || fza_ah64_pr_mpd == "eng") then {
        _rotorrpmchar = "\fza_ah64_us\tex\char\g";
        _rotorrpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
        if (_rotorrpm < 110) then {
            _rpmmsg = 0;
        };
        if (_rotorrpm > 110 && isengineon _heli && (getpos _heli select 2) > 5) then {
            _rotorrpmchar = "\fza_ah64_us\tex\char\r";
            _rotorrpmtape = "\fza_ah64_us\tex\mpd\Rtape.paa";
            if (_rpmmsg == 0) then {
                ["fza_ah64_bt_rotorrpm", 1.7, "fza_ah64_bt_high", 1] execvm "\fza_ah64_controls\scripting\damage\dam_bt_audio.sqf";
                _rpmmsg = 1;
            };
        };
        if (_rotorrpm < 94) then {
            _rotorrpmchar = "\fza_ah64_us\tex\char\r";
            _rotorrpmtape = "\fza_ah64_us\tex\mpd\Rtape.paa";
        };
        _rotorrpmformat1 = [_rotorrpm, _rotorrpmchar] call fza_ah64_digithun;
        _rotorrpmformat2 = [_rotorrpm, _rotorrpmchar] call fza_ah64_digitten;
        _rotorrpmformat3 = [_rotorrpm, _rotorrpmchar] call fza_ah64_digit;

        _e1trqchar = "\fza_ah64_us\tex\char\g";
        _e1trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
        _e2trqchar = "\fza_ah64_us\tex\char\g";
        _e2trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";

        if (_e1trq > 0 && _e1trq < 100) then {
            _e1trqchar = "\fza_ah64_us\tex\char\g";
            _e1trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
        };
        if (_e1trq > 101 && _e1trq < 115) then {
            _e1trqchar = "\fza_ah64_us\tex\char\y";
            _e1trqtape = "\fza_ah64_us\tex\mpd\Ytape.paa";
        };
        if (_e1trq > 115) then {
            _e1trqchar = "\fza_ah64_us\tex\char\r";
            _e1trqtape = "\fza_ah64_us\tex\mpd\Rtape.paa";
        };

        if (_e2trq > 0 && _e2trq < 100) then {
            _e2trqchar = "\fza_ah64_us\tex\char\g";
            _e2trqtape = "\fza_ah64_us\tex\mpd\Gtape.paa";
        };
        if (_e2trq > 101 && _e2trq < 115) then {
            _e2trqchar = "\fza_ah64_us\tex\char\y";
            _e2trqtape = "\fza_ah64_us\tex\mpd\Ytape.paa";
        };
        if (_e2trq > 115) then {
            _e2trqchar = "\fza_ah64_us\tex\char\r";
            _e2trqtape = "\fza_ah64_us\tex\mpd\Rtape.paa";
        };





        _e1trqformat1 = [_e1trq, _e1trqchar] call fza_ah64_digit;
        _e1trqformat2 = [_e1trq, _e1trqchar] call fza_ah64_digitten;
        _e1trqformat3 = [_e1trq, _e1trqchar] call fza_ah64_digithun;
        _e2trqformat1 = [_e2trq, _e2trqchar] call fza_ah64_digit;
        _e2trqformat2 = [_e2trq, _e2trqchar] call fza_ah64_digitten;
        _e2trqformat3 = [_e2trq, _e2trqchar] call fza_ah64_digithun;

        _e1rpmchar = "\fza_ah64_us\tex\char\g";
        _e1rpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";

        _e1npformat1 = [_e1percent, _e1rpmchar] call fza_ah64_digithun;
        _e1npformat2 = [_e1percent, _e1rpmchar] call fza_ah64_digitten;
        _e1npformat3 = [_e1percent, _e1rpmchar] call fza_ah64_digit;

        _e2rpmchar = "\fza_ah64_us\tex\char\g";
        _e2rpmtape = "\fza_ah64_us\tex\mpd\Gtape.paa";

        _e2npformat1 = [_e2percent, _e2rpmchar] call fza_ah64_digithun;
        _e2npformat2 = [_e2percent, _e2rpmchar] call fza_ah64_digitten;
        _e2npformat3 = [_e2percent, _e2rpmchar] call fza_ah64_digit;

        _e1tgtpercent = round(_e1tgt);
        _e1tgtchar = "\fza_ah64_us\tex\char\g";
        _e1tgttape = "\fza_ah64_us\tex\mpd\Gtape.paa";

        _e1tgtformat1 = [_e1tgtpercent, _e1tgtchar] call fza_ah64_digithun;
        _e1tgtformat2 = [_e1tgtpercent, _e1tgtchar] call fza_ah64_digitten;
        _e1tgtformat3 = [_e1tgtpercent, _e1tgtchar] call fza_ah64_digit;

        _e2tgtpercent = round(_e2tgt);
        _e2tgtchar = "\fza_ah64_us\tex\char\g";
        _e2tgttape = "\fza_ah64_us\tex\mpd\Gtape.paa";

        _e2tgtformat1 = [_e2tgtpercent, _e2tgtchar] call fza_ah64_digithun;
        _e2tgtformat2 = [_e2tgtpercent, _e2tgtchar] call fza_ah64_digitten;
        _e2tgtformat3 = [_e2tgtpercent, _e2tgtchar] call fza_ah64_digit;

        _e1opsichar = "\fza_ah64_us\tex\char\g";
        if (_e1opsi < 20 || _e1opsi > 95) then {
            _e1opsichar = "\fza_ah64_us\tex\char\r";
        };
        _e1opsiformat1 = [_e1opsi, _e1opsichar] call fza_ah64_digithun;
        _e1opsiformat2 = [_e1opsi, _e1opsichar] call fza_ah64_digitten;
        _e1opsiformat3 = [_e1opsi, _e1opsichar] call fza_ah64_digit;

        _e2opsichar = "\fza_ah64_us\tex\char\g";
        if (_e2opsi < 20 || _e2opsi > 95) then {
            _e2opsichar = "\fza_ah64_us\tex\char\r";
        };
        _e2opsiformat1 = [_e2opsi, _e2opsichar] call fza_ah64_digithun;
        _e2opsiformat2 = [_e2opsi, _e2opsichar] call fza_ah64_digitten;
        _e2opsiformat3 = [_e2opsi, _e2opsichar] call fza_ah64_digit;
        _e1ngchar = "\fza_ah64_us\tex\char\g";
        if (_e1ng > 1023 && _e1ng < 1051) then {
            _e1ngchar = "\fza_ah64_us\tex\char\y";
            _e1ngtape = "\fza_ah64_us\tex\mpd\Ytape.paa";
        };
        if (_e1ng < 630 || _e1ng > 1051) then {
            _e1ngchar = "\fza_ah64_us\tex\char\r";
            _e1ngtape = "\fza_ah64_us\tex\mpd\Rtape.paa";
        };

        _e1ngformat1 = [_e1ng, _e1ngchar] call fza_ah64_digithun;
        _e1ngformat2 = [_e1ng, _e1ngchar] call fza_ah64_digitten;
        _e1ngformat3 = [_e1ng, _e1ngchar] call fza_ah64_digit;
        _e2ngchar = "\fza_ah64_us\tex\char\g";
        if (_e2ng > 1023 && _e2ng < 1051) then {
            _e2ngchar = "\fza_ah64_us\tex\char\y";
            _e2ngtape = "\fza_ah64_us\tex\mpd\Ytape.paa";
        };
        if (_e2ng < 630 || _e2ng > 1051) then {
            _e2ngchar = "\fza_ah64_us\tex\char\r";
            _e2ngtape = "\fza_ah64_us\tex\mpd\Rtape.paa";
        };

        _e2ngformat1 = [_e2ng, _e2ngchar] call fza_ah64_digithun;
        _e2ngformat2 = [_e2ng, _e2ngchar] call fza_ah64_digitten;
        _e2ngformat3 = [_e2ng, _e2ngchar] call fza_ah64_digit;

        //HYDRAULICS

        _phydformat = _phyd * 2970;
        _phydformat1 = [_phydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digitthou;
        _phydformat2 = [_phydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digithun;
        _phydformat3 = [_phydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digitten;
        _phydformat4 = [_phydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digit;
        _uhydformat = _uhyd * 2970;
        _uhydformat1 = [_uhydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digitthou;
        _uhydformat2 = [_uhydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digithun;
        _uhydformat3 = [_uhydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digitten;
        _uhydformat4 = [_uhydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digit;
        _ahydformat = _phyd * 3000;
        _ahydformat1 = [_ahydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digitthou;
        _ahydformat2 = [_ahydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digithun;
        _ahydformat3 = [_ahydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digitten;
        _ahydformat4 = [_ahydformat, "\fza_ah64_us\tex\char\g"] call fza_ah64_digit;

        _phyd1format1 = _phydformat1;
        _phyd1format2 = _phydformat2;
        _phyd1format3 = _phydformat3;
        _phyd1format4 = _phydformat4;
        _uhyd1format1 = _uhydformat1;
        _uhyd1format2 = _uhydformat2;
        _uhyd1format3 = _uhydformat3;
        _uhyd1format4 = _uhydformat4;
        _ahyd1format1 = _ahydformat1;
        _ahyd1format2 = _ahydformat2;
        _ahyd1format3 = _ahydformat3;
        _ahyd1format4 = _ahydformat4;

        if (getpos _heli select 2 > 1) then {
            _ifb = "\fza_ah64_us\tex\mpd\ifbox.paa";
            _ofb = "";
            _phydformat1 = "";
            _phydformat2 = "";
            _phydformat3 = "";
            _phydformat4 = "";
            _uhydformat1 = "";
            _uhydformat2 = "";
            _uhydformat3 = "";
            _uhydformat4 = "";
            _ahydformat1 = "";
            _ahydformat2 = "";
            _ahydformat3 = "";
            _ahydformat4 = "";
            _e1opsiformat1 = "";
            _e1opsiformat2 = "";
            _e1opsiformat3 = "";
            _e2opsiformat1 = "";
            _e2opsiformat2 = "";
            _e2opsiformat3 = "";
        } else {
            _ofb = "\fza_ah64_us\tex\mpd\eng.paa";
            _ifb = "";
            _phyd1format1 = "";
            _phyd1format2 = "";
            _phyd1format3 = "";
            _phyd1format4 = "";
            _uhyd1format1 = "";
            _uhyd1format2 = "";
            _uhyd1format3 = "";
            _uhyd1format4 = "";
            _ahyd1format1 = "";
            _ahyd1format2 = "";
            _ahyd1format3 = "";
            _ahyd1format4 = "";
        };
    };
    if (fza_ah64_pr_mpd == "eng") then {
        _heli setobjecttexture [SEL_PR_MPD_BACK, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_BACK, "\fza_ah64_us\tex\mpd\eng.paa"];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OFB, _ofb];
        _heli setobjecttexture [SEL_MPD_PR_ENG_IFB, _ifb];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1NPB, _e1rpmtape];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGTB, _e1tgttape];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2NPB, _e2rpmtape];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGTB, _e2tgttape];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQB, _e1trqtape];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQB, _e2trqtape];
        _heli setobjecttexture [SEL_MPD_PR_ENG_LTRQBAR, "\fza_ah64_us\tex\mpd\eng.paa"];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RTRRPMB, _rotorrpmtape];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGTBG, "\fza_ah64_us\tex\mpd\eng.paa"];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGTBG, "\fza_ah64_us\tex\mpd\eng.paa"];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQBG, "\fza_ah64_us\tex\mpd\eng.paa"];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQBG, "\fza_ah64_us\tex\mpd\eng.paa"];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGT1, _e1tgtformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGT2, _e1tgtformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGT3, _e1tgtformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGT1, _e2tgtformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGT2, _e2tgtformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGT3, _e2tgtformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQ1, _e1trqformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQ2, _e1trqformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQ3, _e1trqformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQ1, _e2trqformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQ2, _e2trqformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQ3, _e2trqformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_ACCPSI1, _ahydformat4];
        _heli setobjecttexture [SEL_MPD_PR_ENG_ACCPSI2, _ahydformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_ACCPSI3, _ahydformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_ACCPSI4, _ahydformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_UTIPSI1, _uhydformat4];
        _heli setobjecttexture [SEL_MPD_PR_ENG_UTIPSI2, _uhydformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_UTIPSI3, _uhydformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_UTIPSI4, _uhydformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_PRIPSI1, _phydformat4];
        _heli setobjecttexture [SEL_MPD_PR_ENG_PRIPSI2, _phydformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_PRIPSI3, _phydformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_PRIPSI4, _phydformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NG1, _e1ngformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NG2, _e1ngformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NG3, _e1ngformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NG1, _e2ngformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NG2, _e2ngformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NG3, _e2ngformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NP1, _e1npformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NP2, _e1npformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NP3, _e1npformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NP1, _e2npformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NP2, _e2npformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NP3, _e2npformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL1PSI1, _e1opsiformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL1PSI2, _e1opsiformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL1PSI3, _e1opsiformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL2PSI1, _e2opsiformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL2PSI2, _e2opsiformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL2PSI3, _e2opsiformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RRPM1, _rotorrpmformat3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RRPM2, _rotorrpmformat2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RRPM3, _rotorrpmformat1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1ACCPSI1, _ahyd1format4];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1ACCPSI2, _ahyd1format3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1ACCPSI3, _ahyd1format2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1ACCPSI4, _ahyd1format1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1UTIPSI1, _uhyd1format4];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1UTIPSI2, _uhyd1format3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1UTIPSI3, _uhyd1format2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1UTIPSI4, _uhyd1format1];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1PRIPSI1, _phyd1format4];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1PRIPSI2, _phyd1format3];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1PRIPSI3, _phyd1format2];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1PRIPSI4, _phyd1format1];
        if (local _heli) then {
            _heli animate["mpd_pr_eng_e1trq", _e1trq / 130.0];
            _heli animate["mpd_pr_eng_e2trq", _e2trq / 130.0];
            _heli animate["mpd_pr_eng_1tgt", ([_tgtTapeScaler, _e1tgt] call fza_fnc_linearInterp)# 1];
            _heli animate["mpd_pr_eng_2tgt", ([_tgtTapeScaler, _e2tgt] call fza_fnc_linearInterp)# 1];
            _heli animate["mpd_pr_eng_e1np", ([_npTapeScaler, _e1percent] call fza_fnc_linearInterp)# 1];
            _heli animate["mpd_pr_eng_e2np", ([_npTapeScaler, _e2percent] call fza_fnc_linearInterp)# 1];

            _heli animate["mpd_pr_eng_rtrrpm", ([_npTapeScaler, _rotorrpm] call fza_fnc_linearInterp)# 1];
        };
    } else {
        _heli setobjecttexture [SEL_MPD_PR_ENG_1NPB, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGT_1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGT1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGT2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGT3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGTB, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TGTBG, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2NPB, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGT_1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGT1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGT2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGT3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGTB, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TGTBG, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQ1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQ2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQ3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQB, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1TRQBG, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQ1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQ2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQ3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQB, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_2TRQBG, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_LTRQBAR, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_ACCPSI1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_ACCPSI2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_ACCPSI3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_ACCPSI4, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_UTIPSI1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_UTIPSI2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_UTIPSI3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_UTIPSI4, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_PRIPSI1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_PRIPSI2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_PRIPSI3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_PRIPSI4, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NG1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NG2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NG3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NG1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NG2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NG3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NP1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NP2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E1NP3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NP1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NP2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_E2NP3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL1PSI1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL1PSI2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL1PSI3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL2PSI1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL2PSI2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OIL2PSI3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RRPM1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RRPM2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RRPM3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA4, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA5, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA6, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA7, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA8, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA9, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA10, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA11, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_WCA12, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_IFB, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_OFB, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RTRRPMB, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_HPA, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_HPP, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_HPU, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RBE1NG, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RBE1NP, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RBE1OP, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RBE2NG, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RBE2NP, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_RBE2OP, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1ACCPSI1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1ACCPSI2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1ACCPSI3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1ACCPSI4, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1UTIPSI1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1UTIPSI2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1UTIPSI3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1UTIPSI4, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1PRIPSI1, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1PRIPSI2, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1PRIPSI3, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_1PRIPSI4, ""];
        _heli setobjecttexture [SEL_MPD_PR_ENG_BACK, ""];
    };
    sleep 0.03;
};