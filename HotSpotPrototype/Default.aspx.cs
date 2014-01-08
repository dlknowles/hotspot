using System;
using System.Web.UI.WebControls;
using System.Linq;

namespace HotSpotPrototype
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {        
            foreach (HotspotCls h in StaticVariables.Hotspots)
            {
                switch (h.ShapeType)
                {
                    case "Rect":
                        AddRectangleHotspot(h);                          
                        break;
                    case "Polygon":
                        AddPolygonHotspot(h);
                        break;
                    case "Circle":
                        AddCircleHotspot(h);
                        break;
                }
            }
        }
             
        private void AddRectangleHotspot(HotspotCls h)
        {
            RectangleHotSpot area = new RectangleHotSpot();
            area.AlternateText = h.Description;
            area.PostBackValue = h.ID.ToString();
            area.HotSpotMode = HotSpotMode.PostBack;
            area.Left = h.Coordinates[0];
            area.Top = h.Coordinates[1];
            area.Bottom = h.Coordinates[1] + h.Height;
            area.Right = h.Coordinates[0] + h.Width;

            imgHotspot.HotSpots.Add(area);
        }

        private void AddPolygonHotspot(HotspotCls h)
        {
            PolygonHotSpot area = new PolygonHotSpot();
            area.AlternateText = h.Description;
            area.PostBackValue = h.ID.ToString();
            area.HotSpotMode = HotSpotMode.PostBack;
            area.Coordinates = string.Join(",", h.Coordinates.Select(x => x.ToString()).ToArray());

            imgHotspot.HotSpots.Add(area);
        }

        private void AddCircleHotspot(HotspotCls h)
        {
            CircleHotSpot area = new CircleHotSpot();
            area.AlternateText = h.Description;
            area.PostBackValue = h.ID.ToString();
            area.HotSpotMode = HotSpotMode.PostBack;
            area.X = h.Coordinates[0];
            area.Y = h.Coordinates[1];
            area.Radius = h.Width;

            imgHotspot.HotSpots.Add(area);
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddEditHotspot.aspx");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddEditHotspot.aspx");
        }
    }
}