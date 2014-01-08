function Hotspot(shape) {
    this.shape = (shape || null);
    this.id = 0;
    this.shapeType = '';
    this.coordinates = new Array();
    this.width = 0;
    this.height = 0;
    this.name = 'Test';
    this.description = 'This is a test.';
}

Hotspot.prototype.toJSON = function (includeId) {
    if (!includeId) includeId = false;

    var jstr = "{";

    if (includeId == true) {
        jstr += "'id':'" + this.id + "',";
    }

    jstr += "'shapeType':'" + this.shapeType + "'," +
                            "'coordinates':[" + this.coordinates + "]," +
                            "'width':" + this.width + "," +
                            "'height':" + this.height + "," +
                            "'name':'" + this.name + "'," +
                            "'description':'" + this.description + "'}";
    return jstr;
};