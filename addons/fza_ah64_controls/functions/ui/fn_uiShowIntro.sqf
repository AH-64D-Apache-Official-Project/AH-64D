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
"<t align='center' size='2'>AH-64D Official Project V3.0</t><br/>
<br/>
<t align='center'><img size='10' image='\fza_ah64_model\tex\intro.jpg'/></t><br/>
<br/>
V3.0 moves the flight model and the aircraft systems to HeliSim Core, and brings a new IHADSS helmet and symbology, new radar modes and a VIDEO page. It needs HeliSim Core 1.4.2 or later and CBA_A3 3.16 or later.<br/>
<br/>
<t align='center' size='1.5'>Documentation</t><br/>
Our documentation continues to be maintained at <a href='https://ah-64d-apache-official-project.github.io/'>https://ah-64d-apache-official-project.github.io</a>. For more information on the mod, we recommend going here.<br/>
<br/>
<t align='center' size='1.5'>HeliSim Core</t><br/>
The flight model and the aircraft systems (engines, electrics, hydraulics, fuel and rotor) now come from the separate HeliSim Core mod, which must be loaded. The flight control modes run on its flight management computer: attitude hold picks position, velocity or attitude hold by your ground speed, and heading hold blends into turn coordination. The main and tail rotors can now be destroyed.<br/>
<br/>
<t align='center' size='1.5'>Helmet and symbology</t><br/>
A new IHADSS helmet is now the AH-64D pilot's default headgear, and is needed to bring the monocle down and for head tracking. The helmet symbology has four flight modes (transition, cruise, hover and bob-up), the CPG's weapon symbology, missile constraints, the rocket steering cursor and the high action display. Either crew station can take the PNVS or the TADS FLIR as its night vision sensor.<br/>
<br/>
<t align='center' size='1.5'>Sensors and targeting</t><br/>
Range sources (laser, radar, navigation, manual and automatic) are shown on the HAD, and targets can be stored along your sight. The laser spot tracker finds someone else's laser spot and turns the TADS onto it. The radar gains TPM and RMAP modes, and a radial menu covers your sight, the TADS, the radar, the laser spot tracker and your symbology.<br/>
<br/>
<t align='center' size='1.5'>Weapons</t><br/>
Radar Hellfires are powered and aligned before they can be fired. With the gun in FXD, a reticle marks where it will hit, and ALT LAUNCH stops the gun firing straight after a rocket or missile launch.<br/>
<br/>
<t align='center' size='1.5'>MPDs</t><br/>
The new VIDEO page shows the TADS, the PNVS or either crew station's helmet symbology, and there are games on the MPD for the long wait on the ground.<br/>
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
