function Point(x, y, isLast) {
    if (isLast == undefined || isLast == null) {
        isLast = false;
    }

    this.x = x;
    this.y = y;
    this.isLast = isLast;
    this.toArray = function () {
        return [x, y];
    };
}

function PointArray() {
    Array.call(this);
}

PointArray.prototype = new Array();
PointArray.prototype.constructor = Array;
PointArray.prototype.toArray = function () {
    var points = new Array();

    for (var i = 0; i < this.length; ++i) {
        points.push(this[i].x, this[i].y);
    }

    return points;
}
PointArray.prototype.toCoordinateArray = function () {
    var coords = new Array();

    for (var i = 0; i < this.length; ++i) {
        coords.push(this[i].x);
        coords.push(this[i].y);
    }

    return coords;
}