_heli = _this select 0;

if(isNil "fza_ah64_skindialog") then {fza_ah64_skindialog = true;} else {fza_ah64_skindialog = true;};

if(isNil "fza_ah64_custskinlist") then
{
fza_ah64_custskinlist = ["\fza_ah64_us\tex\ex\b2_co.paa","\fza_ah64_us\tex\ex\b2_weather_co.paa","\fza_ah64_us\tex\ex\229arb_co.paa","\fza_ah64_us\tex\ex\229arb_weather_co.paa"];
};

_skinselector = 1;
while {(_skinselector < count fza_ah64_skinlist)} do
{
	if(!(fza_ah64_skinlist select _skinselector in fza_ah64_custskinlist)) then
	{
		if(!(fza_ah64_skinlist select _skinselector == "fza_ah64_us\tex\ex\b2_co.paa")) then
		{
			fza_ah64_custskinlist = fza_ah64_custskinlist + [(fza_ah64_skinlist select _skinselector)];
		};
	};
	_skinselector = _skinselector + 2;
};

	_curskin = "";
	_skinselector = 0;
	while {(_skinselector < count fza_ah64_skinlist)} do
	{
		if(fza_ah64_skinlist select _skinselector == _heli) then
		{
			_curskin = (fza_ah64_skinlist select (_skinselector + 1));
			_selector = count fza_ah64_skinlist;
		};
		_skinselector = _skinselector + 2;
	};

_fza_ah64_skinsel = createdialog "fza_ah64_skinmenu";

_skincam = "camera" camcreate (getpos _heli);
_skincam camSetTarget _heli;
_skincam cameraEffect ["internal", "BACK"];
_skincam camsetrelpos [20,0,0.5];
_skincam camCommit 0;
showCinemaBorder false;

_counter = 0;
{
	lbAdd [201, _x];
	//lbSetPicture [201, _counter, _x];
	//lbSetPictureColor [201, _counter, [1,1,1,1]];
	_counter = _counter + 1;
} foreach fza_ah64_custskinlist;

ctrlsettext [203,_curskin];

lbsetcursel [201, 0];

_curcamdir = 90;

while {(dialog) && (fza_ah64_skindialog)} do
{
_curcamdir = _curcamdir + 1;
if(_curcamdir > 360) then {_curcamdir = 0;};
_skincam camsetrelpos [(20 * (sin _curcamdir)),(20 * (cos _curcamdir)),0.5];
_skincam camCommit 0.1;
sleep 0.1;
};

_skincam cameraEffect ["terminate","back"];
camDestroy _skincam;