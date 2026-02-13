import * as base from "./ihadss/base";
import * as flight from "./ihadss/flight";
import * as sensor from "./ihadss/sensor";
import * as weapon from "./ihadss/weapon";

export type model = {
  flight: flight.model;
  sensor: sensor.model;
  weapon: weapon.model;
  //ihadss had fields
  ownerCue: string;
  wpnInhibit: string;
  sightSelStatus: string;
  sightStatus: string;
  rngAndRngSrc: number;
  wpnControl: string;
  acqSelStatus: string;
  wpnStatus: string;
};

export const exampleModel: model = {
  flight: flight.exampleModel,
  sensor: sensor.exampleModel,
  weapon: weapon.exampleModel,
  //ihadss had fields
  ownerCue: "-OWNER-CUE-",
  wpnInhibit: "WEAPON-INHIB",
  sightSelStatus: "SSS--L",
  sightStatus: "SIGHT-STATUS",
  rngAndRngSrc: 1000,
  wpnControl: "WPNCT",
  acqSelStatus: "ACQS",
  wpnStatus: "WEAPONSTATUS",
};

function ihadssStyle(_ctx: CanvasRenderingContext2D) {
  _ctx.strokeStyle = "#0F0";
  _ctx.fillStyle = "#0F0";
  _ctx.font = "15px BMKApacheFont";
  _ctx.globalAlpha = 1;
  _ctx.lineWidth = 2;
}

export function drawIhadss(_ctx: CanvasRenderingContext2D, _model: model): void {
  ihadssStyle(_ctx)
  //Torque
  _ctx.textAlign = "left";
  _ctx.textBaseline = "bottom";
  _ctx.fillText(_model.flight.engTq.toFixed(0) + "%", 129, 115);
  _ctx.globalAlpha = 1;
  _ctx.lineWidth = 2;

  //TGT
  //This should only display in the last 2 or 2.5 minutes of a particular tgt limit
  //If dual engine, then it's the last 2 minutes of the 10 minute limit, if single
  //engine, then it's the full duration of the 2.5 minute limit 
  /*
  _ctx.font = "15px BMKApacheFont";
  _ctx.textAlign = "right";
  _ctx.fillText(model.flight.engTgt.toFixed(0) + "C", 174, 115 + 17);
  */
  
  //TAS
  _ctx.font      = "15px BMKApacheFont";
  _ctx.textAlign = "right";
  _ctx.fillText(_model.flight.tas.toFixed(0), 154, 232);

  //G-meter
  //There's currently nothing to feed this value
  /*
  _ctx.font = "15px BMKApacheFont";
  _ctx.textAlign = "right";
  _ctx.fillText("1.2G", 154+6, 232 + 22);
  */

  //MSL Altitude
  if (_model.flight.selSymb == "cruise") {
    _ctx.font         = "15px BMKApacheFont";
    _ctx.textAlign    = "right";
    _ctx.textBaseline = "middle";
    _ctx.fillText(_model.flight.baroAlt.toFixed(0), 513, 108);
  }

  //VSI > 1000 FPM Descent Text
  if (_model.flight.roc < -1000) {
    const rocVal = Math.round(_model.flight.roc / 100) * 100;
    _ctx.fillText(rocVal.toFixed(0), 513, 354);
  }

  //Owner Cue
  _ctx.textAlign    = "center";
  _ctx.textBaseline = "bottom";
  _ctx.fillText("-OWNDER-CUE-", 320, 395);
  //_ctx.fillText(_model.ownerCue, 320, 395);

  //WPN Inhibit
  _ctx.fillText("WEAPON-INHIB", 320, 412);
  //_ctx.fillText(_model.wpnInhibit, 320, 412);

  const adjustment  = 5;
  const adjustment2 = 3;
  //HAD Sight Select Status
  _ctx.textAlign = "left";
  _ctx.textBaseline = "bottom";
  _ctx.fillText("SSS--L", 121 - adjustment, 452);
  //_ctx.fillText(_model.sightSelStatus, 121 - adjustment, 452);

  //HAD Sight Status
  _ctx.fillText("SIGHT-STATUS", 121 - adjustment, 471);
  //_ctx.fillText(_model.sightStatus, 121 - adjustment, 471);

  //HAD Range & Range Source
  const temp = 1234;
  _ctx.fillText("*" + temp.toFixed(0), 200 - adjustment, 452);
  //_ctx.fillText(_model.rngAndRngSrc.toFixed(0), 200 - adjustment, 452);

  //HAD Weapon Control
  _ctx.fillText("WPNCT", 391 - adjustment2, 452);
  //_ctx.fillText(_model.wpnControl, 391 - adjustment2, 452);

  //HAD Acquisition Select Status
  _ctx.fillText("ACQS", 458 - adjustment2, 452);
  //_ctx.fillText(_model.acqSelStatus, 458 - adjustment2, 452);

  //HAD Weapon Status
  _ctx.fillText("WEAPONSTATUS", 391 - adjustment2, 471);
  //_ctx.fillText(_model.wpnStatus, 391 - adjustment2, 471);

  //Radar Altitude
  _ctx.textAlign = "right";
  _ctx.textBaseline = "bottom";
  _ctx.fillText(_model.flight.radAlt.toFixed(0), 510, 232);

  //HI Altitude Alert
  //This needs to be set by the FLT SET page, which is not currently implemented
  if (_model.flight.radAlt > _model.flight.hiAltWarn) {
    _ctx.textAlign = "right";
    _ctx.textBaseline = "middle";
    _ctx.fillText("HI", 510, 232 - 24);
  }

  //LO Altitude Alert
  //This needs to be set by the FLT SET page, which is not currently implemented
  if (_model.flight.radAlt < _model.flight.loAltWarn) {
    _ctx.textAlign = "right";
    _ctx.textBaseline = "middle";
    _ctx.save();
    _ctx.fillText("LO", 510, 232 + 21);
  }

  //Waypoint Selection
 if (_model.flight.selSymb == "trans" || _model.flight.selSymb == "cruise") {
    _ctx.font         = "15px BMKApacheFont";
    _ctx.textAlign    = "left";
    _ctx.textBaseline = "bottom";
    _ctx.fillText(_model.flight.curWpt, 86, 365);

    //Waypoint Distance
    _ctx.font         = "15px BMKApacheFont";
    _ctx.textAlign    = "right";
    _ctx.textBaseline = "bottom";
    //The "KM" needs to dissapear when a waypoint is currently selected or present
    if (_model.flight.dstToWpt != "") {
      _ctx.fillText(_model.flight.dstToWpt + "KM", 222, 365);
    }
    //Ground Speed
    _ctx.fillText(_model.flight.gndSpd.toFixed(0), 134, 389);

    //Waypoint Time to Go
    _ctx.fillText(_model.flight.timeToWpt, 215, 389);
  }

  base.draw(_ctx);
  flight.draw(_ctx, _model.flight);
  sensor.draw(_ctx, _model.sensor);
  weapon.draw(_ctx, _model.weapon);
}

export type icontype = "headtracker"

export function drawIhadssIcon(_ctx: CanvasRenderingContext2D, _icon: icontype): void {
  ihadssStyle(_ctx)
  _ctx.save();
  _ctx.translate(32, 32);
  switch (_icon) {
    case "headtracker": {
      sensor.drawHeadTracker(_ctx);
    }
  }
  _ctx.restore();
}