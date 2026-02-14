export type model = {
};


export const exampleModel: model = {
};

export function draw(_ctx: CanvasRenderingContext2D, _model: model) {
  drawArticulatingRocketSteeringCursor(_ctx, _model);
  drawLoblConstraintsBox(_ctx, _model);
  drawLoalConstraintsBox(_ctx, _model);

  drawInhibitedRocketSteeringCursor(_ctx, _model);
}

function drawArticulatingRocketSteeringCursor(_ctx: CanvasRenderingContext2D, _model: model) {
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

function drawInhibitedRocketSteeringCursor(_ctx: CanvasRenderingContext2D, _model: model) {
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
            _ctx.moveTo(-23 + (lineIncrement * i),       -(cursorHeight / 2) - 5);
            _ctx.lineTo(-23 + (lineIncrement * (i + 1)), -(cursorHeight / 2) - 5);
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

function drawLoblConstraintsBox(_ctx: CanvasRenderingContext2D, _model: model) {
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

function drawLoalConstraintsBox(_ctx: CanvasRenderingContext2D, _model: model) {
    const posX = 320;
    const posY = 240;  
    
    const boxWidthHeight = 26;

    _ctx.save();
    _ctx.translate(posX + 50, posY - 60);
    _ctx.beginPath();

    _ctx.strokeRect(-boxWidthHeight / 2, -boxWidthHeight / 2, boxWidthHeight, boxWidthHeight);

    _ctx.stroke();
    _ctx.restore();
}