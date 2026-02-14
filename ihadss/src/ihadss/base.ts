export type model = {
  crewStation: string;  //"PLT" "CPG"
  sightSelect: string;  //"HMD" "TADS" "FCR"
  sensorSelect: string; //"OFF" "NORM"
};

export const exampleModel: model = {
  crewStation: "CPG",
  sightSelect: "HMD",
  sensorSelect: "OFF",
};

export function draw(_ctx: CanvasRenderingContext2D, _model: model) {
  drawLos(_ctx);
  if (_model.crewStation == "PLT") {
    drawFieldOfRegardPilot(_ctx);
  } else {
    drawFieldOfRegardGunner(_ctx);
  };
};

function drawLos(_ctx: CanvasRenderingContext2D) {
  _ctx.save();
  _ctx.translate(320, 240);
  _ctx.beginPath();
  for (let i = 0; i < 4; i++) {
    _ctx.moveTo(0, 9);
    _ctx.lineTo(0, 9 + 18);
    _ctx.rotate(0.5 * Math.PI);
  };
  _ctx.stroke();
  _ctx.restore();
};

export function drawHeadTracker(_ctx: CanvasRenderingContext2D) {
  _ctx.save();
  _ctx.beginPath();
  for (let i = 0; i < 4; i++) {
    _ctx.moveTo(-8, 18);
    _ctx.lineTo(0, 26);
    _ctx.lineTo(8, 18);
    _ctx.rotate(0.5 * Math.PI);
  }
  _ctx.stroke();
  _ctx.restore();
}

function drawFieldOfRegardPilot(_ctx: CanvasRenderingContext2D) {
  const forWidth  = 116;
  const forHeight = 44;

  _ctx.strokeRect(320 - (forWidth / 2), 455 - (forHeight / 2), forWidth, forHeight);

  //Left vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(262,448);
  _ctx.lineTo(269,448);
  _ctx.stroke();

  //Right vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(371,448);
  _ctx.lineTo(378,448);
  _ctx.stroke();

  //Top vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320,433);
  _ctx.lineTo(320,440);
  _ctx.stroke();

  //Bottom vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320,469);
  _ctx.lineTo(320,476);
  _ctx.stroke();
};

function drawFieldOfRegardGunner(_ctx: CanvasRenderingContext2D) {
  const forWidth  = 124;
  const forHeight = 44;

  _ctx.strokeRect(320 - (forWidth / 2), 455 - (forHeight / 2), forWidth, forHeight);

  //Left vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(258,448);
  _ctx.lineTo(265,448);
  _ctx.stroke();

  //Right vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(375,448);
  _ctx.lineTo(382,448);
  _ctx.stroke();

  //Center top vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320,433);
  _ctx.lineTo(320,440);
  _ctx.stroke();

  //Center bottom vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320,469);
  _ctx.lineTo(320,476);
  _ctx.stroke();

  //Top left 90 degree vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320 - 47, 433);
  _ctx.lineTo(320 - 47, 440);
  _ctx.stroke();

  //Top left 90 degree vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320 - 47, 469);
  _ctx.lineTo(320 - 47, 476);
  _ctx.stroke();

  //Top right 90 degree vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320 + 47, 433);
  _ctx.lineTo(320 + 47, 440);
  _ctx.stroke();

  //Top right 90 degree vertical tic mark
  _ctx.beginPath();
  _ctx.moveTo(320 + 47, 469);
  _ctx.lineTo(320 + 47, 476);
  _ctx.stroke();
};