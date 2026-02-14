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
  pitchBias: 5,
  selSymb: "cruise",
  vel: [5, 8],
  accel: [5, 7],
  fpv: [0.03, 0.1],
  pitch: -25.0,
  roll: 15.0,
  heading: 16,
  sideslip: 0.33,
  roc: -1350,
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

export function draw(_ctx: CanvasRenderingContext2D, _model: model) {
  drawTrimBall(_ctx, _model);
  drawLubberLine(_ctx);
  drawAccelerationCue(_ctx, _model);
  drawVelocityVector(_ctx, _model);
  drawVsiScale(_ctx, _model);
  drawRadAltScale(_ctx, _model);
  drawVsiIndexer(_ctx, _model);
  drawAttHoldIndicator(_ctx, _model);
  drawAltHoldIndicator(_ctx, _model);
  drawFlightPathVector(_ctx, _model);
  drawTransitionHorizonLine(_ctx, _model);
  drawCruisePitchLadder(_ctx, _model);
  drawNavigationFlyToCue(_ctx, _model);
  drawBobUpBox(_ctx, _model);
  drawHeadingTape(_ctx, _model);
}

function drawTrimBall(_ctx: CanvasRenderingContext2D, _model: model) {
  _ctx.beginPath();
  //Vertical line left
  _ctx.moveTo(311, 415);
  _ctx.lineTo(311, 433);

  //Vertical line right
  _ctx.moveTo(329, 415);
  _ctx.lineTo(329, 433);

  //Horizontal line
  const maxLeft = 257;
  const maxRight = 383;
  _ctx.moveTo(maxLeft, 433);
  _ctx.lineTo(maxRight, 433);
  _ctx.stroke();

  const radius = 9;

  const trimPos = interpolate(
    clamp(_model.sideslip, -1, 1),
    -1,
    1,
    maxLeft + radius,
    maxRight - radius,
  );

  _ctx.beginPath();
  _ctx.arc(trimPos, 424, radius, 0, 2 * Math.PI);
  _ctx.fill();
}

function drawLubberLine(_ctx: CanvasRenderingContext2D) {
  _ctx.beginPath();
  _ctx.moveTo(318, 73);
  _ctx.lineTo(322, 73);
  _ctx.lineTo(322, 96);
  _ctx.lineTo(318, 96);
  _ctx.lineTo(318, 73);
  _ctx.fill();
}

function drawAccelerationCue(_ctx: CanvasRenderingContext2D, _model: model) {
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

      _ctx.beginPath();
      _ctx.arc(accelPosX, accelPosY, radius, 0, 2 * Math.PI);
      _ctx.stroke();
  }
}

function drawVelocityVector(_ctx: CanvasRenderingContext2D, _model: model) {
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

    _ctx.beginPath();
    _ctx.arc(velVecTipPosX, velVecTipPosY, radius, 0, 2 * Math.PI);
    _ctx.fill();

    _ctx.beginPath();
    _ctx.moveTo(velVecOriginX, velVecOriginY);
    _ctx.lineTo(velVecTipPosX, velVecTipPosY);
    _ctx.stroke();
  }
}

function drawVsiScale(_ctx: CanvasRenderingContext2D, _model: model) {
  const posX         = 533;
  const vsiScaleTopY = 104;
  const vsiScaleBotY = 347;

  const width        = 10;
  const numTicks     = 20;
  const spacing      = (vsiScaleBotY - vsiScaleTopY) / numTicks;

  _ctx.beginPath();
    //Large ticks
  for (let i = 6; i <= numTicks - 6; i++) {
    _ctx.moveTo(posX              , vsiScaleTopY + (i * spacing));
    _ctx.lineTo(posX + (width / 2), vsiScaleTopY + (i * spacing));
  }
  //Large ticks
  for (let i = 0; i <= numTicks; i++) {
    if (i % 5 == 0) {
      _ctx.moveTo(posX - (width / 2), vsiScaleTopY + (i * spacing));
      _ctx.lineTo(posX + (width / 2), vsiScaleTopY + (i * spacing));
    }
  }
  _ctx.stroke();
}

function drawRadAltScale(_ctx: CanvasRenderingContext2D, _model: model) {
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
    _ctx.beginPath();
    _ctx.rect(542 - (altBarWidth / 2), vsiScaleBotY, altBarWidth, -altScale * curAltAgl);
    _ctx.fill();
    //Large ticks
    for (let i = 16; i <= numTicks - 1; i++) {
      _ctx.moveTo(posX - (width / 2), vsiScaleTopY + (i * spacing));
      _ctx.lineTo(posX,               vsiScaleTopY + (i * spacing));
    }
    //Large ticks
    for (let i = 0; i <= numTicks; i++) {
      if (i % 5 == 0) {
        _ctx.moveTo(posX - (width / 2), vsiScaleTopY + (i * spacing));
        _ctx.lineTo(posX + (width / 2), vsiScaleTopY + (i * spacing));
      }
    }
    _ctx.stroke();
  }
}

