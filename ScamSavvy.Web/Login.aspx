<%@ Page Title="Log in | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="LoginPage" %>
<%-- Owner: Ahmad (Accounts module) --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .account-card { max-width: 28rem; margin: 0 auto; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card ss-card account-card">
        <div class="card-body p-4 p-md-5 ss-form">
            <h1 class="h3 mb-1">Log in</h1>
            <p class="text-muted mb-4">Welcome back to Scam Savvy.</p>

            <asp:Label ID="lblMessage" runat="server" EnableViewState="false" Visible="false" />

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtEmail" CssClass="form-label" Text="Email" />
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" MaxLength="150" TextMode="Email" autocomplete="username" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Enter your email." Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="mb-4">
                <asp:Label runat="server" AssociatedControlID="txtPassword" CssClass="form-label" Text="Password" />
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="current-password" ValidateRequestMode="Disabled" />
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Enter your password." Display="Dynamic" CssClass="text-danger" />
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Log in" CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" />

            <p class="text-center mt-3 mb-0">
                New here?
                <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="~/Register.aspx" Text="Create an account" />
            </p>
        </div>
    </div>
</asp:Content>
