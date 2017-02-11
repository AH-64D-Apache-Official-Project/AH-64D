----------------------------------
AH-64 SOURCE BY NODUNIT & FRANZE
SOURCE RELEASE 02/08/2017 v1.42
----------------------------------
INTENDED FOR ARMA3 ONLY!!!!
-----------
DISCLAIMER
-----------

If something goes wrong while using this addon, you cannot hold the authors responsible.
Use this package and the included contents at your own risk.

----------------------------------------------------------------------
For the full online manual, go to:
http://mechmodels.com/mas/downloads/ah64v2/manual/ah64dv2_manual.html
----------------------------------------------------------------------

NOTICE: The contents of this package (textures, models, scripting) were created by
Franze and Nodunit; if you wish to use any of it, please credit them with the
creation of the original work!

You are not allowed to use this addon for commercial purposes in any way.
This includes incentive content as donations for servers, monetized servers, or
related commercial purposes.

Creation of content with assets provided by this addon (scripts, skins, etc.)
does not imply ownership of the addon or contents within. Ownership of this addon
is the sole property of Franze and Nodunit and associated subsidaries.

--------
CREDITS
--------

Nodunit (models, textures)
Franze (scripting)

---Voice---

Bardosy - Kestrel flight
Fangs McCoy - Bitchin' Betty
Franze - Dusk Knight 3-2, Grey Wolf, ground forces
froggyluv - Instructor
nettrucker - Co-Pilot Gunner

--- Additional Credits---

General Barron (getpitch, getbank, setpitch, setbank functions)
Noubernou (clickable cockpits concept, per frame eventhandler)
Robert Hammer (Door open/close sounds, Main Rotor Sounds)
Hellcat (testing, campaign guide)
islefan (testing, advisor)
Jason (testing, advisor)
b00ce (testing)

---Music Credits---

Jeehun Hwang (Heavy Gear, Mechwarrior 2 soundtracks) http://jeehun.com/
Barry Leitch (TFX, Drakan soundtracks) http://www.barryleitch.com/
Origin Skunkworks (Longbow 2 soundtracks)
Bioware (Shattered Steel soundtracks)

---Special Thanks---

Max Power - Testing, model and texture advice
BG ECP - pilot advisor

--------------
VERSION NOTES
--------------

Known issues -
- Player will report 'out of fuel' radio message with CEM on. Reason: to keep
player from being able to take off without going through startup procedure,
fuel is set to 0 until startup procedure has been followed. Cannot disable the
default radio 'out of fuel' message.
- Betty audio messages will play when dead or out of aircraft.
- Audio issues with engine loop sound.
- Sometimes engine startup procedure is skipped.
- Contact of certain objects will result in aircraft explosion.
- Aircraft weapon weight remains constant.
- Gun/pylons do not work in multiclient aircraft in multiplayer.

V1.42 -
- New HMD horizon object.

V1.41 -
- Fixed errors in scripting relayed to AFM.
- Fixed arming menu error.
- Added PNVS HDU function.
- Added keys for head tracking toggle and waypoint cycle: User 19 for head tracking
toggle and User 18 for waypoint cycle.
- Improved automatic gun tracking and aiming.

V1.4 -
- Modified model and texture.
- Added skin selection to arming menu.
- Fixed some glitches with ASE, TSD, and FCR displays.

v1.32 -
- Modified data transfer mechanics.
- Fixed bug with PNVS and FLIR lenses on the model.
- Fixed multiplayer bugs with scripting not initializing.
- Added CPG control options when AI is piloting.
- Modified model UV coordinates.
- Fixed bug with multiplayer missile avoidance.

v1.31 -
- Modified gun tracking in HMD and AUTO modes to remove bank error.
- Modified IHADSS scripting to work faster on per frame handler.
- Modified weapon damage so that if using a linked weapon and one
pylon is damaged, only ordnance is lost on that pylon.
- New laser designation system for CPG.
- New experimental mouse input for click actions: when the Head Tracking On action
is used, the mouse will move the 'X' click action point.
- Gun burst no longer forced time restriction. Gun now has overheat tracking
and overuse can result in gun jamming.
- Gunner heads down symbology in place.
- Added DTV monochrome effect.
- Modified gun control: gun control exclusively the realm of the CPG in multiplayer.
- Fixed issue with MPD buttons not working with CEM off.

v1.3 -
- Modified shadow LOD.
- Modified pilot LOD.
- Modified missile guidance.
- Modified missions to account for new damage scripting.
- Modified campaign missions "Pin Drop" and "Hallowed Ground" to include radio
commands for ordering Dusk Knight to stop, continue, or fly to an area. Dusk
Knight will also wait until the player takes off to continue his way route.
- Modified pilot and gunner LODs to have weapons and rotor components.
- Fixed crew placement in crew fire LOD placement that resulted in their being
unhittable except in certain places. Still requires a weapon capable of 
penetrating armor to prevent 'makarov' crew kills.
- Fixed vulnerability in underside of cockpit area.
- Opening doors will now allow crew to be shot.
- Fixed pilot able to use SAL missiles without a gunner.

v1.2 -
- New gun functionality: holding gun fire for 1+ seconds will clear the burst limit,
but in doing so introduces a chance of a jam if gun is overused.
- Changed weapon and ammo class inheritance.
- Modified missile guidance scripting.
- Fixed cockpit glass invulnerability.
- Fixed CPG-Pilot multiplayer issue with gun/pylons.
- Fixed shadow issues.
- Fixed skin selection areas.
- Fixed TADS stow for CPG.

v1.1 -
- Engine startup now has sounds and UFD/WCA page feedback for state of components.
- APU and engines will burn fuel in complex startups.
- IHADSS must be turned on (IHADSS toggle action) after battery turned on.
- Added IHADSS toggle capability to click action on IHADSS storage box.
- UFD, MPDs, and IHADSS in off state until battery, APU, or engines are on.
- Added rotor RPM audio message when exceeding 110% and an altitude above 5m while ENG page active.
- Modified UFD messages to be uniform in color and size; removed some messages.
- Replaced main rotor sounds with Robert Hammer samples.
- Improved shadow LOD.
- M230 burst behavior changed - waiting 1 second or more in the middle of a burst resets burst limit.
- Fixed FCR page components errors with TSD.
- Fixed gunner unable to turn on FCR in single player.
- Fixed Pilot-CPG damage effects - now passed between crew members.
- Fixed click helper not appearing after resuming from a saved game.
- Fixed CPG TSD map not hiding.

v1 -
- Scripting system is unoptimized.
- Binarization causes slowdowns; bone count too high for binarize.
- No LODs for aircraft.
- M230 auto tracking at high angles of bank inaccurate.
- Tail geometry does not disappear after losing tail.
- Aircraft sits partially in the air with missing tail.
- Textures not finished.
- Holes in model when tailboom destroyed. A cap will be made later.
- If two clients are in one aircraft, damage effects are not passed between them.