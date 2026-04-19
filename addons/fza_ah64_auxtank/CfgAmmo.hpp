class CfgAmmo {
    class ammo_Missile_mim145;
    class M_Vorona_HEAT;

    class fza_ah64_auxtank_explosion_large: ammo_Missile_mim145 {
        hit = 0;
		indirectHit = 90;
		indirectHitRange = 45;
        model = "\A3\weapons_f\empty";
		CraterEffects = "AAMissileCrater";
		explosionEffects = "AAMissileExplosion";
    };
    class fza_ah64_auxtank_explosion_medium: M_Vorona_HEAT {
        hit = 0;
		indirectHit = 50;
		indirectHitRange = 25;
        model = "\A3\weapons_f\empty";
		CraterEffects = "ATMissileCrater";
		explosionEffects = "ATMissileExplosion";
    };
    class fza_ah64_auxtank_explosion_small: M_Vorona_HEAT {
        hit = 0;
		indirectHit = 30;
		indirectHitRange = 15;
        model = "\A3\weapons_f\empty";
		explosionEffects = "SencondaryExplosion";
		craterEffects = "SecondaryCrater";
    };
};
