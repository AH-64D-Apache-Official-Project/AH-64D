//MASTER INIT FOR AH-64D PROJECT
#include "\fza_ah64_controls\headers\selections.h"
_heli = _this select 0;

if (!(isNil "fza_ah64_noinit")) exitwith {};

if !(_heli getVariable ["fza_ah64_aircraftInitialised", false]) then {
    _heli setVariable ["fza_ah64_aircraftInitialised", true, true];
    _heli selectweapon "fza_ma_safe";
    _heli animate["pdoor", 1];
    _heli animate["gdoor", 1];
    _heli animate["plt_rtrbrake", 1];
    _heli animate["plt_firesw", 0.5];
    _heli animate["cpg_firesw", 0.5];
    _heli animate["tads_stow", 1];
    _heli setVariable ["fza_ah64_estarted", false, true];
    _heli setVariable ["fza_ah64_agmode", 0, true];
    _heli setVariable ["fza_ah64_pfzs", [[],[],[],[],[],[],[],[]], true];
    _heli setVariable ["fza_ah64_pfz_count", 0, true];
    _heli setVariable ["fza_ah64_curwpnum", 0, true];
    _heli setVariable ["fza_ah64_waypointdata", [getPos _heli], true];
    _heli setVariable ["fza_ah64_acq_plt", 3, true];
    _heli setVariable ["fza_ah64_acq_cpg", 3, true];
    _heli setVariable ["fza_ah64_hmdfsmode", "trans", true];
    _heli setVariable ["fza_ah64_ltype", "TopDown", true];
    _heli setVariable ["fza_ah64_shotat_list", [], true];
    _heli setVariable ["fza_ah64_shotmissile_list", [], true];
    _heli setVariable ["fza_ah64_tsdsort", 0, true];
    _heli setVariable ["fza_ah64_currentLase", objNull, true];
    _heli setVariable ["fza_ah64_currentSkippedLases", [], true];
};
_heli setVariable ["fza_ah64_aseautopage", 0];
_heli setVariable ["fza_ah64_mpdPage", ["OFF", "OFF"]];
_heli setVariable ["fza_ah64_mpdCurrPage", ["OFF", "OFF"]];
_heli setVariable ["fza_ah64_burst_limit", 10];
_heli setVariable ["fza_ah64_fcrcscope", false];
_heli setVariable ["fza_ah64_ihadssoff", 1];
_heli setVariable ["fza_ah64_ihadss_pnvs_cam", false];
_heli setVariable ["fza_ah64_ihadss_pnvs_day", true];
_heli setVariable ["fza_ah64_monocleinbox", true];
_heli setVariable ["fza_ah64_mpdbrightness", 1];
_heli setVariable ["fza_ah64_rangesetting", 0.001]; //1km
_heli setVariable ["fza_ah64_rocketsalvo", 1];
_heli setVariable ["fza_ah64_tsdmode", "nav"];

[_heli] call fza_fnc_engineInit;

_skinset = 0;
if (!(_heli in fza_ah64_skinlist)) then {
    _setskin = [_heli, "\fza_ah64_us\tex\ex\b2_weather_co.paa"] execvm "\fza_ah64_controls\scripting\damage\skins.sqf";
    _skinset = 1;
};


//DEFAULT WEIGHT 

if ((weightRTD _heli select 3) == 0) then {
    if (typeof _heli == "fza_ah64d_b2e") then {
        _heli setCustomWeightRTD 295;
    };
};

_aiturrets = [_heli] execvm "\fza_ah64_controls\scripting\turrets.sqf";
_blades = [_heli] execvm "\fza_ah64_controls\scripting\bladerot.sqf";

if (typeOf _heli == "fza_ah64d_b2e") then {
    [_heli] execvm "\fza_ah64_controls\scripting\fcr_animate.sqf";
};

