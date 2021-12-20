class CfgVehicles {
    class Helicopter;
    class Helicopter_Base_F: Helicopter {
        class EventHandlers;
    };
    class fza_ah64base : Helicopter_Base_F {
        class EventHandlers: EventHandlers {
            class fza_dms {
                init = "[_this # 0] call fza_dms_fnc_init"; //<-- C51 always is the user positio
            };
        };
    };
};

/***
Waypoints/Hazards = 1 to 50 (50 possible)

--Ident (ABR) - FzaIconTypes 2 Char Identifier
--Free Text (3 char string)
--Grid "13S FU 1234 5678" format  <-- Default in KU = 4713SFU12345678
--Alt in feet (gnd for targets, ideally air for waypoints) <-- Use the aircraft

array of:
    [_ident, _freeText, _type, _iconTex, _iconOffset, _iconType, _armaPos, _gridCoord, _latLong, _altMsl, _altAgl]
    or
    -1 for not found
    C05

[heli, type, index, ident, free, pos, altMsl] call fza_dms_fnc_pointCreate
true if success, false if fail

[heli, type, index, valueType] call fza_dms_fnc_pointGetValue
nil if fail
Value otherwise

[heli, type, index, valueType, newValue] call fza_dms_fnc_pointEditValue
true if success, false if fail

[heli, type, index] call fza_dms_fnc_pointDelete
true if success, false if fail

[type, ident] call fza_dms_fnc_pointIsValidIdent
true if success, false if fail

Control Measures  = 51 to 99 (49 possible)
--93 thru 99 = Present Position icons
Target/Threats    = 1 to 50 (50 possible)
-----------------------------------------
149 total points

ID ABR "W84 47 13S FU" 1234 5678 ALT

***/