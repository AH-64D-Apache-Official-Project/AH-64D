export function draw(ctx: CanvasRenderingContext2D) {
  drawLos(ctx);
}

function drawLos(ctx: CanvasRenderingContext2D) {
  ctx.save();
  ctx.translate(320, 240);
  ctx.beginPath();
  for (let i = 0; i < 4; i++) {
    ctx.moveTo(0, 9);
    ctx.lineTo(0, 9 + 18);
    ctx.rotate(0.5 * Math.PI);
  }
  ctx.stroke();
  ctx.restore();
}
