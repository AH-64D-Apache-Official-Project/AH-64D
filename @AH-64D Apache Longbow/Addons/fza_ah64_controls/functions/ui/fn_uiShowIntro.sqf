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
"<t align='center' size='2'>AH-64D Official Project V2.2</t><br/>
<br/>
<t align='center'><img size='10' image='\fza_ah64_us\tex\intro.jpg'/></t><br/>
<br/>
After over three years of development, we are happy to announce V2.2. This has been a large release with changes ranging from the displays being rewritten, to a new flight model and damage handling being implemented.<br/>
<br/>
<t align='center' size='1.5'>Documentation</t><br/>
To support the new release, we have revised and rewritten all of our documentation, which can be still found at <a href='https://ah-64d-apache-official-project.github.io/'>https://ah-64d-apache-official-project.github.io</a>. For more information on the mod, we recommend going here.<br/>
<br/>
<t align='center' size='1.5'>Displays</t><br/>
We have rewritten all the MPDs using a combination of Arma's MFD config system, and the new UI to texture system. This has given us the ability to have increased fidelity for our displays, both in improving existing pages and also adding new ones. All pages are also available on both MPDs. We also have a functional UFD and KU, along with other buttons in the cockpit like the ARM/SAFE and caution lights working as expected<br/>
<br/>
<t align='center' size='1.5'>Helisim</t><br/>
SFM+ has been replaced with a full new custom flight model with SFM fully disabled. It accurately simulates phenomena like Ground Effect, Main Rotor Torque Effect, ETL, and VRS in a variety of situations. The CG and mass of the aircraft are updated and correctly simulated.<br/>
A Flight Management Computer with Force Trim, Hold Modes (Heading, Altitude, Attitude), CAS and SAS has been added, to give you a smoother ride.
<br/>
<t align='center' size='1.5'>Damage model</t><br/>
Our damage model is better tied into the aircraft's systems, you can expect to lose certain abilities depending on what damage you take.<br/>
<br/>
<t align='center' size='1.5'>Audio update</t><br/>
The audio you encounter in the aircraft has been improved, so you will get better audible feedback from systems in the aircraft<br/>
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
private _buttonSpoiler = _display displayctrl 2400;
private _textSpoiler = _display displayctrl 1101;
private _text2 = _display displayCtrl 1102;

//Fill only the first text
_text1 ctrlSetStructuredText _content;

//Resize StructuredText component to display the scrollbar if needed
private _positionText1 = ctrlPosition _text1;
private _yText1 = _positionText1 select 1;
private _hText1 = ctrlTextHeight _text1;
_text1 ctrlSetPosition [_positionText1 select 0, _yText1, _positionText1 select 2, _hText1];
_text1 ctrlcommit 0;

//Hide second text, spoiler text and button
_buttonSpoiler ctrlSetFade 1;
_buttonSpoiler ctrlCommit 0;
_buttonSpoiler ctrlEnable false;

_textSpoiler ctrlSetFade 1;
_textSpoiler ctrlCommit 0;

_text2 ctrlSetFade 1;
_text2 ctrlCommit 0;