// Stub for HEMTT build - CBA keybinding component
#define WARNING_1(msg,a1)
#define WARNING_2(msg,a1,a2)
#define QUOTE(var1) #var1
#define DOUBLES(var1,var2) var1##_##var2
#define ADDON CBA_keybinding
#define GVAR(var1) DOUBLES(ADDON,var1)
#define QGVAR(var1) QUOTE(GVAR(var1))
#define HASH_NULL []
#define KEYBIND_NULL 0
#define DIK_ESCAPE 0x01
#define DIK_LSHIFT 0x2A
#define DIK_RSHIFT 0x36
#define DIK_LCONTROL 0x1D
#define DIK_RCONTROL 0x9D
#define DIK_LMENU 0x38
#define DIK_RMENU 0xB8
