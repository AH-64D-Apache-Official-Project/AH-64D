import { clipMainDisplay, type coord } from "./common";

export type model = {
  headTracker: coord;
};

export const exampleModel: model = {
  headTracker: [0.5, 0.5],
};

export function draw(ctx: CanvasRenderingContext2D, model: model) {
  drawFieldOfRegard(ctx, model);
  drawHeadTracker(ctx, model);
}

export function drawFieldOfRegard(
  ctx: CanvasRenderingContext2D,
  _model: model,
) {
  ctx.strokeRect(262, 433, 116, 43);
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
