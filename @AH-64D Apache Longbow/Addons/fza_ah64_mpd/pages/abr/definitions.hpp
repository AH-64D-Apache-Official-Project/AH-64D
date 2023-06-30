START_SECTION(WPS, "WAYPOINTS", MPD_COLOUR_GREEN)
    ABBREVIATION("COMM_CHECK_POINT",CC)
    BLANK_SPACE()
    ABBREVIATION("LANDING ZONE",LZ)
    BLANK_SPACE()
    ABBREVIATION("PASSAGE POINT",PP)
    BLANK_SPACE()
    ABBREVIATION("RELEASE POINT",RP)
    BLANK_SPACE()
    ABBREVIATION("START POINT",SP)
    BLANK_SPACE()
    ABBREVIATION("WAYPOINT",WP)
    BLANK_SPACE()
END_SECTION()


START_SECTION(HZRDS, "HAZARDS", MPD_COLOUR_YELLOW)
    ABBREVIATION("TOWER OVER 1000",TO)
    ABBREVIATION("TOWER UNDER 1000",TU)
    BLANK_SPACE()
    ABBREVIATION("WIRES POWER",WL)
    ABBREVIATION("WIRES TELE/ELEC",WS)
    BLANK_SPACE()
END_SECTION()


START_SECTION(GCM, "GENERAL CTRLM", MPD_COLOUR_GREEN)
    ABBREVIATION("AIR CONTROL POINT",AP)
    ABBREVIATION("AIRFIELD GENERAL",AG)
    ABBREVIATION("AIRFIELD INSTRUM",AI)
    ABBREVIATION("AIRFIELD LIGHTED",AL)
    ABBREVIATION("ARTY FIRE PT 1",F1)
    ABBREVIATION("ARTY FIRE PT 2",F2)
    ABBREVIATION("ASSEMBLY AREA",AA)
    BLANK_SPACE()
    //ABBREVIATION("BATTALION",BN)
    ABBREVIATION("BATTLE POSITION",BP)
    ABBREVIATION("BRIDGE OR GAP",BR)
    //ABBREVIATION("BRIGADE",BD)
    BLANK_SPACE()
    ABBREVIATION("CHECKPOINT",CP)
    //ABBREVIATION("COMPANY",CO)
    //ABBREVIATION("CORPS",CR)
    BLANK_SPACE()
    //ABBREVIATION("DIVISION",DI)
    //BLANK_SPACE()
    ABBREVIATION("FARP FUEL ONLY",FF)
    ABBREVIATION("FARP AMMO ONLY",FM)
    ABBREVIATION("FARP FUEL/AMMO",FC)
    //ABBREVIATION("FOWRD ASSEMB AREA",FA)
    BLANK_SPACE()
    ABBREVIATION("GRND LITE/SM TOWN",GL)
    BLANK_SPACE()
    ABBREVIATION("HOLDING AREA",HA)
    BLANK_SPACE()
    ABBREVIATION("IDM SUBSCRIBER",ID)
    BLANK_SPACE()
    //ABBREVIATION("NBC AREA",NB)
    //ABBREVIATION("NDB SYMBOL",BE)
    //BLANK_SPACE()
    //ABBREVIATION("RAILHEAD POINT",RH)
    //ABBREVIATION("REGIMENT/GROUP",GP)
    //BLANK_SPACE()
    //ABBREVIATION("US ARMY",US)
    //BLANK_SPACE()
END_SECTION()


