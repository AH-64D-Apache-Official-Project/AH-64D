# Rocket Employment

Version 2.0 introduced a more accurate rocket steering cursor which uses the currently selected sight to provide maneuver cues to the crew in order to align the aircraft with the target. The following procedures outline how to engage a target cooperatively from a hover, but apply during running fire or diving fire engagements as well. For indepdendent rocket engagements, it is recommended that the FXD mode is employed.

# Rocket Steering Cursor

There are two modes available to the crew when employing rockets: NORM (a.k.a. articulating) and Fixed (FXD). For both modes, the fixed point of reference for the rocket steering cursor is the aircraft centerline, also known as the Armament Datum Line (ADL). In NORM, the rocket steering cursor is dynamic and moves with the selected sight (HMD, TADS, FCR), in FXD the rocket steering cursor is fixed to the aircraft centerline. 

| NORM | FXD |
| :-: | :-: |
| ![NORM](images/weapons/rktCursor_NORM.png) | ![FXD](images/weapons/rktCursor_FXD.png) 

As an example, the PLT has HMD as their currently selected sight, and they have a target they wish to engage to the left. When they look to the left, the rocket steering cursor will displace to the left indicating that the pilot needs to turn left to align the nose of the aircraft with the target. As they apply left pedal or maneuver the aircraft to the left the rocket steering cursor will move right. When the rocket steering cursor is centered with the LOS, the nose is aligned with the target. The critical piece to this is that the PLT keeps the LOS on the target! Any movement of the PLT LOS will result in movement of the rocket steering cursor and add to frustrations in lining the aircraft up. A common technique which works well in ARMA since there are no winds, is to ignore the rocket steering cursor and instead use the head tracker for azimuth and then the LOS for elevation. So long as the head tracker is aligned with the target, and the LOS is correct in elevation, the rocket will hit the target. The images below illustrate this sequence.

**Engagment Sequence using HMD as the selected sight**
|     |     |
| :-: | :-- |
| Step 1 | ![1](images/weapons/rktEngage_01.png) |
| Step 2 | ![2](images/weapons/rktEngage_02.png) |
| Step 3 | ![3](images/weapons/rktEngage_03.png) |
| Step 4 | ![4](images/weapons/rktEngage_04.png) |


Advantages associated with the NORM mode include shallower dive angles as a result of the articulating pylons and when employed cooperatively, a more stable platform and accurate range to target. Disadvantages include a more 'complex' and 'confusing' setup, particularly when firing HMD due to the dynamic nature of the rocket steering cursor. 

Advantages associated with the FXD mode include a simpler setup, you literally put the target in the fixed rocket steering cursor circle and pull the trigger. Disadvntages include steeper dive angles, and less accurate range to target.

# Rocket Engagment Sequence

To engage a target with rockets, use the following sequence, known as SWARM:

Target - Select ('R' or 'T' key)

1. **S**ight - Select HMD, TADS, FCR, etc. (Ctrl + Right Click)
2. **W**eapon - WAS (Weapon Action Switch) rockets (Keyboard 2)
3. **A**rm - Verify (Armed by default in ARMA)
4. **R**ange - Verify outside of minimum (500m), within maximum (7500m)
5. **M**essages - Verify Type Selection (6RC, 6PD, 6FL, etc.), Mode (NORM/FXD) and Quantity OR no PYLON LIMIT, AZ LIMIT, etc. displayed

It is recommended that when utilizing the NORM mode, a cooperative engagement be employed. When engaging cooperatively, the CPG uses the TADS to acquire the target which provides steering information to the PLT via the rocket steering cursor. Once the CPG has acquired the target, they call 'match', the PLT then responds with 'matching' and once the rocket steering cursor is centered in the LOS the PLT then calls 'shoot' and the CPG fires.
