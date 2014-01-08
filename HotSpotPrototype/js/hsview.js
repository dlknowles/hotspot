var userAgent = navigator.userAgent.toLowerCase();

// Figure out what browser is being used
var browser = {
    version: (userAgent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/) || [0, '0'])[1],
    safari: /webkit/.test(userAgent),
    opera: /opera/.test(userAgent),
    msie: /msie/.test(userAgent) && !/opera/.test(userAgent),
    mozilla: /mozilla/.test(userAgent) && !/(compatible|webkit)/.test(userAgent)
};

var msg,
    msgDiv,
    msgHeader,
    mapDiv,
    areas,
    offsetX = -100,
    offsetY = -10;

function init() {
    msgDiv = $('#message');
    msgDiv.hide();
    msgHeader = $('#message_header');
    mapDiv = $("#image_map");
    areas = $('area');

    $('img').mapster({
        stroke: true,
        strokeColor: '333333',
        fillColor: '41B7D8',
        fillOpacity: 0.3,
        scaleMap: false
    });

    areas.mapster('set', true);

    areas.click(function (e) {
        msg.html($(this).attr("alt"));
        msgDiv.css("top", mapDiv.offset().top);
        msgDiv.css("left", mapDiv.offset().left);
        msgDiv.show();

        if (browser.mozilla) {
            $(this).mapster('set', true);
        }
        else {
            $(this).mapster('set', false);
        }

        return false;
    });

    msgHeader.mousedown(function (e) {
        $(document).mousemove(function (e) {
            msgDiv.css("left", e.pageX + offsetX);
            msgDiv.css("top", e.pageY + offsetY);
        });

        $(document).mouseup(function (e) {
            $(document).unbind('mousemove');
            $(document).unbind('mouseup');
        });
    });

    $('#message_closer').click(function (e) { msgDiv.hide(); });
}
