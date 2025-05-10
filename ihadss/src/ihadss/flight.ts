import { clamp, interpolate } from "../math";

export type model = {
  trim: number;
};

export const exampleModel = {
  trim: 0.33,
};

export function draw(ctx: CanvasRenderingContext2D, model: model) {
  drawTrim(ctx, model.trim);
  drawLubberLine(ctx);
}

function drawTrim(ctx: CanvasRenderingContext2D, trim: number) {
  ctx.beginPath();
  //Vertical line left
  ctx.moveTo(311, 415);
  ctx.lineTo(311, 433);

  //Vertical line right
  ctx.moveTo(329, 415);
  ctx.lineTo(329, 433);

  //Horizontal line
  const maxLeft = 257;
  const maxRight = 383;
  ctx.moveTo(maxLeft, 433);
  ctx.lineTo(maxRight, 433);
  ctx.stroke();

  const radius = 9;

  const trimPos = interpolate(
    clamp(trim, -1, 1),
    -1,
    1,
    maxLeft + radius,
    maxRight - radius,
  );

  ctx.beginPath();
  ctx.arc(trimPos, 424, radius, 0, 2 * Math.PI);
  ctx.fill();
}

function drawLubberLine(ctx: CanvasRenderingContext2D) {
  ctx.beginPath();
  ctx.moveTo(320, 74);
  ctx.lineTo(320, 97);
  ctx.stroke();
}
