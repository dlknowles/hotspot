<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="AddHotspot.aspx.cs" Inherits="HotSpotPrototype.AddHotspot" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="http://code.createjs.com/easeljs-0.5.0.min.js"></script>
    <script src="js/hsedit.js"></script>
    <script>
        var coordsField;

        $(document).ready(function () {
            coordsField = $('#<%=coords.ClientID %>'); 
            init();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <header>
        <h2>Add a Hotspot</h2>
    </header>

    <div id="instructions">
        Click the image to create the corners of the hotspot. Then fill out the description below the image and click "Submit".
    </div>

    <asp:HiddenField ID="coords" runat="server" />
    
    <canvas id="canvas" width="800" height="600"></canvas>

    <div id="details_container">
        <fieldset>
            <legend>Hotspot Details</legend>
            
            <asp:Label runat="server" ID="lblName" AssociatedControlID="txtName" Text="Name: " />
            <asp:TextBox runat="server" ID="txtName" />

            <asp:Label runat="server" ID="lblDescription" AssociatedControlID="txtDescription" Text="Description: " />
            <asp:TextBox runat="server" ID="txtDescription" TextMode="MultiLine" />
        </fieldset>

        <asp:Button ID="btnSubmit" runat="server" Text="Submit" onclick="btnSubmit_Click" />
    </div>
</asp:Content>
