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
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("52%", 129, 115);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  //TGT
  ctx.font = "15px BMKApacheFont";
  ctx.textAlign = "right";
  ctx.fillText("860C", 174, 115 + 17);

  //TAS
  ctx.fillText("102", 154, 232);

  //G-meter
  ctx.fillText("1.2G", 154+6, 232 + 22);

  //MSL Altitude
  ctx.textAlign = "right";
  ctx.textBaseline = "middle";
  ctx.fillText("5200", 513, 115);

  //VSI > 1000 FPM Descent Text
  ctx.fillText("-2500", 513, 354);

  //Owner Cue
  ctx.textAlign = "center";
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
  ctx.fillText("50", 510, 232);

  //HI Altitude Alert
  ctx.textAlign = "right";
  ctx.textBaseline = "middle";
  ctx.fillText("HI", 510, 232 - 22);

  //LO Altitude Alert
  ctx.save();
  ctx.fillText("LO", 510, 232 + 21);

  //Center Heading
  ctx.textAlign = "center";
  ctx.textBaseline = "bottom";
  ctx.fillText("360", 320, 61);

  ctx.fillText("W", 199+12, 57);

  ctx.fillText("30", 199+48, 57);

  ctx.fillText("33", 199+84, 57);

  ctx.fillText("3", 199+157, 57);

  ctx.fillText("6", 199+194, 57);

  ctx.fillText("E", 199+230, 57);

  //Waypoint Selection
  ctx.textAlign = "left";
  ctx.textBaseline = "bottom";
  ctx.fillText("W19", 86, 365);

  //Waypoint Distance
  ctx.textAlign = "right";
  ctx.textBaseline = "bottom";
  ctx.fillText("14.4KM", 222, 365);

  //Ground Speed
  ctx.fillText("44", 134, 389);

  //Waypoint Time to Go
  ctx.fillText("5:52", 215, 389);

  base.draw(ctx);
  flight.draw(ctx, model.flight);
  sensor.draw(ctx, model.sensor);
}
