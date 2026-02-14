import * as base from "./ihadss/base";
import * as flightFormat from "./ihadss/flightFormat";
import * as gunnerFormat from "./ihadss/gunnerFormat";
import * as sensor from "./ihadss/sensor";
import * as weapon from "./ihadss/weapon";

export type model = {
    base: base.model;
    flightFormat: flightFormat.model;
    gunnerFormat: gunnerFormat.model;
    sensor: sensor.model;
    weapon: weapon.model;
}

export const exampleModel: model = {
    base: base.exampleModel,
    flightFormat: flightFormat.exampleModel,
    gunnerFormat: gunnerFormat.exampleModel,
    sensor: sensor.exampleModel,
    weapon: weapon.exampleModel,
}

function ihadssStyle(_ctx: CanvasRenderingContext2D) {
    _ctx.strokeStyle = "#0F0";
    _ctx.fillStyle = "#0F0";
    _ctx.font = "15px BMKApacheFont";
    _ctx.globalAlpha = 1;
    _ctx.lineWidth = 2;
}

export function drawIhadss(_ctx: CanvasRenderingContext2D, _model: model): void {
    ihadssStyle(_ctx);
    
    base.draw(_ctx, _model.base);
    
    if (_model.base.crewStation == "plt") {
        flightFormat.draw(_ctx, _model.flightFormat);
        sensor.draw(_ctx, _model.sensor);
        weapon.draw(_ctx, _model.weapon);
    } else {
        //0 = HMD, 2 = FCR
        if (_model.base.sightSelect == 0 || _model.base.sightSelect == 2) {
            flightFormat.draw(_ctx, _model.flightFormat); 
            sensor.draw(_ctx, _model.sensor);
            weapon.draw(_ctx, _model.weapon);
        } else {
            gunnerFormat.draw(_ctx, _model.gunnerFormat);
            sensor.draw(_ctx, _model.sensor);
            weapon.draw(_ctx, _model.weapon);
        }
    }
}

export type icontype = "headtracker"

export function drawIhadssIcon(_ctx: CanvasRenderingContext2D, _icon: icontype): void {
    ihadssStyle(_ctx)
    _ctx.save();
    _ctx.translate(32, 32);
    switch (_icon) {
        case "headtracker": {
            base.drawHeadTracker(_ctx);
        };
    };
    _ctx.restore();
}