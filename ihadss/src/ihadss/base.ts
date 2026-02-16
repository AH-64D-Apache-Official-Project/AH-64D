export type model = {
  crewStation: string;  //"plt" "cpg"
  sightSelect: number;  //0 = hmd, 1 = tads, 2 = fcr
  nvsModeNorm: boolean;
  selSymb: string;  //"bobup", "hover", "trans", "cruise"
  wpnWas: number; //0 = none, 1 = gun, 2 = rkt, 3 = msl
  heading: number;
  gndSpd: number;
  radAlt: number;
  ownerCue: string;
  wpnInhibit: string;
  sightStatus: string;
  rngAndRngSrc: number;
  wpnControl: string;
  acqSelStatus: string;
  wpnStatus: string;
}

export const exampleModel: model = {
  crewStation: "cpg",
  sightSelect: 1,
  nvsModeNorm: false,
  selSymb: "trans",
  wpnWas: 0,
  heading: 16,
  gndSpd: 72,
  radAlt: 243,
  ownerCue: "-OWNER-CUE-",
  wpnInhibit: "WEAPON-INHIB",
  sightStatus: "SIGHT-STATUS",
  rngAndRngSrc: 1000,
  wpnControl: "WPNCT",
  acqSelStatus: "ACQS",
  wpnStatus: "WEAPONSTATUS",
}

export function ihadssStyle(_ctx: CanvasRenderingContext2D) {
  _ctx.strokeStyle = "#0F0";
  _ctx.fillStyle = "#0F0";
  _ctx.font = "15px BMKApacheFont";
  _ctx.globalAlpha = 1;
  _ctx.lineWidth = 2;
}

export function draw(_ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.crewStation == "plt") {
    drawFlightFormatLos(_ctx);
    drawFieldOfRegardPilot(_ctx);
  } else {
    //1 = TADS
    if (_model.sightSelect == 1 && _model.nvsModeNorm == false) {
      drawGunnerFormatLos(_ctx);
      drawFieldOfRegardGunner(_ctx);
    } else {
      drawFlightFormatLos(_ctx);
      drawFieldOfRegardGunner(_ctx);
    };
  };
  drawHeadingTape(_ctx, _model);
  drawLubberLine(_ctx);
  drawHadFields(_ctx, _model);
}

export function drawFlightFormatLos(_ctx: CanvasRenderingContext2D) {
  _ctx.save();
  _ctx.translate(320, 240);
  _ctx.beginPath();
  for (let i = 0; i < 4; i++) {
    _ctx.moveTo(0, 10);
    _ctx.lineTo(0, 10 + 18);
    _ctx.rotate(0.5 * Math.PI);
  };
  _ctx.stroke();
  _ctx.restore();
}

function drawGunnerFormatLos(_ctx: CanvasRenderingContext2D) {
  _ctx.save();
  _ctx.translate(320, 240);
  _ctx.beginPath();
  //Top vertical line
  _ctx.moveTo( 0, -27);
  _ctx.lineTo( 0, -10);
  //Right horizontal line
  _ctx.moveTo( 10, 0);
  _ctx.lineTo( 53, 0);
  //Bottom vertical line
  _ctx.moveTo( 0, 10);
  _ctx.lineTo( 0, 27);
  //Left horizontal line
  _ctx.moveTo(-53, 0);
  _ctx.lineTo(-10,  0);

  _ctx.stroke();
  _ctx.restore();
}

export function drawHeadTracker(_ctx: CanvasRenderingContext2D) {
  _ctx.save();
  _ctx.beginPath();
  for (let i = 0; i < 4; i++) {
    _ctx.moveTo(-8, 18);
    _ctx.lineTo(0, 26);
    _ctx.lineTo(8, 18);
    _ctx.rotate(0.5 * Math.PI);
  }
  _ctx.stroke();
  _ctx.restore();
}

export function drawFieldOfRegardPilot(_ctx: CanvasRenderingContext2D) {
  const forWidth  = 116;
  const forHeight = 44;

  _ctx.strokeRect(320 - (forWidth / 2), 455 - (forHeight / 2), forWidth, forHeight);

  //Left vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(262,448);
  _ctx.lineTo(269,448);
  _ctx.stroke();

  //Right vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(371,448);
  _ctx.lineTo(378,448);
  _ctx.stroke();

  //Top vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320,433);
  _ctx.lineTo(320,440);
  _ctx.stroke();

  //Bottom vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320,469);
  _ctx.lineTo(320,476);
  _ctx.stroke();
}

