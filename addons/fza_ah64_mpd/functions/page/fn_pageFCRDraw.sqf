#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli", "_mpdIndex", "_state", "_persistState"];

private _fcrMode = _heli getVariable "fza_ah64_fcrMode";
private _cScope  = _heli getVariable "fza_ah64_fcrcscope";

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_CSCOPE), BOOLTONUM(_cScope)];
_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_SCAN_SIZE), _heli getVariable ["fza_ah64_fcrScanSize", 0]];
if (_heli animationPhase "fcr_enable" == 0) then {_fcrMode = FCR_DISP_MODE_OFF;};

// RMAP and TPM have their own pages
if (_fcrMode in [FCR_DISP_MODE_RMAP, FCR_DISP_MODE_TPM]) exitWith {
    [_heli, _mpdIndex, ["fcrrmap", "fcrtpm"] select (_fcrMode == FCR_DISP_MODE_TPM)] call fza_mpd_fnc_setCurrentPage;
};

_heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_FCR_MODE), _fcrMode];

switch _fcrMode do {
    case FCR_DISP_MODE_OFF: { //NOT INSTALLED
        [_heli, "fza_ah64_fcrTargets", []] call fza_fnc_updateNetworkGlobal;
        if (((_heli getVariable "fza_ah64_fcrState") # 0) != FCR_MODE_OFF) then {
            _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, CBA_missionTime], true];
        };
        // Targets live on the scope HTML canvas — push an empty picture
        [[_heli, _mpdIndex] call fza_mpd_fnc_htmlCtrl, "fzaFCRScope.update", '{"mode":1,"targets":[],"shots":[]}'] call fza_mpd_fnc_htmlPush;
    };
    case FCR_DISP_MODE_GTM: {
        _this call fza_mpd_fnc_fcrGTMDraw;
    };
    case FCR_DISP_MODE_ATM: {
        _this call fza_mpd_fnc_fcrATMDraw;
    };
};

[_heli, _mpdIndex] call fza_mpd_fnc_fcrStatusDraw;