function drawVsiIndexer (_ctx: CanvasRenderingContext2D, _model: model) {
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

  _ctx.beginPath();
  _ctx.moveTo(posX - 7, posY - (vsiScale * curRoC) - 8);
  _ctx.lineTo(posX - 5, posY - (vsiScale * curRoC) - 8);
  _ctx.lineTo(posX + 5, posY - (vsiScale * curRoC) - 1);
  _ctx.lineTo(posX + 5, posY - (vsiScale * curRoC) + 1);
  _ctx.lineTo(posX - 5, posY - (vsiScale * curRoC) + 8);
  _ctx.lineTo(posX - 5, posY - (vsiScale * curRoC) + 8);
  _ctx.lineTo(posX - 7, posY - (vsiScale * curRoC) + 8);
  _ctx.lineTo(posX - 7, posY - (vsiScale * curRoC) - 8);
  _ctx.fill();
}

function drawAltHoldIndicator (_ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.altHoldAct) {
    const vsiScaleTopY = 104;
    const vsiScaleBotY = 347;
    
    const posX = 523;
    const posY = (vsiScaleTopY + vsiScaleBotY) / 2;

    _ctx.beginPath();
    _ctx.moveTo(posX - 10, posY - 9);
    _ctx.lineTo(posX - 3, posY - 9);
    _ctx.lineTo(posX + 6, posY - 2);
    _ctx.lineTo(posX + 6, posY + 2);
    _ctx.lineTo(posX - 3, posY + 9);
    _ctx.lineTo(posX - 10, posY + 9);
    _ctx.lineTo(posX - 10, posY - 10);
    _ctx.stroke();
  }
}

function drawAttHoldIndicator (_ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.attHoldAct) {
    _ctx.beginPath();
    _ctx.moveTo(119, 214);
    _ctx.lineTo(156, 214);
    _ctx.lineTo(158, 216);
    _ctx.lineTo(158, 234);
    _ctx.lineTo(156, 236);
    _ctx.lineTo(119, 236);
    _ctx.lineTo(117, 234);
    _ctx.lineTo(117, 216);
    _ctx.lineTo(119, 214);
    _ctx.stroke();
  }
}

function drawFlightPathVector(_ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "trans" || _model.selSymb == "cruise") {
    const fovX = 40;
    const fovY = 30;

    const scalarX = fovX / 640;
    const scalarY = fovY / 480;

    const posX = 320 + ((_model.fpv[0] * fovX) / scalarX);
    const posY = 240 - ((_model.fpv[1] * fovY) / scalarY);

    const radius = 9;

    _ctx.beginPath();
    _ctx.arc(posX, posY, radius, 0, 2 * Math.PI);
    _ctx.stroke();

    _ctx.save();
    _ctx.translate(posX, posY);
    _ctx.beginPath();
    for (let i = 0; i < 3; i++) {
      _ctx.moveTo(9, 0);
      _ctx.lineTo(9 + 9, 0);
      _ctx.rotate(-0.5 * Math.PI);
    }
    _ctx.stroke();
    _ctx.restore();
  }
}

function drawTransitionHorizonLine(_ctx: CanvasRenderingContext2D, _model: model) {
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

    _ctx.save();
    _ctx.translate(posX, posY);
    _ctx.rotate(-_model.roll * 0.0174533);
    _ctx.beginPath();
 
    for (let i = 0; i < 8; i++) {
      if ((i % 2) == 0) {
        _ctx.moveTo(-horizonStart + (horizonIncrement * i), 0);
        _ctx.lineTo(-horizonStart + (horizonIncrement * (i + 1)), 0);
      }
      if ((i % 2) == 0) {
        _ctx.moveTo(horizonStart - (horizonIncrement * i), 0);
        _ctx.lineTo(horizonStart - (horizonIncrement * (i + 1)), 0);
      }
    }
    _ctx.stroke();
    _ctx.restore();
  }
}

