_heli = _this select 0;

if(!(player == gunner _heli && local _heli && local driver _heli)) exitwith {};

if(isnil "fza_ah64_cpg_bankleft") then
{
fza_ah64_cpg_bankleft = false;
fza_ah64_cpg_bankright = false;
fza_ah64_cpg_nosedown = false;
fza_ah64_cpg_noseup = false;
fza_ah64_cpg_heightup = false;
fza_ah64_cpg_heightdown = false;
fza_ah64_cpg_yawleft = false;
fza_ah64_cpg_yawright = false;
};

if(inputaction "HeliCyclicLeft" > 0.5 && !(fza_ah64_cpg_bankleft)) then {player groupchat "BANK LEFT"; fza_ah64_cpg_bankleft = true;};
if(inputaction "HeliCyclicLeft" < 0.5 && fza_ah64_cpg_bankleft) then {player groupchat "STOP"; fza_ah64_cpg_bankleft = false;};
if(inputaction "HeliCyclicRight" > 0.5 && !(fza_ah64_cpg_bankright)) then {player groupchat "BANK RIGHT"; fza_ah64_cpg_bankright = true;};
if(inputaction "HeliCyclicRight" < 0.5 && fza_ah64_cpg_bankright) then {player groupchat "STOP"; fza_ah64_cpg_bankright = false;};
if(inputaction "HeliForward" > 0.5 && !(fza_ah64_cpg_noseup)) then {player groupchat "FORWARD"; fza_ah64_cpg_noseup = true;};
if(inputaction "HeliForward" < 0.5 && fza_ah64_cpg_noseup) then {player groupchat "STOP"; fza_ah64_cpg_noseup = false;};
if(inputaction "HeliBack" > 0.5 && !(fza_ah64_cpg_nosedown)) then {player groupchat "BACK"; fza_ah64_cpg_nosedown = true;};
if(inputaction "HeliBack" < 0.5 && fza_ah64_cpg_nosedown) then {player groupchat "STOP"; fza_ah64_cpg_nosedown = false;};
if(inputaction "HeliRudderLeft" > 0.5 && !(fza_ah64_cpg_yawleft)) then {player groupchat "LEFT"; fza_ah64_cpg_yawleft = true;};
if(inputaction "HeliRudderLeft" < 0.5 && fza_ah64_cpg_yawleft) then {player groupchat "STOP"; fza_ah64_cpg_yawleft = false;};
if(inputaction "HeliRudderRight" > 0.5 && !(fza_ah64_cpg_yawright)) then {player groupchat "LEFT"; fza_ah64_cpg_yawright = true;};
if(inputaction "HeliRudderRight" < 0.5 && fza_ah64_cpg_yawright) then {player groupchat "STOP"; fza_ah64_cpg_yawright = false;};
if(inputaction "HeliUp" > 0.5 && !(fza_ah64_cpg_heightup)) then {player groupchat "UP"; fza_ah64_cpg_heightup = true;};
if(inputaction "HeliUp" < 0.5 && fza_ah64_cpg_heightup) then {player groupchat "STOP"; fza_ah64_cpg_heightup = false; _heli flyinheight (getpos _heli select 2); _heli domove (getpos _heli);};
if(inputaction "HeliDown" > 0.5 && !(fza_ah64_cpg_heightdown)) then {player groupchat "DOWN"; fza_ah64_cpg_heightdown = true;};
if(inputaction "HeliDown" < 0.5 && fza_ah64_cpg_heightdown) then {player groupchat "STOP"; fza_ah64_cpg_heightdown = false; _heli flyinheight (getpos _heli select 2); _heli domove (getpos _heli);};
_helipb = _heli call fza_ah64_getpb;
_helip = _helipb select 0;
_helib = _helipb select 1;
_helidir = getdir _heli;
_helivdir = vectordir _heli;
_helivup = vectorup _heli;
_heliv = velocity _heli;
if(fza_ah64_cpg_heightup) then {_heli setvelocity [(_heliv select 0),(_heliv select 1),(_heliv select 2)+0.5];};
if(fza_ah64_cpg_heightdown) then {_heli setvelocity [(_heliv select 0),(_heliv select 1),(_heliv select 2)-0.2];};
if(fza_ah64_cpg_bankleft) then {[_heli,_helip,_helib - 0.5] call fza_ah64_setpb;};
if(fza_ah64_cpg_bankright) then {[_heli,_helip,_helib + 0.5] call fza_ah64_setpb;};
if(fza_ah64_cpg_nosedown) then {[_heli,_helip + 1,_helib] call fza_ah64_setpb; _heli setvelocity [(_heliv select 0) - (sin _helidir * 0.1),(_heliv select 1) - (cos _helidir * 0.1),(_heliv select 2)];};
if(fza_ah64_cpg_noseup) then {[_heli,_helip - 1,_helib] call fza_ah64_setpb; _heli setvelocity [(_heliv select 0) + (sin _helidir * 0.1),(_heliv select 1) + (cos _helidir * 0.1),(_heliv select 2)];};
if(fza_ah64_cpg_yawleft) then {_heli setVectorDirAndUp [[(_helivdir select 0) + (sin (_helidir - 1)),(_helivdir select 1) + (cos (_helidir - 1)),(_helivdir select 2)],[(_helivup select 0),(_helivup select 1),(_helivup select 2)]];};
if(fza_ah64_cpg_yawright) then {_heli setVectorDirAndUp [[(_helivdir select 0) + (sin (_helidir + 1)),(_helivdir select 1) + (cos (_helidir + 1)),(_helivdir select 2)],[(_helivup select 0),(_helivup select 1),(_helivup select 2)]];};