START_SECTION(FCM, "FRIENDLY CTRLM", MPD_COLOUR_CYAN)
    //ABBREVIATION("ADU FRIENDLY",AD)
    //ABBREVIATION("AIR ASSAULT FRIEN",AS)
    //ABBREVIATION("AIR CAVALRY FRIEN",AV)
    //ABBREVIATION("AIRBORNE FRIEND",AB)
    ABBREVIATION("ARMOR FRIEND",AM)
    //ABBREVIATION("ARMOR CAV FRIEND",CA)
    //ABBREVIATION("AV MAINT FRIEND",MA)
    BLANK_SPACE()
    //ABBREVIATION("CHEMICAL FRIEND",CF)
    //BLANK_SPACE()
    //ABBREVIATION("DECON FRIEND",DF)
    //BLANK_SPACE()
    //ABBREVIATION("ENGINEERS FRIEND",EN)
    //ABBREVIATION("ELECWAR FRIEND",FW)
    //BLANK_SPACE()
    //ABBREVIATION("GROWTH CTRLM FR1",Z1)
    //ABBREVIATION("GROWTH CTRLM FR2",Z2)
    //ABBREVIATION("GROWTH CTRLM FR3",Z3)
    //BLANK_SPACE()
    //ABBREVIATION("FIXED WING FRIEND",WF)
    ABBREVIATION("FIELD ARTY FRIEND",FL)
    BLANK_SPACE()
    //ABBREVIATION("HELI ATTACK FRIEN",AH)
    //ABBREVIATION("HELI GENRI FRIEN",FG)
    //BLANK_SPACE()
    //ABBREVIATION("HOSPITAL FRIEND",HO)
    //BLANK_SPACE()
    ABBREVIATION("INFANTRY FRIEND",FI)
    BLANK_SPACE()
    ABBREVIATION("MECH INFANTRY",MI)
    //ABBREVIATION("MEDICAL FRIEND",MD)
    BLANK_SPACE()
    //ABBREVIATION("TOC FRIEND",TF)
    //BLANK_SPACE()
    ABBREVIATION("UNIT ID FRIEND",FU)
    BLANK_SPACE()
END_SECTION()


START_SECTION(ECM, "ENEMY CTRLM", MPD_COLOUR_RED)
    //ABBREVIATION("AIR ASSAULT ENEMY",ES)
    //ABBREVIATION("AIR CAVALRY EMEMY",EV)
    //ABBREVIATION("AIR DEFENSE ENEMY",ED)
    //ABBREVIATION("AIRBORNE ENEMY",EB)
    //ABBREVIATION("ARMOR CAV ENEMY",EC)
    ABBREVIATION("ARMOR ENEMY",AE)
    //ABBREVIATION("AV MAINT ENEMY",ME)
    BLANK_SPACE()
    //ABBREVIATION("CHEMICAL ENEMY",CE)
    //BLANK_SPACE()
    //ABBREVIATION("DECON ENEMY",DE)
    //BLANK_SPACE()
    //ABBREVIATION("ENGINEERS ENEMY",EE)
    //ABBREVIATION("ELEC WAR ENEMY",WR)
    //BLANK_SPACE()
    ABBREVIATION("FIELD ARTY ENEMY",EF)
    //ABBREVIATION("FIXED WING ENEMY",WE)
    BLANK_SPACE()
    //ABBREVIATION("GROWTH CTRLM EN1",Z4)
    //ABBREVIATION("GROWTH CTRLM EN2",Z5)
    //ABBREVIATION("GROWTH CTRLM EN3",Z6)
    //BLANK_SPACE()
    //ABBREVIATION("HELI ATTACK ENEMY",EK)
    //ABBREVIATION("HELI GENRL ENEMY",HG)
    //ABBREVIATION("HOSPITAL ENEMY",EH)
    //BLANK_SPACE()
    ABBREVIATION("INFANTRY ENEMY",EI)
    BLANK_SPACE()
    ABBREVIATION("MECH INFANTRY EN",EM)
    //ABBREVIATION("MEDICAL ENEMY",EX)
    BLANK_SPACE()
    //ABBREVIATION("TOC ENEMY",ET)
    //BLANK_SPACE()
    ABBREVIATION("UNIT ID ENEMY",EU)
    BLANK_SPACE()
END_SECTION()


