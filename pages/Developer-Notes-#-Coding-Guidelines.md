These are general coding guidelines for writing code in the apache mod. These are guidelines - not rules - and as such there may be circumstances where you should not follow them to make the code better. Just generally, if you follow these rules you cannot go far wrong.

This document is based roughly on the [ACE3 coding guidelines](https://ace3mod.com/wiki/development/coding-guidelines.html#64-return-values), though with some differentiation as we follow a different project structure to them. Primarily, we don't use macros as regularly as they do.

## Reasons for guidelines

* Code is written once, and read many times. For that reason we should write code to be easily read.
* This codebase is worked on by more than just one developer, by having a common standard the project is more cohesive and readable for all.
* If code is harder to read / not well explained it is easier for bugs to be present without us realising.
* Methods to avoid common mistakes are within the coding guidelines. By following them you are less likely to hit the same mistakes.

## Variable scopes and naming

1) All global variables (variables not beginning with a `_`) should start with the prefix `fza_ah64_<variable name>`.

2) Local and private variables should not have a prefix

3) All variables should use [`camelCase`](https://en.wikipedia.org/wiki/Camel_case) to signify spaces between words rather than [`snake_case`](https://en.wikipedia.org/wiki/Snake_case) (could get confused with the underscores in prefixes) or `PascalCase`

4) No variables will have `_fnc` in them so as to not get confused with functions

5) Variables should be given descriptive names that explain what they're storing (with exceptions for loops and variables like `_i`.)

### Bad:
```sqf
globalVariable = 1; // Bad - could collide with other mods.
_x = _a animate [_b, [_c, 0, 1] call BIS_fnc_clamp; // Way too obtuse, difficult to know what all these variable names are in
_MyVariable = []; // Is not in camelCase
_tmp = 7; // Unless this is a short lived variable, it should probably be given a better name.
```

### Good:
```sqf
fza_ah64_globalVariable
_heliSpeed
```

## Functions

1) All functions shall be defined using [CfgFunctions](https://community.bistudio.com/wiki/Arma_3:_Functions_Library). Functions to be `execVM`ed will never be added to the mod, in fact old functions that work like this should be moved to the new method gradually.

2) Functions will be organised into folders related to what they do, and named with a prefix that is the name of their folder. For example a function with in the `mpd` folder may be called `fza_fnc_mpd<name>`

> Only very general functions with no real category should not be categorised. These should be placed in the root of the `fza_ah64_controls/scripting/functions/` folder.

3) Before writing a function, check in the list of [Arma 3 Commands](https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands), [Arma 3 Functions](https://community.bistudio.com/wiki/Category:Arma_3:_Functions) and [CBA Functions](https://cbateam.github.io/CBA_A3/docs/files/overview-txt.html) to see if there is a function that already does what you want.

4) Where possible run functions using `call` in an unscheduled environment rather than in a scheduled one. For reasoning, please look at ACE3's ["Arma 3 Scheduler and our Practices"](https://ace3mod.com/wiki/development/arma-3-scheduler-and-our-practices.html)

5) All code will be documented in the naturaldocs style, I would recommend copy-pasting the header from another page and modifying it. _All_ sections should be filled.

## Function Parameters

1) If the apache helicopter object is passed in as an argument to your function, call it `_heli` for consistency.

2) For extracting parameters from a function, use the [`params`](https://community.bistudio.com/wiki/params) command, rather than `_this` and `select`. It also has good configuration for providing default values and checking input types if they are things you need to do:

### Bad
```sqf
_heli = _this select 0;
_mustBeNumber = _this select 1;
_withDefault = _this select 2;
```

### Good
```sqf
params ["_heli", ["_mustBeNumber", nil, [0]], ["_withDefault", 1]];
```