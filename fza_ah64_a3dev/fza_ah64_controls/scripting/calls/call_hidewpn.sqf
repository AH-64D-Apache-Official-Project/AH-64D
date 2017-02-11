private ["_val","_num"];
_heli = _this select 0;
_num = 227;

while{(_num >= 0)} do
{
_heli setobjecttexture [_num,""];
_num = _num - 1;
};