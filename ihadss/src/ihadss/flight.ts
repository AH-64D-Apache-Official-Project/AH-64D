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
  drawVsiScale(ctx, model);
  drawRadAltScale(ctx, model);
  drawVsiIndexer(ctx, model);
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

function drawVsiScale(ctx: CanvasRenderingContext2D, model: model) {
  const posX         = 533;
  const vsiScaleTopY = 104;
  const vsiScaleBotY = 347;

  const width        = 10;
  const numTicks     = 20;
  const spacing      = (vsiScaleBotY - vsiScaleTopY) / numTicks;

  ctx.beginPath();
    //Large ticks
  for (let i = 6; i <= numTicks - 6; i++) {
    ctx.moveTo(posX              , vsiScaleTopY + (i * spacing));
    ctx.lineTo(posX + (width / 2), vsiScaleTopY + (i * spacing));
  }
  //Large ticks
  for (let i = 0; i <= numTicks; i++) {
    if (i % 5 == 0) {
      ctx.moveTo(posX - (width / 2), vsiScaleTopY + (i * spacing));
      ctx.lineTo(posX + (width / 2), vsiScaleTopY + (i * spacing));
    }
  }
  ctx.stroke();
}

function drawRadAltScale(ctx: CanvasRenderingContext2D, model: model) {
  const posX         = 551;
  const vsiScaleTopY = 104;
  const vsiScaleBotY = 347;

  const width        = 10;
  const altBarWidth  = 6;
  const numTicks     = 20;
  const spacing      = (vsiScaleBotY - vsiScaleTopY) / numTicks;

  const maxAlt       = 200; //ft agl
  const altScale     = (vsiScaleBotY - vsiScaleTopY) / maxAlt;
  const curAltAgl    = 50;

  ctx.beginPath();
  ctx.rect(542 - (altBarWidth / 2), vsiScaleBotY, altBarWidth, -altScale * curAltAgl);
  ctx.fill();
  //Large ticks
  for (let i = 16; i <= numTicks - 1; i++) {
    ctx.moveTo(posX - (width / 2), vsiScaleTopY + (i * spacing));
    ctx.lineTo(posX,               vsiScaleTopY + (i * spacing));
  }
  //Large ticks
  for (let i = 0; i <= numTicks; i++) {
    if (i % 5 == 0) {
      ctx.moveTo(posX - (width / 2), vsiScaleTopY + (i * spacing));
      ctx.lineTo(posX + (width / 2), vsiScaleTopY + (i * spacing));
    }
  }
  ctx.stroke();
}

function drawVsiIndexer (ctx: CanvasRenderingContext2D, model: model) {
  const vsiScaleTopY = 104;
  const vsiScaleBotY = 347;

  const posX = 523;
  const posY = (vsiScaleTopY + vsiScaleBotY) / 2;

  const vsiMax       = 2000; //fpp
  const vsiScale     = (vsiScaleBotY - vsiScaleTopY) / vsiMax;
  const curRoC       = -333;

  ctx.beginPath();
  ctx.moveTo(posX - 7, (posY - (vsiScale * curRoC)) - 8);
  ctx.lineTo(posX + 6,  posY - (vsiScale * curRoC));
  ctx.lineTo(posX - 7, (posY - (vsiScale * curRoC))+ 8);
  ctx.lineTo(posX - 7, (posY - (vsiScale * curRoC)) - 9);
  ctx.fill();
}