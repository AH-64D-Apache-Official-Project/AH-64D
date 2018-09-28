private ["_heli"];
_heli = _this select 0;

while {fza_ah64_estarted} do
{
  if((_heli animationphase "plt_eng1_throttle" > 0.2) && (_heli animationphase "plt_eng1_throttle" < 0.95)) then
  {
    (vehicle player) setWantedRPMRTD [13500, 10, 0];
  };
  if((_heli animationphase "plt_eng1_throttle" > 0.95)) then
  {
    (vehicle player) setWantedRPMRTD [20000, 7, 0];
  };
  if((_heli animationphase "plt_eng2_throttle" > 0.2) && (_heli animationphase "plt_eng2_throttle" < 0.95)) then
  {
    (vehicle player) setWantedRPMRTD [13500, 10, 1];

  };
  if((_heli animationphase "plt_eng2_throttle" > 0.95)) then
  {
    (vehicle player) setWantedRPMRTD [20000, 7, 1];
  };
  if((_heli animationphase "plt_eng1_throttle" == 0)) then
  {
    (vehicle player) setWantedRPMRTD [0, 30, 0];
  };
  if((_heli animationphase "plt_eng2_throttle" == 0)) then
  {
    (vehicle player) setWantedRPMRTD [0, 30, 1];
  };
  sleep 0.5;
  onEachFrame
  {
	systemChat str canSuspend; //false
	[] spawn {hint str canSuspend}; //true
	onEachFrame {};
  };
};
