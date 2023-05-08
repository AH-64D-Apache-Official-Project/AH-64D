params ["_kp", "_ki", "_kd"];

createHashMapFromArray
    [ ["kp", _kp]
    , ["ki", _ki]
    , ["kd", _kd]
    , ["prevError", 0]
    , ["integral",  0]
    ];