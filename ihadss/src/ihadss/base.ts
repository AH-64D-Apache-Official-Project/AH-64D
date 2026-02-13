export function draw(_ctx: CanvasRenderingContext2D) {
  drawLos(_ctx);
}

function drawLos(_ctx: CanvasRenderingContext2D) {
  _ctx.save();
  _ctx.translate(320, 240);
  _ctx.beginPath();
  for (let i = 0; i < 4; i++) {
    _ctx.moveTo(0, 9);
    _ctx.lineTo(0, 9 + 18);
    _ctx.rotate(0.5 * Math.PI);
  }
  _ctx.stroke();
  _ctx.restore();
}
