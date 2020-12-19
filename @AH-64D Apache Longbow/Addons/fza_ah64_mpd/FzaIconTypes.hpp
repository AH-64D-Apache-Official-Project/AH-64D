class FzaIconTypes {
    class AA {
        tex= "\fza_ah64_mpd\tex\tsdIcons\aa.paa";
        type = POINT_TYPE_CM;
    };
    class AG:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\ag.paa";};
    class AI:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\ai.paa";};
    class AL:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\al.paa";};
    class AP:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\ap.paa";};
    class BP:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\bp.paa";};
    class BR:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\br.paa";};
    class EA:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\ea.paa";};
    class EF:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\ef.paa";};
    class EI:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\ei.paa";};
    class EM:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\em.paa";};
    class EU:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\eu.paa";};
    class FA:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\fa.paa";};
    class FC:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\fc.paa";};
    class FF:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\ff.paa";};
    class FI:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\fi.paa";};
    class FL:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\fl.paa";};
    class FM:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\fm.paa";};
    class FU:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\fu.paa";};
    class GL:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\gl.paa";};
    class HA:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\ha.paa";};
    class IDM:AA { tex= "\fza_ah64_mpd\tex\tsdIcons\idmsub.paa";};
    class MI:AA  { tex= "\fza_ah64_mpd\tex\tsdIcons\mi.paa";};

    class CC {
        type = POINT_TYPE_WP;
        tex= "\fza_ah64_mpd\tex\tsdIcons\cc.paa";
    };
    class LZ:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\lz.paa";};
    class PP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\pp.paa";};
    class RP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\rp.paa";};
    class SP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\sp.paa";};
    class WP:CC  { tex= "\fza_ah64_mpd\tex\tsdIcons\wp.paa";};

    class TO {
        type = POINT_TYPE_HZ;
        tex= "\fza_ah64_mpd\tex\tsdIcons\to.paa";
    };
    class TU:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\tu.paa";};
    class WL:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\wl.paa";};
    class WS:TO  { tex= "\fza_ah64_mpd\tex\tsdIcons\ws.paa";};    

    class GU {
        type = POINT_TYPE_TG;
        tex = "\fza_ah64_mpd\tex\tsdIcons\gu.paa";
    };  
    class R :GU { tex= "\fza_ah64_mpd\tex\tsdIcons\r.paa";};
    class TG:GU  { tex= "\fza_ah64_mpd\tex\tsdIcons\tg.paa";};  
};

/***
1. TSD - Select
2. WPT (B4) - Select
3. ADD (L2) - Select
4. Type (L3 thru L5) - WP, HZ or CM select  <-- Selected a WP and I put in a CM ABR (AG) this is invalide, KU flash
5. Point (L1) - Select
6. On the KU enter:
----IDENT (ABR), then KU enter
----Free Text (3 Characters), then KU enter
----Grid (manually or via cursor enter on TSD) if manually, KU enter
----Altitude (manually or received from TSD cursor selection), if manually, KU enter

***/