<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="CanvasTestbed.aspx.cs" Inherits="HotSpotPrototype.CanvasTestbed" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="message"></div>

    <div id="editorbuttons">
        <button type="button" id="btnSelect">Selector</button>
        <button type="button" id="btnRect">Rectangle</button>
        <button type="button" id="btnPoly">Polygon</button>
        <button type="button" id="btnCircle">Circle</button>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <button type="button" id="btnSubmit">Create Hotspot</button>
    </div>
    
    <div id="editform">
        <fieldset>
            <legend>Hotspot details</legend>

            <label for="txtName">Name:</label>
            <input type="text" id="txtName" name="txtName" placeholder="Name" autofocus="autofocus" />

            <label for="txtDescription">Description:</label>
            <textarea id="txtDescription" name="txtDescription" placeholder="Description" rows="2" cols="20"></textarea>

            <div class="button_box">
                <button type="button" id="btnSave">Save</button>   
                <button type="button" id="btnDelete">Delete</button>
            </div>
        </fieldset>
    </div>
    
    <div id="container"></div>
        
    <script src="js/lib/kinetic-v4.3.3.min.js"></script>
    <script src="js/Utilities.js"></script>
    <script src="js/Hotspot.js"></script>
    <script>
        // variables
        var CANVAS_HEIGHT = 600,
            CANVAS_WIDTH = 800;
  
        var rectbutton,     
            polybutton,     
            circlebutton,
            submitbutton,
            selectbutton,
            deletebutton,
            editbutton,
            savebutton,
            nametext,
            descriptiontext,
            messageDiv,
            editform,
            pagename;

        var stage,
            layer;

        var background,             // the background shape. the layer needs this to build shapes on
            rect,                   // represents a rectangle shape in design mode
            poly,                   // represents a polygon shape in design mode
            circle,                 // represetns a circle shape in design mode
            polypoints,             // array of Point objects stored for poly
            shapeType,              // the type of shape currently being built in design mode
            hsFillColor,            // fill color for submitted hotspot shapes
            fillColor,              // fill color for hotspot shapes in design mode
            strokeColor,            // stroke color for shapes
            selectedFillColor,      // fill color for selected hotspot shapes
            hotspots;               // array of hotspots that have been created and placed in data

        var moving,                 // is cursor moving. used to build rects and circles
            selectEnabled,          // can shapes be selected?
            selectedShape;          // the currently selected shape

        // when doc is ready, run the init function.
        $(document).ready(init);

        // initialization functions
        function init() {
            setVars();
            setPageElements();
            setStage();
            addImage();
            getHotspots();
        }

        function setPageElements() {
            pagename = 'CanvasTestbed.aspx';

            messageDiv = $('#message');
            editform = $('#editform');
            rectbutton = $('#btnRect');
            polybutton = $('#btnPoly');
            circlebutton = $('#btnCircle');
            selectbutton = $('#btnSelect');
            submitbutton = $("#btnSubmit");
            deletebutton = $('#btnDelete');
            editbutton = $('#btnEdit');
            savebutton = $('#btnSave');
            nametext = $('#txtName');
            descriptiontext = $('#txtDescription');

            selectbutton.attr('disabled', 'disabled');
            submitbutton.attr('disabled', 'disabled');

            editform.hide();

            selectbutton.click(function (e) { selectbuttonOnClick(e); });
            savebutton.click(function (e) { savebuttonOnClick(e); });
            editbutton.click(function (e) { editbuttonOnClick(e); });
            deletebutton.click(function (e) { deletebuttonOnClick(e); });
            submitbutton.click(function (e) { submitbuttonOnClick(e); });
            rectbutton.click(function (e) { rectbuttonOnClick(e); });
            polybutton.click(function (e) { polybuttonOnClick(e); });
            circlebutton.click(function (e) { circlebuttonOnClick(e); });
        }

        function setVars() {
            fillColor = 'rgba(65, 183, 216, 0.5)';
            hsFillColor = 'rgba(100, 0, 0, 0.5)';
            selectedFillColor = 'rgba(100, 0, 0, 0.7)';
            strokeColor = '#333333';
            moving = false;
            selectEnabled = true;
        }

        function setStage() {
            layer = new Kinetic.Layer();
            stage = new Kinetic.Stage({
                container: 'container',
                width: CANVAS_WIDTH,
                height: CANVAS_HEIGHT
            });


            background = new Kinetic.Rect({
                x: 0,
                y: 0,
                width: stage.getWidth(),
                height: stage.getHeight(),
                fill: 'rgba(255, 255, 255, 0)'
            });

            layer.add(background);

            stage.add(layer);
        }

        function setDefaults() {
            disableElement(selectbutton);
            enableElement(rectbutton);
            enableElement(polybutton);
            enableElement(circlebutton);
            disableElement(submitbutton);

            stage.off('mousedown mousemove mouseup');

            selectEnabled = true;

            removeShape(rect);
            removeShape(poly);
            removeShape(circle);

            if (selectedShape) {
                unselectShape();
            }
        }

        // page element event handlers
        function selectbuttonOnClick(e) {
            setDefaults();
            layer.drawScene();
        }

        function rectbuttonOnClick(e) {
            selectEnabled = false;
            unselectShape();

            enableElement(selectbutton);
            disableElement(rectbutton);
            enableElement(polybutton);
            enableElement(circlebutton);
            disableElement(submitbutton);

            handleRectangle();
        }

        function polybuttonOnClick(e) {
            selectEnabled = false;
            unselectShape();

            enableElement(selectbutton);
            enableElement(rectbutton);
            disableElement(polybutton);
            enableElement(circlebutton);
            disableElement(submitbutton);

            handlePolygon();
        }

        function circlebuttonOnClick(e) {
            selectEnabled = false;
            unselectShape();

            enableElement(selectbutton);
            enableElement(rectbutton);
            enableElement(polybutton);
            disableElement(circlebutton);
            disableElement(submitbutton);

            handleCircle();
        }

        function deletebuttonOnClick(e) {
            if (selectedShape) {
                deleteHotspot(e);
                unselectShape();
            }
        }

        function savebuttonOnClick(e) {
            editHotspot(e);
        }

        function submitbuttonOnClick(e) {
            createHotspot(e);
        }
        
        // AJAX calls
        function getHotspots() {
            hotspots = new Array();

            $.ajax({
                type: "POST",
                url: pagename + "/GetHotspots",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var d = data.d;
                    var len = d.length;

                    for (var i = 0; i < len; ++i) {

                        var hs = new Hotspot();
                        hs.shapeType = d[i].ShapeType;
                        hs.coordinates = d[i].Coordinates;
                        hs.description = d[i].Description;
                        hs.height = d[i].Height;
                        hs.id = d[i].ID;
                        hs.name = d[i].Name;
                        hs.width = d[i].Width;

                        hotspots.push(hs);
                    }

                    renderAllHotspots();
                }
            });
        }

        function deleteHotspot(e) {
            var hs;
            var l = hotspots.length
            for (var i = 0; i < l; ++i) {
                if (hotspots[i].shape == selectedShape) {
                    hs = hotspots[i];
                    break;
                }
            }

            $.ajax({
                type: "POST",
                url: pagename + "/DeleteHotspot",
                data: "{'id':" + hs.id + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var d = data.d;
                }
            });

            unselectShape();
            removeShape(hs.shape);
        }

        function editHotspot(e) {
            var hs;
            var l = hotspots.length
            for (var i = 0; i < l; ++i) {
                if (hotspots[i].shape == selectedShape) {
                    hs = hotspots[i];
                    break;
                }
            }

            if (hs) {
                hs.name = nametext.val();
                hs.description = descriptiontext.val();

                $.ajax({
                    type: "POST",
                    url: pagename + "/EditHotspot",
                    data: hs.toJSON(true),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        var d = data.d;

                        nametext.val('');
                        descriptiontext.val('');

                        unselectShape();
                    }
                });
            }
        }

        function createHotspot(e) {          
            var hs = new Hotspot();
            
            switch (shapeType) {
                case SHAPE_TYPE.RECT:
                    hs.shapeType = 'Rect';
                    hs.shape = rect;
                    hs.coordinates = [rect.getX(), rect.getY()];
                    hs.width = rect.getWidth();
                    hs.height = rect.getHeight();
                    removeShape(rect);
                    break;
                case SHAPE_TYPE.POLY:
                    hs.shapeType = 'Polygon';
                    hs.shape = poly;
                    hs.coordinates = polypoints;
                    removeShape(poly);
                    break;
                case SHAPE_TYPE.CIRCLE:
                    hs.shapeType = 'Circle';
                    hs.shape = circle;
                    hs.coordinates = [circle.getX(), circle.getY()];
                    hs.width = parseInt(circle.getRadius());
                    hs.height = parseInt(circle.getRadius());
                    removeShape(circle);
                    break;
            }

            $.ajax({
                type: "POST",
                url: pagename + "/CreateHotspot",
                data: hs.toJSON(),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    setDefaults();
                    var d = data.d;

                    hs.id = d.ID;

                    hotspots.push(hs);

                    renderHotspot(hs);
                    selectShape(hs.shape);
                }
            });
        }

        // kinetic js related
        function selectShape(shape) {
            unselectShape(false);
            selectedShape = shape;
            shape.setDraggable(true);
            shape.setFill(selectedFillColor);
            layer.draw();

            var l = hotspots.length
            for (var i = 0; i < l; ++i) {
                if (hotspots[i].shape == shape) {
                    setDetailsText(hotspots[i]);
                    break;
                }
            }

            if (editform.is(":hidden")) editform.slideDown("fast");
        }

        function unselectShape(hideEdit) {
            if (hideEdit == undefined || hideEdit == null) hideEdit = true;

            if (selectedShape) {
                selectedShape.setFill(hsFillColor);
                selectedShape = undefined;
                shape.setDraggable(false);
                layer.draw();

                if (!editform.is(":hidden") && hideEdit == true) editform.slideUp("fast");
            }
        }

        function renderHotspot(hs) {
            switch (hs.shapeType) {
                case 'Rect':
                    shape = new Kinetic.Rect({
                        x: hs.coordinates[0],
                        y: hs.coordinates[1],
                        width: hs.width,
                        height: hs.height,
                        fill: hsFillColor,
                        stroke: 'black',
                        strokeWidth: 1
                    });
                    break;
                case 'Polygon':
                    shape = new Kinetic.Polygon({
                        points: hs.coordinates,
                        fill: hsFillColor,
                        stroke: 'black',
                        strokeWidth: 1
                    });
                    break;
                case 'Circle':
                    shape = new Kinetic.Circle({
                        x: hs.coordinates[0],
                        y: hs.coordinates[1],
                        radius: hs.width,
                        fill: hsFillColor,
                        stroke: 'black',
                        strokeWidth: 1
                    });
                    break;
            }

            shape.on('mousedown', function (e) {
                if (selectEnabled) {
                    selectShape(this);
                    if (editform.is(":hidden")) editform.slideDown("fast");
                }
            });

            shape.on('mouseover', function (e) {
                if (selectEnabled) {
                    document.body.style.cursor = 'pointer';
                }
            });

            shape.on('mouseout', function (e) {
                document.body.style.cursor = 'default';
            });

            shape.on('dragend', function (e) {
                updateHotspotPostion(this);
            });

            hs.shape = shape;
            layer.add(shape);
            shape.moveToTop();
            layer.draw();
        }

        function updateHotspotPostion(shape) {
            var hotspotlength = hotspots.length;

            for (var i = 0; i < hotspotlength; ++i) {
                var h = hotspots[i];
                var coords = new Array();

                if (h.shape == shape) {
                    switch (h.shapeType) {
                        case 'Rect':
                        case 'Circle':
                            coords.push(shape.getX());
                            coords.push(shape.getY());
                            break;
                        case 'Polygon':
                            var points = shape.getPoints();
                            var plen = points.length;

                            for (var pi = 0; pi < plen; ++pi) {
                                coords.push(points[pi].x);
                                coords.push(points[pi].y);
                            }
                            break;
                    }
                    h.coordinates = coords;

                    break;
                }
            }
        }

        function renderAllHotspots() {
            var hotspotlength = hotspots.length;

            for (var i = 0; i < hotspotlength; ++i) {
                renderHotspot(hotspots[i]);
            }
        }

        function addImage() {
            var imageObj = new Image();
            imageObj.onload = function () {
                var building = new Kinetic.Image({
                    x: 0,
                    y: 0,
                    image: imageObj,
                    width: CANVAS_WIDTH,
                    height: CANVAS_HEIGHT
                });

                layer.add(building);
                building.moveToBottom();
                layer.draw();
            };
            imageObj.src = 'images/building.png';
        }

        function removeShape(shape) {
            if (shape) {
                shape.setFill('rgba(0, 0, 0, 0)');
                shape.setStroke('rgba(0, 0, 0, 0)');

                if (shapeType == SHAPE_TYPE.RECT && shape.shapeType == 'Rect') {
                    shape.setWidth(0);
                    shape.setHeight(0);
                } else if (shapeType == SHAPE_TYPE.CIRCLE && shape.shapeType == 'Circle') {
                    shape.setRadius(0);
                }

                var temp = new Array();
                var l = hotspots.length;


                for (var i = 0; i < l; ++i) {
                    if (hotspots[i].shape != shape) {
                        temp.push(hotspots[i]);
                    }
                }

                hotspots = temp;
            }
            layer.draw();
        }

        function handlePolygon() {
            if (!selectEnabled) {
                stage.off('mousedown mousemove mouseup');
                polypoints = new Array();  
                removeShape(rect);
                removeShape(circle);
                shapeType = SHAPE_TYPE.POLY;

                stage.on('mousedown', function () {
                    var mousePos = stage.getMousePosition(),
                    x = mousePos.x,
                    y = mousePos.y;

                    polypoints.push(x);
                    polypoints.push(y);
                    if (!poly) {
                        poly = new Kinetic.Polygon({
                            points: [],
                            fill: fillColor,
                            stroke: 'black',
                            strokeWidth: 1
                        });

                        layer.add(poly);
                    }

                    poly.setFill(fillColor);
                    poly.setStroke('black');
                    poly.setPoints(polypoints); 

                    layer.drawScene();

                    enableElement(submitbutton);
                });
            }
        }

        function handleRectangle() {
            if (!selectEnabled) {
                stage.off('mousedown mousemove mouseup');
                removeShape(poly);
                removeShape(circle);
                shapeType = SHAPE_TYPE.RECT;

                stage.on('mousedown', function () {
                    enableElement(submitbutton);

                    if (moving) {
                        moving = false;
                        layer.draw();
                    } else {
                        var mousePos = stage.getMousePosition();

                        if (!rect) {
                            rect = new Kinetic.Rect({
                                x: 22,
                                y: 7,
                                width: 0,
                                height: 0,
                                fill: fillColor,
                                stroke: 'black',
                                strokeWidth: 1
                            });
                            layer.add(rect);
                        }

                        rect.setFill(fillColor);
                        rect.setStroke('black');
                        rect.setX(mousePos.x);
                        rect.setY(mousePos.y);

                        moving = true;
                        layer.drawScene();
                    }
                });

                stage.on('mousemove', function () {
                    if (moving) {
                        var mousePos = stage.getMousePosition();
                        var x = mousePos.x,
                        y = mousePos.y;

                        rect.setWidth(mousePos.x - rect.getX());
                        rect.setHeight(mousePos.y - rect.getY());
                        moving = true;
                        layer.drawScene();
                    }
                });

                stage.on('mouseup', function () {
                    moving = false;
                });
            }
        }

        function handleCircle() {
            if (!selectEnabled) {
                stage.off('mousedown mousemove mouseup');
                removeShape(rect);
                removeShape(poly);
                shapeType = SHAPE_TYPE.CIRCLE;

                stage.on('mousedown', function () {
                    if (moving) {
                        moving = false;
                        layer.draw();
                    } else {
                        var mousePos = stage.getMousePosition();

                        if (!circle) {
                            circle = new Kinetic.Circle({
                                x: 22,
                                y: 7,
                                radius: 0,
                                fill: fillColor,
                                stroke: 'black',
                                strokeWidth: 1
                            });
                            layer.add(circle);
                        }

                        circle.setFill(fillColor);
                        circle.setStroke('black');
                        circle.setX(mousePos.x);
                        circle.setY(mousePos.y);

                        moving = true;
                        layer.drawScene();

                        enableElement(submitbutton);
                    }
                });

                stage.on('mousemove', function () {
                    if (moving) {
                        var mousePos = stage.getMousePosition();
                        var x1 = mousePos.x,
                        y1 = mousePos.y,
                        radius = getDistance(circle.getX(), circle.getY(), x1, y1);

                        circle.setRadius(radius);
                        moving = true;
                        layer.drawScene();
                    }
                });

                stage.on('mouseup', function () {
                    moving = false;
                });
            }
        }

        // helper functions
        function setDetailsText(hs) {
            nametext.val(hs.name);
            descriptiontext.val(hs.description);
        }

    </script>
</asp:Content>
