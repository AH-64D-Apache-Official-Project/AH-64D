import * as base from "./base";

export type model = {
    isHeadsDown: boolean;
    sensorSelect: string;
    fov: number;    //0 = W, 1 = M, 2 = N, 3 = Z
}

export const exampleModel: model = {
    isHeadsDown: false,
    sensorSelect: "DVO",
    fov: 0,
}

export function draw(_ctx: CanvasRenderingContext2D, _baseModel: base.model, _model: model) {
    drawText(_ctx, _baseModel, _model);
}

export function drawText(_ctx: CanvasRenderingContext2D, _baseModel: base.model, _model: model) {  
    _ctx.textAlign    = "right";
    _ctx.textBaseline = "bottom";

    //Ground speed
    _ctx.fillText(_baseModel.gndSpd.toFixed(0), 250, 432);

    //Radar altitude
    _ctx.fillText(_baseModel.radAlt.toFixed(0), 433, 432);

    drawTadsSelectedSensorText(_ctx, _model);
    if (_model.sensorSelect == "FLIR") {
        drawFlirFovGates(_ctx, _model);
    } else if (_model.sensorSelect == "DTV") {
        drawDtvFovGates(_ctx, _model);
    } else if (_model.sensorSelect == "DVO") {
        drawDvoFovGates(_ctx, _model);
    }
}

export function drawTadsSelectedSensorText(_ctx: CanvasRenderingContext2D, _model: model) {
    _ctx.textAlign    = "left";
    _ctx.textBaseline = "bottom";
    
    if (_model.sensorSelect == "FLIR") {
        _ctx.fillText("FLIR", 116, 115);
    } else if (_model.sensorSelect == "DTV") {
        _ctx.fillText("DTV", 116, 115);
    } else if (_model.sensorSelect == "DVO") {
        _ctx.fillText("DVO", 116, 115);
    }
}

