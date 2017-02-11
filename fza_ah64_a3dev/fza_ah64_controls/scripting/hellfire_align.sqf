_array = _this;
_ah64 = _this select 0;
_weapon = _this select 1;
_ammotype = _this select 4;
_missobj = _this select 6;
_mags = magazines _ah64;
_offset1 = [-2.4,2.3,-2.35];
_offset2 = [-1.7,2.3,-2.35];
_offset3 = [1.7,2.3,-2.35];
_offset4 = [2.4,2.3,-2.35];
_offset = _offset1;

if (_missobj isKindOf "fza_agm114l") then
{

if(_weapon == "fza_agm114_14_8") then
{
_ammocnt = _ah64 ammo _weapon;
if(_ammocnt == 7) then {_offset = _offset4;};
if(_ammocnt == 6) then {_offset = _offset1;};
if(_ammocnt == 5) then {_offset = _offset4;};
if(_ammocnt == 4) then {_offset = _offset1;};
if(_ammocnt == 3) then {_offset = _offset4;};
if(_ammocnt == 2) then {_offset = _offset1;};
if(_ammocnt == 1) then {_offset = _offset4;};
if(_ammocnt == 0) then {_offset = _offset1;};
};

if(_weapon == "fza_agm114_23_8") then
{
_ammocnt = _ah64 ammo _weapon;
if(_ammocnt == 7) then {_offset = _offset3;};
if(_ammocnt == 6) then {_offset = _offset2;};
if(_ammocnt == 5) then {_offset = _offset3;};
if(_ammocnt == 4) then {_offset = _offset2;};
if(_ammocnt == 3) then {_offset = _offset3;};
if(_ammocnt == 2) then {_offset = _offset2;};
if(_ammocnt == 1) then {_offset = _offset3;};
if(_ammocnt == 0) then {_offset = _offset2;};
};

if (_weapon in fza_ah64_hellfireweps1) then
{
_offset = _offset1;
};

if (_weapon in fza_ah64_hellfireweps2) then
{
_offset = _offset2;
};

if (_weapon in fza_ah64_hellfireweps3) then
{
_offset = _offset3;
};

if (_weapon in fza_ah64_hellfireweps4) then
{
_offset = _offset4;
};

_worldPos = _ah64 modelToWorldVisual _offset;
_missobj setPos _worldPos;

_pbvar = _missobj call fza_ah64_getpb;
_dir = direction _missobj;
_angle = (_pbvar select 0) + ((_ah64 animationphase "pylon1")*10);
_pitch = (_pbvar select 1);

_vecdx = sin(_dir) * cos(_angle);
_vecdy = cos(_dir) * cos(_angle);
_vecdz = sin(_angle);

_vecux = cos(_dir) * cos(_angle) * sin(_pitch);
_vecuy = sin(_dir) * cos(_angle) * sin(_pitch);
_vecuz = cos(_angle) * cos(_pitch);

_missobj setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];

[_missobj] call fza_ah64_fx_rktmsl;
};