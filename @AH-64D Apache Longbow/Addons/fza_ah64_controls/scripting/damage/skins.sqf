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
    _heli setObjectTextureGlobal[1150, "\fza_ah64_us\tex\ex\fcr_co.paa"];
    //FCR//
    _heli setObjectTextureGlobal[1151, "\fza_ah64_us\tex\ex\fcr_co.paa"];
};
//PNVS//
_heli setObjectTextureGlobal[1152, _mainskin];
//hstab
_heli setObjectTextureGlobal[1153, _mainskin];
//twsus
_heli setObjectTextureGlobal[1154, _mainskin];
//alq1
_heli setObjectTextureGlobal[1155, "\fza_ah64_us\tex\ex\disco_co.paa"];
//alq2
_heli setObjectTextureGlobal[1156, _mainskin];
//cockpit
_heli setObjectTextureGlobal[1157, "\fza_ah64_us\tex\ex\Int.paa"];
//cockpit glass
_heli setObjectTextureGlobal[1158, "\fza_ah64_us\tex\ex\win_ca.paa"];
//fuse
_heli setObjectTextureGlobal[1159, _mainskin];
//fuse ld
_heli setObjectTextureGlobal[1160, "\fza_ah64_us\tex\ex\win_ca.paa"];
//lefab
_heli setObjectTextureGlobal[1161, _mainskin];
//lelight
_heli setObjectTextureGlobal[1162, "\fza_ah64_us\tex\ex\win_ca.paa"];
//leng
_heli setObjectTextureGlobal[1163, _mainskin];
//lgear
_heli setObjectTextureGlobal[1164, _mainskin];
//lwing
_heli setObjectTextureGlobal[1165, _mainskin];
//m230
_heli setObjectTextureGlobal[1166, _mainskin];
//mainrotor mech
_heli setObjectTextureGlobal[1167, "\fza_ah64_us\tex\ex\rtrs_co.paa"];
//nose
_heli setObjectTextureGlobal[1168, _mainskin];
//pylon1
_heli setObjectTextureGlobal[1169, _mainskin];
//pylon2
_heli setObjectTextureGlobal[1170, _mainskin];
//pylon3
_heli setObjectTextureGlobal[1171, _mainskin];
//pylon4
_heli setObjectTextureGlobal[1172, _mainskin];
//refab
_heli setObjectTextureGlobal[1173, _mainskin];
//relight
_heli setObjectTextureGlobal[1174, "\fza_ah64_us\tex\ex\win_ca.paa"];
//reng
_heli setObjectTextureGlobal[1175, _mainskin];
//rgear
_heli setObjectTextureGlobal[1176, _mainskin];
//rwing
_heli setObjectTextureGlobal[1177, _mainskin];
//tads1
_heli setObjectTextureGlobal[1178, _mainskin];
//tads2
_heli setObjectTextureGlobal[1179, "fza_ah64_us\tex\ex\optic_co.paa"];
//tads3
_heli setObjectTextureGlobal[1180, "\fza_ah64_us\tex\ex\win_ca.paa"];
//tailboom
_heli setObjectTextureGlobal[1181, _mainskin];
//tailboom ld
_heli setObjectTextureGlobal[1182, "\fza_ah64_us\tex\ex\win_ca.paa"];
//tailrotor mech
_heli setObjectTextureGlobal[1183, "\fza_ah64_us\tex\ex\rtrs_co.paa"];
//vtail
_heli setObjectTextureGlobal[1184, _mainskin];
//REFAB DAM HEAVY
_heli setObjectTextureGlobal[1185, _mainskin];
//REFAB DAM CATA
_heli setObjectTextureGlobal[1186, _mainskin];
//LEFAB DAM HEAVY
_heli setObjectTextureGlobal[1187, _mainskin];
//LEFAB DAM CATA
_heli setObjectTextureGlobal[1188, _mainskin];
//tail blades
_heli setObjectTextureGlobal[1244, "\fza_ah64_us\tex\ex\rtrs_co.paa"];
//main blades
_heli setObjectTextureGlobal[1246, "\fza_ah64_us\tex\ex\rtrs_co.paa"];