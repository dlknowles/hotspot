<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="HotspotTest.aspx.cs" Inherits="HotSpotPrototype.HotspotTest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<asp:ImageMap ImageUrl="~/images/building.png" runat="server" ID="imgHotspot" GenerateEmptyAlternateText="true" HotSpotMode="PostBack" Width="800" Height="600">
        <asp:RectangleHotSpot HotSpotMode="PostBack" Left="253" Top="125" Right="313" Bottom="193" AlternateText="Test" />
        <asp:PolygonHotSpot HotSpotMode="PostBack" Coordinates="253,125,313,125,313,193,253,193" AlternateText="Test" />
        
    </asp:ImageMap>
</asp:Content>