function drawCruisePitchLadder(_ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "cruise") {
    _ctx.save(); // clip save
      const w = 300;
      const h = 320;
      _ctx.rect(320 - (w / 2), 255 - (h / 2), w, h);
      _ctx.clip();//320 - (botWidth / 2),480 - botHeight, botWidth, botHeight);
      
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

      _ctx.save(); // pitch ladder save
      _ctx.translate(posX, posY);
      _ctx.rotate(-_model.roll * 0.0174533);
      _ctx.beginPath();

      //horizon line
      _ctx.moveTo(-horizonStart, 0);
      _ctx.lineTo( horizonStart, 0);
      //////////////////////////////////////////////////////////////////////////////////////////
      //0 to 30 degrees up  ////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////
      for (let i = 1; i < 4; i++) {
        drawSolidLadderLine(_ctx, _model, i * -10, scalar, shortHorizonStart + (i * 12), shortHorizonWidth + (i * 24));
      }
      //////////////////////////////////////////////////////////////////////////////////////////
      //45 degrees up       ////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////
      drawSolidLadderLine(_ctx, _model, -45, scalar, shortHorizonStart + 54, shortHorizonWidth + 108);
      //////////////////////////////////////////////////////////////////////////////////////////
      //60 degrees up       ////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////
      drawSolidLadderLine(_ctx, _model, -60, scalar, shortHorizonStart + 72, shortHorizonWidth + 144);
      
      _ctx.stroke();
      //////////////////////////////////////////////////////////////////////////////////////////
      //90 degrees up       ////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////
      drawZenithNadir(_ctx, _model, -90, scalar, "CLIMB");
      //////////////////////////////////////////////////////////////////////////////////////////
      //0 to 30 degrees down ///////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////
      for (let i = 1; i < 4; i++) {
        drawDashedLadderLine(_ctx, _model, i * 10, scalar, shortHorizonStart + (i * 12), shortHorizonWidth + (i * 24));
      }
      //////////////////////////////////////////////////////////////////////////////////////////
      //45 degrees down     ////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////
      drawDashedLadderLine(_ctx, _model, 45, scalar, shortHorizonStart + 54, shortHorizonWidth + 108);
      //////////////////////////////////////////////////////////////////////////////////////////
      //60 degrees down     ////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////
      drawDashedLadderLine(_ctx, _model, 60, scalar, shortHorizonStart + 72, shortHorizonWidth + 144);
      
      _ctx.stroke();
      //////////////////////////////////////////////////////////////////////////////////////////
      //90 degrees down     ////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////
      drawZenithNadir(_ctx, _model, 90, scalar, "DIVE");

      _ctx.restore(); // pitch ladder restore
    _ctx.restore(); // clip restore
  }
}

function drawSolidLadderLine(_ctx: CanvasRenderingContext2D, _model: model, _pitch: number, _scalar: number, _x: number, _w: number) {
  const y = _pitch / _scalar;
  const pitchText = Math.abs(_pitch);
  //left text
  _ctx.font      = "15px BMKApacheFont";
  _ctx.textAlign = "right";
  _ctx.fillText((pitchText).toFixed(0), -_x - 1, y + 7);
  //left vertical line
  _ctx.moveTo(-_x + 1, y);
  _ctx.lineTo(-_x + 1, y + 7);
  //left horizontal line
  _ctx.moveTo(-_x, y);
  _ctx.lineTo(-_x + (_w / 2) - 20, y);
  //right horizontal line
  _ctx.moveTo( _x, y);
  _ctx.lineTo( _x - (_w / 2) + 20, y);
  //right vertical line
  _ctx.moveTo( _x - 1, y);
  _ctx.lineTo( _x - 1, y + 7);
  //right text
  _ctx.font      = "15px BMKApacheFont";
  _ctx.textAlign = "left";
  _ctx.fillText((pitchText).toFixed(0),  _x + 1, y + 7);
}

function drawDashedLadderLine(_ctx: CanvasRenderingContext2D, _model: model, _pitch: number, _scalar: number, _x: number, _w: number)
{
  const y = _pitch / _scalar;
  const w = (_w - 26) / 12;
  const pitchText = Math.abs(_pitch);
  //left text
  _ctx.font      = "15px BMKApacheFont";
  _ctx.textAlign = "right";
  _ctx.fillText((pitchText).toFixed(0), -_x - 1, y + 7);
  //left vertical line
  _ctx.moveTo(-_x + 1, y);
  _ctx.lineTo(-_x + 1, y - 7);
  for (let i = 0; i < 6; i++) {
    if ((i % 2) == 0) {
      //left horizontal line
      _ctx.moveTo(-_x + (w * i),       y);
      _ctx.lineTo(-_x + (w * (i + 1)), y);
      }
  }
  for (let i = 0; i < 6; i++) {
    if ((i % 2) == 0) {
      //right horizontal line
      _ctx.moveTo(_x - (w * i),       y);
      _ctx.lineTo(_x - (w * (i + 1)), y);
    }
  }
  //right vertical line
  _ctx.moveTo(_x - 1, y);
  _ctx.lineTo(_x - 1, y - 7);
  //right text
  _ctx.font      = "15px BMKApacheFont";
  _ctx.textAlign = "left";
  _ctx.fillText((pitchText).toFixed(0), _x + 1, y + 7);
}

