# Changelog Notes:

*11/02/2022*
* Service Ceiling adjustment from default
* Start switch animation update

*09/02/2022*
* Fixed uninitialised aircraft breaking fn_animReset.sqf (#174)
* Dead CFG Removal
* Incoming missile duplicate warning fix (#170)
* IHADSS power Change (#171)

*16/01/2022*
* Robbie Tank and Default Magazine change, Default Fuel Adjustment (#162)
* Animated Horizontal stabilizer (#156)
* Animation state override (#163)

*15/01/2022*
* Power Lever Exploit Fix (#146)
* SFM+ weight, damage and torque table fix (#154)
* SFM+ Default Fuel, Performance and Damage Locality Update (#158)

*15/01/2022*
* Hide vanilla UI (#152)

*23/12/2021*
* Updated hover torque values
* Updated intro

*16/12/2021*
* Corrected weapon selection logic

*08/12/2021*
* SFM+ Engine Update (#143)

*03/12/2021*
* Reduced startup duration from 80 seconds to 45

*02/12/2021*
* Rocket salvo Unreliability fix (#141)

*02/12/2021*
* SFM+ Input Fix (#142)

*24/11/2021*
* removal of outdated setting (#139)
* Jammer delay fix (#138)
* Updated Hellfire Penetrator (#135)
* Move engine simulation to be local but globally synchronised. (#134)

*15/11/2021*
* Moved sight select to shift

*07/11/2021*
* Remove debug systemChats, fixed selected rocket

*06/11/2021*
* ARMA 2.06 Update, FCR & ASE Streamlining (#113)
* AI Crew Functionality, New default Gear, Armor Boost & Small fixes (#112)

*05/11/2021*
* Error fixes

*31/10/2021*
* Update waypointadd.sqf to use map click event handler (#126)

*09/10/2021*
* SFM+ Map Screen Fix (#119)
* Fix config syntax (#125)
* Fix texture path for cloudSmall1.p3d (#124)

*22/08/2021*
* Sfm plus damage update (#107)

*09/08/2021*
* FCR Acquisition & Los Fix (#83)

*06/08/2021*
* Fire Extinguisher Replaceable (#100)

*05/08/2021*
* Gun overheat breaking rearm fix (#92)
* Got the rocket salvo functioning again (#93)
* Improved terminal hellfire stability (#95)
* Tads shake from hull damage fix  (#97)
* ASE update using vanilla CM systems  (#90)
* Fix Flood lighting stability and mp (#106)
* Flare EFX change (source files credited to Pingopete) (#105)

*02/07/2021*
* Draw3d event handler fix (#85)

*20/06/2021*
* Rewritten simulation (#82)
* Infinite Variable bug in ASE Track warner (#82)
* Targeting fix for Ase Page open (#82)
* Fixed some missing semicolons
* Renamed settings group
* Fixed race condition between aircraft initialisation and scheduler
* Removed debug statement

*18/06/2021*
* Fixed APU sound loop. Pair programmed with Indigo

*17/06/2021*
* Make changes to mod naming as per voodoo's request
* Remove Rotorlib (#78)
* Fixed accidental hovering bug (#78)

*04/06/2021*
* Fix infinitely growing target variable (#75)

*26/05/2021*
* Israeli texture (Nodunit)
* Marvels Shield texture (Nodunit)
* Kane's wrath texture (Nodunit)

*25/05/2021*
* Made the stabilator function over a more specific range of airspeed/collective settings to enhance stability.

*24/05/2021*
* Fixed helicopter self-reporting in FCR
* Improved laser range symbology
* Fixed MP bug where gunner's seat would not always turn on MPDs on JIP

*23/05/2021*
* Move FCR script to work in scheduled environment (improved performance)
* PNVS keybinding fix
* Fix gun memory point
* Fix TSD targeting selection selecting not visible targets
* Calibrate TSD, ASE and FCR page icon position
* Switch C-Scope to use a bigger fixed-wing icon
* Fix JAM OHEAT warning error and others on WCA not appearing
* Dampened the input of keyboard action on SFM
* Cockpit glass fix

*14/05/2021*
* Fixed missing cockpit model

*12/04/2021*
* Fixed rotors & FCR animations.
* Fixed death texture
* Cscope priority by range (cscope bug fix)
* Fixed M230 stow position when sight select HMD
* Fixed M230 reload time (back to 450ish)

*10/04/2021*
* Implemented proper fuel flow
* Added SFM+ Stabilator
* Improved rigid body inertia
* Increase illumination flare duration 30->100
* Fixed flare memory points
* Increased landing light strength
* Added empty loadout
* Added miscellaneous WCA warnings back
* Updated target selection system

*09/04/2021*
* Fixed A3TI in PNVS 
* Improved PNVS head tracking
* Removed PNVS overlay when in PNVS turret

*08/04/2021*
* Added compatibility for LESH towing
* Updated PFZ Viewing (map icon and TSD filtering)
* Changed initial sight for both crewstations to HMD
* Moved each pylon to use 4 subpylons rather than 7. 
* Added more information on limits of pylon system (Credit to BradMick for limits)
* Fixed AH-64D no FCR automatically loading with Longbow missiles
* Added already existing descriptions to pylon menu tooltip
* Fixed crosshair and image filtering appearing when outside of the aircraft
* Fixed image auto tracking being interfered with by new sight system
* Removed old arming menu option
* Fixed aim position for image auto track

*06/04/2021*
* Added a welcome sceen on mod start up
* Removed hydras from ace frag
* Removed 30mm from ace frag
* Hellfires now limited to 40 degrees left/right
* Increase M230E1 RPM to reflect 650 RPM in-game (the reload time is not accurate)
* Added a penetration submunition for the 30mm
* Added penetrators to hellfires
* Fixed submunition direction for hydras
* Re-added Flechette red smoke
* Added AAC textures to the mod
* Fixed FCR page when FCR not installed
* Fixed hellfire flight timer
* Fixed laser jitter in MP
* Increased cannon accuracy
* Removed (temporarily) acquisition sources and rewritten sighting system.
* Fixed PFZs and laser cycling
* Added inhibits to the weapons system.

*04/04/2021*
* UFD and Fire systems fix

*03/04/2021*
* making blade animation script singleplayer only
* Added 211th Skins

*1/04/2021*
- Image Auto Tracking (IAT)
- hellfire texture and unwrap fixes
- Fixed the ENG page so that it works with SFM.

*30/03/2021*
- Fixed air-to-air FCR
- Fixed air-to-ground FCR FOV
- Fixed icon positioning on FCR page

*23/03/2021*
- performance improvement for targeting code
- converted scripts into functions
- optimised the heavy radar variables

*20/03/2021*
- added United Kingdom army air corps texture

*17/03/2021*
- Implemented Dynamic Loadouts for the Apache, credit to BradMick for 3D modelling and design help
- Removed old loadout system
- Moved skins and enabling FCR to vehicle customization
- Fixed disappeared textures, moved as many damage handlers off scripts as possible
- Added new RNLAF skins, courtesy of Houseman
- Added default presets to loadouts

*14/03/2021*
- radar max detection range changed from 10K to 8K
- disabling rocket salvo to prevent bug were hellfires shot with hydras //TEMP//
- added vanilla thermal sensor CFG IR sensor
- Increased size of fixed-wing cscope icons
- Fixed bindable jammer toggle
- Made ase scripts functions rather than `execVm`ed scripts
- Made jammer activation linked to both seats
- Fixed tsd & FCR ADA icons
- Submunitions activation are now a function
- Fixed ASE Display on server enviroment
- Fixed missile warning volume
- Added a bindable key to switch between self/remote laser

*06/11/2020*
- ECM script fixed
- Re-added ADA datebase
- Re-added correct auto hover detector
- Tempory fix for the TSD/FCR Radar Icons
- Re-added missile datebase
- Fixed the position issue for the gunner seat ENG1 fire button
- Fixed the broken shadow on the FCR
- CMimmunity move fix - radar hellfire failing in LO trajectory
- Disabled part that was breaking ASE and error codes in Targetupdating 
- "Shot at" fixed so it adds target to "shot at" list (BRK still can't remove it from shot at list)
- Updated AFM (BradMick v5 AFM)

*23/10/2020*
- Restored PNVS optics turret
- When enabling TIR, the mouse cursor will remain centered
- Tweaked RKTs thrust time
- CBA integration major update (by mattysmith22) 
- Added throttle lever idle sound

*20/10/2020*
- Removed pilot optic turret; PNVS is now usable trough NVS MODE switch from the frontseat & backseat (LVL knobs need to be rotated for daytime or night time toggle - default: day).
  The PiP HDU PNVS is shared between the front & the backseat
- Fixed PiP HDU PNVS transparency
- C-Scope container fix (by Rosd6)
- ECM script rework (by Rosd6)
- Added cam shake for MSL & RKTs

*11/10/2020*
- Improved AFM based on old logic (by BradMick)
- Fixed alternate sensor icon
- Added propper 3D M130 flares dispenser on tail 
- Firing the M230 should no longer shake screen for all clients (by Rosd6)

*04/10/2020*
- Fixed ACRE intercom preventing racks radio PTTs usage
- Added targeting informations toggle - prior future CBA update (by mattysmith22)
- Fixed headtracking toggle option appearing in action menu outside the aircraft
- Fixed config inheritance and code cleaning in CfgVehicles (by mattysmith22)
- Fixed AGM-144 max altitude launch (by Rosd6)
- Fixed AFM rotor brake not applying (by AngusLogan)
- Fixed animations reset when players JIP (by AngusLogan)
- Fixed skin locality issue (by AngusLogan)
- Updated AFM, damping, mixing and CG location (by Keplager) 
- Fixed 300 rounds magazine upon rearming (by Rosd6)
- Added IHADSS alternate sensors for CPG & PLT (by mattysmith22)


*06/06/2020*
- Added PiP values for longer ranges to Video Options (by Keplager)
- Fixed IHADSS overlay (by mattysmith22)
- TGT, Nr and Np are now scaled more correctly (by mattysmith22)
- Fixed bug where JIP would cause you to fall out the sky by resetting the ECU (by mattysmith22)
- Extracted out settings to a header file, generally cleaned things up (by mattysmith22)
- Fixed ENG control (by mattysmith22)
- PNVS Optics layer fix when getting out 
- Added A3TI full compatibility (CPG FLIR & PLT PNVS)
- Fixed PNVS color (MPD grey source logic)


*07/05/2020*
- Datalink not being automatically enabled (by Keplager)
- User actions allowing for players to try and access waypoints with a negative index (by mattysmith22)
- Targeting being limited on FCR page by the scale in TSD (by Keplager & mattysmith22)
- Removed F_VirtualMan entity

*04/05/2020*
- Fixed FCR in multiplayer (by Keplager)
- Resolve missing sound files issues in CfgSoundShaders

*01/05/2020*
- Reduced burst limit cooldown to 1 second instead of 3 seconds
- Expanded M151 & M229 area of effect
- Potential fix for invisible aircraft on dedicated servers
- Jammers critical error fix (by mattysmith22)
- Potential fix for FCR weird behaviour in multiplayer (by Keplager)
- Minor AFM update (by Keplager)
- Reduced RKTs smoke clouds
- Fixed some more ASE related script errors

*12/04/2020*
- Complete weapon sounds overhaul based on JSRS shaders
- Removed MSL & RKTs offset

*09/04/2020*
- Fixed rotor blur shadow
- A3 Sensors compatibility and restored FCR variant of the aircraft (by Keplager)
- Fixed AGM-114 SAL1 & SAL2 tracking (by Keplager)
- Changed default loadout for the FCR variant
- Fixed 3D floor holes for both PLT & CPG 
- Minor 3D adjustement to the ORT

*06/04/2020*
- Fixed TADS animation when shut down or lack of power
- Fixed M255, M257, M151 & M261 submunitions
- Changed default loadout based on real AH-64D operation
- Fixed turning off engine when player gets in cargo
- Adjusted landing light strenght and direction

*03/04/2020*
- Minor external model 3D adjustements
- Fixed 3D side panels holes in CPG & PLT seats
- Updated some cockpit switches sound
- Added CPG BRT and NVS switch animation
- Added avionics sound upon aircraft power up

*02/04/2020*
- Corrected a bug where the CPG would loose all IHADSS data while heads down when disabling the laser
- Added clickable floodlight button for both CPG and PLT
- Added clickable navigation & anticollision lights button on PLT side

*30/03/2020*
- Corrected sonic cracks heard from CPG optic when headsdown
- Further tweak to AGM-114 family and M230
- Couple minor sound tweaks
- Restored full auto on M230, limited by burst limiter setting (WPN page) just like in the real aircraft
- Hence no more burst firing mode and sounds anymore
- Ability to lock on TADS target, compatible with most ACQ submodes
- Added randomization in RKTs flight path
- AGM-114 SAL2 cannot track targets without laser designation anymore
- Monocle is finally fixed
- IHADSS flight data will no longer appear in external view
- Code cleaning...

*07/03/2019*
- Removed NAV fixes on the A3 map, now TSD only.
- Fixed waypoint script error on the editor.
- Tweaked 30mm rounds max speed.
- Reduced AGM-114 area of effect.
- Reduced M230 damage.

*02/03/2019*
- Fixed aircraft weight after rearming - by Zeitsev.
- Removed fza_ah64d_b2e for further FCR fixes, performances and code improvements.
- Minor AFM tweaking - by Zeitsev.

*21/02/2019*
- AFM update - by Keplager and BradMick.
- Couple sounds tweaking.
- Possible M230 performance fix.

*13/01/2019*
- Minor sound tweaks.
- Minor change to WPN page on LST & LRFD channels.

*08/12/2018*
- Reworked GUN FXD symbology.
- Added Master Arm/Safe.
- Retextured 230 GAL fuel tanks.
- Added 300 rounds magazine by default.
- Added refuel/repair and rearm delay.

*07/12/2018*
- Resized ASE threat circles.
- Removed BARO ALT in Cruise mode from CPG's TADS view.
- Fixed APU sounds on dedicated server.
- Reworked HDU script, it's now temporary on by default however the procedure still needs to be done.

*04/12/2018*
- Reworked M261 sounds.
- Fixed UI "white" menu bug.
- Tweaked M230 sound.
- Tweaked engines and rotor sounds at distance.

*24/11/2018*
- Fixed flares issue making vanilla aircrafts not being able to drop flares - by Jamo.
- Fixed Rearm & Repair feature.

*04/10/2018*
- Added dynamic engines throttle levers - by Keplager.
- Added proper onboard radios (VHF ARC-186, UHF ARC-164, FM1 ARC-201D, FM2 ARC-201D).  
- Fixed APU & BATT MP synchronization on dedicated servers.
- Tweaked AGM-114 area of effect.
- Replaced IHADSS 180°, 360°, 270° and 90° headings by S, N, W and E.

*28/09/2018*
- Tweaked M230 damage and effects.

*17/09/2018*
- Update on the Advanced Flight Model (AFM), rotor intertia fixed - by Keplager.

*16/09/2018*
- Removed fza_ah64d_chaff30 upon rearming.
- Added hot refuel.
- Removed APU 3D virtual object placeholder.
- Restored ability for PLT to close CPG door.
- Rewrited bunch of scripts, performance are increased in SP.
- Added NVS MODE switch simulation.
- Added aircraft state persistence.
- Tweaked weapon sounds at distance.
- Added single flare dispense instead of burst.


*02/09/2018*
- Updated Advanced Flight Model (AFM) data - by Keplager.
- Increased HDU PNVS resolution.
- Fixed autohover values - by Keplager.
- Unstowed TADS and PNVS camera once APU is running.
- Added NVS MODE cockpit interaction.
- Fixed HDU PNVS FPS.

*11/07/2018*
- Core file architecture rework - by Yax.
- Restored ability for CPG to take controls.
- Fixed CPG POV and hands position.
- Minor fix to Optical Relay Tube (ORT) 3D model.
- Added ingame monocle. (w/ Keplager + Yax)
- Removed vanilla UI lock box.
- Removed vanilla NVG mode to PNVS.
- Removed green cursor upon 3rd person.
- Fixed GUN azimuth limit on HMD ACQ. (/w Jamo)
- Reworked TADS informations display.
- Added RKT FXD symbology.
- Reworked TADS DTV colors.
- Disabled PNVS view if not enough electrical power.
- Added new PNVS rendering effect.
- Added new APU & ENG 3D sounds.
- Added APU sound loop. (/w Reyhard)
- External sounds adjustments.
- Changed IHADSS & IHADSS BRT toggle sounds.
- Added two steps IHADSS procedure, first put the monocle on and then click IHADSS BRT to put it alive (requires APU). 
- Added threat circles to ASE MPD page.
- Fixed laser issue not showing up on objects (buildings, rocks, vehicles...) at long distances - by Reyhard.
- Fixed ENG starters glitch.
- Added Fire Panel Test WARN sounds.

*11/07/2018*
- M230 & RKT distance sound adjustments.
- Restored M230 vibrations upon firing.
- Restored M230 barrel smoke effect.
- Battery should now provide supply by itself for CPG in MP.
- Minor change to ACRE 2 onboard radio configuration.

*10/07/2018*
- Fixed flares count display.
- Initial TSD display set to 1km.
- Added TSD MAP automatic compatibility with all maps - by Farquharson.

*11/06/2018*
- Fixed gun ammo count on WPN page.

*29/04/2018*
- Advanced Flight Model (AFM) update based on real engines performances.
- Reduced waypoint transition distance (from 500 to 50 meters).
- Fixed SMG_Burst error.
- Minor changes to auto-hover mode detector.
- Added initial steerpoint (WP0) upon spawning.
- Changed default M230 position to FXD.
- Disabled TADS imagery when engines off.


*13/04/2018*
- Advanced Flight Model (AFM) update.
- Added ACRE 2 support (requires development build & ACE) /w AN-PRC117F, Racks & Infantry Telephone.
- Fixed 'Gun Crosshair Fixed' symbology.

*08/04/2018*
- Changed Custom User 11 for IHADSS Toggle.
- Changed Custom User 12 for HDU PNVS Toggle.
- Restored GUN pipper for P*, removed for CPG (WIP).
- Edited CPG FOV. 
- Enhanced Crosshair (Custom User 20) visibility. 
- Lighten interactions trough action menu.
- Restored AH-64D Apache (without Longbow FCR).
- Removed vehicle chat regarding CPG laser state.
- Partially fixed misaligned backlight textures.
- Added signature files.

*04/04/2018*
- Advanced Flight Model (AFM) changes.
- PNVS azimuth bug fixed (-90°/+90°)

*02/04/2018*
- ENG RMPD PAGE rework to match real aircraft values (WIP).
- Complexified startup procedure.
- Tweaked animations to be less restrictive.
- Fixed TADS optic stability.

*11/03/2018*
- Dynamic rotor sound.
- Added damage sounds.
- New startup/shutdown procedure based on the real aircraft (WIP).
- Flares effects display fixed.
- Fixed internal & external startup sounds.
- Increased engine spooling time.
- Removed M230 full auto for burst with proper sound effect.
- Crash wreck fixed.
- Tweaked armor values.
- New M230 gun calculation based on laser range, own speed, movement and ballistics.
- Reduced 30mm ammo velocity.
- Increased 30mm ammo spread.
- Fixed TADS & M230 AZ limits.
- Fixed PNVS AZ & EL limits. 
- Changed default loadout.
- Changed CPG animation.
- Changed AGM-114, M230 & Hydras sound effects. 

*20/08/2017*
- Proper "laser on" symbology display while CPG is head down in RTO - by blindbat2006.
- PLT optics zoom slightly enhanced.
- Added laser system keybindings (Custom User 5 & Custom User 10).
- Replacement of few old sounds by better quality ones.
- Overall aircraft sounds volume tweaked.

*23/07/2017*
- PNVS mouse control slowed down (even more) - by blindbat2006.

*22/07/2017*
- Removed vanilla locking display - by blindbat2006.

*11/07/2017*
- Short term fix for FCR - by blindbat2006.
- Engine sounds lowered - by blindbat2006.
- Fixed RPT spam - by blindbat2006.

*03/04/2017*
- Added TADS NVG.
- Reduced PNVS motion sensitivity.

*20/03/2017*
- Added internal lights.
- Fixed flares memorypoint.

*19/03/2017*
- Replaced chaffs by flares.
- Enhanced startup and shutdown sound.
- Various volume tweaks.
- Added external lights.
- New optic effects for PLT.

*10/03/2017*
- Reduced APU volume.
- Reduced ignition starters volumes.
- Reworked startup sound.
- Reworked shutdown sound.
- TADS slew is now fixed to the ground (Point of Interest).
- Added new PLT DTV/PNVS optics in order to counter A3 limitations regarding aircraft performances.
- Early flares system, replacing the old one, doesn't display flares/chaffs quantities (WIP).
- Added new get-in animation.
- Added ground-to-air radar threats compatibility (A3+RHS+LOP) - now positively identified by the ASE.
- Added support vehicles compatibility (A3+RHS) - Arming menu will be available whether Ammo, Fuel, or Repair truck is placed.
- Aircraft compatibility with ACE refueling system.
- Increased CPG TADS axis sensitivity.
- AGM-114L cannot track laser spot anymore.
- Added Waypoint Cycle Backward/Forward - Custom User 17 & Custom User 18.

*23/02/2017*
- Edited AFM now based on A3 B_Heli_Attack_01 (WIP).
- Edited get-in & get-out sounds.
- Tweaked cockpit interior sounds volumes.
- New engine interior sound captured from the real aircraft.
- Aircraft will spawn all doors opened by default.
- TSD NAV mode instead of TSD ATK initialized by default.
- Edited default skin.

*20/02/2017*
- Added realistic flyby external sounds (JSRS4).
- Re-edited AGM-114 Hellfire sound (JSRS4).
- Re-edited M230 sound (JSRS4).
- Re-edited M261 rocket launcher sound (JSRS4).
- Fixed prime.rvmat error - by Shifty.FR.
- Changed "B_30mm_AP" to "B_30mm_MP" ammo settings.

*11/02/2017*
- PNVS zoom enhanced w/ WHOT FLIR & NVG.
- APU sound is longer (not looped yet).
- Edited Hellfire launch sound.
- Edited M230 sound.
- Tweaked Hellfire damage according to different types.
- Tweaked Hellfire explosion animation.
- Enhanced M230 dispersion.
