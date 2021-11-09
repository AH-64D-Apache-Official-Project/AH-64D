---
title: SFM+
tags: [flight_model]
sidebar: ah64d_sidebar
permalink: flight-model-sfm-plus.html
folder: flightmodel
---

SFM+ is an experiment aimed at improving the stock ARMA Simple Flight Model (SFM) by applying forces that are only available in the current RotorLib Advanced Flight Model (AFM). SFM+ is also a complete overhaul of the mods existing engine and fuel page and presents an accurate depiction of helicopter performance limits and fuel flow as detailed in the Public Intelligence AH-64D Operator's Manual.

Currently the only force generator in SFM+ is a fully dynamic stabilator. _**The stabilator can be toggled off in the CBA Settings for the mod and is defaulted on.**_ The function of the stabilator was developed using ["First Article Preproduction Tests of the AH-64A Helicopter"](https://apps.dtic.mil/dtic/tr/fulltext/u2/a170594.pdf) and operates just as it does in the actual helicopter. The values are custom to the mod, but present accurate behaviors based on control input and airspeed. The chart below shows the stabilator schedule developed for the mod. Along the vertical axis is stabilator position, where a negative value means the stabilator is scheduled trailing edge down and positive value indicates the stabalator is scheduled trailing edge up. 

<img style="width:50%;display:inline" src="images/sfmplus/stabilatorSchedule.png"/><img style="width:50%;display:inline" src="images/sfmplus/throttleExample.png"/>

There are 5 unique schedules based on collective input. 0% collective means the collective (or throttle) is fully down (or back). 100% collective means the collective (or throttle) is fully up (or forward). This is ONLY with regards to the physical position of your input device and has NOTHING to do with the TQ in the aircraft. The general logic is this: A reduction in collective implies a desire to decelerate this will cause the stabilator to schedule up and result in the nose pitching up, the pilot has to apply forward cyclic to manage this pitch rate. Conversely, an increase in collective implies a desire to accelerate, this will cause the stabilator to schedule down and result in the nose pitching down, the pilot has to apply aft cyclic to manage this pitch rate. 

This is expected and normal behavior.

On the topic of the engine page overhaul: All torques displayed are accurate as are fuel flows. The engine page also replicates the effects of ground effect and airspeed on torque. As the aircraft ascends out of ground effect, the required hover torque will increase up to an altitude of 50 feet. Gross weight is also dynamic with SFM+. The baseline configuration for the aircraft (8 hellfires, 38 rockets, 1200rds of 30mm and 2517lbs of fuel) requires an IGE hover torque of ~83% TQ and OGE ~103% TQ dual engine. You are limited to a maximum TQ dual engine of 100% continously and between 101 to 115% TQ for 6 seconds. Exceeding this time limit or 115% will cause damage to the aircraft. You will have to make a decision: Do you take fewer weapons or less fuel? As the aircraft burns fuel and you fire weapons, the aircraft weight will update dynamically thus reducing your current power requirements.

The aircraft is trimmed via the stabilator for the following airspeeds: 
* 70kts at ~52% TQ depending on gross weight
* 90kts at ~57% TQ depending on gross weight
* 120kts at ~97% TQ depending on gross weight

Without the stabilator, the aircraft will maintian straight and level flight at 55kts with 56% TQ applied.

More additions will be made in the future, for now this is a limited feature test being used to lay the ground work for a replacement for the AFM.

# SFM+ 2.0 (Upcoming features, not yet implemented)

## Damage Modeling
SFM+ 2.0 now features damage modeling. This is a means of enforcing proper startup procedures and enhance realism. No long will you be able to start a single engine and leave it at idle and take off. Within 30 seconds of exceeding the limits outlined below the transmission will fail and the aircraft fall out of the sky.

**During Start**

|Tq | Nr |
|:--|:--|
| <= 30% | <= 50% |
| <= 70% | <= 90% |

**Single Engine Torque**

|Tq | Time |
|:--|:--|
| 0 to 110% | Normal Operation|
| 110% | Continuous |
| 111 to 122% | 2.5 Minutes |
| 123 to 125% | 6 Seconds |

**Dual Engine Torque**

| Tq | Time |
|:--|:--|
| 0 to 100% | Normal Operation|
| 100% | Continuous |
| 101 to 115% | 6 Seconds |


## Engine Start Differences
SFM+ 2.0 no longer requires you to wait for the Ng to peak at 23% before bringing a power lever to idle. In addition to this, power levers may be manipulated indpendently again AFTER the power levers have been advanced to fly. The revised start up procedure is as follows:

1. Start switch to Start
2. At the first sign of Ng, Power Lever - IDLE
3. Monitor for a rise in TGT, Engine Oil and Np within 45 seconds of bringing ther power lever to IDLE.
4. Check the start box does not go out prior to 52% Ng (not yet implemented)
5. Second engine start after attaining Ng IDLE speed of 67.9%.

After the second engine has been started and stabilized at IDLE, simultaneously advance both power levers to fly (default action). 

## Single Engine Sim

Once the power levers are at fly, each power lever can be manipulated indpendently. Beware of your current Tq, as it WILL double, potentially exceeding the Tq limits outlined above.