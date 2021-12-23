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
"<t align='center' size='2'>AH-64D Official Project V2.1</t><br/>
<br/>
<t align='center'><img size='10' image='\fza_ah64_us\tex\intro.jpg'/></t><br/>
<br/>
We are excited to give to the community our first release since the massive V2.0 update. In this update, we have built upon V2.0 to revolutionise some areas of the mod:<br/>
<br/>
<t align='center' size='1.5'>Documentation</t><br/>
To support the new release, we have revised and rewritten all of our documentation, and it has since been moved to <a href='https://ah-64d-apache-official-project.github.io/'>https://ah-64d-apache-official-project.github.io</a>. For more information on the mod, we recommend going here.<br/>
<br/>
<t align='center' size='1.5'>Keybindings</t><br/>
We are happy to release a new keybinding update, which has redone every control to be closer to the real aircraft. They are now also all mappable to joystick buttons, and for those people with home cockpits each button in the aircraft is mappable to a keybind. To see the list of keybindings, and their default values, go to <a href='https://ah-64d-apache-official-project.github.io/keybinds.html'>keybinds</a><br/>
<br/>
<t align='center' size='1.5'>SFM+</t><br/>
We have improved how the collective is read for both keyboard and joystick users.<br/>
The stabilator is now, by default, only on for joystick users. Keyboard users that still want it, will still be able to enable it in the settings.<br/>
Engine overtorque damage is now simulated. With a full fuel and ammo load, you will NOT be able to hover out of ground effect. Burn some fuel, or fire some ammo beforehand!<br/>
The general rules are don’t spend longer than 6 seconds over 101-115% torque, and do not exceed 115% torque at any point. When in a single engine situation, the limits are more forgiving. for more information please see <a href='https://ah-64d-apache-official-project.github.io/flight-model-sfm-plus.html'>here</a>.<br/>
<br/>
<t align='center' size='1.5'>AI Update</t><br/>
AI will now be able to operate basic systems of the aircraft - an AI pilot will be able to start the aircraft, and will be able to operate the fire panel.<br/>
AI should also better use the aircraft’s weapons, and should be compatible with other AI mods.<br/>
<br/>
<t align='center' size='1.5'>ASE Update</t><br/>
Threats to the aircraft should better appear on the ASE page, and the jammers have been improved also.<br/>
<br/>
There is now a 1.5 second activation delay for the jammers whenever activating them.<br/>
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