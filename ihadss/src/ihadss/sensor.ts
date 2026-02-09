export type model = {
};


export const exampleModel: model = {
};

export function draw(ctx: CanvasRenderingContext2D, model: model) {
  drawHeadingTape(ctx);
  drawFieldOfRegardPilot(ctx, model);
  drawFieldOfRegardFcrCenterline(ctx);
  drawFieldOfRegardFcrPrevCenterline(ctx);
  drawFieldOfRegardCuedLosDot(ctx);
  drawFieldOfRegardFieldOfViewBox(ctx);
  drawCuedLos(ctx);
  drawCueingDotTop(ctx);
  drawCueingDotRight(ctx);
  drawCueingDotBottom(ctx);
  drawCueingDotLeft(ctx);
  drawCommandBobupHeading(ctx);
  drawAlternateSensorBearing(ctx);
  drawHeadingTapeFcrCenterline(ctx);
}

const pilotFieldOfRegardLeft  = 262;
const pilotFieldOfRegardRight = 433;

export function drawFieldOfRegardPilot(ctx: CanvasRenderingContext2D, _model: model) {
  ctx.strokeRect(pilotFieldOfRegardLeft, pilotFieldOfRegardRight, 116, 43);

  //Left vertical tic mark
  ctx.beginPath();
  ctx.moveTo(262,448);
  ctx.lineTo(269,448);
  ctx.stroke();

  //Right vertical tic mark
  ctx.beginPath();
  ctx.moveTo(371,448);
  ctx.lineTo(378,448);
  ctx.stroke();

  //Top vertical tic mark
  ctx.beginPath();
  ctx.moveTo(320,433);
  ctx.lineTo(320,440);
  ctx.stroke();

  //Bottom vertical tic mark
  ctx.beginPath();
  ctx.moveTo(320,469);
  ctx.lineTo(320,476);
  ctx.stroke();
}

export function drawFieldOfRegardFcrCenterline(ctx: CanvasRenderingContext2D) {
  const posX = 320 - 15;
 
  ctx.beginPath();
  ctx.moveTo(posX, 433);
  ctx.lineTo(posX, 476);
  ctx.stroke();
}

export function drawFieldOfRegardFcrPrevCenterline(ctx: CanvasRenderingContext2D) {
  const posX = 320 + 35;
 
  const top = 433;
  const bot = 476;
  
  const numTicks = 9;
  const spacing  = (bot - top) / numTicks;

  ctx.beginPath();
  for (let i = 0; i < numTicks; i++) {
    if (i % 2 == 0) {
      ctx.moveTo(posX, top + (i * spacing));
      ctx.lineTo(posX, top + ((i + 1) * spacing));
    }
  }
  ctx.stroke();
}

export function drawFieldOfRegardGunner(ctx: CanvasRenderingContext2D, _model: model) {
  ctx.strokeRect(262, 433, 116, 43);

  //Left vertical tic mark
  ctx.beginPath();
  ctx.moveTo(262,448);
  ctx.lineTo(269,448);
  ctx.stroke();

  //Right vertical tic mark
  ctx.beginPath();
  ctx.moveTo(371,448);
  ctx.lineTo(378,448);
  ctx.stroke();

  //Top vertical tic mark
  ctx.beginPath();
  ctx.moveTo(320,433);
  ctx.lineTo(320,440);
  ctx.stroke();

  //Bottom vertical tic mark
  ctx.beginPath();
  ctx.moveTo(320,469);
  ctx.lineTo(320,476);
  ctx.stroke();
}

export function drawFieldOfRegardFieldOfViewBox(ctx: CanvasRenderingContext2D) {
  const fovPosX = 320 - 30;
  const fovPosY = 448 - 5;

  ctx.beginPath();
  ctx.moveTo(fovPosX - 9, fovPosY - 7);
  ctx.lineTo(fovPosX + 9, fovPosY - 7);
  ctx.lineTo(fovPosX + 9, fovPosY + 7);
  ctx.lineTo(fovPosX - 9, fovPosY + 7);
  ctx.lineTo(fovPosX - 9, fovPosY - 8);
  ctx.stroke();
}

export function drawFieldOfRegardCuedLosDot (ctx: CanvasRenderingContext2D) {
  const fovPosX = 320 + 20;
  const fovPosY = 452 + 10;
  
  const radius  = 2;

  ctx.beginPath();
  ctx.arc(fovPosX, fovPosY, radius, 0, 2 * Math.PI);
  ctx.fill();
}

