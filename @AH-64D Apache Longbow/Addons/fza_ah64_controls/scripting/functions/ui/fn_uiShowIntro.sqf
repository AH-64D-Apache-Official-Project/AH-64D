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
"<t align='center' size='2'>AH-64D Official Project</t><br/>
<br/>
<t align='center'><img size='10' image='\fza_ah64_us\tex\intro.jpg'/></t><br/>
<br/>
Starting in February 2017 from the ARMA 2 mod of the same name, this project received significant changes and enhancements over the years as the development team grew. <br/>
<br/>
With the help of real-world AH-64D/E pilots we are proud to present to you one of the best rotary wing experiences possible within the limitations of ARMA 3. <br/>
<br/>
With 2.0, our team presents over a year’s worth of work designed to enhance the fidelity, immersion, performance, reliability and lay the groundwork for new features. To that end entire sections of the mod were re-written from scratch with an eye towards utilizing inbuilt ARMA 3 features. <br/>
<br/>
To get started and familiarize yourself with your new office, head over to our <a href='https://github.com/AH-64D-Apache-Official-Project/AH-64D/wiki/Setting-Up'>AH-64D Official Project Wiki page.</a><br/>
<br/>
If you want to support us and be part of our large community, feel free to join us on our <a href='https://discord.gg/rB6yDDy'>AH-64D Official Project Discord.</a><br/>
<br/>
If you have any questions, please check our #faq channel on Discord prior to asking. If you do encounter a bug that you would like to report, please do so on our <a href='https://github.com/AH-64D-Apache-Official-Project/AH-64D/issues'>Github</a><br/>
<br/>
PS: This introduction message can be turned off in Options>Addon Options>AH-64D Official Project.<br/>
<br/>
We really hope you'll enjoy our mod as much as we do. Fly safe.<br/>
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