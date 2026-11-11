// What the setup asks about: CBA settings (by name) and bindable actions (by user action name)
(function () {
  'use strict';

  var CASUAL = 0, REALISTIC = 2;

  var settings = {
    bmkhs_helisimRealismSetting: {
      label: 'Flight model', type: 'list', options: [[CASUAL, 'Casual'], [REALISTIC, 'Realistic']]
    },
    bmkhs_autoPedal: {
      label: 'Auto pedal', type: 'bool',
      help: 'The computer works the pedals for you and holds your heading when you let go. Your pedal keys still turn the nose.'
    },
    bmkhs_autoPitch: {
      label: 'Auto pitch', type: 'bool', casualOnly: true,
      help: 'Holds the nose at its level-flight attitude, so you are not fighting the nose rising as you speed up.'
    },
    bmkhs_autoRoll: {
      label: 'Auto roll', type: 'bool', casualOnly: true,
      help: 'A roll key banks the aircraft up to its limit, and letting go rolls it back to wings level.'
    },
    bmkhs_keyboardStickyPitch: { label: 'Sticky pitch', type: 'bool' },
    bmkhs_keyboardStickyRoll: { label: 'Sticky roll', type: 'bool' },
    bmkhs_keyboardStickyYaw: { label: 'Sticky yaw', type: 'bool' },
    bmkhs_mouseAsJoystick: {
      label: 'Mouse as joystick', type: 'bool',
      help: 'Moving the mouse moves the cyclic. While you free-look, the cyclic stops taking the mouse, so you can look around without flying.'
    },
    bmkhs_mouseSense: {
      label: 'Mouse sensitivity', type: 'slider', min: 0.1, max: 1, step: 0.05,
      help: 'How far the cyclic moves for a given mouse movement, when the mouse is the joystick.'
    },
    bmkhs_springlessCyclic: {
      label: 'Springless cyclic', type: 'bool',
      help: 'For a stick with no centring spring, or a force feedback stick. Force trim no longer moves the trim position for you.'
    },
    bmkhs_springlessPedals: {
      label: 'Springless pedals', type: 'bool',
      help: 'For pedals with no centring spring. This also turns heading hold off.'
    },
    bmkhs_cyclicCenterTrimMode: {
      label: 'Cyclic centre trim mode', type: 'bool',
      help: 'After you let go of force trim, the stick does nothing until it is back in the middle. Stops the aircraft jerking as a sprung stick returns to centre after you trim.'
    },
    bmkhs_pedalCenterTrimMode: {
      label: 'Pedal centre trim mode', type: 'bool',
      help: 'The same for the pedals: after force trim they do nothing until they are back in the middle.'
    },
    bmkhs_vrsWarning: {
      label: 'Vortex ring state warning', type: 'bool',
      help: 'Warns you as you start to settle into your own downwash, from descending too fast at low speed.'
    },
    bmkhs_ctrlVisColor: {
      label: 'Control input visualiser colours', type: 'list',
      options: [[0, 'Default (green / orange / red)'], [1, 'NVG (all green)'], [2, 'Monochrome'], [3, 'Amber'], [4, 'Blue force'], [5, 'High contrast']],
      help: 'Colours of the on-screen control positions shown by the Control Input Visualiser key (Ctrl+I by default).'
    },
    hct_interaction_trackIR_interaction_cursor: {
      label: 'Detached interaction cursor', type: 'bool',
      help: 'The cockpit cursor moves with the mouse instead of sitting in the middle of your view. Made for TrackIR and other head tracking, so you can look one way and point at a switch another.'
    },
    hct_interaction_trackIR_interaction_cursorSensitivity: {
      label: 'Detached cursor sensitivity', type: 'slider', min: 1, max: 10, step: 0.5,
      help: 'How fast the detached cursor moves.'
    },
    hct_interaction_showLabels: {
      label: 'Switch labels', type: 'list', options: [[0, 'No labels'], [1, 'Name'], [2, 'Name and keys']],
      help: 'What is shown next to the cockpit switch you are pointing at. Name and keys tells you what to press.'
    },
    fza_ah64_tadsIgnoreHatchetCursor: {
      label: 'TADS ignores the detached cursor', type: 'bool',
      help: 'With the TADS on your helmet display, the mouse still slews the TADS while the detached cursor is on. Holding the cursor key still stops it.'
    },
    fza_ah64_showPopupv2_3: {
      label: 'Welcome popup', type: 'bool',
      help: 'Shows the welcome message the first time you get into an Apache in each mission.'
    },
    fza_ah64_vanillaTargetingEnable: {
      label: 'Arma targeting information', type: 'bool',
      help: 'Arma\'s own target markers and information. Needs a game restart to change.'
    },
    fza_ah64_tadsCycleIncludeDTV: {
      label: 'Night Vision key includes DTV', type: 'bool',
      help: 'The Night Vision key, which cycles the TADS sensor for the CPG, also stops at the daylight TV.'
    },
    fza_ah64_tadsCycleIncludeDVO: {
      label: 'Night Vision key includes DVO', type: 'bool',
      help: 'The Night Vision key also stops at the direct view optics.'
    },
    fza_ah64_LMCSensitivity: {
      label: 'LMC sensitivity', type: 'slider', min: 0, max: 1, step: 0.05,
      help: 'How strongly your aim input steers the TADS linear motion compensator, which keeps the TADS tracking a moving target.'
    },
    fza_ah64_radialDwellTime: {
      label: 'Radial menu dwell time', type: 'slider', min: 0.5, max: 3, step: 0.1, unit: 's',
      help: 'How long a stick or hat has to point at a radial menu item to pick it.'
    },
    fza_ah64_radialKeepOpen: {
      label: 'Keep radial menu open', type: 'bool',
      help: 'The radial menu stays open after you pick something, so you can pick several in a row.'
    },
    fza_ah64_volumeMaster: {
      label: 'Master volume', type: 'slider', min: 0, max: 5, step: 0.5,
      help: 'Volume of the cockpit sounds and warnings.'
    },
    fza_ah64_volumeRlwr: {
      label: 'Radar warning volume', type: 'slider', min: 0, max: 5, step: 0.5,
      help: 'Volume of the radar and laser warning tones.'
    },
    fza_ah64_animControls: {
      label: 'Animate the stick and collective', type: 'bool',
      help: 'Your cyclic and collective move in the cockpit as you fly. Turn off for a little performance.'
    }
  };

  function joy(p) { return p.device === 'joystick'; }
  function cpg(p) { return p.seat !== 'pilot'; }
  function plt(p) { return p.seat !== 'cpg'; }

  // need(p): 'required' | 'recommended' | 'optional' | 'hidden'; want(p): 'axis' | 'mouseAxis' | 'any'
  var cyclicWant = function (p) { return p.cyclic === 'axis' ? 'axis' : (p.cyclic === 'mouse' ? 'mouseAxis' : 'any'); };
  var pedalNeed = function (p) { return p.pedals === 'auto' ? 'recommended' : 'required'; };
  var pedalWant = function (p) { return p.pedals === 'axis' ? 'axis' : 'any'; };

  var actions = [
    // Flying
    { id: 'bmkhs_cyclicForward', sec: 'flight', title: 'Cyclic forward', does: 'Tilts the nose down, so you speed up or move forwards.',
      how: { axis: 'Push your stick forward.', pad: 'Push the right thumbstick up.', mouse: 'Move the mouse forward (Mouse Up).', keys: 'Press the key you want. W is the default.' },
      need: function () { return 'required'; }, want: cyclicWant, vanilla: ['HeliCyclicForward', 'HeliForward'], pair: 'bmkhs_cyclicBackward' },
    { id: 'bmkhs_cyclicBackward', sec: 'flight', title: 'Cyclic backward', does: 'Lifts the nose, so you slow down or move backwards.',
      how: { axis: 'Pull your stick back.', pad: 'Pull the right thumbstick down.', mouse: 'Move the mouse back (Mouse Down).', keys: 'Press the key you want. S is the default.' },
      need: function () { return 'required'; }, want: cyclicWant, vanilla: ['HeliCyclicBack', 'HeliBack'], pair: 'bmkhs_cyclicForward' },
    { id: 'bmkhs_cyclicLeft', sec: 'flight', title: 'Cyclic left', does: 'Rolls the aircraft left.',
      how: { axis: 'Push your stick left.', pad: 'Push the right thumbstick left.', mouse: 'Move the mouse left (Mouse Left).', keys: 'Press the key you want. A is the default.' },
      need: function () { return 'required'; }, want: cyclicWant, vanilla: ['HeliCyclicLeft', 'HeliLeft'], pair: 'bmkhs_cyclicRight' },
    { id: 'bmkhs_cyclicRight', sec: 'flight', title: 'Cyclic right', does: 'Rolls the aircraft right.',
      how: { axis: 'Push your stick right.', pad: 'Push the right thumbstick right.', mouse: 'Move the mouse right (Mouse Right).', keys: 'Press the key you want. D is the default.' },
      need: function () { return 'required'; }, want: cyclicWant, vanilla: ['HeliCyclicRight', 'HeliRight'], pair: 'bmkhs_cyclicLeft' },
    { id: 'bmkhs_collectiveUp', sec: 'flight', title: 'Collective up', does: 'More lift: climb, or take off.',
      how: { axis: 'Push your throttle (or lever) forward, away from you.' },
      need: function (p) { return p.collective === 'axis' ? 'required' : 'hidden'; }, want: function () { return 'axis'; },
      vanilla: ['HeliCollectiveRaiseCont', 'HeliCollectiveRaise', 'HeliUp', 'HeliThrottlePos'], pair: 'bmkhs_collectiveDn' },
    { id: 'bmkhs_collectiveDn', sec: 'flight', title: 'Collective down', does: 'Less lift: descend, or land. Without it the bottom half of your throttle does nothing.',
      how: { axis: 'Pull your throttle (or lever) back, towards you.' },
      need: function (p) { return p.collective === 'axis' ? 'required' : 'hidden'; }, want: function () { return 'axis'; },
      vanilla: ['HeliCollectiveLowerCont', 'HeliCollectiveLower', 'HeliDown', 'HeliThrottleNeg'], pair: 'bmkhs_collectiveUp' },
    { id: 'bmkhs_kbCollectiveUp', sec: 'flight', title: 'Keyboard collective up', does: 'More lift while held: climb, or take off.',
      how: { keys: 'Press the key or button you want. Left Shift is the default.', pad: 'Press the right bumper or trigger.' },
      need: function (p) { return p.collective === 'axis' ? 'hidden' : 'required'; }, want: function () { return 'any'; }, vanilla: ['HeliUp', 'HeliCollectiveRaise'] },
    { id: 'bmkhs_kbCollectiveDn', sec: 'flight', title: 'Keyboard collective down', does: 'Less lift while held: descend, or land.',
      how: { keys: 'Press the key or button you want. Left Ctrl is the default.', pad: 'Press the left bumper or trigger.' },
      need: function (p) { return p.collective === 'axis' ? 'hidden' : 'required'; }, want: function () { return 'any'; }, vanilla: ['HeliDown', 'HeliCollectiveLower'] },
    { id: 'bmkhs_pedalLeft', sec: 'flight', title: 'Pedal left', does: 'Turns the nose left.',
      how: { rudder: 'Push your left pedal.', twist: 'Twist your stick left.', pad: 'Push the left thumbstick left.', keys: 'Press the key you want. Q is the default.' },
      need: pedalNeed, want: pedalWant, vanilla: ['HeliRudderLeft'], pair: 'bmkhs_pedalRight' },
    { id: 'bmkhs_pedalRight', sec: 'flight', title: 'Pedal right', does: 'Turns the nose right.',
      how: { rudder: 'Push your right pedal.', twist: 'Twist your stick right.', pad: 'Push the left thumbstick right.', keys: 'Press the key you want. E is the default.' },
      need: pedalNeed, want: pedalWant, vanilla: ['HeliRudderRight'], pair: 'bmkhs_pedalLeft' },
    { id: 'bmkhs_forceTrim', sec: 'flight', title: 'Force trim', does: 'Hold it, put the stick where you want it, then let go: that stick position becomes the new centre, and the hold modes take the aircraft as it is now as their target.',
      how: { any: 'Press a button on your stick, ideally one under your thumb or a finger.' },
      need: function (p) { return joy(p) ? 'required' : (p.device === 'gamepad' ? 'recommended' : 'optional'); }, want: function () { return 'any'; } },
    { id: 'bmkhs_forceTrimPanic', sec: 'flight', title: 'Force trim reset', does: 'Clears the trim and centres the controls. Your way out if the trim has ended up somewhere odd.',
      need: function (p) { return p.device === 'kbm' ? 'optional' : 'recommended'; }, want: function () { return 'any'; } },
    { id: 'bmkhs_stickyInterrupt', sec: 'flight', title: 'Sticky control interrupt', does: 'Hold to take direct control of the sticky axes again. Space is the default.',
      need: function (p) { return p.sticky ? 'required' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'bmkhs_holdModeAttitude', sec: 'flight', title: 'Attitude hold', does: 'Turns attitude hold on or off. It holds your position, speed or attitude depending on how fast you are going.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'bmkhs_holdModeAltitude', sec: 'flight', title: 'Altitude hold', does: 'Turns altitude hold on or off.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'bmkhs_holdModesOff', sec: 'flight', title: 'Hold modes off', does: 'Turns every hold mode off.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'bmkhs_ctrlVisToggle', sec: 'flight', title: 'Control input visualiser', does: 'Shows where your controls are on screen. Handy for checking your setup in flight. Ctrl+I is the default.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },

    // Cockpit
    { id: 'hct_interaction_use', sec: 'cockpit', title: 'Interact', does: 'Presses the button, or flips the switch, that the cursor is on. F is the default.',
      need: function () { return 'required'; }, want: function () { return 'any'; } },
    { id: 'hct_interaction_cursor', sec: 'cockpit', title: 'Mouse cursor (hold)', anyOf: 'cursor', does: 'While held, the mouse moves a pointer around the cockpit instead of your view. The default is the Right Windows key, which many keyboards do not have.',
      need: function () { return 'required'; }, want: function () { return 'any'; } },
    { id: 'hct_interaction_cursorToggle', sec: 'cockpit', title: 'Mouse cursor (toggle)', anyOf: 'cursor', does: 'The same pointer, on with one press and off with the next. Bind this or the hold version.',
      need: function () { return 'required'; }, want: function () { return 'any'; } },
    { id: 'hct_interaction_fore', sec: 'cockpit', title: 'Next setting', does: 'Turns a knob or moves a switch one position on. The mouse wheel is the default.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },
    { id: 'hct_interaction_back', sec: 'cockpit', title: 'Previous setting', does: 'Turns a knob or moves a switch one position back. The mouse wheel is the default.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_radialMenu', sec: 'cockpit', title: 'Radial menu', does: 'Opens a menu for your sight, the TADS, the radar, the laser spot tracker and your symbology. Good on a HOTAS: pick items with a hat.',
      need: function (p) { return p.device === 'kbm' ? 'optional' : 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_radialUp', sec: 'cockpit', title: 'Radial menu: up', does: 'Points the open radial menu up. Bind the four directions to a hat or a thumbstick.',
      need: function (p) { return p.device === 'kbm' ? 'optional' : 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_radialDown', sec: 'cockpit', title: 'Radial menu: down', does: 'Points the open radial menu down.',
      need: function (p) { return p.device === 'kbm' ? 'optional' : 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_radialLeft', sec: 'cockpit', title: 'Radial menu: left', does: 'Points the open radial menu left.',
      need: function (p) { return p.device === 'kbm' ? 'optional' : 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_radialRight', sec: 'cockpit', title: 'Radial menu: right', does: 'Points the open radial menu right.',
      need: function (p) { return p.device === 'kbm' ? 'optional' : 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_mpdCursorUp', sec: 'cockpit', title: 'MPD cursor: up', does: 'Moves your cursor on the cockpit screens. Bind the four directions to a hat or a mini-stick.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_mpdCursorDown', sec: 'cockpit', title: 'MPD cursor: down', does: 'Moves your screen cursor down.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_mpdCursorLeft', sec: 'cockpit', title: 'MPD cursor: left', does: 'Moves your screen cursor left.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_mpdCursorRight', sec: 'cockpit', title: 'MPD cursor: right', does: 'Moves your screen cursor right.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_mpdCursorEnter', sec: 'cockpit', title: 'MPD cursor: enter', does: 'Presses the screen button the cursor is on.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_mpdCursorDisplaySelect', sec: 'cockpit', title: 'MPD cursor: display select', does: 'Jumps your cursor to the other screen.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },

    // Weapons and sensors, both crew stations
    { id: 'DefaultAction', sec: 'weapons', title: 'Fire', does: 'Fires the weapon you have actioned. Left mouse button by default.',
      need: function () { return 'required'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_wasGun', sec: 'weapons', title: 'Action the gun', does: 'Selects the gun for your crew station. Press again to put it away. 1 is the default.',
      need: function () { return 'required'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_wasRkt', sec: 'weapons', title: 'Action the rockets', does: 'Selects the rockets for your crew station. 2 is the default.',
      need: function () { return 'required'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_wasMsl', sec: 'weapons', title: 'Action the missiles', does: 'Selects the Hellfires for your crew station. 3 is the default.',
      need: function () { return 'required'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_v30_sightSelectHMD', sec: 'weapons', title: 'Sight select HMD', does: 'Makes your helmet your sight: weapons point where you look. Shift+1 is the default.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_v30_sightSelectFCR', sec: 'weapons', title: 'Sight select FCR', does: 'Makes the fire control radar your sight. Shift+3 is the default.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },
    { id: 'ActiveSensorsToggle', sec: 'weapons', title: 'Radar on/off (FCR scan)', does: 'Arma\'s radar key starts and stops the FCR scanning, for whoever has the FCR as their sight. Ctrl+R is the default.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_fcrSingleScan', sec: 'weapons', title: 'FCR single scan', does: 'Scans the radar once. Shift+R is the default.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },
    { id: 'vehLockTargets', sec: 'weapons', title: 'Lock target (next FCR target)', does: 'Arma\'s lock key steps through the radar\'s targets, for whoever owns the FCR.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_flare', sec: 'weapons', title: 'Flare', does: 'Drops one flare. X is the default.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },
    { id: 'launchCM', sec: 'weapons', title: 'Countermeasures (chaff)', does: 'Arma\'s countermeasures key drops chaff.',
      need: function () { return 'recommended'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_symbologySelectUp', sec: 'weapons', title: 'Symbology select up', does: 'Switches your helmet symbology between transition and cruise. Shift+B is the default.',
      need: function (p) { return plt(p) ? 'recommended' : 'optional'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_symbologySelectDown', sec: 'weapons', title: 'Symbology select down', does: 'Switches your helmet symbology between hover and bob-up. Ctrl+B is the default.',
      need: function (p) { return plt(p) ? 'recommended' : 'optional'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_symbologySelectPress', sec: 'weapons', title: 'Symbology select press', does: 'Brings up the flight page on the left screen. B is the default.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'Headlights', sec: 'weapons', title: 'Lights (searchlight)', does: 'Arma\'s lights key turns the searchlight on and off.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_collectiveEmergJett', sec: 'weapons', title: 'Emergency jettison', does: 'Drops every store. For when you are too heavy to stay in the air.',
      need: function () { return 'optional'; }, want: function () { return 'any'; } },

    // CPG
    { id: 'fza_ah64_v30_sightSelectTADS', sec: 'weapons', seat: 'cpg', title: 'Sight select TADS', does: 'Makes the TADS camera the CPG\'s sight. Shift+2 is the default.',
      need: function (p) { return cpg(p) ? 'required' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_laserDesig', sec: 'weapons', seat: 'cpg', title: 'Laser (lase)', does: 'Fires the laser while held, for range and for laser-guided Hellfires. G is the default.',
      need: function (p) { return cpg(p) ? 'required' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'zoomIn', sec: 'weapons', seat: 'cpg', title: 'Zoom in (TADS field of view)', does: 'Arma\'s zoom keys step the TADS to a narrower field of view.',
      need: function (p) { return cpg(p) ? 'recommended' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'zoomOut', sec: 'weapons', seat: 'cpg', title: 'Zoom out (TADS field of view)', does: 'Steps the TADS to a wider field of view.',
      need: function (p) { return cpg(p) ? 'recommended' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'NightVision', sec: 'weapons', seat: 'cpg', title: 'Night vision (TADS sensor)', does: 'Arma\'s night vision key cycles the TADS between its sensors.',
      need: function (p) { return cpg(p) ? 'recommended' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_sightSlave', sec: 'weapons', seat: 'cpg', title: 'Sight slave', does: 'Points the TADS at the acquisition source, such as a stored target or the pilot\'s helmet, or frees it again. Shift+F is the default.',
      need: function (p) { return cpg(p) ? 'recommended' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_cpgStoreUpdate', sec: 'weapons', seat: 'cpg', title: 'Store/update', does: 'Stores a target point where your sight is looking. Shift+G is the default.',
      need: function (p) { return cpg(p) ? 'recommended' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_tadsLHGLmc', sec: 'weapons', seat: 'cpg', title: 'LMC', does: 'Turns the TADS linear motion compensator on and off, which keeps the TADS tracking a moving target. Ctrl+T is the default.',
      need: function (p) { return cpg(p) ? 'recommended' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_iatEngage', sec: 'weapons', seat: 'cpg', title: 'IAT (image auto tracker)', does: 'Locks the TADS onto the target under the crosshair, or lets go of it.',
      need: function (p) { return cpg(p) ? 'optional' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_v30_sightSelectLink', sec: 'weapons', seat: 'cpg', title: 'Sight select link', does: 'Links the radar to the TADS, or the TADS to the radar.',
      need: function (p) { return cpg(p) ? 'optional' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_lstAuto', sec: 'weapons', seat: 'cpg', title: 'Laser spot tracker: auto', does: 'Searches for someone else\'s laser spot and turns the TADS onto it.',
      need: function (p) { return cpg(p) ? 'optional' : 'hidden'; }, want: function () { return 'any'; } },
    { id: 'fza_ah64_missileAdvance', sec: 'weapons', seat: 'cpg', title: 'Missile advance', does: 'Steps to the next missile, when the missile mode is manual.',
      need: function (p) { return cpg(p) ? 'optional' : 'hidden'; }, want: function () { return 'any'; } }
  ];

  // Read for conflicts and for the "Arma's own helicopter controls" check only, never listed
  var extra = [
    'HeliCyclicForward', 'HeliForward', 'HeliCyclicBack', 'HeliBack', 'HeliCyclicLeft', 'HeliLeft', 'HeliCyclicRight', 'HeliRight',
    'HeliCollectiveRaiseCont', 'HeliCollectiveRaise', 'HeliUp', 'HeliThrottlePos',
    'HeliCollectiveLowerCont', 'HeliCollectiveLower', 'HeliDown', 'HeliThrottleNeg', 'HeliRudderLeft', 'HeliRudderRight',
    'AimUp', 'AimDown', 'AimLeft', 'AimRight', 'AimHeadUp', 'AimHeadDown', 'AimHeadLeft', 'AimHeadRight', 'LookAround', 'LookAroundToggle'
  ];

  window.FZA_SETUP_CATALOGUE = { CASUAL: CASUAL, REALISTIC: REALISTIC, settings: settings, actions: actions, extra: extra };
})();
