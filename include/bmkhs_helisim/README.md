# HeliSim Core headers - vendored copy

These are copies of HeliSim Core's headers, committed here so the AH-64D builds
with nothing but `hemtt build` - no submodule, no junction, no setup step. It is
the same arrangement as `include/x/cba` and `include/z/ace` beside it.

**Matches HeliSim Core 1.1.0.0** (copied at 1.0.1.0; 1.0.2.0 and 1.1.0.0 changed none of these headers).

**Do not edit these files here.** Change them in HeliSim Core, then copy them
back over. The procedure, and why it is done this way, is in HeliSim Core's
`docs/AIRCRAFT_GUIDE.md` under "Building your mod against Core's headers".

Only the headers an AH-64D file actually `#include`s are here:

| Header | Included by |
|---|---|
| `functions/systems/systems.hpp` | `SYS_*` thresholds - WPN, turret aim, WCA, FCR, IHADSS, fire, auxtank, ASE |
| `functions/core/core.hpp` | unit and speed constants - controls preInit, WCA, fuel page, IHADSS |
| `functions/fuel/fuel.hpp` | fuel thresholds - WCA, `fn_fuelGetData` |
| `fmOverride.hpp` | `fza_ah64_helisim/config/cfgVehicles.hpp` |
| `hitPoints.hpp` | `fza_ah64_helisim/config/cfgVehicles.hpp` |
| `controlMacros.hpp` | `fza_ah64_helisim/config/CfgUserActions.hpp` |

HeliSim's *code* is not here and is not needed to build: every `bmkhs_fnc_*`
runs from the HeliSim Core mod loaded in game, which must be the same version
as these headers.
