SHAPE_TYPE = {
    RECT: 0,
    POLY: 1,
    CIRCLE: 2
};

function enableElement(elem) {
    if (elem.attr('disabled')) elem.removeAttr('disabled');
}

function disableElement(elem) {
    if (!elem.attr('disabled')) elem.attr('disabled', 'disabled');
}

function getDistance(x0, y0, x1, y1) {
    var x2 = (x1 - x0) * (x1 - x0),
                y2 = (y1 - y0) * (y1 - y0);

    return Math.sqrt(x2 + y2);
}

function makeAjaxCall(url, data, onsuccess, onerror) {
    if (!data || data == '') data = '{}';

    $.ajax({
        type: "POST",
        url: url,
        data: data,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: onsuccess
    });
}

function isEven(n) {
    return (n % 2) == 0;
}
