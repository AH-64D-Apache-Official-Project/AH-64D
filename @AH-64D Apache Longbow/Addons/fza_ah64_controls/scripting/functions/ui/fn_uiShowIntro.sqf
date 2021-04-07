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
diag_log "test";
private _content = parseText
"<t align='center' size='2'>Welcome to the apache mod!</t><br/>
<br/>
<t align='center'><img size='10' image='\fza_ah64_us\tex\intro.jpg'/></t><br/>
<br/>
We are happy to bring you many months of work from our community, with a large code rewrite in the backend to bring you more features and better quality.<br/>
<br/>
Want to learn how to get set up? Can't click things in the cockpit? Why don't you check our <a href='https://github.com/AH-64D-Apache-Official-Project/AH-64D/wiki/Setting-Up'>wiki</a>!<br/>
<br/>
Want to get more involved in the community? Join us on our discord <a href='https://discord.gg/rB6yDDy'>here</a>. If you have any questions, make sure to check out the FAQ channel, there are lots of great resources there!<br/>
<br/>
To be able to click things in the cockpit, make sure to bind something to our custom cockpit interaction under our keybinds. Default is User Action 20.<br/>
<br/>
This message can be disabled in the CBA settings for our mod.<br/>
<br/>
Happy flying!<br/>
Apache mod development team<br/>
<br/>";
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