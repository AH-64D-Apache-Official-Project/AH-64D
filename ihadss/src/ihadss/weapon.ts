import * as base from "./base";

export type model = {
}

export const exampleModel: model = {
}

export function draw(_ctx: CanvasRenderingContext2D, _baseModel: base.model, _model: model) {
  if (_baseModel.wpnWas == 2) {
    drawArticulatingRocketSteeringCursor(_ctx);
    drawInhibitedRocketSteeringCursor(_ctx);
  }
  
  if (_baseModel.wpnWas == 3) {
    drawLoblConstraintsBox(_ctx);
    drawInhibitedLoblConstraintsBox(_ctx);
  
    drawLoalConstraintsBox(_ctx);
    drawInhibitedLoalConstraintsBox(_ctx);
  }
}

export function drawArticulatingRocketSteeringCursor(_ctx: CanvasRenderingContext2D) {
    const posX = 320;
    const posY = 240;

    const cursorHeight = 90;

    _ctx.save();
    _ctx.translate(posX + 30, posY + 20);
    _ctx.beginPath();
 
    //Upper left horizontal line
    _ctx.moveTo(-23, -(cursorHeight / 2) - 5);
    _ctx.lineTo( -5, -(cursorHeight / 2) - 5);

    //Upper right horizontal line
    _ctx.moveTo( 23, -(cursorHeight / 2) - 5);
    _ctx.lineTo(  5, -(cursorHeight / 2) - 5);

    //Center vertical line
    _ctx.moveTo(0, -(cursorHeight / 2));
    _ctx.lineTo(0,  (cursorHeight / 2));

    //Bottom left horizontal line
    _ctx.moveTo(-23, (cursorHeight / 2) + 5);
    _ctx.lineTo( -5, (cursorHeight / 2) + 5);

    //Bottom right horizontal line
    _ctx.moveTo( 23, (cursorHeight / 2) + 5);
    _ctx.lineTo(  5, (cursorHeight / 2) + 5);

    _ctx.stroke();
    _ctx.restore();
}

export function drawInhibitedRocketSteeringCursor(_ctx: CanvasRenderingContext2D) {
    const posX = 320;
    const posY = 240;

    const cursorHeight  = 90;
    const lineWidth     = 18;
    const lineIncrement = lineWidth / 3;

    _ctx.save();
    _ctx.translate(posX + 50, posY - 20);
    _ctx.beginPath();
 
    //Upper left horizontal line
    for (let i = 0; i < 3; i++) {
        if ((i % 2) == 0) {
            _ctx.moveTo(-23 + (lineIncrement * i),       -(cursorHeight / 2) - 4);
            _ctx.lineTo(-23 + (lineIncrement * (i + 1)), -(cursorHeight / 2) - 4);
        }
    }

    //Upper right horizontal line
    for (let i = 0; i < 3; i++) {
        if ((i % 2) == 0) {
            _ctx.moveTo( 23 - (lineIncrement * i),       -(cursorHeight / 2) - 5);
            _ctx.lineTo( 23 - (lineIncrement * (i + 1)), -(cursorHeight / 2) - 5);
        }
    }

    //Center vertical line
    _ctx.moveTo(0, -45);
    _ctx.lineTo(0, -31);

    _ctx.moveTo(0, -26);
    _ctx.lineTo(0, -12);

    _ctx.moveTo(0, -7);
    _ctx.lineTo(0,  7);

    _ctx.moveTo(0, 12);
    _ctx.lineTo(0, 26);

    _ctx.moveTo(0, 31);
    _ctx.lineTo(0, 45);

    //Upper left horizontal line
    for (let i = 0; i < 3; i++) {
        if ((i % 2) == 0) {
            _ctx.moveTo(-23 + (lineIncrement * i),       (cursorHeight / 2) + 5);
            _ctx.lineTo(-23 + (lineIncrement * (i + 1)), (cursorHeight / 2) + 5);
        }
    }

    //Upper right horizontal line
    for (let i = 0; i < 3; i++) {
        if ((i % 2) == 0) {
            _ctx.moveTo( 23 - (lineIncrement * i),       (cursorHeight / 2) + 5);
            _ctx.lineTo( 23 - (lineIncrement * (i + 1)), (cursorHeight / 2) + 5);
        }
    }
    _ctx.stroke();
    _ctx.restore();
}

export function drawLoblConstraintsBox(_ctx: CanvasRenderingContext2D) {
    const posX = 320;
    const posY = 240;  
    
    const boxWidthHeight = 100;

    _ctx.save();
    _ctx.translate(posX - 80, posY + 40);
    _ctx.beginPath();

    _ctx.strokeRect(-boxWidthHeight / 2, -boxWidthHeight / 2, boxWidthHeight, boxWidthHeight);

    _ctx.stroke();
    _ctx.restore();
}

