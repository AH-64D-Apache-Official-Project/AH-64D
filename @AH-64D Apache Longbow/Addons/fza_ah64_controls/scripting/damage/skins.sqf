#include "\fza_ah64_controls\headers\selections.h"
_heli = _this select 0;
_mainskin = _this select 1;

if (isNil "fza_ah64_skinlist") then {
    fza_ah64_skinlist = [_heli, _mainskin];
};

if (_heli in fza_ah64_skinlist) then {
    _skinselector = 0;
    while {
        (_skinselector < count fza_ah64_skinlist)
    }
    do {
        if (fza_ah64_skinlist select _skinselector == _heli) then {
            fza_ah64_skinlist set[(_skinselector + 1), _mainskin];
            _skinselector = count fza_ah64_skinlist;
        };
        _skinselector = _skinselector + 2;
    };
} else {
    fza_ah64_skinlist = fza_ah64_skinlist + [_heli, _mainskin];
};

//_mainskin = "\fza_ah64_us\tex\ex\b2_co.paa";

//if(isNil "fza_ah64_skinlist") then {fza_ah64_skinlist = [];};

//SKIN INDEX 1150 - 1184//
if (typeOf _heli == "fza_ah64d_b2e") then {
    //MAST//
    _heli setobjecttexture [SEL_MAST, "\fza_ah64_us\tex\ex\fcr_co.paa"];
    //FCR//
    _heli setobjecttexture [SEL_LONGBOW, "\fza_ah64_us\tex\ex\fcr_co.paa"];
};
//PNVS//
_heli setobjecttexture [SEL_SKIN_PNVS, _mainskin];
//hstab
_heli setobjecttexture [SEL_SKIN_HSTAB, _mainskin];
//twsus
_heli setobjecttexture [SEL_TWSUS, _mainskin];
//alq1
_heli setobjecttexture [SEL_SKIN_ALQ1, "\fza_ah64_us\tex\ex\disco_co.paa"];
//alq2
_heli setobjecttexture [SEL_SKIN_ALQ2, _mainskin];
//cockpit
_heli setobjecttexture [SEL_SKIN_COCKPIT, "\fza_ah64_us\tex\ex\Int.paa"];
//cockpit glass
_heli setobjecttexture [SEL_SKIN_COCKPITGLASS, "\fza_ah64_us\tex\ex\win_ca.paa"];
//fuse
_heli setobjecttexture [SEL_SKIN_FUSE, _mainskin];
//fuse ld
_heli setobjecttexture [SEL_SKIN_FUSE_LD, "\fza_ah64_us\tex\ex\win_ca.paa"];
//lefab
_heli setobjecttexture [SEL_SKIN_LEFAB, _mainskin];
//lelight
_heli setobjecttexture [SEL_SKIN_LELIGHT, "\fza_ah64_us\tex\ex\win_ca.paa"];
//leng
_heli setobjecttexture [SEL_SKIN_LENG, _mainskin];
//lgear
_heli setobjecttexture [SEL_SKIN_LGEAR, _mainskin];
//lwing
_heli setobjecttexture [SEL_SKIN_LWING, _mainskin];
//m230
_heli setobjecttexture [SEL_SKIN_M230, _mainskin];
//mainrotor mech
_heli setobjecttexture [SEL_SKIN_MAINROTOR, "\fza_ah64_us\tex\ex\rtrs_co.paa"];
//nose
_heli setobjecttexture [SEL_SKIN_NOSE, _mainskin];
//pylon1
_heli setobjecttexture [SEL_SKIN_PYLON1, _mainskin];
//pylon2
_heli setobjecttexture [SEL_SKIN_PYLON2, _mainskin];
//pylon3
_heli setobjecttexture [SEL_SKIN_PYLON3, _mainskin];
//pylon4
_heli setobjecttexture [SEL_SKIN_PYLON4, _mainskin];
//refab
_heli setobjecttexture [SEL_SKIN_REFAB, _mainskin];
//relight
_heli setobjecttexture [SEL_SKIN_RELIGHT, "\fza_ah64_us\tex\ex\win_ca.paa"];
//reng
_heli setobjecttexture [SEL_SKIN_RENG, _mainskin];
//rgear
_heli setobjecttexture [SEL_SKIN_RGEAR, _mainskin];
//rwing
_heli setobjecttexture [SEL_SKIN_RWING, _mainskin];
//tads1
_heli setobjecttexture [SEL_SKIN_TADS1, _mainskin];
//tads2
_heli setobjecttexture [SEL_SKIN_TADS2, "fza_ah64_us\tex\ex\optic_co.paa"];
//tads3
_heli setobjecttexture [SEL_SKIN_TADS3, "\fza_ah64_us\tex\ex\win_ca.paa"];
//tailboom
_heli setobjecttexture [SEL_SKIN_TAILBOOM, _mainskin];
//tailboom ld
_heli setobjecttexture [SEL_SKIN_TAILBOOM_LD, "\fza_ah64_us\tex\ex\win_ca.paa"];
//tailrotor mech
_heli setobjecttexture [SEL_SKIN_TAILROTOR, "\fza_ah64_us\tex\ex\rtrs_co.paa"];
//vtail
_heli setobjecttexture [SEL_SKIN_VTAIL, _mainskin];
//REFAB DAM HEAVY
_heli setobjecttexture [SEL_SKIN_REFAB_D_HEAVY, _mainskin];
//REFAB DAM CATA
_heli setobjecttexture [SEL_SKIN_REFAB_D_CATA, _mainskin];
//LEFAB DAM HEAVY
_heli setobjecttexture [SEL_SKIN_LEFAB_D_HEAVY, _mainskin];
//LEFAB DAM CATA
_heli setobjecttexture [SEL_SKIN_LEFAB_D_CATA, _mainskin];
//tail blades
_heli setobjecttexture [SEL_TR_BLADES, "\fza_ah64_us\tex\ex\rtrs_co.paa"];
//main blades
_heli setobjecttexture [SEL_MR_BLADES, "\fza_ah64_us\tex\ex\rtrs_co.paa"];