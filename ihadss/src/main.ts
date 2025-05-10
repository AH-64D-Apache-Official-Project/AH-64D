import { drawIhadss, exampleModel } from "./ihadss";
import "./style.css";

const canvas = document.getElementById("canvas")! as HTMLCanvasElement;
const context = canvas.getContext("2d")!;

const ASPECT_RATIO = 4 / 3;

// Logical resolution (can be anything)
const VIRTUAL_WIDTH = 640;
const VIRTUAL_HEIGHT = VIRTUAL_WIDTH / ASPECT_RATIO;

function draw() {
  context.fillStyle = "#000";
  context.fillRect(0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT);
  drawIhadss(context, exampleModel);
}

function resizeCanvas() {
  const windowWidth = window.innerWidth;
  const windowHeight = window.innerHeight;

  const width = Math.min(windowWidth, windowHeight * ASPECT_RATIO);
  const height = Math.min(windowHeight, windowWidth / ASPECT_RATIO);

  // Canvas is automatically resized to be the largest it can be while maintaining aspect ratio
  canvas.style.width = `${width}px`;
  canvas.style.height = `${height}px`;

  canvas.width = VIRTUAL_WIDTH;
  canvas.height = VIRTUAL_HEIGHT;
  draw();
}
document.fonts.add(new FontFace("BMKApacheFont", "url(./BMKApacheFont.ttf)"));
document.fonts.load("3px BMKApacheFont").then(() => {
  window.addEventListener("resize", resizeCanvas);
  resizeCanvas();
});
