import { clipMainDisplay, type coord } from "./common";

export type model = {
  headTracker: coord;
};

export const exampleModel: model = {
  headTracker: [0.5, 0.5],
};

export function draw(ctx: CanvasRenderingContext2D, model: model) {
  drawFieldOfRegardPilot(ctx, model);
  drawHeadTracker(ctx, model);
  drawFieldOfView(ctx);
  drawCueingDotTop(ctx);
  drawCueingDotRight(ctx);
  drawCueingDotBottom(ctx);
  drawCueingDotLeft(ctx);
  drawHeadingTape(ctx);
}

export function drawFieldOfRegardPilot(ctx: CanvasRenderingContext2D, _model: model) {
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

export function drawFieldOfView(ctx: CanvasRenderingContext2D) {
  const fovPosX = 300;
  const fovPosY = 452;

  ctx.beginPath();
  ctx.moveTo(fovPosX - 9, fovPosY - 7);
  ctx.lineTo(fovPosX + 9, fovPosY - 7);
  ctx.lineTo(fovPosX + 9, fovPosY + 7);
  ctx.lineTo(fovPosX - 9, fovPosY + 7);
  ctx.lineTo(fovPosX - 9, fovPosY - 8);
  ctx.stroke();
}

export function drawHeadTracker(ctx: CanvasRenderingContext2D, model: model) {
  ctx.save();
  const trackerX = model.headTracker[0] * ctx.canvas.width;
  const trackerY = model.headTracker[1] * ctx.canvas.height;
  clipMainDisplay(ctx);
  ctx.translate(trackerX, trackerY);

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

export function drawHeadingTape(ctx: CanvasRenderingContext2D) {
  const left180x  = 199;
  const right180x = 441;
  const posY      = 64;

  const shortTickHeight = 3;
  const longTickHeight  = 5;

  const width     = right180x - left180x;
  const numTicks  = 20;
  const spacing   = width / numTicks;

  ctx.beginPath();
  //Small ticks
  for (let i = 0; i <= numTicks; i++) {
    if (i % 1 == 0) {
      ctx.moveTo(199 + (i * spacing), posY - shortTickHeight);
      ctx.lineTo(199 + (i * spacing), posY + shortTickHeight);
    }
  }
  //Large ticks
  for (let i = 0; i <= numTicks; i++) {
    if (i % 3 == 1) {
      ctx.moveTo(199 + (i * spacing), posY - longTickHeight);
      ctx.lineTo(199 + (i * spacing), posY + longTickHeight);
    }
  }
  ctx.stroke();
}