export function drawFieldOfRegardGunner(_ctx: CanvasRenderingContext2D) {
  const forWidth  = 124;
  const forHeight = 44;

  _ctx.strokeRect(320 - (forWidth / 2), 455 - (forHeight / 2), forWidth, forHeight);

  //Left vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(258,448);
  _ctx.lineTo(265,448);
  _ctx.stroke();

  //Right vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(375,448);
  _ctx.lineTo(382,448);
  _ctx.stroke();

  //Center top vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320,433);
  _ctx.lineTo(320,440);
  _ctx.stroke();

  //Center bottom vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320,469);
  _ctx.lineTo(320,476);
  _ctx.stroke();

  //Top left 90 degree vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320 - 47, 433);
  _ctx.lineTo(320 - 47, 440);
  _ctx.stroke();

  //Top left 90 degree vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320 - 47, 469);
  _ctx.lineTo(320 - 47, 476);
  _ctx.stroke();

  //Top right 90 degree vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320 + 47, 433);
  _ctx.lineTo(320 + 47, 440);
  _ctx.stroke();

  //Top right 90 degree vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320 + 47, 469);
  _ctx.lineTo(320 + 47, 476);
  _ctx.stroke();
}

export function drawHeadingTape(_ctx: CanvasRenderingContext2D, _model: model) {
  const posY      = 66;

  const shortTickHeight = 3;
  const longTickHeight  = 5;
  const textoffsetY     = 7;

  const numTicks  = 36;
  const spacing   = 12;

  const aircraftoffset = Math.round(_model.heading * spacing / 10);
  _ctx.beginPath();

  for (let i = 0; i < numTicks; i++) {
    let tickheading = i * 10;
    let offset = tickheading - _model.heading;

    if (offset < -180) {
      offset += 360;
      tickheading += 360;
    } else if (offset > 180) {
      offset -= 360;
      tickheading -= 360;
    }

    if (offset <= -105 || offset >= 105) {
      continue;
    }

    const major = (tickheading % 30) == 0;
    const tickX = (320 + tickheading * spacing / 10 - aircraftoffset);
    
    if (major) {
      _ctx.moveTo(tickX, posY - longTickHeight);
      _ctx.lineTo(tickX, posY + longTickHeight);
    } else {
      _ctx.moveTo(tickX, posY - shortTickHeight);
      _ctx.lineTo(tickX, posY + shortTickHeight);
    }

    _ctx.textAlign = "center";
    _ctx.font = "15px BMKApacheFont";

    if (((tickheading + 360) % 360) == 0) {
      _ctx.fillText("N", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 30) {
      _ctx.fillText("3", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 60) {
      _ctx.fillText("6", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 90) {
      _ctx.fillText("E", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 120) {
      _ctx.fillText("12", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 150) {
      _ctx.fillText("15", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 180) {
      _ctx.fillText("S", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 210) {
      _ctx.fillText("21", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 240) {
      _ctx.fillText("24", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 270) {
      _ctx.fillText("W", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 300) {
      _ctx.fillText("30", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 330) {
      _ctx.fillText("33", tickX, posY - textoffsetY);
    }
  }
  _ctx.stroke();

  const headingtext = _model.heading.toFixed(0);
  const textwidth = _ctx.measureText(headingtext);
  const textpadding = 10;
  
  _ctx.clearRect(320 - ((textwidth.width + textpadding) / 2), 40, textwidth.width + textpadding, 20);
  
  //Center Heading
  _ctx.textAlign = "center";
  _ctx.font = "18px BMKApacheFont";
  _ctx.textBaseline = "bottom";
  _ctx.fillText(headingtext, 320, 60);
}

export function drawLubberLine(_ctx: CanvasRenderingContext2D) {
  _ctx.beginPath();
  _ctx.moveTo(318, 73);
  _ctx.lineTo(322, 73);
  _ctx.lineTo(322, 96);
  _ctx.lineTo(318, 96);
  _ctx.lineTo(318, 73);
  _ctx.fill();
}

export function drawHadFields(_ctx: CanvasRenderingContext2D, _model: model) {
  ihadssStyle(_ctx);

  //Owner Cue
  _ctx.textAlign    = "center";
  _ctx.textBaseline = "bottom";
  _ctx.fillText(_model.ownerCue,   320, 395);

  //WPN Inhibit
  _ctx.fillText(_model.wpnInhibit, 320, 412);

  //HAD Sight Select Status
  drawSightSelectStatus(_ctx, _model);

  //HAD Sight Status
  _ctx.fillText(_model.sightStatus, 116, 471);

  //HAD Range & Range Source
  _ctx.fillText(_model.rngAndRngSrc.toFixed(0), 195, 452);

  //HAD Weapon Control
  _ctx.fillText(_model.wpnControl,   388, 452);

  //HAD Acquisition Select Status
  _ctx.fillText(_model.acqSelStatus, 455, 452);

  //HAD Weapon Status
  _ctx.fillText(_model.wpnStatus,    388, 471);
}

export function drawSightSelectStatus(_ctx: CanvasRenderingContext2D, _model: model) {
    _ctx.textAlign    = "left";
    _ctx.textBaseline = "bottom";
    //0 = hmd, 1 = tads, 2 = fcr
    if (_model.sightSelect == 0) {
        _ctx.fillText("HMD", 116, 452);
    } else if (_model.sightSelect == 1) {
        _ctx.fillText("TADS", 116, 452);
    } else if (_model.sightSelect == 2) {
        _ctx.fillText("FCR", 116, 452);
    }
}