export function drawLoalConstraintsBox(_ctx: CanvasRenderingContext2D) {
    const posX = 320;
    const posY = 240;  
    
    const boxWidthHeight = 26;

    _ctx.save();
    _ctx.translate(posX - 50, posY - 60);
    _ctx.beginPath();

    _ctx.strokeRect(-boxWidthHeight / 2, -boxWidthHeight / 2, boxWidthHeight, boxWidthHeight);

    _ctx.stroke();
    _ctx.restore();
}

export function drawInhibitedLoblConstraintsBox(_ctx: CanvasRenderingContext2D) {
    const posX = 320;
    const posY = 240;  

    _ctx.save();
    _ctx.translate(posX + 90, posY - 40);
    _ctx.beginPath();

    //Top of box
    _ctx.moveTo(-51, -50);
    _ctx.lineTo(-42, -50);
    _ctx.moveTo(-38, -50);
    _ctx.lineTo(-22, -50);
    _ctx.moveTo(-18, -50);
    _ctx.lineTo( -2, -50);
    _ctx.moveTo(  2, -50);
    _ctx.lineTo( 18, -50);
    _ctx.moveTo( 22, -50);
    _ctx.lineTo( 38, -50);
    _ctx.moveTo( 42, -50);
    _ctx.lineTo( 51, -50);

    //Right of box
    _ctx.moveTo( 50,-50);
    _ctx.lineTo( 50,-42);
    _ctx.moveTo( 50,-38);
    _ctx.lineTo( 50,-22);
    _ctx.moveTo( 50,-18);
    _ctx.lineTo( 50, -2);
    _ctx.moveTo( 50,  2);
    _ctx.lineTo( 50, 18);
    _ctx.moveTo( 50, 22);
    _ctx.lineTo( 50, 38);
    _ctx.moveTo( 50, 42);
    _ctx.lineTo( 50, 50);

    //Bottom of box
    _ctx.moveTo(-51, 50);
    _ctx.lineTo(-42, 50);
    _ctx.moveTo(-38, 50);
    _ctx.lineTo(-22, 50);
    _ctx.moveTo(-18, 50);
    _ctx.lineTo( -2, 50);
    _ctx.moveTo(  2, 50);
    _ctx.lineTo( 18, 50);
    _ctx.moveTo( 22, 50);
    _ctx.lineTo( 38, 50);
    _ctx.moveTo( 42, 50);
    _ctx.lineTo( 51, 50);

    //Left of box
    _ctx.moveTo(-50,-50);
    _ctx.lineTo(-50,-42);
    _ctx.moveTo(-50,-38);
    _ctx.lineTo(-50,-22);
    _ctx.moveTo(-50,-18);
    _ctx.lineTo(-50, -2);
    _ctx.moveTo(-50,  2);
    _ctx.lineTo(-50, 18);
    _ctx.moveTo(-50, 22);
    _ctx.lineTo(-50, 38);
    _ctx.moveTo(-50, 42);
    _ctx.lineTo(-50, 50);

    _ctx.stroke();
    _ctx.restore();
}

export function drawInhibitedLoalConstraintsBox(_ctx: CanvasRenderingContext2D) {
    const posX = 320;
    const posY = 240;  

    _ctx.save();
    _ctx.translate(posX - 70, posY + 20);
    _ctx.beginPath();

    //Top of box
    _ctx.moveTo(-14, -13);
    _ctx.lineTo( -9, -13);
    _ctx.moveTo( -5, -13);
    _ctx.lineTo(  5, -13);
    _ctx.moveTo(  9, -13);
    _ctx.lineTo( 14, -13);

    //Right of box
    _ctx.moveTo( 13, -13);
    _ctx.lineTo( 13,  -9);
    _ctx.moveTo( 13,  -5);
    _ctx.lineTo( 13,   5);
    _ctx.moveTo( 13,   9);
    _ctx.lineTo( 13,  13);

    //Bottom of box
    _ctx.moveTo(-14, 13);
    _ctx.lineTo( -9, 13);
    _ctx.moveTo( -5, 13);
    _ctx.lineTo(  5, 13);
    _ctx.moveTo(  9, 13);
    _ctx.lineTo( 14, 13);

    //Left of box
    _ctx.moveTo(-13, -13);
    _ctx.lineTo(-13,  -9);
    _ctx.moveTo(-13,  -5);
    _ctx.lineTo(-13,   5);
    _ctx.moveTo(-13,   9);
    _ctx.lineTo(-13,  13);

    _ctx.stroke();
    _ctx.restore();
}