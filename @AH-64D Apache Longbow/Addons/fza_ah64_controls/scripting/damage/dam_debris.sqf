_heli = _this select 0;
_part = _this select 1;

if(_part == "tailboom") then
{
//fx
drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 0.5, 4, [0,-4,-2], [0,0,0], 0, 0.6, 0.5, 0, [4,8], [[0.01,0.01,0.01,1],[0.01,0.01,0.01,1],[0.01,0.01,0.01,0.9],[0.01,0.01,0.01,0.8],[0,0,0,0]], [0], 0.1, 0.2, "", "", _heli];
drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 13, 2, 0], "", "Billboard", 0.5, 4, [0,-4,-2], [(random 5) + (random -5),(random 5) + (random -5),(random 5) + (random -5)], 0, 1, 0.1, 0, [0.5], [[1,1,1,-7]], [1000], 0.1, 0.2, "", "", _heli];
drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 13, 2, 0], "", "Billboard", 0.5, 4, [0,-4,-2], [(random 5) + (random -5),(random 5) + (random -5),(random 5) + (random -5)], 0, 1, 0.1, 0, [0.5], [[1,1,1,-7]], [1000], 0.1, 0.2, "", "", _heli];
drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 13, 2, 0], "", "Billboard", 0.5, 4, [0,-4,-2], [(random 5) + (random -5),(random 5) + (random -5),(random 5) + (random -5)], 0, 1, 0.1, 0, [0.5], [[1,1,1,-7]], [1000], 0.1, 0.2, "", "", _heli];
drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 13, 2, 0], "", "Billboard", 0.5, 4, [0,-4,-2], [(random 5) + (random -5),(random 5) + (random -5),(random 5) + (random -5)], 0, 1, 0.1, 0, [0.5], [[1,1,1,-7]], [1000], 0.1, 0.2, "", "", _heli];
if(local _heli) then
{
_tailboom = createvehicle ["fza_ah64_tailboom_debris", [(getpos _heli select 0),(getpos _heli select 1),(getpos _heli select 2)], [], 0, "NONE"];
_tailboom setdir (getdir _heli - (180 + random 5 + random -5));
_tailboom setpos [(getpos _heli select 0)+(sin getdir _heli * -5.5),(getpos _heli select 1)+(cos getdir _heli * -5.5),(getpos _heli select 2)+0.5];
_tailboom setvelocity [(velocity _heli select 0)+random 5+(random -5),(velocity _heli select 1)+random 5+(random -5),(velocity _heli select 2)+random 5+(random -5)];
_vtail = "fza_ah64_vtail_debris" createvehicle [(getpos _heli select 0),(getpos _heli select 1),(getpos _heli select 2)];
_vtail setdir (getdir _heli - (180 + random 5 + random -5));
_vtail setpos [(getpos _heli select 0)+(sin getdir _heli * -6.7),(getpos _heli select 1)+(cos getdir _heli * -6.7),(getpos _heli select 2)+2.7];
_vtail setvelocity [(velocity _heli select 0)+random 5+(random -5),(velocity _heli select 1)+random 5+(random -5),(velocity _heli select 2)+random 5+(random -5)];
//_tr = "fza_ah64_tr_debris" createvehicle [(getpos _heli select 0),(getpos _heli select 1),(getpos _heli select 2)];
//_tr setdir (getdir _heli - (180 + random 5 + random -5));
//_tr setpos [(getpos _heli select 0)+(sin getdir _heli * -6.8)+(cos getdir _heli * -0.7),(getpos _heli select 1)+(cos getdir _heli * -6.8)+(sin getdir _heli * 0.7),(getpos _heli select 2)+3.7];
//_tr setvelocity (velocity _heli);
_hstab = "fza_ah64_hstab_debris" createvehicle [(getpos _heli select 0),(getpos _heli select 1),(getpos _heli select 2)];
_hstab setdir (getdir _heli - (180 + random 5 + random -5));
_hstab setpos [(getpos _heli select 0)+(sin getdir _heli * -7),(getpos _heli select 1)+(cos getdir _heli * -7),(getpos _heli select 2)+0.5];
_hstab setvelocity [(velocity _heli select 0)+random 5+(random -5),(velocity _heli select 1)+random 5+(random -5),(velocity _heli select 2)+random 5+(random -5)];
};
};