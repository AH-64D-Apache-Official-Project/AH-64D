params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#define SALVO_ALL 99

private _rocketInventory = [_heli] call fza_fnc_weaponRocketInventory;

private _curAmmo = getText (configFile >> "CfgWeapons" >> _heli getVariable "fza_ah64_selectedRocket" >> "fza_ammoType");
if (_heli getVariable "fza_ah64_rocketsalvo" == SALVO_ALL) then {
    [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_SALVO), "ALL"] call fza_mpd_fnc_updateMfdText;
} else {
    [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_SALVO), (_heli getVariable "fza_ah64_rocketsalvo") toFixed 0] call fza_mpd_fnc_updateMfdText;
};

private _rocketInvIndex = _rocketInventory findIf {if (_x isEqualTo []) then {false} else {_x # 0 == _curAmmo}};
if (_rocketInvIndex != -1) then {
    (_rocketInventory # _rocketInvIndex) params ["", "_selectedRktQty", "_selectedRktPylons", "_selectedRktText"];
    [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_TOT_QTY), _selectedRktQty toFixed 0] call fza_mpd_fnc_updateMfdText;
} else {
    [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_TOT_QTY), "0"] call fza_mpd_fnc_updateMfdText;
};
[_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_RKT_SELECTED_INV), _rocketInvIndex] call fza_mpd_fnc_updateMfdValue;

//Rkt inventory options (left side of WPN page)
{
    if !(_x isEqualTo []) then {
        _x params ["", "_rktQty", "", "_rktText"];
        [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_INV_1_NAME + _forEachIndex), _rktText] call fza_mpd_fnc_updateMfdText;
        [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_INV_1_QTY + _forEachIndex), _rktQty toFixed 0] call fza_mpd_fnc_updateMfdText;
    } else {
        [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_INV_1_NAME + _forEachIndex), ""] call fza_mpd_fnc_updateMfdText;
        [_heli, MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_RKT_INV_1_QTY + _forEachIndex), ""] call fza_mpd_fnc_updateMfdText;
    };
} forEach (_rocketInventory);

_this call fza_mpd_fnc_WpnQuantityDraw;