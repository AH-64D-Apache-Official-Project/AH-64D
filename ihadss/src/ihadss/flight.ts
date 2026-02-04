import { clamp, interpolate } from "../math";
import type { coord } from "./common";

export type model = {
  selSymb: string;  //"bobup", "hover", "trans", "cruise"
  vel: coord;
  accel: coord;
  pitch: number;
  roll: number;
  sideslip: number;
  roc: number;
  tas: number;
  gndSpd: number;
  radAlt: number;
  baroAlt: number;
  engTq: number;
  engTgt: number;
  curWpt: string;
  dstToWpt: string;
  timeToWpt: string;
  acftHdg: number;
  attHoldAct: boolean;
  altHoldAct: boolean;
  loAltWarn: number;
  hiAltWarn: number;
};

export const exampleModel: model = {
  selSymb: "hover",
  vel: [5, 8],
  accel: [5, 7],
  pitch: 45.0,
  roll: 45.0,
  sideslip: 0.33,
  roc: 500,
  tas: 90,
  gndSpd: 70,
  radAlt: 75,
  baroAlt: 250,
  engTq: 72,
  engTgt: 860,
  curWpt: "W19",
  dstToWpt: "6.5",
  timeToWpt: "2:00:00",
  acftHdg: 229,
  altHoldAct: true,
  attHoldAct: true,
  loAltWarn: 33,
  hiAltWarn: 200,
};

export function draw(ctx: CanvasRenderingContext2D, model: model) {
  drawTrimBall(ctx, model);
  drawLubberLine(ctx);
  drawAccelerationCue(ctx, model);
  drawVelocityVector(ctx, model);
  drawVsiScale(ctx, model);
  drawRadAltScale(ctx, model);
  drawVsiIndexer(ctx, model);
  drawAttHoldIndicator(ctx, model);
  drawAltHoldIndicator(ctx, model);
  drawFlightPathVector(ctx, model);
  drawTransitionHorizonLine(ctx, model);
  drawNavigationFlyToCue(ctx, model);
  drawBobUpBox(ctx, model);
}

function drawTrimBall(ctx: CanvasRenderingContext2D, _model: model) {
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
    clamp(_model.sideslip, -1, 1),
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
    if (_model.selSymb == "bobup" || _model.selSymb == "hover" || _model.selSymb == "trans") {
      const max = 167;

      let scalar =  0;
      if (_model.selSymb == "bobup" || _model.selSymb == "hover") {
        scalar = 6 / max;
      } else if (_model.selSymb == "trans")
      {
        scalar = 60 / max;
      }
      
      const velX = clamp(
      (_model.vel[0] * 1.94384) / scalar
      , -max
      , max
      );
      const velY = clamp(
      (_model.vel[1] * 1.94384) / scalar
      , -max
      , max
      );
    
      const accelX = _model.accel[0] * 10;
      const accelY = _model.accel[1] * 10;

      let accelPosX = 320;
      let accelPosY = 240;
      if (_model.gndSpd <= 6) { 
      accelPosX = 320 + velX + accelX;
      accelPosY = 240 - velY - accelY;
      }
      else {
        accelPosX = 320 + accelX;
        accelPosY = 240 - accelY;
      }

      const radius    = 7;

      ctx.beginPath();
      ctx.arc(accelPosX, accelPosY, radius, 0, 2 * Math.PI);
      ctx.stroke();
  }
}

//The scalar needs to change based on hover/transition symbology
function drawVelocityVector(ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "bobup" || _model.selSymb == "hover" || _model.selSymb == "trans") {
    const velVecOriginX = 320;
    const velVecOriginY = 240;

    const max = 167;

    let scalar =  0;
    if (_model.selSymb == "bobup" || _model.selSymb == "hover") {
      scalar = 6 / max;
    } else if (_model.selSymb == "trans")
    {
      scalar = 60 / max;
    }

    const velX = clamp(
    (_model.vel[0] * 1.94384) / scalar
    , -max
    , max
    );
    const velY = clamp(
    (_model.vel[1] * 1.94384) / scalar
    , -max
    , max
    );

    const velVecTipPosX = 320 + velX;
    const velVecTipPosY = 240 - velY;

    const radius = 2;

    ctx.beginPath();
    ctx.arc(velVecTipPosX, velVecTipPosY, radius, 0, 2 * Math.PI);
    ctx.fill();

    ctx.beginPath();
    ctx.moveTo(velVecOriginX, velVecOriginY);
    ctx.lineTo(velVecTipPosX, velVecTipPosY);
    ctx.stroke();
  }
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
  const curAltAgl    = clamp(
   _model.radAlt
  , 0
  , maxAlt
  );

  if (curAltAgl < 200) {
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
}

function drawVsiIndexer (ctx: CanvasRenderingContext2D, _model: model) {
  const vsiScaleTopY = 104;
  const vsiScaleBotY = 347;

  const posX = 523;
  const posY = (vsiScaleTopY + vsiScaleBotY) / 2;

  const vsiMax   = 2000; //fpm
  const vsiScale = (vsiScaleBotY - vsiScaleTopY) / vsiMax;
  const curRoC   = clamp(
    _model.roc
  , -vsiMax / 2
  ,  vsiMax / 2
  );

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
  if (_model.altHoldAct) {
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
}

function drawAttHoldIndicator (ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.attHoldAct) {
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
}

function drawFlightPathVector(ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "trans" || _model.selSymb == "cruise") {
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
}

function drawTransitionHorizonLine(ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "trans") {
    const posX = 320;

    const pitchBias = 5;
    const scalar    = 5 / 22;
    const maxY      = 35 / scalar;
    const pitchY = clamp(
    (_model.pitch + pitchBias) / scalar
    , -maxY
    , maxY
    );

    const posY = 240 + pitchY;

    const horizonStart = 142;
    const horizonWidth = 110;
    const horizonIncrement = horizonWidth / 8;

    ctx.save();
    ctx.translate(posX, posY);
    ctx.rotate(-_model.roll * 0.0174533);
    ctx.beginPath();
    //ctx.moveTo(-horizonStart, 0);
    //ctx.lineTo(horizonWidth, 0);  
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
}

function drawNavigationFlyToCue(ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "trans" || _model.selSymb == "cruise") {
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
}

function drawBobUpBox(ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "bobup") {
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
}