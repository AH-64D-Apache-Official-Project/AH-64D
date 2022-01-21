---
title: SFM+
tags: [flight_model]
sidebar: ah64d_sidebar
permalink: flight-model-sfm-plus.html
folder: flightmodel
---

SFM+ is a visual simulation that presents an accurate performance model in ARMA's SFM. It also provides a force generating stabilator designed to expand the pitch range of the aircraft and allow for hands off flight for a given power setting. Another feature of SFM+ is damage modeling.

## Performance Model
SFM+ accurately accounts for weight of the aircraft and consults several lookup tables to present accurate performance figures to the pilot. The Table below presents information for the default aircraft placed in the 3DEN editor.

{% include note.html content="Currently all performance data is for a PA of 0ft and 20C only!"%}

The table below presents performance data for the aircraft. The gross weight of the non-FCR aircraft is 8828kg (19462lbs) and the gross weight of the FCR aircraft is 9123kg (20113lbs). This weight includes: 2x Pilots, 100% fuel, 2x M-299 Longbow Hellfire Missile Launchers, 2x M261 Rocket Pods, 1200x rounds of 30mm, 38x Rockets and 8x Hellfires.

| Max Tq Dual Engine | Max Tq Single Engine |
|:--|:--|
| 127% | 131% |

Maximum Torque Dual Engine and Single engine are the maximum torque the engines can produce based on environmental conditions. This torque can best be thought of as "life torque", meaning that if the pilot finds themselves in a bad situation, this torque can be used to save the aircraft. It will exceed the drive train limits and cause damage, but it will allow the aircraft to fly another day.

| Max Cont TQ Dual Engine | Max Cont TQ Single Engine |
|:--|:--|
| 100 % | 110% |

Maximum continuous torque dual engine and single engine is the maximum torque the pilot can continuously pull during flight. These limits are determined by the drive train.

| Max GWT In Ground Effect | Max GWT Out of Ground Effect |
|:--|:--|
|20260 lbs | 18700 lbs |

Maximum gross weight IGE and OGE are the maximum gross weights the aircraft can support when operating IGE and OGE.

| Go/No-Go Torque IGE | Go/No-Go Torque OGE |
|:--|:--|
| 88% | 80% |

Go/No-Go torque represents the maximum GWT IGE/OGE as measured at a 5-foot hover. Exceeding Go/No-Go torque OGE while at a 5-foot hover informs the crew that they DO NOT have OGE hover power, and are restricted from performing maneuvers requiring OGE hover power. Exceeding Go/No-Go torque IGE while at a 5-foot hover informs the crew that they DO NOT have OGE or IGE power and are restricted from performing maneuvers requiring OGE hover power. 

| Hover TQ In Ground Effect (Non-FCR) | Hover Torque Out of Ground Effect (Non-FCR) |
|:--|:--|
| 84% | *105% |


| Hover TQ In Ground Effect (FCR) | Hover Torque Out of Ground Effect (FCR) |
|:--|:--|
| 88% | *110% |

{% include note.html content="* Indicates the TQ required to hover in this mode exceeds the Maximum Continuous Torque Dual Engine"%}

SFM+ simulates ground effect and out of ground effect. The aircraft is considered to be operating in ground effect with less than 1 rotor diamter (~48 feet) above ground level. As the aircraft climbs in altitude, ground effect is lost and required torque to hover increases. SFM+ also simulates the effects of Effective Translational Lift and as the aircraft transitions into forward flight will benefit from an increase in rotor efficiency and a decreased power requirement. 

In order to hover out of ground effect, the crew MUST reduce weight, or remain above ETL (~24 kts)! The recommended configuration is 38% fuel, 38x Rockets and 6x Hellire missiles.

## Damage Modeling

{% include note.html content="Currently a ROTOR RPM HIGH warning and audio indicate an impending transmission failure."%}

SFM+ now features damage modeling. This is a means of enforcing proper startup procedures and enhance realism. No long will you be able to start a single engine and leave it at idle and take off. Within 30 seconds of exceeding the limits outlined below the transmission will fail and the aircraft fall out of the sky.

**During Start**

|Tq | Nr |
|:--|:--|
| <= 30% | <= 50% |
| <= 70% | <= 90% |

**Single Engine Torque**

{% include warning.html content="Exceeding 111 - 122% single engine torque for greater than 2.5 minutes, or 123 - 125% Torque for greater than 6 seconds, or 125% torque for any amount of time will result in a catastrophic transmission failure and/or loss of aircraft and crew!" %}

|Tq | Time |
|:--|:--|
| 0 to 110% | Normal Operation|
| 110% | Continuous |
| 111 to 122% | 2.5 Minutes |
| 123 to 125% | 6 Seconds |

**Dual Engine Torque**

{% include warning.html content="Exceeding 100 - 115% dual engine torque for greater than 6 seconds, or 115% Torque for any amount of time will result in a catastrophic transmission failure and/or loss of aircraft and crew!"" %}

| Tq | Time |
|:--|:--|
| 0 to 100% | Normal Operation|
| 100% | Continuous |
| 101 to 115% | 6 Seconds |

## Single Engine Sim

Once the power levers are at fly, each power lever can be manipulated indpendently. Beware of your current Tq, as it WILL double, potentially exceeding the Tq limits outlined above.