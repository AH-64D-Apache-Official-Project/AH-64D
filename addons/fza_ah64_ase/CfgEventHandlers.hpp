class Extended_PostInit_EventHandlers {
    class fza_ah64_ase_postInit {
        clientInit = "call fza_ase_fnc_rJamCommsInit;";
    };
};

// Chaff against engine-guided radar missiles
class Extended_FiredBIS_EventHandlers {
    class Helicopter {
        class fza_ase_decoyFired {
            firedBIS = "_this call fza_ase_fnc_decoyFired;";
        };
    };
};

class Extended_IncomingMissile_EventHandlers {
    class fza_ah64base {
        class fza_ah64base_incomingMissile_eh {
            incomingMissile = "_this call {[_this#0,_this#2,_this#4] spawn fza_ase_fnc_missileWarning;};";
        };
    };
};
