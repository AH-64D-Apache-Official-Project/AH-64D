private["_heli"];
_heli = _this select 0;
if (!(player in _heli)) exitwith {};
if (!(isnil "fza_ah64_enableturrets")) exitwith {};
_estate = 0;
_turdir = 0;
_turelev = 0;
_pnvsdir = 0;
_pnvselev = 0.5;
_pylonelev = 0;
_pylonelev1 = 0;
_pylonelev2 = 0;
_pylonelev3 = 0;
_pylonelev4 = 0;
_headdir = 0;
_headelev = 0;
_head1dir = 0;
_head1elev = 0;

_wPos = [0, 0, 0];
_targvel = [0, 0, 0];
_targspeed = 0;
_targasl = [0, 0, 0];
_distfactor = 0;
_relvel = 0;
_finalX = 0;
_finalY = 0;
_elevation = 0;
_azimuth = 0;
_gunbank = 0;
_distval = 150;
_distval2 = 50;
_distfactor2 = 1;
_powerfactor = 1.9;
_toffactor = 0.002;
_rktavgvel = 990;

// AUTOTRACK
if ((fza_ah64_guncontrol == 1 || fza_ah64_guncontrol == 2) && (gunner _heli == player || driver _heli == player) && (local gunner _heli || (isNull gunner _heli && local _heli) || (local _heli && !(alive gunner _heli)))) then {
    if (!(gunner _heli == player) || (gunner _heli == player)) then {
        if (isNull fza_ah64_mycurrenttarget || fza_ah64_guncontrol == 1) then {
            _wPos = screentoworld[0.5, 0.5];
            _targvel = [0, 0, 0];
            _targspeed = 0;
            _targasl = [(_wPos select 0), (_wPos select 1), (getTerrainHeightASL[(_wPos select 0), (_wPos select 1)])];
        } else {
            _wPos = fza_ah64_mycurrenttarget modelToWorldVisual(fza_ah64_mycurrenttarget selectionposition "zamerny");
            _targvel = velocity fza_ah64_mycurrenttarget;
            _targspeed = speed fza_ah64_mycurrenttarget;
            _targasl = getposasl fza_ah64_mycurrenttarget;
        };
        _helipos = _heli modelToWorldVisual(_heli selectionposition "usti hlavne");
        if (_targasl select 2 < 0) then {
            _targasl = [(_targasl select 0), (_targasl select 1), 0];
        };

        ////keep this for later in case we add manual ranging///
        //if(inputaction "FlapsUp" > 0.5) then {_distval = _distval + 50; _distval2 = _distval2 + 5; hint format ["%1",_distval2];};
        //if(inputaction "FlapsDown" > 0.5) then {_distval = _distval - 50; _distval2 = _distval2 - 5; hint format ["%1",_distval2];};

        //if(_distval < 1) then {_distval = 1;};
        //if(_distval2 < 1) then {_distval2 = 1;};

        ////ROCKETTABLE////
        ///<500m = 0m
        ///850m = 5m
        ///2000m = 15m
        ///2250 = 18m
        ///2500m = 22m
        ///4km = 49.5
        ///4km average vel 625ms

        _distfactor = 3;

        ////GUNTABLE////
        //0.086 == 2250m == 193.5m == 1.845
        //0.061 == 2000m == 122m == 1.878
        //0.043 == 1750m == 75.25m == 1.902
        //0.031 == 1500m == 46.5m == 1.915
        //0.014 == 1000m == 14m == 1.935
        //0.006 == 500m == 3m == 1.92
        //0.002 == 250m == 0.5m == 1.91
        //0.001 == <250m == 0.5m == 1.91
        //4.6x

        _powerfactor = 2;
        _toffactor = 850;
        _rktavgvel = 1260;
        if (_heli distance _targasl > 90) then {
            _powerfactor = 1.99;
            _toffactor = 840;
            _distfactor = 3;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 190) then {
            _powerfactor = 1.9895;
            _toffactor = 835;
            _distfactor = 3;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 290) then {
            _powerfactor = 1.989;
            _toffactor = 830;
            _distfactor = 3;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 390) then {
            _powerfactor = 1.9885;
            _toffactor = 825;
            _distfactor = 3;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 490) then {
            _powerfactor = 1.988;
            _toffactor = 820;
            _distfactor = 3.5;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 590) then {
            _powerfactor = 1.9875;
            _toffactor = 815;
            _distfactor = 5.3;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 690) then {
            _powerfactor = 1.987;
            _toffactor = 810;
            _distfactor = 5.6;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 790) then {
            _powerfactor = 1.9865;
            _toffactor = 805;
            _distfactor = 5.9;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 890) then {
            _powerfactor = 1.986;
            _toffactor = 800;
            _distfactor = 6;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 990) then {
            _powerfactor = 1.9855;
            _toffactor = 795;
            _distfactor = 7;
            _rktavgvel = 1060;
        };
        if (_heli distance _targasl > 1090) then {
            _powerfactor = 1.985;
            _toffactor = 790;
            _distfactor = 9;
            _rktavgvel = 1010;
        };
        if (_heli distance _targasl > 1190) then {
            _powerfactor = 1.9845;
            _toffactor = 785;
            _distfactor = 10;
            _rktavgvel = 950;
        };
        if (_heli distance _targasl > 1290) then {
            _powerfactor = 1.984;
            _toffactor = 780;
            _distfactor = 11;
            _rktavgvel = 850;
        };
        if (_heli distance _targasl > 1390) then {
            _powerfactor = 1.9833;
            _toffactor = 775;
            _distfactor = 12;
            _rktavgvel = 800;
        };
        if (_heli distance _targasl > 1490) then {
            _powerfactor = 1.9826;
            _toffactor = 770;
            _distfactor = 13.2;
            _rktavgvel = 700;
        };
        if (_heli distance _targasl > 1740) then {
            _powerfactor = 1.9819;
            _toffactor = 760;
            _distfactor = 14;
            _rktavgvel = 650;
        };
        if (_heli distance _targasl > 1990) then {
            _powerfactor = 1.981;
            _toffactor = 740;
            _distfactor = 17;
            _rktavgvel = 640;
        };
        if (_heli distance _targasl > 2050) then {
            _powerfactor = 1.98;
            _toffactor = 720;
            _distfactor = 18;
            _rktavgvel = 620;
        };
        if (_heli distance _targasl > 2150) then {
            _powerfactor = 1.978;
            _toffactor = 700;
            _distfactor = 20;
            _rktavgvel = 610;
        };
        if (_heli distance _targasl > 2250) then {
            _powerfactor = 1.977;
            _toffactor = 680;
            _distfactor = 21;
            _rktavgvel = 600;
        };
        if (_heli distance _targasl > 2500) then {
            _powerfactor = 1.976;
            _toffactor = 660;
            _distfactor = 23.3;
            _rktavgvel = 580;
        };
        if (_heli distance _targasl > 2900) then {
            _powerfactor = 1.974;
            _distfactor = 31.5;
            _rktavgvel = 360;
        };
        if (_heli distance _targasl > 3400) then {
            _powerfactor = 1.972;
            _distfactor = 40.9;
            _rktavgvel = 320;
        };
        if (_heli distance _targasl > 3900) then {
            _powerfactor = 1.965;
            _distfactor = 54;
            _rktavgvel = 280;
        };
        if (_heli distance _targasl > 4400) then {
            _powerfactor = 1.95;
            _distfactor = 67;
            _rktavgvel = 230;
        };

        _distfactor2 = (((_heli distance _targasl) * 0.01) ^ 2) - (((_heli distance _targasl) * 0.01) ^ _powerfactor);

        //_tof = (_heli distance _targasl) * _toffactor;
        //_tof = (_heli distance _targasl) / _toffactor;
        _tof = (_heli distance _targasl) / (1700 - ((_heli distance _targasl) ^ 0.6));
        if (currentweapon _heli in fza_ah64_rocketweps14 || currentweapon _heli in fza_ah64_rocketweps23 || currentweapon _heli in fza_ah64_rocketweps1 || currentweapon _heli in fza_ah64_rocketweps2 || currentweapon _heli in fza_ah64_rocketweps3 || currentweapon _heli in fza_ah64_rocketweps4) then {
            _tof = (_heli distance _targasl) / (1800 - ((_heli distance _targasl) ^ 0.6));
        };

        _vxcor = ((_targvel select 0) - (velocity _heli select 0)) * _tof;
        _vycor = ((_targvel select 1) - (velocity _heli select 1)) * _tof;
        _vzcor = ((_targvel select 2) - (velocity _heli select 2)) * _tof;

        _finalX = (_targasl select 0) + _vxcor;
        _finaly = (_targasl select 1) + _vycor;
        _finalZ = (_targasl select 2) + _vzcor + _distfactor;
        _finalZ2 = (_targasl select 2) + _vzcor + _distfactor2;

        //note to self: next time make something simple like a tricycle or a baseball//
        _targdir = ((_helipos select 0) - (_finalX)) atan2((_finalY) - (_helipos select 1));
        _helidir = direction _heli;
        if (_helidir > 180) then {
            _helidir = _helidir - 360;
        };
        _targdir = _targdir + _helidir;
        if (_targdir < -180) then {
            _targdir = _targdir + 360;
        };
        if (_targdir > 180) then {
            _targdir = _targdir - 360;
        };

        _targelev = ((getposasl _heli select 2) - (_finalZ)) atan2([_finalX, _finalY, 0] distance[(_helipos select 0), (_helipos select 1), 0]);
        _targelevg = ((getposasl _heli select 2) - (_finalZ2)) atan2([_finalX, _finalY, 0] distance[(_helipos select 0), (_helipos select 1), 0]);
        //player globalchat format ["%1 %2",_targelev,_distfactor2];

        _pbvar = _heli call fza_fnc_getPitchBank;
        _pitch = _pbvar select 0;
        _bank = _pbvar select 1;
        _azimuth = (_targdir * (cos _bank)) + ((-1 * (_targelevg + _pitch)) * (sin _bank));
        if (_azimuth > 0) then {
            _gunbank = _bank * -1;
        };
        if (_azimuth <= 0) then {
            _gunbank = _bank;
        };
        _elevation = (_targelevg + (_pitch * (cos _targdir)) + (_bank * (sin _targdir))) * (cos _pitch);
        _pylonelev = ((-1 * _targdir) * (sin _bank)) + ((-1 * (_targelev + _pitch)) * (cos _bank));

        _finalZ2 = (_wPos select 2) + _vzcor + _distfactor2;
        if (currentweapon _heli == "Laserdesignator_mounted" || (!(isNull lasertarget _heli) && (currentweapon _heli == "fza_agm114_23_8" || currentweapon _heli == "fza_agm114_14_8" || currentweapon _heli in fza_ah64_hellfireweps1 || currentweapon _heli in fza_ah64_hellfireweps2 || currentweapon _heli in fza_ah64_hellfireweps3 || currentweapon _heli in fza_ah64_hellfireweps4))) then {
            _finalZ2 = (_wPos select 2);
        };
        _modpos = _heli worldtomodel[_finalX, _finaly, _finalZ2];
        _gunpos = _heli selectionPosition "osahlavne";
        _modpos = [(_modpos select 0) - (_gunpos select 0), (_modpos select 1) - (_gunpos select 1), (_modpos select 2) - (_gunpos select 2)];
        _modposX = (_modpos select 0) atan2(_modpos select 1);
        _azimuth = ((_modpos select 0) atan2(_modpos select 1)) * -1;
        _elevation = (((_modpos select 2) atan2(((_modpos select 1) * (cos _modposX)) + ((_modpos select 0) * (sin _modposX))))) * -1;

        if (!(currentweapon _heli in fza_ah64_rocketweps14 || currentweapon _heli in fza_ah64_rocketweps23 || currentweapon _heli in fza_ah64_rocketweps1 || currentweapon _heli in fza_ah64_rocketweps2 || currentweapon _heli in fza_ah64_rocketweps3 || currentweapon _heli in fza_ah64_rocketweps4)) then {
            _pylonelev = 5;
        };
        if (!(isengineon _heli)) then {
            _pylonelev = 0;
            _elevation = -7;
            _azimuth = 0;
        };
        if ("fza_ah64_gun_fail" in (_heli magazinesturret[-1]) || ("fza_ah64_rwp_fail" in (_heli magazinesturret[-1]) && "fza_ah64_lwp_fail" in (_heli magazinesturret[-1]))) then {
            _azimuth = 0;
            _elevation = -10;
        };
        if (_elevation > 55) then {
            _elevation = 55;
        };
        if (_elevation < -15) then {
            _elevation = -15;
        };
        if (_azimuth < -110) then {
            _azimuth = -110;
        };
        if (_azimuth > 110) then {
            _azimuth = 110;
        };
        if (_pylonelev > 10) then {
            _pylonelev = 10;
        };
        if (_pylonelev < -10) then {
            _pylonelev = -10;
        };
        if ("fza_ah64_rwp_fail" in (_heli magazinesturret[-1]) && "fza_ah64_lwp_fail" in (_heli magazinesturret[-1])) then {
            _pylonelev = 5.07;
        };
        fza_ah64_pylonelev1 = _pylonelev;
        fza_ah64_pylonelev2 = _pylonelev;
        fza_ah64_pylonelev3 = _pylonelev;
        fza_ah64_pylonelev4 = _pylonelev;
        if ("fza_auxtank_230_1" in magazines _heli) then {
            fza_ah64_pylonelev1 = 5;
        };
        if ("fza_auxtank_230_2" in magazines _heli) then {
            fza_ah64_pylonelev2 = 5;
        };
        if ("fza_auxtank_230_3" in magazines _heli) then {
            fza_ah64_pylonelev3 = 5;
        };
        if ("fza_auxtank_230_4" in magazines _heli) then {
            fza_ah64_pylonelev4 = 5;
        };
        _heli animate["mainTurret", (_azimuth * 0.0174528)];
        _heli animate["mainGun", (_elevation * -0.0174528)];
        _heli animate["pylon1", (fza_ah64_pylonelev1 * 0.1)];
        _heli animate["pylon2", (fza_ah64_pylonelev2 * 0.1)];
        _heli animate["pylon3", (fza_ah64_pylonelev3 * 0.1)];
        _heli animate["pylon4", (fza_ah64_pylonelev4 * 0.1)];
    };
};

