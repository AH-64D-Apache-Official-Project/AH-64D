/* ----------------------------------------------------------------------------
Function: fza_fnc_uiShowIntro
Description:
    onLoad event handler for the introduction popup
Parameters:
    _display - display that the dialog is opened up on
Returns:
    Nothing
Examples:
    --- Code
    call fza_fnc_uiShowIntro
    ---
Author:
    Mattysmith22
---------------------------------------------------------------------------- */
params ["_display"];
fza_ah64_introShownThisScenario = true;

private _content = parseText
"<t align='center' size='2'>AH-64D Official Project V2.3</t><br/>
<br/>
<t align='center'><img size='10' image='\fza_ah64_model\tex\intro.jpg'/></t><br/>
<br/>
V2.3 is here, building on the V2.2 flight model and displays overhaul with a round of refinements, new systems and bug fixes across HeliSim, the MPDs and multiplayer.<br/>
<br/>
<t align='center' size='1.5'>Documentation</t><br/>
Our documentation continues to be maintained at <a href='https://ah-64d-apache-official-project.github.io/'>https://ah-64d-apache-official-project.github.io</a>. For more information on the mod, we recommend going here.<br/>
<br/>
<t align='center' size='1.5'>Helisim</t><br/>
The flight model has received another major pass. Retreating Blade Stall has been added and tuned, autorotations are more forgiving, and the rotor and fuselage code has been reworked for more accurate velocity and wind handling. Auto pedal and auto pitch logic have been retuned, heading hold and yaw SAS bugs have been fixed, and several rotor controller issues have been resolved.<br/>
<br/>
<t align='center' size='1.5'>Fuel system</t><br/>
A new dynamic fuel system has been added, matching the -10 fuel page logic. Each tank is independently simulated, with crossfeed, automatic fuel balancing, fuel leaks and auxiliary tank logic all modeled, and represented on a new MPD fuel page showing live fuel line flow.<br/>
<br/>
<t align='center' size='1.5'>Mission Planner</t><br/>
A brand new pre-flight Mission Planner has been added, giving you a full browser-based loadout and systems editor before you ever start the mission. Configure pylon loadouts, fuel state and FCR settings, then save and load your configurations between missions.<br/>
<br/>
<t align='center' size='1.5'>FCR</t><br/>
The Fire Control Radar has been reworked under the hood, the FCR will now perform sweeping reveals of targets and the FCR dome will animate accordingly, this may naturaly cause delays in a scan start whilst the FCR positions itself correctly for the scan. The MPD's ATM and GTM radar pages and the TSD page have all been redrawn to take advantage of this, giving more accurate and reliable target data.<br/>
<br/>
<t align='center' size='1.5'>Hellfire</t><br/>
The Hellfire ARH seeker has been substantially rewritten, with dedicated logic for line-of-sight checks, target seeker cone validation, target constraints and chaff/countermeasure defeat. Combined with FCR target data now being fed directly to the missile, Remote Fire and SAL engagements should feel noticeably more realistic.<br/>
<br/>
<t align='center' size='1.5'>Multiplayer &amp; stability</t><br/>
A number of multiplayer-specific bugs have been fixed, including pylon validity checks, customise add/remove desync and jettison-all behaviour. translations have been improved, And most notisably, a sweeping array of logic bugs that could cause the airframe to be unstable have now been fixes<br/>
<br/>
Fly safe! <br/>
<br/>
<t align='right'>AH-64D Official Project</t><br/>
<t align='right'>Development Team</t>";
//[_content, "Welcome to the apache mod!"] spawn BIS_fnc_guiMessage

//Format and set welcome message
private _colorHighlight = ["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet;
_colorHighlight = _colorHighlight call BIS_fnc_colorRGBtoHTML;
private _colorWarning = ["IGUI", "WARNING_RGB"] call BIS_fnc_displayColorGet;
_colorWarning = _colorWarning call BIS_fnc_colorRGBtoHTML;

//Definitions of controls influenced by Spoiler button
private _text1 = _display displayCtrl 1100;
private _buttonSpoiler = _display displayCtrl 2400;
private _textSpoiler = _display displayCtrl 1101;
private _text2 = _display displayCtrl 1102;

//Fill only the first text
_text1 ctrlSetStructuredText _content;

//Resize StructuredText component to display the scrollbar if needed
private _positionText1 = ctrlPosition _text1;
private _yText1 = _positionText1 select 1;
private _hText1 = ctrlTextHeight _text1;
_text1 ctrlSetPosition [_positionText1 select 0, _yText1, _positionText1 select 2, _hText1];
_text1 ctrlCommit 0;

//Hide second text, spoiler text and button
_buttonSpoiler ctrlSetFade 1;
_buttonSpoiler ctrlCommit 0;
_buttonSpoiler ctrlEnable false;

_textSpoiler ctrlSetFade 1;
_textSpoiler ctrlCommit 0;

_text2 ctrlSetFade 1;
_text2 ctrlCommit 0;
