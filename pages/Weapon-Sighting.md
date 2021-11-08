# Weapon Sighting

The new release has an entire rework of how the weapons sighting system operates, in order to clean up code and bring it closer to the real aircraft. However, this means we have deviated significantly from how the previous version of the mod works, so it is good to re-acquaint yourself with the new definition.

## Terms

* **Sight** - A sight is a system that the aircraft uses to train a weapons system on a target. The operator selects a sight, and then when they WAS a weapon that weapon will 'look down' that sight.
* **Acquisition Source** - An acquisition source is some data source that you can use to help you acquire a target with your sight. An example would be the other crew-member's headset, so you could train your sight where they're looking.

> :construction: Acquisition sources are not implemented yet. The placeholder source `T01` is shown.

This is different to the old system, where the acquisition source would be what you'd select to train the weapons on the target.

## Sights

* **FCR** - The FCR sight will sight whatever the Next-To-Shoot (NTS) target is, from the FCR. If the FCR does not have an NTS, then the weapons systems won't be actionable.
* **HMD** - The HMD sight will sight whatever you are looking at with the IHADSS.
> :information_source: The ranging for things like rockets is always 1KM away.
* **TADS** - The TADS sight will select what the TADS is aiming at
> :heavy_exclamation_mark: Unexpected results may occur when using this mode if the TADS is pointed at the air.
* **FXD** - The FXD sight will fix the weapon system to the nose of the aircraft (including the camera).

## Selecting sights

Sights can be selected using the "Optics Mode" button (Generally `Ctrl+Right Click`). That will cycle through them in the order described above.

## Viewing selected sight

The selected sight can be viewed on the IHADSS symbology in the lower-left corner.

It is also visible on the WPN page.