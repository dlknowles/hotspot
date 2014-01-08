<%@ Page Title="Demo - Add Hotspot" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="HotSpotPrototype.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">   
    <script src="js/lib/jquery.imagemapster.js"></script>
    <script src="js/hsview.js"></script>
    <script>        
        $(document).ready(function () {
            msg = $('#<%= lblMessage.ClientID %>');
            init();
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <header>
        <h2>View Image</h2>
    </header>
    <div id="instructions">
        Click the colored regions on the image to view the description. 
    </div>
    <div id="image_map">
    <asp:ImageMap ImageUrl="~/images/building.png" runat="server" ID="imgHotspot" GenerateEmptyAlternateText="true" HotSpotMode="PostBack">
    </asp:ImageMap>
        <div id="message" class="message_box">
            <div id="message_header">
                Room details
                <span id="message_closer">X</span>
            </div>
            <div id="message_content">
                <asp:Label ID="lblMessage" CssClass="message_content" runat="server" />
            </div>    
            <div class="button_box">
                <asp:Button ID="btnEdit" runat="server" Text="Edit" onclick="btnEdit_Click" />
                <asp:Button ID="btnDelete" runat="server" Text="Delete" 
                    onclick="btnDelete_Click" />
            </div>    
        </div>
    </div>
</asp:Content>
