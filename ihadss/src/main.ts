import { drawIhadss, drawIhadssIcon, exampleModel, type model, type icontype} from "./ihadss";
import type { coord } from "./ihadss/common";
import "./style.css";

const canvas = document.getElementById("canvas")! as HTMLCanvasElement;
const context = canvas.getContext("2d")!;


let inArma3 = window.A3API ? true : false

type canvasState = {type: "empty"} | {type: "ihadss", state:model} | {type:"ihadssicon", icon:icontype}

let state: canvasState = inArma3 ? {type: "empty"} : {type: "ihadss", state: exampleModel}

function canvasSize(): coord {
  // Logical resolution (can be anything)
  switch (state.type) {
    case "empty":
    case "ihadss": {
      const VIRTUAL_WIDTH = 640;
      const VIRTUAL_HEIGHT = 480;
      return [VIRTUAL_WIDTH, VIRTUAL_HEIGHT]
    }
    case "ihadssicon": {
      return [64, 64]
    }
  }
}

function draw() {
  if (!inArma3) {
    context.fillStyle = "#000";
    context.fillRect(0, 0, canvas.width, canvas.height)
  } else {
    context.clearRect(0, 0, canvas.width, canvas.height);
  }

  switch (state.type) {
    case "ihadss": {
      drawIhadss(context, state.state);
      return;
    }
    case "ihadssicon": {
      drawIhadssIcon(context, state.icon);
      return;
    }
  }
}

export function updateModel(newModel:model) {
  inArma3 = true
  state = {type: "ihadss", state: newModel};
  draw();
}

export function drawIcon(icon: icontype) {
  inArma3 = true
  state = {type: "ihadssicon", icon: icon};
  setCanvasSize();
  draw();
  window.A3API?.SendAlert("drawcomplete");
}

function setCanvasSize() {
  const [canvasWidth, canvasHeight] = canvasSize();
  canvas.width = canvasWidth;
  canvas.height = canvasHeight;
  draw();
}


// @ts-expect-error implicitly has an 'any' type
window["updateModel"] = updateModel;
// @ts-expect-error implicitly has an 'any' type
window["drawIcon"] = drawIcon;

let originalWidth = 0;
let originalHeight = 0;

function resizeCanvas() {
  const windowWidth = window.innerWidth;
  const windowHeight = window.innerHeight;

  if (windowWidth == originalWidth && windowHeight == originalHeight) {
    return
  }

  originalHeight = windowHeight;
  originalWidth = windowWidth;

  const [canvasWidth, canvasHeight] = canvasSize();
  const aspectRatio = canvasWidth / canvasHeight

  const width = Math.min(windowWidth, windowHeight * aspectRatio);
  const height = Math.min(windowHeight, windowWidth / aspectRatio);

  // Canvas is automatically resized to be the largest it can be while maintaining aspect ratio
  canvas.style.width = `${width}px`;
  canvas.style.height = `${height}px`;
}
document.fonts.load("3px BMKApacheFont").then(() => {
  window.addEventListener("resize", resizeCanvas);
  setCanvasSize();
  resizeCanvas();
});
