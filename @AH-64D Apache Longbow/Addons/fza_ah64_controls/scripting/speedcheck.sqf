_bomb = _this select 0;

while {
    (alive _bomb)
}
do {
    player globalchat format["MISSILE SPEED IS %1 MISSILE ALT IS %2", speed _bomb, getpos _bomb select 2];
    sleep 1;
};