export function drawHeadTracker(ctx: CanvasRenderingContext2D) {
  ctx.save();
  ctx.beginPath();
  for (let i = 0; i < 4; i++) {
    ctx.moveTo(-8, 18);
    ctx.lineTo(0, 26);
    ctx.lineTo(8, 18);
    ctx.rotate(0.5 * Math.PI);
  }
  ctx.stroke();
  ctx.restore();
}

export function drawCueingDotTop(ctx: CanvasRenderingContext2D) {
  const radius = 3;

  ctx.beginPath();
  ctx.arc(320, 203, radius, 0, 2 * Math.PI);
  ctx.fill();
}

export function drawCueingDotRight(ctx: CanvasRenderingContext2D) {
  const radius = 3;

  ctx.beginPath();
  ctx.arc(357, 240, radius, 0, 2 * Math.PI);
  ctx.fill();
}

export function drawCueingDotBottom(ctx: CanvasRenderingContext2D) {
  const radius = 3;

  ctx.beginPath();
  ctx.arc(320, 277, radius, 0, 2 * Math.PI);
  ctx.fill();
}

export function drawCueingDotLeft(ctx: CanvasRenderingContext2D) {
  const radius = 3;

  ctx.beginPath();
  ctx.arc(283, 240, radius, 0, 2 * Math.PI);
  ctx.fill();
}

const headingTapeLeftX   = 199;
const headingTapeRightX  = 441;
const headingTapeDegrees = 200;

function drawCuedLos(ctx: CanvasRenderingContext2D) {
  ctx.save();
  ctx.translate(320 + 80, 240 + 40);
  ctx.beginPath();
  for (let i = 0; i < 4; i++) {
    ctx.moveTo(0, 9 + 18);
    ctx.lineTo(0, 9 + 12);
    ctx.moveTo(0, 9 + 6);
    ctx.lineTo(0, 9);
    ctx.rotate(0.5 * Math.PI);
  }
  ctx.stroke();
  ctx.restore();
}

function drawCommandBobupHeading(ctx: CanvasRenderingContext2D) {
  const hdgDiff   = -60;
  const width     = headingTapeRightX - headingTapeLeftX;
  const increment = width / headingTapeDegrees;

  const posX = 320 + (hdgDiff * increment);
  const posY = 83;

  ctx.beginPath();
  ctx.moveTo(posX - 6, posY + 6);
  ctx.lineTo(posX, posY - 7);
  ctx.lineTo(posX + 6, posY + 6);
  ctx.stroke();
}

function drawAlternateSensorBearing(ctx: CanvasRenderingContext2D) {
  const hdgDiff   = 60;
  const width     = headingTapeRightX - headingTapeLeftX;
  const increment = width / headingTapeDegrees;

  const posX = 320 + (hdgDiff * increment);
  const posY = 83;

  ctx.beginPath();
  ctx.moveTo(posX - 4, posY + 4);
  ctx.lineTo(posX, posY - 5);
  ctx.lineTo(posX + 4, posY + 4);
  ctx.fill();
}

function drawHeadingTapeFcrCenterline(ctx: CanvasRenderingContext2D) {
  const hdgDiff   = 30;
  const width     = headingTapeRightX - headingTapeLeftX;
  const increment = width / headingTapeDegrees;

  const posX = 320 + (hdgDiff * increment);
  const posY = 76;

  ctx.beginPath();
  ctx.moveTo(posX - 1, posY - 3);
  ctx.lineTo(posX - 1, posY + 3);
  ctx.lineTo(posX - 4, posY + 3);
  ctx.lineTo(posX - 5, posY + 2);
  ctx.lineTo(posX - 6, posY);
  ctx.lineTo(posX - 5, posY - 2);
  ctx.lineTo(posX - 4, posY - 3);
  ctx.lineTo(posX - 2, posY - 3);
  ctx.lineTo(posX - 1, posY - 3);

  ctx.moveTo(posX + 1, posY - 3);
  ctx.lineTo(posX + 1, posY + 3);
  ctx.lineTo(posX + 4, posY + 3);
  ctx.lineTo(posX + 5, posY + 2);
  ctx.lineTo(posX + 6, posY);
  ctx.lineTo(posX + 5, posY - 2);
  ctx.lineTo(posX + 4, posY - 3);
  ctx.lineTo(posX + 2, posY - 3);
  ctx.lineTo(posX + 1, posY - 3);
  ctx.fill();
}