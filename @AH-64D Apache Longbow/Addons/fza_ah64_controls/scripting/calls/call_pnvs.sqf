private["_heli"];
_heli = _this select 0;
if (player == driver _heli && (vehicle player) isKindOf "fza_ah64base") then {

    _headcenter = inputaction "LookCenter";
    _heli animate["pnvs", fza_ah64_pnvsdir];
    _heli animate["pnvs_vert", fza_ah64_pnvselev];
	
	fza_ah64_pnvsdir = fza_ah64_pnvsdir + fza_ah64_headdir;
    fza_ah64_pnvselev = fza_ah64_pnvselev + fza_ah64_headelev;

    if (player == driver _heli && (_heli animationphase "plt_apu" > 0.5 || isengineon _heli)) then {
        fza_ah64_headdir = (-0.0125 * (0.0125 * inputaction "LookLeft")) + (0.0125 * (0.0125 * inputaction "LookRight"));
        fza_ah64_headelev = (0.0125 * (0.0125 * inputaction "LookUp")) + (-0.0125 * (0.0125 * inputaction "LookDown"));
    };

    if (_headcenter > 0) then {
        fza_ah64_pnvsdir = 0;
        fza_ah64_pnvselev = 0.5;
        fza_ah64_turdir = 0;
        fza_ah64_turelev = 0;
    };

    if (fza_ah64_tiron) then {
        fza_ah64_pnvselev = (-5 * (inputaction "LookDownCont")) + (5 * (inputaction "LookUpCont")) + 0.5;
        fza_ah64_pnvsdir = (-1.5 * (inputaction "LookLeftCont")) + (1.5 * (inputaction "LookRightCont"));
    };

    if (missionNameSpace getVariable["fza_ah64_headTrack", false] && (cameraView == "INTERNAL")) then {
        private _vectToTarget = [0, 0, 0] vectorFromTo(getCameraViewDirection player);
        private _vectorModelSpace = _heli vectorWorldToModel _vectToTarget;
        private _angleX = asin(_vectorModelSpace# 0);
        private _angleY = (asin(_vectorModelSpace# 2) + 8); // 4.74764 is the vertical offset between helo and view dir
        fza_ah64_pnvsdir = _angleX * (0.75 / 90);
        fza_ah64_pnvselev =
            if (_angleY < 0) then[{
                _angleY * (1 / 45)
            }, {
                _angleY * (1 / 20)
            }];
    };

    fza_ah64_pnvsdir = fza_ah64_pnvsdir min 0.75 max - 0.75;
    fza_ah64_pnvselev = fza_ah64_pnvselev min 1 max - 1;

    if ("fza_ah64_pnvs_fail" in (_heli magazinesturret[-1])) then {
        fza_ah64_pnvsdir = -1;
        fza_ah64_pnvselev = 1;
    };
};
