using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

namespace HotSpotPrototype
{
    public partial class CanvasTestbed : System.Web.UI.Page
    {
        // private static List<Hotspot> hotspots = new List<Hotspot>();
        private static int id = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        [WebMethod]
        public static HotspotCls CreateHotspot(string shapeType, int[] coordinates, int width, int height, string name, string description)
        {                         
            HotspotCls retval = new HotspotCls(shapeType, coordinates, width, height, name, description);

            retval.ID = ++id;
            StaticVariables.Hotspots.Add(retval);

            return retval;
        }

        [WebMethod]
        public static Boolean DeleteHotspot(int id)
        {
            foreach (HotspotCls h in StaticVariables.Hotspots)
            {
                if (h.ID == id)
                {
                    StaticVariables.Hotspots.Remove(h);
                    return true;
                }
            }

            return false;
        }

        [WebMethod]
        public static HotspotCls EditHotspot(int id, string shapeType, int[] coordinates, int width, int height, string name, string description)
        {
            // note: shapeType is only included because to the javascript toJSON method's formatting.

            // TODO: Position changes don't persist for polygons.
            foreach (HotspotCls h in StaticVariables.Hotspots)
            {
                if (h.ID == id)
                {
                    h.Coordinates = coordinates;
                    h.Width = width;
                    h.Height = height;
                    h.Name = name;
                    h.Description = description;

                    return h;
                }
            }

            return null;
        }

        [WebMethod]
        public static List<HotspotCls> GetHotspots()
        {
            if (StaticVariables.Hotspots.Count < 1)
            {
                GenerateHotspots();
            }

            return StaticVariables.Hotspots;
        }

        private static void GenerateHotspots()
        {
            int[] coords = new int[2];

            coords[0] = 0;
            coords[1] = 0;

            HotspotCls h = new HotspotCls("Rect", coords, 50, 50, "Test 1", "This is hotspot 1");
            h.ID = ++id;
            StaticVariables.Hotspots.Add(h);

            coords = new int[2];
            coords[0] = 200;
            coords[1] = 0;
            h = new HotspotCls("Rect", coords, 50, 50, "Test 2", "This is hotspot 2");
            h.ID = ++id;
            StaticVariables.Hotspots.Add(h);
        }

        [WebMethod]
        public static string GetDate()
        {
            return DateTime.Now.ToString();
        }
    }
}