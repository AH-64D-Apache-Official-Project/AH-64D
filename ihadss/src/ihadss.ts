import * as base from "./ihadss/base";
import * as flight from "./ihadss/flight";
import * as sensor from "./ihadss/sensor";

export type model = {
  flight: flight.model;
  sensor: sensor.model;
};

export const exampleModel: model = {
  flight: flight.exampleModel,
  sensor: sensor.exampleModel,
};

function ihadssStyle(ctx: CanvasRenderingContext2D) {
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;
}

export function drawIhadss(ctx: CanvasRenderingContext2D, model: model): void {
  ihadssStyle(ctx)
  //Torque
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText(model.flight.engTq.toFixed(0) + "%", 129, 115);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //TGT
  //This should only display in the last 2 or 2.5 minutes of a particular tgt limit
  //If dual engine, then it's the last 2 minutes of the 10 minute limit, if single
  //engine, then it's the full duration of the 2.5 minute limit 
  /*
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.fillText(model.flight.engTgt.toFixed(0) + "C", 174, 115 + 17);
  */
  
  //TAS
  ctx.font      = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.fillText(model.flight.tas.toFixed(0), 154, 232);

  //G-meter
  //There's currently nothing to feed this value
  /*
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.fillText("1.2G", 154+6, 232 + 22);
  */

  //MSL Altitude
  if (model.flight.selSymb == "cruise") {
    ctx.font         = "15px BMKApacheFont";
    ctx.textAlign    = "right";
    ctx.textBaseline = "middle";
    ctx.fillText(model.flight.baroAlt.toFixed(0), 513, 108);
  }

  //VSI > 1000 FPM Descent Text
  if (model.flight.roc < -1000) {
    ctx.fillText(model.flight.roc.toFixed(0), 513, 354);
  }

  //Owner Cue
  ctx.textAlign    = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAAAAAAAA", 320, 395);

  //WPN Inhibit
  ctx.fillText("AAAAAAAAAAAA", 320, 412);

  const adjustment  = 5;
  const adjustment2 = 3;
  //HAD Sight Select Status
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAAAL", 121 - adjustment, 452);

  //HAD Range & Range Source
  ctx.fillText("AAAAA", 200 - adjustment, 452);

  //HAD Weapon Control
  ctx.fillText("AAAAA", 391 - adjustment2, 452);

  //HAD Acquisition Select Status
  ctx.fillText("AAAA", 458 - adjustment2, 452);

  //HAD Sight Status
  ctx.fillText("AAAAAAAAAAAA", 121 - adjustment, 471);

  //HAD Weapon Status
  ctx.fillText("AAAAAAAAAAAA", 391 - adjustment2, 471);

  //Radar Altitude
  ctx.textAlign = "right";
  ctx.textBaseline = "bottom";
  ctx.fillText(model.flight.radAlt.toFixed(0), 510, 232);

  //HI Altitude Alert
  //This needs to be set by the FLT SET page, which is not currently implemented
  if (model.flight.radAlt > model.flight.hiAltWarn) {
    ctx.textAlign = "right";
    ctx.textBaseline = "middle";
    ctx.fillText("HI", 510, 232 - 24);
  }

  //LO Altitude Alert
  //This needs to be set by the FLT SET page, which is not currently implemented
  if (model.flight.radAlt < model.flight.loAltWarn) {
    ctx.textAlign = "right";
    ctx.textBaseline = "middle";
    ctx.save();
    ctx.fillText("LO", 510, 232 + 21);
  }

  //Center Heading
  ctx.textAlign = "center";
  ctx.font = "18px BMKApacheFont";
  ctx.textBaseline = "bottom";
  ctx.fillText(model.flight.acftHdg.toFixed(0), 320, 60);

  ctx.font = "15px BMKApacheFont";
  ctx.fillText("W", 199+12, 57);
  ctx.fillText("30", 199+48, 57);
  ctx.fillText("33", 199+84, 57);
  ctx.fillText("3", 199+157, 57);
  ctx.fillText("6", 199+194, 57);
  ctx.fillText("E", 199+230, 57);

  //Waypoint Selection
  ctx.font         = "15px BMKApacheFont";
  ctx.textAlign    = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText(model.flight.curWpt, 86, 365);

  //Waypoint Distance
  ctx.font         = "15px BMKApacheFont";
  ctx.textAlign    = "right";
  ctx.textBaseline = "bottom";
  //The "KM" needs to dissapear when a waypoint is currently selected or present
  if (model.flight.dstToWpt != "") {
    ctx.fillText(model.flight.dstToWpt + "KM", 222, 365);
  }
  //Ground Speed
  ctx.fillText(model.flight.gndSpd.toFixed(0), 134, 389);

  //Waypoint Time to Go
  ctx.fillText(model.flight.timeToWpt, 215, 389);

  base.draw(ctx);
  flight.draw(ctx, model.flight);
  sensor.draw(ctx, model.sensor);
}

export type icontype = "headtracker"

export function drawIhadssIcon(ctx: CanvasRenderingContext2D, icon: icontype): void {
  ihadssStyle(ctx)
  ctx.save();
  ctx.translate(32, 32);
  switch (icon) {
    case "headtracker": {
      sensor.drawHeadTracker(ctx);
    }
  }
  ctx.restore();
}