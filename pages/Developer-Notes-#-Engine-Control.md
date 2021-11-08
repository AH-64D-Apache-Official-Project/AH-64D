# Engine control system

This an explanation of how the engine control system works, how to extend it in the future and common pitfalls you may hit when dealing with rotorlib.

First of all, the new system was built to handle the following issues with the original system:

* Incorrect AFM engine data displayed on the engine MFD page and IHADSS
* The startup procedure, and data is inaccurate to the original aircraft.
* The original control system did not keep the engine torques stable and in sync, leading to instability in engine operation as one would try to do all the work (the one that started first)

The new system was built to handle these issues, and its main component is the state machine. Each engine has a state, and it is stored in the variable `fza_ah64_engineStates` *ON THE APACHE UNIT*. This means they can be retrieved using `_heli getVariable "fza_ah64_engineStates"` and assigned using `setVariable`.

**Note:** Make sure changes are propagated out to other clients to make it MP-compatible.

The variable takes the following form:

`[[engine 1 state, engine 1 param], [engine 2 state, engine 2 param]]`

Essentially, there is 1 array for each engine. The first element is the name of the state as a string, the second is the state parameter, some data that is also stored about the engine. What is here depends on the state.

# State diagram

![State machine](images/dev/engineStateMachine.png)

## States

| State | Params |
| :-- | :-- |
| `"OFF"` | N/A |
| `"OFFSTARTED` | The time the state was entered |
| `"STARTEDOFF` | The time the state was entered |
| `"STARTED"` | N/A |
| `"STARTEDIDLE"` | The time the state was entered |
| `"IDLE"` | N/A |
| `"IDLEOFF"` | The time the state was entered |
| `"IDLEFLY"` | The time the state was entered |
| `"FLY"` | N/A |
| `"FLYIDLE"` | The time the state was entered |

## Functions

States can transition for 2 main reasons - they hit a time (for the transition states), and should exit based on that, or an action was performed on the engine panel.

* Time-based transitions are handled by `fza_fnc_engineUpdate`, which checks if any of those conditions occur. This should be called by any function that uses the engine state, like `fza_fnc_engineGetData`, before said state is used.
* Action-based transitions are handled by `fza_fnc_engineSetPosition`, which can take in any of the actions in `engineConstants.h` and change the engine's state where necessary.

To get engine data, you should always go through `fza_fnc_engineGetData`. This calculates all the spoofed data too, like Ng and TGT to add to the mix.

The engines are controlled by `fza_fnc_engineGovernor`, which takes the engine state (and maybe some parameters) and controls the rotorlib simulation to ensure that the engines act accordingly. It itself uses `fza_fnc_engineGetTarget` which works out what each engine would like to do. The governor should be called very regularly (at least once every second), otherwise the rotorlib engines may work in an irregular manner.

The code was written in a very modular way, so to change some functionality just go into the related controller.