START_SECTION(PPT, "PREPLANNED TGT/THRT", MPD_COLOUR_RED)
    //ABBREVIATION("ADU AMX-13",AX)
    //ABBREVIATION("ADU ASPIDE",AS)
    //ABBREVIATION("ADU ENEMY",ED)
    //ABBREVIATION("ADU GEPARD",GP)
    //ABBREVIATION("ADU GROWTH 1",G1)
    //ABBREVIATION("ADU GROWTH 2",G2)
    //ABBREVIATION("ADU GROWTH 3",G3)
    //ABBREVIATION("ADU GROWTH 4",G4)
    //ABBREVIATION("ADU SPADA",SD)
    //ABBREVIATION("ADU M1983",83)
    ABBREVIATION("ADU 2S6/SA-13",S6)
    BLANK_SPACE()
    //ABBREVIATION("GUN AIR DEFENSE",AA)
    ABBREVIATION("GUN GENERIC",GU)
    //ABBREVIATION("GUN MARKSMAN",MK)
    //ABBREVIATION("GUN SABRE",SB)
    //ABBREVIATION("GUN SELF PROP",GS)
    //ABBREVIATION("GUN TOWED",GT)
    ABBREVIATION("GUN ZSU-23",ZU)
    BLANK_SPACE()
    //ABBREVIATION("NAVAL SYSTEMS",NV)
    //BLANK_SPACE()
    //ABBREVIATION("SAM BLOWPIPE",BP)
    //ABBREVIATION("SAM BLOODHOUND",BH)
    //ABBREVIATION("SAM CHAPPARAL",CH)
    //ABBREVIATION("SAM CROTALE",CT)
    //ABBREVIATION("SAM CSA-2/1/X",C2)
    //ABBREVIATION("SAM HAWK",HK)
    //ABBREVIATION("SAM jAVELIN",JA)
    //ABBREVIATION("SAM PATRIOT",PT)
    //ABBREVIATION("SAM REDEYE",RE)
    //ABBREVIATION("SAM RAPIER",RA)
    //ABBREVIATION("SAM ROLAND",RO)
    ABBREVIATION("SAM SA-1",1)
    ABBREVIATION("SAM SA-2",2)
    ABBREVIATION("SAM SA-3",3)
    ABBREVIATION("SAM SA-4",4)
    ABBREVIATION("SAM SA-5",5)
    ABBREVIATION("SAM SA-6",6)
    ABBREVIATION("SAM SA-7",7)
    ABBREVIATION("SAM SA-8",8)
    ABBREVIATION("SAM SA-9",9)
    ABBREVIATION("SAM SA-10",10)
    ABBREVIATION("SAM SA-11",11)
    ABBREVIATION("SAM SA-12",12)
    ABBREVIATION("SAM SA-13",13)
    ABBREVIATION("SAM SA-14",14)
    ABBREVIATION("SAM SA-15",15)
    ABBREVIATION("SAM SA-16",16)
    ABBREVIATION("SAM SA-17",17)
    //ABBREVIATION("SAM SAMP",SM)
    //ABBREVIATION("SAM SATCP",SP)
    //ABBREVIATION("SAM SELF PROP",SP)
    //ABBREVIATION("SAM SHAHINE/R440",SH)
    //ABBREVIATION("SAM STARSTREAK",SS)
    //ABBREVIATION("SAM TIGERCAT",TC)
    //ABBREVIATION("SAM STINGER",ST)
    //ABBREVIATION("SAM TOWED",SA)
    //ABBREVIATION("SAM UNKNOWN",U)
    //ABBREVIATION("SAM VULCAN",VU)
    BLANK_SPACE()
    ABBREVIATION("RADAR BATTL SURV",SR)
    ABBREVIATION("RADAR TGT ACQ",TR)
    //ABBREVIATION("RBS-70",70)
    BLANK_SPACE()
    ABBREVIATION("TARGET REF POINT",TG)
    BLANK_SPACE()
END_SECTION()