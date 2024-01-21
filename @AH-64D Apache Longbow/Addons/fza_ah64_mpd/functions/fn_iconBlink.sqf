private _milisecondVal = (CBA_missionTime - (floor CBA_missionTime));

if ((_milisecondVal > 0.25 && _milisecondVal < 0.50) || (_milisecondVal > 0.75 && _milisecondVal < 1)) exitWith {
    true;
};
false;