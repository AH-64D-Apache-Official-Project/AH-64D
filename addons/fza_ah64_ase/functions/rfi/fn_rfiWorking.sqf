/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rfiWorking

Description:
    Whether the RFI is fitted, powered and undamaged

Parameters:
    _heli - the helicopter

Returns:
    Bool

Examples:
    if ([_heli] call fza_ase_fnc_rfiWorking) then {...};

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli"];

_heli animationPhase "fcr_enable" == 1
&& {_heli getVariable ["bmkhs_dcBusOn", false]}
&& {(_heli getVariable ["fza_ah64_ase_rfiPwr", ASE_RFI_STATE_ON]) == ASE_RFI_STATE_ON}
&& {_heli getHitPointDamage "hit_msnEquip_fcr" < SYS_FCR_DMG_THRESH}
