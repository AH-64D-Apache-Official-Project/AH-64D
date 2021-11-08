**1. How do I interact with cockpit switches?**
- You need to bind "Crosshair Action" by going to Options > Controls > Configure Addons and bind Crosshair Action to the desired keyboard input.

**2. How do I map inputs to my HOTAS?**
- Go to Options > Controls > Custom controls and bind your desired HOTAS input to a custom input, then assign this custom input to "Crosshair Action" as discussed previously.

**3. How do I start the aircraft?**
1. Rotor Brake Switch - OFF
2. Battery Switch - ON
3. Eng 1 Start Switch - Start
4. Ng - Check 23%
5. Power Lever - Idle
When Ng stabilized at idle (~67.9%), repeat steps 3 through 5
6. Power Levers - Advance to fly when ENG OIL PSI 70 (~1 minute after second reaches idle)

**4. How do I change the aircraft loadout/re-arm?**
- The legacy re-arming menu was removed and replaced with the ARMA 3 pylon system.  
- ED3N: Right click on the helicopter and select attributes and locate Pylon Settings.
- In Game: Ammo truck, Zeus, or ACE, same as any other helicopter in the game.

**5. How do I turn on the radar, the "salute" key doesn't work.**
- The radar now uses the ARMA 3 radar key, Default is Lctrl + R.

**6. What happened to the ATAS-92 Stinger?**
- The ATAS was removed since there is no open source information on it's implementation in the aircraft and conflicts with the projects current direction. It will not be re-added.

**7. How do I "attach" (turn on) the Helmet Display Unit (HDU)?**
- Right panel below the cockpit door handle and directly behind the COM panel is the storage container for the HDU. Click on the container to "attach" (turn on) the HDU.

**8. My HDU is "attached" but there's no symbology being displayed.**
- On the left side of the instrument panel, below the ARMAMENT panel is the pilot VIDEO panel. Locate and click on the IHADSS BRT CONT to display HDU symbology. NOTE: The HDU symbology will only display when the APU is ON.

**9. How do I prevent the cursor (green x) from moving while using TrackIR or other head tracking software?**
- To prevent the cursor from moving go to Options > Addon Options and de-select: Allow cursor movement while in headtracking mode. Conversely if you want it to move, select this option. The cursor can be centered by pressing numpad 5.

**10. I can't start the aircraft and the engine page is displaying values.**
- You need to ensure only ONE axis is mapped to Collective Raise (Analog) and Collective Lower (Analog). Due to the nature of how ARMA handles throttle input (and with the mods Simple Flight Model (SFM) enhancements), this is required for it to function correctly.

**11. How do I add waypoints to the TSD?**
1. TSD button - Select
2. NAV Phase (B2) - Verify
3. Add (R1) - Select
4. Go to the ARMA map screen and left click on the map, then exit ARMA map screen.
5. XMIT (R3) - Select to save waypoints
6. ZOOM (L1) - Select appropriate scale to verify WPs saved successfully.

**12. How do I zoom when using the Pilot Night Vision System (PNVS) camera?**
- Since this isn't a feature of the actual aircraft, it is not a feature in the mod. Short answer is: You don't.

**13. Why can't I assign weapons to the pilot?**
- Currently the mod assumes all weapons are handled by the CPG. As a result if you place weapons on the PLT in the Editor, certain key functions, such as the symbology required for aiming will not be present.