// NORM

if (((fza_ah64_guncontrol == 0 || fza_ah64_guncontrol == 3) && (local gunner _heli || (isNull gunner _heli && local _heli) || (local _heli && !(alive gunner _heli)))) || (!(gunner _heli == player || driver _heli == player) && (local _heli))) then {
    if (fza_ah64_turdir > 1.5) then {
        fza_ah64_turdir = 1.5
    };
    if (fza_ah64_turdir < -1.5) then {
        fza_ah64_turdir = -1.5
    };
    if (fza_ah64_turelev > 0.2) then {
        fza_ah64_turelev = 0.2
    };
    if (fza_ah64_turelev < -1) then {
        fza_ah64_turelev = -1
    };
    _curcontrol = (_heli animationphase "tads_tur");
    _curguncontrol = (_heli animationphase "tads");
    if (_curcontrol > 1.5) then {
        _curcontrol = 1.5;
    };
    if (_curcontrol < -1.5) then {
        _curcontrol = -1.5;
    };
    if (_curguncontrol > 0.28777) then {
        _curguncontrol = 0.28777;
    };
    if (fza_ah64_guncontrol == 3 && (gunner _heli == player || driver _heli == player) || !(isengineon _heli)) then {
        _curcontrol = 0;
        _curguncontrol = 0.17;
    };
    if (currentweapon _heli in fza_ah64_rocketweps14 || currentweapon _heli in fza_ah64_rocketweps23 || currentweapon _heli in fza_ah64_rocketweps1 || currentweapon _heli in fza_ah64_rocketweps2 || currentweapon _heli in fza_ah64_rocketweps3 || currentweapon _heli in fza_ah64_rocketweps4) then {
        //0.28777//
        fza_ah64_pylonelev = _curguncontrol;
        if ("fza_ah64_rwp_fail" in (_heli magazinesturret[-1]) && "fza_ah64_lwp_fail" in (_heli magazinesturret[-1])) then {
            fza_ah64_pylonelev = 5.07;
        };
        if (_curguncontrol > 0) then {
            fza_ah64_pylonelev = _curguncontrol * 3;
        };
        if (_curguncontrol < 0) then {
            fza_ah64_pylonelev = _curguncontrol * 6;
        };
        if (fza_ah64_pylonelev > 1) then {
            fza_ah64_pylonelev = 1;
        };
        if (fza_ah64_pylonelev < -1) then {
            fza_ah64_pylonelev = -1;
        };
        fza_ah64_pylonelev1 = fza_ah64_pylonelev;
        fza_ah64_pylonelev2 = fza_ah64_pylonelev;
        fza_ah64_pylonelev3 = fza_ah64_pylonelev;
        fza_ah64_pylonelev4 = fza_ah64_pylonelev;
        if ("fza_auxtank_230_1" in magazines _heli) then {
            fza_ah64_pylonelev1 = 0.507;
        };
        if ("fza_auxtank_230_2" in magazines _heli) then {
            fza_ah64_pylonelev2 = 0.507;
        };
        if ("fza_auxtank_230_3" in magazines _heli) then {
            fza_ah64_pylonelev3 = 0.507;
        };
        if ("fza_auxtank_230_4" in magazines _heli) then {
            fza_ah64_pylonelev4 = 0.507;
        };
        _heli animate["pylon1", (fza_ah64_pylonelev1)];
        _heli animate["pylon2", (fza_ah64_pylonelev2)];
        _heli animate["pylon3", (fza_ah64_pylonelev3)];
        _heli animate["pylon4", (fza_ah64_pylonelev4)];
    } else {
        _heli animate["pylon1", 0.507];
        _heli animate["pylon2", 0.507];
        _heli animate["pylon3", 0.507];
        _heli animate["pylon4", 0.507];
    };
    if ("fza_ah64_gun_fail" in (_heli magazinesturret[-1]) || ("fza_ah64_rwp_fail" in (_heli magazinesturret[-1]) && "fza_ah64_lwp_fail" in (_heli magazinesturret[-1]))) then {
        _curcontrol = 0;
        _curguncontrol = 0.17;
    };
    _heli animate["mainTurret", _curcontrol];
    _heli animate["mainGun", _curguncontrol];
};