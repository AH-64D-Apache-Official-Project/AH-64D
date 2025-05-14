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

export function drawIhadss(ctx: CanvasRenderingContext2D, model: model): void {
  //Torque
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("52%", 129, 115);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //TGT
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "bottom";
  ctx.fillText("860C", 174, 115 + 17);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //TAS
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "bottom";
  ctx.fillText("102", 154, 232);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //G-meter
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "bottom";
  ctx.fillText("1.2G", 154+6, 232 + 22);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //MSL Altitude
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "center";
  ctx.fillText("5200", 513, 115);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //VSI > 1000 FPM Descent Text
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "center";
  ctx.fillText("-2500", 513, 354);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //Owner Cue
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAAAAAAAA", 320, 395);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //WPN Inhibit
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAAAAAAAAAA", 320, 412);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  const adjustment  = 5;
  const adjustment2 = 3;
  //HAD Sight Select Status
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAAAL", 121 - adjustment, 452);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //HAD Range & Range Source
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAAA", 200 - adjustment, 452);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //HAD Weapon Control
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAAA", 391 - adjustment2, 452);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //HAD Acquisition Select Status
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAA", 458 - adjustment2, 452);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //HAD Sight Status
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAAAAAAAAAA", 121 - adjustment, 471);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //HAD Weapon Status
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("AAAAAAAAAAAA", 391 - adjustment2, 471);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //Radar Altitude
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "bottom";
  ctx.fillText("50", 510, 232);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //HI Altitude Alert
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "center";
  ctx.fillText("HI", 510, 232 - 22);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //LO Altitude Alert
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "center";
  ctx.fillText("LO", 510, 232 + 21);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //Center Heading
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "19px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("360", 320, 61);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("W", 199+12, 57);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("30", 199+48, 57);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("33", 199+84, 57);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("3", 199+157, 57);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("6", 199+194, 57);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("E", 199+230, 57);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //Waypoint Selection
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("W19", 86, 365);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //Waypoint Distance
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "bottom";
  ctx.fillText("14.4KM", 222, 365);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //Ground Speed
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "bottom";
  ctx.fillText("44", 134, 389);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //Waypoint Time to Go
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.textBaseline = "bottom";
  ctx.fillText("5:52", 215, 389);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  base.draw(ctx);
  flight.draw(ctx, model.flight);
  sensor.draw(ctx, model.sensor);
  ctx.restore();
}
