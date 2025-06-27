import { clamp, interpolate } from "../math";
import type { coord } from "./common";

export type model = {
  vel: coord;
  accel: coord;
  sideslip: number;
};

export const exampleModel: model = {
  vel: [0, 0],
  accel: [0, 0],
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
  drawAttHoldIndicator(ctx, model);
  drawAltHoldIndicator(ctx, model);
  drawFlightPathVector(ctx);
  drawTransitionHorizonLine(ctx);
  drawNavigationFlyToCue(ctx);
  drawBobUpBox(ctx);
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
  ctx.moveTo(318, 73);
  ctx.lineTo(322, 73);
  ctx.lineTo(322, 96);
  ctx.lineTo(318, 96);
  ctx.lineTo(318, 73);
  ctx.fill();
}

function drawAccelerationCue(ctx: CanvasRenderingContext2D, _model: model) {
    // const modelVel   = model.vel;
    // const modelAccel = model.accel;  

    const accelPosX = 320 + 50;
    const accelPosY = 240 - 50;

    const radius    = 7;

    ctx.beginPath();
    ctx.arc(accelPosX, accelPosY, radius, 0, 2 * Math.PI);
    ctx.stroke();
}

function drawVelocityVector(ctx: CanvasRenderingContext2D, _model: model) {

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

function drawVsiScale(ctx: CanvasRenderingContext2D, _model: model) {
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

function drawRadAltScale(ctx: CanvasRenderingContext2D, _model: model) {
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

function drawVsiIndexer (ctx: CanvasRenderingContext2D, _model: model) {
  const vsiScaleTopY = 104;
  const vsiScaleBotY = 347;

  const posX = 523;
  const posY = (vsiScaleTopY + vsiScaleBotY) / 2;

  const vsiMax       = 2000; //fpp
  const vsiScale     = (vsiScaleBotY - vsiScaleTopY) / vsiMax;
  const curRoC       = 333;

  ctx.beginPath();
  ctx.moveTo(posX - 7, posY - (vsiScale * curRoC) - 8);
  ctx.lineTo(posX - 5, posY - (vsiScale * curRoC) - 8);
  ctx.lineTo(posX + 5, posY - (vsiScale * curRoC) - 1);
  ctx.lineTo(posX + 5, posY - (vsiScale * curRoC) + 1);
  ctx.lineTo(posX - 5, posY - (vsiScale * curRoC) + 8);
  ctx.lineTo(posX - 5, posY - (vsiScale * curRoC) + 8);
  ctx.lineTo(posX - 7, posY - (vsiScale * curRoC) + 8);
  ctx.lineTo(posX - 7, posY - (vsiScale * curRoC) - 8);
  ctx.fill();
}

function drawAltHoldIndicator (ctx: CanvasRenderingContext2D, _model: model) {
  const vsiScaleTopY = 104;
  const vsiScaleBotY = 347;
  
  const posX = 523;
  const posY = (vsiScaleTopY + vsiScaleBotY) / 2;

  ctx.beginPath();
  ctx.moveTo(posX - 10, posY - 9);
  ctx.lineTo(posX - 3, posY - 9);
  ctx.lineTo(posX + 6, posY - 2);
  ctx.lineTo(posX + 6, posY + 2);
  ctx.lineTo(posX - 3, posY + 9);
  ctx.lineTo(posX - 10, posY + 9);
  ctx.lineTo(posX - 10, posY - 10);
  ctx.stroke();
}

function drawAttHoldIndicator (ctx: CanvasRenderingContext2D, _model: model) {
  ctx.beginPath();
  ctx.moveTo(119, 214);
  ctx.lineTo(156, 214);
  ctx.lineTo(158, 216);
  ctx.lineTo(158, 234);
  ctx.lineTo(156, 236);
  ctx.lineTo(119, 236);
  ctx.lineTo(117, 234);
  ctx.lineTo(117, 216);
  ctx.lineTo(119, 214);
  ctx.stroke();
}

function drawFlightPathVector(ctx: CanvasRenderingContext2D) {
  const posX = 320 + 130;
  const posY = 240 - 20;

  const radius = 9;

  ctx.beginPath();
  ctx.arc(posX, posY, radius, 0, 2 * Math.PI);
  ctx.stroke();

  ctx.save();
  ctx.translate(posX, posY);
  ctx.beginPath();
  for (let i = 0; i < 3; i++) {
    ctx.moveTo(9, 0);
    ctx.lineTo(9 + 9, 0);
    ctx.rotate(-0.5 * Math.PI);
  }
  ctx.stroke();
  ctx.restore();
}

function drawTransitionHorizonLine(ctx: CanvasRenderingContext2D) {
  const posX = 320;
  const posY = 240 + 40;

  const horizonStart = 142;
  const horizonWidth = 110;
  const horizonIncrement = horizonWidth / 8;

  ctx.save();
  ctx.translate(posX, posY);
  ctx.rotate(0.05 * Math.PI);
  ctx.beginPath();
  for (let i = 0; i < 8; i++) {
    if ((i % 2) == 0) {
      ctx.moveTo(-horizonStart + (horizonIncrement * i), 0);
      ctx.lineTo(-horizonStart + (horizonIncrement * (i + 1)), 0);
    }
    if ((i % 2) == 0) {
      ctx.moveTo(horizonStart - (horizonIncrement * i), 0);
      ctx.lineTo(horizonStart - (horizonIncrement * (i + 1)), 0);
    }
  }
  ctx.stroke();
  ctx.restore();
}

function drawNavigationFlyToCue(ctx: CanvasRenderingContext2D) {
  const posX = 320 + 130;
  const posY = 240 - 20;

  ctx.save();
  ctx.translate(posX, posY);
  ctx.beginPath();
  ctx.moveTo(-27, 5);
  ctx.lineTo(-27,-3);
  ctx.lineTo(-2, -29);
  ctx.lineTo( 2, -29);
  ctx.lineTo( 27,-3);
  ctx.lineTo( 27, 4);
  ctx.lineTo( 17, 13);
  ctx.lineTo(-17, 13);
  ctx.lineTo(-27, 4);
  ctx.stroke();

  ctx.beginPath();
  ctx.moveTo(-3,0);
  ctx.lineTo(0,-3);
  ctx.lineTo(3,0);
  ctx.lineTo(3,2);
  ctx.lineTo(-3,2);
  ctx.lineTo(-3,0);
  ctx.fill();

  ctx.restore();
}

function drawBobUpBox(ctx: CanvasRenderingContext2D) {
  const posX = 320 - 60;
  const posY = 240 + 30;

  ctx.beginPath();
  ctx.moveTo(posX - 10, posY - 20);
  ctx.lineTo(posX + 10, posY - 20);
  ctx.lineTo(posX + 20, posY - 10);
  ctx.lineTo(posX + 20, posY + 10);
  ctx.lineTo(posX + 10, posY + 20);
  ctx.lineTo(posX - 10, posY + 20);
  ctx.lineTo(posX - 20, posY + 10);
  ctx.lineTo(posX - 20, posY - 10);
  ctx.lineTo(posX - 10, posY - 20);
  ctx.stroke();
}