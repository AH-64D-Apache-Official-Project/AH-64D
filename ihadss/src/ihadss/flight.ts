import { clamp, interpolate } from "../math";
import type { coord } from "./common";

export type model = {
  vel: coord;
  accel: coord;
  sideslip: number;
};

export const exampleModel = {
  sideslip: 0.33,
};

export function draw(ctx: CanvasRenderingContext2D, model: model) {
  drawTrimBall(ctx, model.sideslip);
  drawLubberLine(ctx);
  drawAccelerationCue(ctx, model);
  drawVelocityVector(ctx, model);
}

function drawTrimBall(ctx: CanvasRenderingContext2D, sideslip: number) {
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
    clamp(sideslip, -1, 1),
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
  ctx.moveTo(320, 73);
  ctx.lineTo(320, 96);
  ctx.stroke();
}

function drawAccelerationCue(ctx: CanvasRenderingContext2D, model: model) {
    const modelVel   = model.vel;
    const modelAccel = model.accel;  

    const accelPosX = 320 + 50;
    const accelPosY = 240 - 50;

    const radius    = 7;

    ctx.beginPath();
    ctx.arc(accelPosX, accelPosY, radius, 0, 2 * Math.PI);
    ctx.stroke();
}

function drawVelocityVector(ctx: CanvasRenderingContext2D, model: model) {

  const velVecOriginX = 320;
  const velVecOriginY = 240;

  const velVecTipPosX = 320 + 60;
  const velVecTipPosY = 240 - 60;

  const radius = 2;

  ctx.beginPath();
  ctx.arc(velVecTipPosX, velVecTipPosY, radius, 0, 2 * Math.PI);
  ctx.fill();

  ctx.beginPath();
  ctx.moveTo(velVecOriginX, velVecOriginY);
  ctx.lineTo(velVecTipPosX, velVecTipPosY);
  ctx.stroke();
}