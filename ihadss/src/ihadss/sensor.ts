export type model = {
};


export const exampleModel: model = {
};

export function draw(_ctx: CanvasRenderingContext2D, _model: model) {
  drawFieldOfRegardPilot(_ctx, _model);
  drawFieldOfRegardFcrCenterline(_ctx);
  drawFieldOfRegardFcrPrevCenterline(_ctx);
  drawFieldOfRegardCuedLosDot(_ctx);
  drawFieldOfRegardFieldOfViewBox(_ctx);
  drawCuedLos(_ctx);
  drawCueingDotTop(_ctx);
  drawCueingDotRight(_ctx);
  drawCueingDotBottom(_ctx);
  drawCueingDotLeft(_ctx);
  drawCommandBobupHeading(_ctx);
  drawAlternateSensorBearing(_ctx);
  drawHeadingTapeFcrCenterline(_ctx);
}

const pilotFieldOfRegardLeft  = 262;
const pilotFieldOfRegardRight = 433;

export function drawFieldOfRegardPilot(_ctx: CanvasRenderingContext2D, _model: model) {
  _ctx.strokeRect(pilotFieldOfRegardLeft, pilotFieldOfRegardRight, 116, 43);

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

export function drawFieldOfRegardFcrCenterline(_ctx: CanvasRenderingContext2D) {
  const posX = 320 - 15;
 
  _ctx.beginPath();
  _ctx.moveTo(posX, 433);
  _ctx.lineTo(posX, 476);
  _ctx.stroke();
}

export function drawFieldOfRegardFcrPrevCenterline(_ctx: CanvasRenderingContext2D) {
  const posX = 320 + 35;
 
  const top = 433;
  const bot = 476;
  
  const numTicks = 9;
  const spacing  = (bot - top) / numTicks;

  _ctx.beginPath();
  for (let i = 0; i < numTicks; i++) {
    if (i % 2 == 0) {
      _ctx.moveTo(posX, top + (i * spacing));
      _ctx.lineTo(posX, top + ((i + 1) * spacing));
    }
  }
  _ctx.stroke();
}

export function drawFieldOfRegardGunner(_ctx: CanvasRenderingContext2D, _model: model) {
  _ctx.strokeRect(262, 433, 116, 43);

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

export function drawFieldOfRegardFieldOfViewBox(_ctx: CanvasRenderingContext2D) {
  const fovPosX = 320 - 30;
  const fovPosY = 448 - 5;

  _ctx.beginPath();
  _ctx.moveTo(fovPosX - 9, fovPosY - 7);
  _ctx.lineTo(fovPosX + 9, fovPosY - 7);
  _ctx.lineTo(fovPosX + 9, fovPosY + 7);
  _ctx.lineTo(fovPosX - 9, fovPosY + 7);
  _ctx.lineTo(fovPosX - 9, fovPosY - 8);
  _ctx.stroke();
}

export function drawFieldOfRegardCuedLosDot (_ctx: CanvasRenderingContext2D) {
  const fovPosX = 320 + 20;
  const fovPosY = 452 + 10;
  
  const radius  = 2;

  _ctx.beginPath();
  _ctx.arc(fovPosX, fovPosY, radius, 0, 2 * Math.PI);
  _ctx.fill();
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

export function drawCueingDotTop(_ctx: CanvasRenderingContext2D) {
  const radius = 3;

  _ctx.beginPath();
  _ctx.arc(320, 203, radius, 0, 2 * Math.PI);
  _ctx.fill();
}

export function drawCueingDotRight(_ctx: CanvasRenderingContext2D) {
  const radius = 3;

  _ctx.beginPath();
  _ctx.arc(357, 240, radius, 0, 2 * Math.PI);
  _ctx.fill();
}

export function drawCueingDotBottom(_ctx: CanvasRenderingContext2D) {
  const radius = 3;

  _ctx.beginPath();
  _ctx.arc(320, 277, radius, 0, 2 * Math.PI);
  _ctx.fill();
}

export function drawCueingDotLeft(_ctx: CanvasRenderingContext2D) {
  const radius = 3;

  _ctx.beginPath();
  _ctx.arc(283, 240, radius, 0, 2 * Math.PI);
  _ctx.fill();
}

const headingTapeLeftX   = 199;
const headingTapeRightX  = 441;
const headingTapeDegrees = 200;

function drawCuedLos(_ctx: CanvasRenderingContext2D) {
  _ctx.save();
  _ctx.translate(320 + 80, 240 + 40);
  _ctx.beginPath();
  for (let i = 0; i < 4; i++) {
    _ctx.moveTo(0, 9 + 18);
    _ctx.lineTo(0, 9 + 12);
    _ctx.moveTo(0, 9 + 6);
    _ctx.lineTo(0, 9);
    _ctx.rotate(0.5 * Math.PI);
  }
  _ctx.stroke();
  _ctx.restore();
}

function drawCommandBobupHeading(_ctx: CanvasRenderingContext2D) {
  const hdgDiff   = -60;
  const width     = headingTapeRightX - headingTapeLeftX;
  const increment = width / headingTapeDegrees;

  const posX = 320 + (hdgDiff * increment);
  const posY = 83;

  _ctx.beginPath();
  _ctx.moveTo(posX - 6, posY + 6);
  _ctx.lineTo(posX, posY - 7);
  _ctx.lineTo(posX + 6, posY + 6);
  _ctx.stroke();
}

function drawAlternateSensorBearing(_ctx: CanvasRenderingContext2D) {
  const hdgDiff   = 60;
  const width     = headingTapeRightX - headingTapeLeftX;
  const increment = width / headingTapeDegrees;

  const posX = 320 + (hdgDiff * increment);
  const posY = 83;

  _ctx.beginPath();
  _ctx.moveTo(posX - 4, posY + 4);
  _ctx.lineTo(posX, posY - 5);
  _ctx.lineTo(posX + 4, posY + 4);
  _ctx.fill();
}

function drawHeadingTapeFcrCenterline(_ctx: CanvasRenderingContext2D) {
  const hdgDiff   = 30;
  const width     = headingTapeRightX - headingTapeLeftX;
  const increment = width / headingTapeDegrees;

  const posX = 320 + (hdgDiff * increment);
  const posY = 76;

  _ctx.beginPath();
  _ctx.moveTo(posX - 1, posY - 3);
  _ctx.lineTo(posX - 1, posY + 3);
  _ctx.lineTo(posX - 4, posY + 3);
  _ctx.lineTo(posX - 5, posY + 2);
  _ctx.lineTo(posX - 6, posY);
  _ctx.lineTo(posX - 5, posY - 2);
  _ctx.lineTo(posX - 4, posY - 3);
  _ctx.lineTo(posX - 2, posY - 3);
  _ctx.lineTo(posX - 1, posY - 3);

  _ctx.moveTo(posX + 1, posY - 3);
  _ctx.lineTo(posX + 1, posY + 3);
  _ctx.lineTo(posX + 4, posY + 3);
  _ctx.lineTo(posX + 5, posY + 2);
  _ctx.lineTo(posX + 6, posY);
  _ctx.lineTo(posX + 5, posY - 2);
  _ctx.lineTo(posX + 4, posY - 3);
  _ctx.lineTo(posX + 2, posY - 3);
  _ctx.lineTo(posX + 1, posY - 3);
  _ctx.fill();
}