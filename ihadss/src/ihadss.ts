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
  ctx.save();
  ctx.strokeStyle = "#0F0";
  ctx.fillStyle = "#0F0";
  ctx.font = "14px BMKApacheFont";
  ctx.fillText("100%", 100, 100);
  ctx.globalAlpha = 1;
  ctx.lineWidth = 2;

  base.draw(ctx);
  flight.draw(ctx, model.flight);
  sensor.draw(ctx, model.sensor);
  ctx.restore();
}
