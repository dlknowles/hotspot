             
namespace HotSpotPrototype
{
    public class HotspotCls
    {
        private long _id;

        public string ShapeType { get; set; }
        public int[] Coordinates { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public long ID { get { return _id; } set { _id = value; } }

        public HotspotCls(string shapeType, int[] coords, int width, int height, string name, string desc)
        {
            ShapeType = shapeType;
            Coordinates = coords;
            Width = width;
            Height = height;
            Name = name;
            Description = desc;
        }

        public HotspotCls()
        {
            ShapeType = "";
            Coordinates = new int[2];
            Width = 0;
            Height = 0;
            Name = "";
            Description = "";
            _id = 0;
        }

        public HotspotCls(long id)
        {
            // TODO: Get hotspot data from database.
            // get hotspot with id from data
        }
    }
}