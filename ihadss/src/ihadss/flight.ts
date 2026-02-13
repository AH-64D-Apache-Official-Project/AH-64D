import { clamp, interpolate } from "../math";
import type { coord } from "./common";

export type model = {
  pitchBias: number;
  selSymb: string;  //"bobup", "hover", "trans", "cruise"
  vel: coord;
  accel: coord;
  fpv: coord;
  pitch: number;
  roll: number;
  heading: number;
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
  attHoldAct: boolean;
  altHoldAct: boolean;
  loAltWarn: number;
  hiAltWarn: number;
};

export const exampleModel: model = {
  pitchBias: 0,
  selSymb: "cruise",
  vel: [5, 8],
  accel: [5, 7],
  fpv: [-0.1, -0.2],
  pitch: -55.0,
  roll: 0.0,
  heading: 16,
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
  timeToWpt: "2:10:00",
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
  drawCruisePitchLadder(ctx, model);
  drawNavigationFlyToCue(ctx, model);
  drawBobUpBox(ctx, model);
  drawHeadingTape(ctx, model);
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
    const fovX = 40;
    const fovY = 30;

    const scalarX = fovX / 640;
    const scalarY = fovY / 480;

    const posX = 320 + ((_model.fpv[0] * fovX) / scalarX);
    const posY = 240 - ((_model.fpv[1] * fovY) / scalarY);

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

    const scalar    = 5 / 22;
    const maxY      = 35 / scalar;
    const pitchY = clamp(
    (_model.pitch + _model.pitchBias) / scalar
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

function drawCruisePitchLadder(ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "cruise") {
    const scalar    = 5 / 44;
    const pitchY = clamp(
    (_model.pitch + _model.pitchBias) / scalar
    , -(90 / scalar)
    ,  (90 / scalar)
    );

    const posX = 320 - pitchY * Math.sin(-_model.roll * 0.0174533);
    const posY = 240 + pitchY * Math.cos(-_model.roll * 0.0174533);

    const horizonStart      = 142;
    const shortHorizonStart = horizonStart / 3;
    const shortHorizonWidth = 104;

    ctx.save();
    ctx.translate(posX, posY);
    ctx.rotate(-_model.roll * 0.0174533);
    ctx.beginPath();

    //horizon line
    ctx.moveTo(-horizonStart, 0);
    ctx.lineTo( horizonStart, 0);
    //////////////////////////////////////////////////////////////////////////////////////////
    //0 to 30 degrees up  ////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    for (let i = 1; i < 4; i++) {
      drawSolidLadderLine(ctx, _model, i * -10, scalar, shortHorizonStart + (i * 12), shortHorizonWidth + (i * 24));
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    //45 degrees up       ////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    drawSolidLadderLine(ctx, _model, -45, scalar, shortHorizonStart + 54, shortHorizonWidth + 108);
    //////////////////////////////////////////////////////////////////////////////////////////
    //60 degrees up       ////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    drawSolidLadderLine(ctx, _model, -60, scalar, shortHorizonStart + 72, shortHorizonWidth + 144);
    
    ctx.stroke();
    //////////////////////////////////////////////////////////////////////////////////////////
    //90 degrees up       ////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    drawZenithNadir(ctx, _model, -90, scalar, "CLIMB");
    //////////////////////////////////////////////////////////////////////////////////////////
    //0 to 30 degrees down ///////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    for (let i = 1; i < 4; i++) {
      drawDashedLadderLine(ctx, _model, i * 10, scalar, shortHorizonStart + (i * 12), shortHorizonWidth + (i * 24));
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    //45 degrees down     ////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    drawDashedLadderLine(ctx, _model, 45, scalar, shortHorizonStart + 54, shortHorizonWidth + 108);
    //////////////////////////////////////////////////////////////////////////////////////////
    //60 degrees down     ////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    drawDashedLadderLine(ctx, _model, 60, scalar, shortHorizonStart + 72, shortHorizonWidth + 144);
    
    ctx.stroke();
    //////////////////////////////////////////////////////////////////////////////////////////
    //90 degrees down     ////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    drawZenithNadir(ctx, _model, 90, scalar, "DIVE");

    ctx.restore();

    const topWidth = 640;
    const topHeight = 100;
    ctx.clearRect(320 - (topWidth / 2),100 - topHeight, topWidth, topHeight);

    const rightWidth = 305;
    const rightHeight = 310;
    ctx.clearRect(640 - (rightWidth / 2), 255 - (rightHeight / 2), rightWidth, rightHeight);

    const botWidth = 640;
    const botHeight = 70;
    ctx.clearRect(320 - (botWidth / 2),480 - botHeight, botWidth, botHeight);

    const leftWidth = 320;
    const lefttHeight = 310;
    ctx.clearRect(0 - (leftWidth / 2), 255 - (lefttHeight / 2), leftWidth, lefttHeight);
  }
}

function drawSolidLadderLine(ctx: CanvasRenderingContext2D, _model: model, _pitch: number, _scalar: number, _x: number, _w: number) {
  const y = _pitch / _scalar;
  const pitchText = Math.abs(_pitch);
  //left text
  ctx.font      = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.fillText((pitchText).toFixed(0), -_x - 1, y + 7);
  //left vertical line
  ctx.moveTo(-_x + 1, y);
  ctx.lineTo(-_x + 1, y + 7);
  //left horizontal line
  ctx.moveTo(-_x, y);
  ctx.lineTo(-_x + (_w / 2) - 20, y);
  //right horizontal line
  ctx.moveTo( _x, y);
  ctx.lineTo( _x - (_w / 2) + 20, y);
  //right vertical line
  ctx.moveTo( _x - 1, y);
  ctx.lineTo( _x - 1, y + 7);
  //right text
  ctx.font      = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.fillText((pitchText).toFixed(0),  _x + 1, y + 7);
}

function drawDashedLadderLine(ctx: CanvasRenderingContext2D, _model: model, _pitch: number, _scalar: number, _x: number, _w: number)
{
  const y = _pitch / _scalar;
  const w = (_w - 26) / 12;
  const pitchText = Math.abs(_pitch);
  //left text
  ctx.font      = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.fillText((pitchText).toFixed(0), -_x - 1, y + 7);
  //left vertical line
  ctx.moveTo(-_x + 1, y);
  ctx.lineTo(-_x + 1, y - 7);
  for (let i = 0; i < 6; i++) {
    if ((i % 2) == 0) {
      //left horizontal line
      ctx.moveTo(-_x + (w * i),       y);
      ctx.lineTo(-_x + (w * (i + 1)), y);
      }
  }
  for (let i = 0; i < 6; i++) {
    if ((i % 2) == 0) {
      //right horizontal line
      ctx.moveTo(_x - (w * i),       y);
      ctx.lineTo(_x - (w * (i + 1)), y);
    }
  }
  //right vertical line
  ctx.moveTo(_x - 1, y);
  ctx.lineTo(_x - 1, y - 7);
  //right text
  ctx.font      = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.fillText((pitchText).toFixed(0), _x + 1, y + 7);
}

function drawZenithNadir(ctx: CanvasRenderingContext2D, _model: model, _pitch: number,  _scalar: number, _text: string)
{
  const zenithY = _pitch / _scalar;
  //Zenith dot
  ctx.save();
  ctx.beginPath();
  ctx.arc(0, zenithY, 4, 0, 2 * Math.PI);
  ctx.fill();
  ctx.stroke();
  ctx.restore();
  //Left line
  ctx.beginPath();
  ctx.moveTo( 32, zenithY - 24);
  ctx.lineTo( 32, zenithY + 24);  
  //Right line
  ctx.moveTo(-32, zenithY - 24);
  ctx.lineTo(-32, zenithY + 24);  
  //Top Text
  ctx.font      = "15px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.fillText(_text,  0.0, zenithY - 31);
  //Bottom Text
  ctx.save();
  ctx.translate(0.0, zenithY);
  ctx.rotate(180 * 0.0174533);
  ctx.textAlign = "center";
  ctx.fillText(_text,  0.0, -31);
  ctx.restore();
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

export function drawHeadingTape(ctx: CanvasRenderingContext2D, _model: model) {
  const posY      = 66;

  const shortTickHeight = 3;
  const longTickHeight  = 5;
  const textoffsetY     = 7;

  const numTicks  = 36;
  const spacing   = 12;

  const aircraftoffset = Math.round(_model.heading * spacing / 10);
  ctx.beginPath();

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
      ctx.moveTo(tickX, posY - longTickHeight);
      ctx.lineTo(tickX, posY + longTickHeight);
    } else {
      ctx.moveTo(tickX, posY - shortTickHeight);
      ctx.lineTo(tickX, posY + shortTickHeight);
    }

    ctx.textAlign = "center";
    ctx.font = "15px BMKApacheFont";

    if (((tickheading + 360) % 360) == 0) {
      ctx.fillText("N", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 30) {
      ctx.fillText("3", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 60) {
      ctx.fillText("6", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 90) {
      ctx.fillText("E", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 120) {
      ctx.fillText("12", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 150) {
      ctx.fillText("15", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 180) {
      ctx.fillText("S", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 210) {
      ctx.fillText("21", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 240) {
      ctx.fillText("24", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 270) {
      ctx.fillText("W", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 300) {
      ctx.fillText("30", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 330) {
      ctx.fillText("33", tickX, posY - textoffsetY);
    }
  }
  ctx.stroke();

  const headingtext = _model.heading.toFixed(0);
  const textwidth = ctx.measureText(headingtext);
  const textpadding = 10;
  
  ctx.clearRect(320 - ((textwidth.width + textpadding) / 2), 40, textwidth.width + textpadding, 20);
  
  //Center Heading
  ctx.textAlign = "center";
  ctx.font = "18px BMKApacheFont";
  ctx.textBaseline = "bottom";
  ctx.fillText(headingtext, 320, 60);
}