function drawZenithNadir(_ctx: CanvasRenderingContext2D, _model: model, _pitch: number,  _scalar: number, _text: string)
{
  const zenithY = _pitch / _scalar;
  //Zenith dot
  _ctx.save();
  _ctx.beginPath();
  _ctx.arc(0, zenithY, 4, 0, 2 * Math.PI);
  _ctx.fill();
  _ctx.stroke();
  _ctx.restore();
  //Left line
  _ctx.beginPath();
  _ctx.moveTo( 32, zenithY - 24);
  _ctx.lineTo( 32, zenithY + 24);  
  //Right line
  _ctx.moveTo(-32, zenithY - 24);
  _ctx.lineTo(-32, zenithY + 24);  
  //Top Text
  _ctx.font      = "15px BMKApacheFont";
  _ctx.textAlign = "center";
  _ctx.fillText(_text,  0.0, zenithY - 31);
  //Bottom Text
  _ctx.save();
  _ctx.translate(0.0, zenithY);
  _ctx.rotate(180 * 0.0174533);
  _ctx.textAlign = "center";
  _ctx.fillText(_text,  0.0, -31);
  _ctx.restore();
}

function drawNavigationFlyToCue(_ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "trans" || _model.selSymb == "cruise") {
    const posX = 320 + 130;
    const posY = 240 - 20;

    _ctx.save();
    _ctx.translate(posX, posY);
    _ctx.beginPath();
    _ctx.moveTo(-27, 5);
    _ctx.lineTo(-27,-3);
    _ctx.lineTo(-2, -29);
    _ctx.lineTo( 2, -29);
    _ctx.lineTo( 27,-3);
    _ctx.lineTo( 27, 4);
    _ctx.lineTo( 17, 13);
    _ctx.lineTo(-17, 13);
    _ctx.lineTo(-27, 4);
    _ctx.stroke();

    _ctx.beginPath();
    _ctx.moveTo(-3,0);
    _ctx.lineTo(0,-3);
    _ctx.lineTo(3,0);
    _ctx.lineTo(3,2);
    _ctx.lineTo(-3,2);
    _ctx.lineTo(-3,0);
    _ctx.fill();

    _ctx.restore();
  }
}

function drawBobUpBox(_ctx: CanvasRenderingContext2D, _model: model) {
  if (_model.selSymb == "bobup") {
    const posX = 320 - 60;
    const posY = 240 + 30;

    _ctx.beginPath();
    _ctx.moveTo(posX - 10, posY - 20);
    _ctx.lineTo(posX + 10, posY - 20);
    _ctx.lineTo(posX + 20, posY - 10);
    _ctx.lineTo(posX + 20, posY + 10);
    _ctx.lineTo(posX + 10, posY + 20);
    _ctx.lineTo(posX - 10, posY + 20);
    _ctx.lineTo(posX - 20, posY + 10);
    _ctx.lineTo(posX - 20, posY - 10);
    _ctx.lineTo(posX - 10, posY - 20);
    _ctx.stroke();
  }
}

export function drawHeadingTape(_ctx: CanvasRenderingContext2D, _model: model) {
  const posY      = 66;

  const shortTickHeight = 3;
  const longTickHeight  = 5;
  const textoffsetY     = 7;

  const numTicks  = 36;
  const spacing   = 12;

  const aircraftoffset = Math.round(_model.heading * spacing / 10);
  _ctx.beginPath();

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
      _ctx.moveTo(tickX, posY - longTickHeight);
      _ctx.lineTo(tickX, posY + longTickHeight);
    } else {
      _ctx.moveTo(tickX, posY - shortTickHeight);
      _ctx.lineTo(tickX, posY + shortTickHeight);
    }

    _ctx.textAlign = "center";
    _ctx.font = "15px BMKApacheFont";

    if (((tickheading + 360) % 360) == 0) {
      _ctx.fillText("N", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 30) {
      _ctx.fillText("3", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 60) {
      _ctx.fillText("6", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 90) {
      _ctx.fillText("E", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 120) {
      _ctx.fillText("12", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 150) {
      _ctx.fillText("15", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 180) {
      _ctx.fillText("S", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 210) {
      _ctx.fillText("21", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 240) {
      _ctx.fillText("24", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 270) {
      _ctx.fillText("W", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 300) {
      _ctx.fillText("30", tickX, posY - textoffsetY);
    }
    if (((tickheading + 360) % 360) == 330) {
      _ctx.fillText("33", tickX, posY - textoffsetY);
    }
  }
  _ctx.stroke();

  const headingtext = _model.heading.toFixed(0);
  const textwidth = _ctx.measureText(headingtext);
  const textpadding = 10;
  
  _ctx.clearRect(320 - ((textwidth.width + textpadding) / 2), 40, textwidth.width + textpadding, 20);
  
  //Center Heading
  _ctx.textAlign = "center";
  _ctx.font = "18px BMKApacheFont";
  _ctx.textBaseline = "bottom";
  _ctx.fillText(headingtext, 320, 60);
}