while {
    alive _heli
}
do {
    if ((!isNull (_heli getVariable["fza_ah64_floodlight_cpg", objNull]) || (!isNull (_heli getVariable["fza_ah64_floodlight_plt", objNull]))) && _heli animationphase "plt_batt" < 0.5) then {

        _heli setobjecttexture [SEL_IN_BACKLIGHT, ""];
        _heli setobjecttexture [SEL_IN_BACKLIGHT2, ""];

        deleteVehicle(_heli getVariable["fza_ah64_floodlight_plt", objnull]);
        deleteVehicle(_heli getVariable["fza_ah64_floodlight_cpg", objnull]);
    };

    _mags = magazines _heli;
    _magsp = _heli magazinesturret[-1];

    if (local _heli) then {
        _tadsShouldBeStowed = _heli animationphase "plt_apu" < 1 && !isEngineOn _heli;
        
        if (_tadsShouldBeStowed && _heli animationPhase "tads_stow" == 0) then {
            _heli animate ["tads_stow", 1];
        };
        if (!_tadsShouldBeStowed && _heli animationPhase "tads_stow" == 1) then {
            _heli animate ["tads_stow", 0];
        };
    };

    if (damage _heli > 0.001) then {
        _skinset = 0;
    };

    if (damage _heli < 0.001) then {
        //////light//////
        _heli setobjecttexture [SEL_DAM_FUSE, ""];
        _heli setobjecttexture [SEL_DAM_GDOOR, ""];
        _heli setobjecttexture [SEL_DAM_HSTAB, ""];
        _heli setobjecttexture [SEL_DAM_LEFAB, ""];
        _heli setobjecttexture [SEL_DAM_LENG, ""];
        _heli setobjecttexture [SEL_DAM_LGEAR, ""];
        _heli setobjecttexture [SEL_DAM_LWING, ""];
        _heli setobjecttexture [SEL_DAM_NOSE, ""];
        _heli setobjecttexture [SEL_DAM_PDOOR, ""];
        _heli setobjecttexture [SEL_DAM_PNVS, ""];
        _heli setobjecttexture [SEL_DAM_PYLON1, ""];
        _heli setobjecttexture [SEL_DAM_PYLON2, ""];
        _heli setobjecttexture [SEL_DAM_PYLON3, ""];
        _heli setobjecttexture [SEL_DAM_PYLON4, ""];
        _heli setobjecttexture [SEL_DAM_REFAB, ""];
        _heli setobjecttexture [SEL_DAM_RENG, ""];
        _heli setobjecttexture [SEL_DAM_RGEAR, ""];
        _heli setobjecttexture [SEL_DAM_RWING, ""];
        _heli setobjecttexture [SEL_DAM_TADS, ""];
        _heli setobjecttexture [SEL_DAM_TAILBOOM, ""];
        _heli setobjecttexture [SEL_DAM_VTAIL, ""];
        ///////medium//////////
        _heli setobjecttexture [SEL_MDAM_FUSE, ""];
        _heli setobjecttexture [SEL_MDAM_GDOOR, ""];
        _heli setobjecttexture [SEL_MDAM_HSTAB, ""];
        _heli setobjecttexture [SEL_MDAM_LEFAB, ""];
        _heli setobjecttexture [SEL_MDAM_LENG, ""];
        _heli setobjecttexture [SEL_MDAM_LGEAR, ""];
        _heli setobjecttexture [SEL_MDAM_LWING, ""];
        _heli setobjecttexture [SEL_MDAM_NOSE, ""];
        _heli setobjecttexture [SEL_MDAM_PDOOR, ""];
        _heli setobjecttexture [SEL_MDAM_PNVS, ""];
        _heli setobjecttexture [SEL_MDAM_PYLON1, ""];
        _heli setobjecttexture [SEL_MDAM_PYLON2, ""];
        _heli setobjecttexture [SEL_MDAM_PYLON3, ""];
        _heli setobjecttexture [SEL_MDAM_PYLON4, ""];
        _heli setobjecttexture [SEL_MDAM_REFAB, ""];
        _heli setobjecttexture [SEL_MDAM_RENG, ""];
        _heli setobjecttexture [SEL_MDAM_RGEAR, ""];
        _heli setobjecttexture [SEL_MDAM_RWING, ""];
        _heli setobjecttexture [SEL_MDAM_TADS, ""];
        _heli setobjecttexture [SEL_MDAM_TAILBOOM, ""];
        _heli setobjecttexture [SEL_MDAM_VTAIL, ""];
        //////catastrophic/////
        _heli setobjecttexture [SEL_SKIN_TAILBOOM_TEAR, ""];
        if (_skinset == 0) then {
            _skinselector = 0;
            while {
                (_skinselector < count fza_ah64_skinlist)
            }
            do {
                if (fza_ah64_skinlist select _skinselector == _heli) then {
                    _setskin = [_heli, (fza_ah64_skinlist select(_skinselector + 1))] execvm "\fza_ah64_controls\scripting\damage\skins.sqf";
                    _selector = count fza_ah64_skinlist;
                };
                _skinselector = _skinselector + 2;
            };
            _skinset = 1;
        };
        if (local _heli || player == gunner _heli) then {
            //////light////////
            _heli removemagazinesturret["fza_ah64_dam_fuse", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_nose", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_leng", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_reng", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_lfab", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_rfab", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_lwing", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_rwing", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_tailboom", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_vtail", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_hstab", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_pylon1", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_pylon2", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_pylon3", [-1]];
            _heli removemagazinesturret["fza_ah64_dam_pylon4", [-1]];
            //////medium//////
            _heli removemagazinesturret["fza_ah64_mdam_fuse", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_nose", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_leng", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_reng", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_lfab", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_rfab", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_lwing", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_rwing", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_tailboom", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_vtail", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_hstab", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_pylon1", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_pylon2", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_pylon3", [-1]];
            _heli removemagazinesturret["fza_ah64_mdam_pylon4", [-1]];
            //////catastrophic////
            _heli removemagazinesturret["fza_ah64_cdam_tailboom", [-1]];
            //////systems/////
            _heli removemagazinesturret["fza_ah64_tailrotor_dam", [-1]];
            _heli removemagazinesturret["fza_ah64_tailrotor_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_rotor_dam", [-1]];
            _heli removemagazinesturret["fza_ah64_rotor_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_tads_dam", [-1]];
            _heli removemagazinesturret["fza_ah64_tads_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_pnvs_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_gun_jam", [-1]];
            _heli removemagazinesturret["fza_ah64_gun_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_trans_dam", [-1]];
            _heli removemagazinesturret["fza_ah64_trans_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_fcr_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_fwd_leak", [-1]];
            _heli removemagazinesturret["fza_ah64_aft_leak", [-1]];
            _heli removemagazinesturret["fza_ah64_rdp_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_ldp_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_rwp_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_lwp_fail", [-1]];
            _heli removemagazinesturret["fza_ah64_irjamfail", [-1]];
            _heli removemagazinesturret["fza_ah64_rfjamfail", [-1]];
            _heli removemagazinesturret["fza_ah64_firepdisch", [-1]];
            _heli removemagazinesturret["fza_ah64_firerdisch", [-1]];
        };
    };

    if ("fza_ah64_dam_fuse" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_FUSE, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_nose" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_GDOOR, "\fza_ah64_us\tex\dam\ldam.paa"];
        _heli setobjecttexture [SEL_DAM_NOSE, "\fza_ah64_us\tex\dam\ldam.paa"];
        _heli setobjecttexture [SEL_DAM_PDOOR, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_leng" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_LENG, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_reng" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_RENG, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_lfab" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_LEFAB, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_rfab" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_REFAB, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_lwing" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_LWING, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_rwing" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_RWING, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_tailboom" in _magsp && !("fza_ah64_cdam_tailboom" in _magsp)) then {
        _heli setobjecttexture [SEL_DAM_TAILBOOM, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_vtail" in _magsp && !("fza_ah64_cdam_tailboom" in _magsp)) then {
        _heli setobjecttexture [SEL_DAM_VTAIL, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_hstab" in _magsp && !("fza_ah64_cdam_tailboom" in _magsp)) then {
        _heli setobjecttexture [SEL_DAM_HSTAB, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_tads_dam" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_TADS, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_pylon1" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_PYLON1, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_pylon2" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_PYLON2, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_pylon3" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_PYLON3, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_dam_pylon4" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_PYLON4, "\fza_ah64_us\tex\dam\ldam.paa"];
    };
    if ("fza_ah64_pnvs_fail" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_PNVS, "\fza_ah64_us\tex\dam\ldam.paa"];
    };

    if ("fza_ah64_mdam_fuse" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_FUSE, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_nose" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_GDOOR, "\fza_ah64_us\tex\dam\mdam.paa"];
        _heli setobjecttexture [SEL_MDAM_NOSE, "\fza_ah64_us\tex\dam\mdam.paa"];
        _heli setobjecttexture [SEL_MDAM_PDOOR, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_leng" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_LENG, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_reng" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_RENG, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_lfab" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_LEFAB, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_rfab" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_REFAB, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_lwing" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_LWING, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_rwing" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_RWING, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_tailboom" in _magsp && !("fza_ah64_cdam_tailboom" in _magsp)) then {
        _heli setobjecttexture [SEL_MDAM_TAILBOOM, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_vtail" in _magsp && !("fza_ah64_cdam_tailboom" in _magsp)) then {
        _heli setobjecttexture [SEL_MDAM_VTAIL, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_hstab" in _magsp && !("fza_ah64_cdam_tailboom" in _magsp)) then {
        _heli setobjecttexture [SEL_MDAM_HSTAB, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_tads_fail" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_TADS, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_pylon1" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_PYLON1, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_pylon2" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_PYLON2, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_pylon3" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_PYLON3, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_mdam_pylon4" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_PYLON4, "\fza_ah64_us\tex\dam\mdam.paa"];
    };
    if ("fza_ah64_pnvs_fail" in _magsp) then {
        _heli setobjecttexture [SEL_MDAM_PNVS, "\fza_ah64_us\tex\dam\mdam.paa"];
    };

    if ("fza_ah64_cdam_tailboom" in _magsp) then {
        _heli setobjecttexture [SEL_DAM_TAILBOOM, ""];
        _heli setobjecttexture [SEL_DAM_VTAIL, ""];
        _heli setobjecttexture [SEL_DAM_HSTAB, ""];
        _heli setobjecttexture [SEL_MDAM_TAILBOOM, ""];
        _heli setobjecttexture [SEL_MDAM_VTAIL, ""];
        _heli setobjecttexture [SEL_MDAM_HSTAB, ""];
        //model//
        _heli setobjecttexture [SEL_SKIN_HSTAB, ""];
        _heli setobjecttexture [SEL_SKIN_TAILBOOM, ""];
        _heli setobjecttexture [SEL_SKIN_TAILROTOR, ""];
        _heli setobjecttexture [SEL_SKIN_VTAIL, ""];
        _heli setobjecttexture [SEL_SKIN_TAILBOOM_TEAR, "\fza_ah64_us\tex\dam\metdam_co.paa"];
        _skinset = 0;
    };
};