function Point(x, y, isLast) {
    if (isLast == undefined || isLast == null) {
        isLast = false;
    }

    this.x = x;
    this.y = y;
    this.isLast = isLast;
}

var stage,
            graphics,
            points,
            initialStroke = createjs.Graphics.getRGB(65, 183, 216, 0.5),
            finalStroke = createjs.Graphics.getRGB(100, 100, 100);


$(document).ready(function () { init(); });

function init() {
    stage = new createjs.Stage(document.getElementById("testcanvas"));
    points = new Array();

    // drawing
    graphics = new createjs.Graphics();
    graphics.setStrokeStyle(1);

    stage.onMouseDown = function (e) {
        handleStageMouseDown(e);
    };

    // setting up the ticker
    createjs.Ticker.setFPS(60);
    createjs.Ticker.addListener(window);
}

function handleStageMouseDown(e) {
    var x = stage.mouseX,
                y = stage.mouseY;

    points.push(new Point(x, y, false));

    var rect = new createjs.Shape();
    rect.graphics.beginStroke(initialStroke).drawRect(x, y, 1, 1);

    stage.addChild(rect);

    stage.onMouseUp = function (e) {
        handleStageMouseUp(e, rect);
    }

    stage.onMouseMove = function (e) {
        handleStageMouseMove(e, rect);
    };
}

function handleStageMouseMove(e, rect) {

    var x0 = points[points.length - 1].x,
                y0 = points[points.length - 1].y,
                w = stage.mouseX - x0,
                h = stage.mouseY - y0;

    rect.graphics.beginStroke(initialStroke).drawRect(x0, y0, w, h);

    stage.onMouseUp = function (e) {
        handleStageMouseUp(e, rect);
    }
}

function handleStageMouseUp(e, rect) {
    var x0 = points[points.length - 1].x,
                y0 = points[points.length - 1].y,
                x1 = stage.mouseX,
                y1 = stage.mouseY,
                w = x1 - x0,
                h = y1 - y0;

    rect.graphics.beginFill(initialStroke).drawRect(x0, y0, w, h);
    rect.graphics.beginStroke(finalStroke).drawRect(x0, y0, w, h);

    points.push(new Point(x1, y1, true));

    stage.onMouseMove = null;
    stage.onMouseUp = null;

}

function tick() {
    stage.update();
}