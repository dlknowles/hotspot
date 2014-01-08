<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="AddEditHotspot.aspx.cs" Inherits="HotSpotPrototype.AddEditHotspot" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #container { margin: 0; padding: 0; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
    <script src="js/hsedit2.js"></script>
    <script>
        
        // when doc is ready, run the init function.
        $(document).ready(function () { init('AddEditHotspot.aspx'); });
    </script>
</asp:Content>
