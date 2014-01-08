var stage,
    g,
    points,
    picture;

function Point(x, y, isLast) {
    if (isLast == undefined || isLast == null) {
        isLast = false;
    }

    this.x = x;
    this.y = y;
    this.isLast = isLast;
}

function init() {
    
    stage = new createjs.Stage(document.getElementById("canvas"));
    points = new Array();

    // drawing
    g = new createjs.Graphics();

    picture = new createjs.Bitmap("../images/building.png");
    picture.regX = picture.image.width * 0.5;
    picture.regY = picture.image.height * 0.5;
    stage.addChild(picture);


    var s = new createjs.Shape(g);
    s.width = 640;
    s.height = 480;
    stage.addChild(s);

    stage.onClick = function (e) {
        points.push(new Point(stage.mouseX, stage.mouseY, false));
        drawPoints();
        setCoordsField();
    };

    stage.onDoubleClick = function (e) {
        points.pop();
        points.push(new Point(stage.mouseX, stage.mouseY, true));
        drawPoints();
        setCoordsField();
    }

    // setting up the ticker
    createjs.Ticker.setFPS(60);
    createjs.Ticker.addListener(window);
}

function setCoordsField() {
    var coordStr = '',
                pointsLength = points.length;

    if (pointsLength > 0) {
        for (var i = 0; i < pointsLength; ++i) {
            if (coordStr != '') coordStr += ',';

            coordStr += points[i].x + ',' + points[i].y;
        }
    }

    coordsField.val(coordStr);
}

function drawPoints(displayLog) {
    var newPath = true;

    if (points.length > 0) {
        g.clear();
        g.setStrokeStyle(1); // sets thickness
        g.beginStroke(createjs.Graphics.getRGB(0, 0, 0)); // set color
        g.beginFill(createjs.Graphics.getRGB(100, 100, 100, 0.6));

        for (var i = 0; i < points.length; ++i) {
            if (newPath) {
                g.moveTo(points[i].x, points[i].y);
                newPath = false;
            } else {
                g.lineTo(points[i].x, points[i].y);
            }

            if (points[i].isLast) {
                g.closePath();
                newPath = true;
            }
        }
    }

    if (displayLog) {
        for (var i = 0; i < points.length; ++i) {
            console.log('points[' + i + '] { x:' + points[i].x + ', y:' + points[i].y + ', isLast:' + points[i].isLast + ' }');
        }
    }
}

// done every createJS tick
function tick() {
    // update the stage so that everything to now is rendered
    stage.update();
}