export function drawFlirFovGates(_ctx: CanvasRenderingContext2D, _model: model) {
    _ctx.save();
    _ctx.translate(320, 240);
    _ctx.beginPath();

    //W = 1x mag
    //M = 5.7x mag
    //N = 18x mag
    //Z = 36x mag

    let width = 0;
    let height = 0;
    if (_model.fov == 0) {
        width  = 112;
        height = 84;
        //Top left corner
        _ctx.moveTo(-(width / 2),      -height / 2);
        _ctx.lineTo(-(width / 2) + 17, -height / 2);
        _ctx.moveTo(-(width / 2) + 1, -(height / 2));
        _ctx.lineTo(-(width / 2) + 1, -(height / 2) + 17);

        //Top right corner
        _ctx.moveTo( (width / 2),      -height / 2);
        _ctx.lineTo( (width / 2) - 17, -height / 2);
        _ctx.moveTo( (width / 2) - 1, -(height / 2));
        _ctx.lineTo( (width / 2) - 1, -(height / 2) + 17);

        //Bottom right corner
        _ctx.moveTo( (width / 2),     (height / 2));
        _ctx.lineTo( (width / 2) - 17,(height / 2));
        _ctx.moveTo( (width / 2) - 1, (height / 2));
        _ctx.lineTo( (width / 2) - 1, (height / 2) - 17);

        //Bottom left corner
        _ctx.moveTo(-(width / 2),     (height / 2));
        _ctx.lineTo(-(width / 2) + 17,(height / 2));
        _ctx.moveTo(-(width / 2) + 1, (height / 2));
        _ctx.lineTo(-(width / 2) + 1, (height / 2) - 17);
    } else if (_model.fov == 1) {
        width  = 203;
        height = 152;
        //Top left corner
        _ctx.moveTo(-(width / 2),      -height / 2);
        _ctx.lineTo(-(width / 2) + 17, -height / 2);
        _ctx.moveTo(-(width / 2) + 1, -(height / 2));
        _ctx.lineTo(-(width / 2) + 1, -(height / 2) + 17);

        //Top right corner
        _ctx.moveTo( (width / 2),      -height / 2);
        _ctx.lineTo( (width / 2) - 17, -height / 2);
        _ctx.moveTo( (width / 2) - 1, -(height / 2));
        _ctx.lineTo( (width / 2) - 1, -(height / 2) + 17);

        //Bottom right corner
        _ctx.moveTo( (width / 2),     (height / 2));
        _ctx.lineTo( (width / 2) - 17,(height / 2));
        _ctx.moveTo( (width / 2) - 1, (height / 2));
        _ctx.lineTo( (width / 2) - 1, (height / 2) - 17);

        //Bottom left corner
        _ctx.moveTo(-(width / 2),     (height / 2));
        _ctx.lineTo(-(width / 2) + 17,(height / 2));
        _ctx.moveTo(-(width / 2) + 1, (height / 2));
        _ctx.lineTo(-(width / 2) + 1, (height / 2) - 17);
    } else if (_model.fov == 2) {
        width  = 320;
        height = 240;
        //Top left corner
        _ctx.moveTo(-(width / 2),      -height / 2);
        _ctx.lineTo(-(width / 2) + 17, -height / 2);
        _ctx.moveTo(-(width / 2) + 1, -(height / 2));
        _ctx.lineTo(-(width / 2) + 1, -(height / 2) + 17);

        //Top right corner
        _ctx.moveTo( (width / 2),      -height / 2);
        _ctx.lineTo( (width / 2) - 17, -height / 2);
        _ctx.moveTo( (width / 2) - 1, -(height / 2));
        _ctx.lineTo( (width / 2) - 1, -(height / 2) + 17);

        //Bottom right corner
        _ctx.moveTo( (width / 2),     (height / 2));
        _ctx.lineTo( (width / 2) - 17,(height / 2));
        _ctx.moveTo( (width / 2) - 1, (height / 2));
        _ctx.lineTo( (width / 2) - 1, (height / 2) - 17);

        //Bottom left corner
        _ctx.moveTo(-(width / 2),     (height / 2));
        _ctx.lineTo(-(width / 2) + 17,(height / 2));
        _ctx.moveTo(-(width / 2) + 1, (height / 2));
        _ctx.lineTo(-(width / 2) + 1, (height / 2) - 17);
    }
    _ctx.stroke();
    _ctx.restore();
    }

    export function drawDtvFovGates(_ctx: CanvasRenderingContext2D, _model: model) {
        _ctx.save();
        _ctx.translate(320, 240);
        _ctx.beginPath();

        //W & M = 14x mag
        //N = 32x mag (should be 63x mag but arma is arma)
        //Z = 63x mag (should be 126x mag

        let width  = 0;
        let height = 0;
        if (_model.fov == 0 || _model.fov == 1) {
        width  = 280;
        height = 210;
        //Top left corner
        _ctx.moveTo(-(width / 2),      -height / 2);
        _ctx.lineTo(-(width / 2) + 17, -height / 2);
        _ctx.moveTo(-(width / 2) + 1, -(height / 2));
        _ctx.lineTo(-(width / 2) + 1, -(height / 2) + 17);

        //Top right corner
        _ctx.moveTo( (width / 2),      -height / 2);
        _ctx.lineTo( (width / 2) - 17, -height / 2);
        _ctx.moveTo( (width / 2) - 1, -(height / 2));
        _ctx.lineTo( (width / 2) - 1, -(height / 2) + 17);

        //Bottom right corner
        _ctx.moveTo( (width / 2),     (height / 2));
        _ctx.lineTo( (width / 2) - 17,(height / 2));
        _ctx.moveTo( (width / 2) - 1, (height / 2));
        _ctx.lineTo( (width / 2) - 1, (height / 2) - 17);

        //Bottom left corner
        _ctx.moveTo(-(width / 2),     (height / 2));
        _ctx.lineTo(-(width / 2) + 17,(height / 2));
        _ctx.moveTo(-(width / 2) + 1, (height / 2));
        _ctx.lineTo(-(width / 2) + 1, (height / 2) - 17);
    } else if (_model.fov == 2) {
        width  = 325;
        height = 244;
        //Top left corner
        _ctx.moveTo(-(width / 2),      -height / 2);
        _ctx.lineTo(-(width / 2) + 17, -height / 2);
        _ctx.moveTo(-(width / 2) + 1, -(height / 2));
        _ctx.lineTo(-(width / 2) + 1, -(height / 2) + 17);

        //Top right corner
        _ctx.moveTo( (width / 2),      -height / 2);
        _ctx.lineTo( (width / 2) - 17, -height / 2);
        _ctx.moveTo( (width / 2) - 1, -(height / 2));
        _ctx.lineTo( (width / 2) - 1, -(height / 2) + 17);

        //Bottom right corner
        _ctx.moveTo( (width / 2),     (height / 2));
        _ctx.lineTo( (width / 2) - 17,(height / 2));
        _ctx.moveTo( (width / 2) - 1, (height / 2));
        _ctx.lineTo( (width / 2) - 1, (height / 2) - 17);

        //Bottom left corner
        _ctx.moveTo(-(width / 2),     (height / 2));
        _ctx.lineTo(-(width / 2) + 17,(height / 2));
        _ctx.moveTo(-(width / 2) + 1, (height / 2));
        _ctx.lineTo(-(width / 2) + 1, (height / 2) - 17);
    }
    _ctx.stroke();
    _ctx.restore();
}

export function drawDvoFovGates(_ctx: CanvasRenderingContext2D, _model: model) {
  _ctx.save();
  _ctx.translate(320, 240);
  _ctx.beginPath();

    //w = 3.5x mag
    //N = 16x mag

  let width  = 0;
  let height = 0;
  if (_model.fov == 0) {
    width  = 140;
    height = 105;
    //Top left corner
    _ctx.moveTo(-(width / 2),      -height / 2);
    _ctx.lineTo(-(width / 2) + 17, -height / 2);
    _ctx.moveTo(-(width / 2) + 1, -(height / 2));
    _ctx.lineTo(-(width / 2) + 1, -(height / 2) + 17);

    //Top right corner
    _ctx.moveTo( (width / 2),      -height / 2);
    _ctx.lineTo( (width / 2) - 17, -height / 2);
    _ctx.moveTo( (width / 2) - 1, -(height / 2));
    _ctx.lineTo( (width / 2) - 1, -(height / 2) + 17);

    //Bottom right corner
    _ctx.moveTo( (width / 2),     (height / 2));
    _ctx.lineTo( (width / 2) - 17,(height / 2));
    _ctx.moveTo( (width / 2) - 1, (height / 2));
    _ctx.lineTo( (width / 2) - 1, (height / 2) - 17);

    //Bottom left corner
    _ctx.moveTo(-(width / 2),     (height / 2));
    _ctx.lineTo(-(width / 2) + 17,(height / 2));
    _ctx.moveTo(-(width / 2) + 1, (height / 2));
    _ctx.lineTo(-(width / 2) + 1, (height / 2) - 17);
  }
  _ctx.stroke();
  _ctx.restore();
}

export function drawAlphaNumericDisplay(_ctx: CanvasRenderingContext2D, _model: model) {

}