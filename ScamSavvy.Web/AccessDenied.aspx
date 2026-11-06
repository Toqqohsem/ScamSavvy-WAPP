<%@ Page Title="Access denied | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="AccessDenied.aspx.cs" Inherits="AccessDenied" %>
<%-- Owner: Ahmad (Accounts module) --%>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card ss-card mx-auto" style="max-width: 36rem;">
        <div class="card-body p-4 p-md-5 text-center">
            <h1 class="h3">You can't open that page</h1>
            <p class="text-muted">
                That page needs a different role.
                <asp:Literal ID="litSignedInAs" runat="server" Mode="Encode" />
            </p>
            <div class="d-flex justify-content-center flex-wrap gap-2 mt-4">
                <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/Default.aspx" CssClass="btn btn-primary" Text="Back to Home" />
                <asp:LinkButton ID="btnSwitchUser" runat="server" CssClass="btn btn-outline-primary"
                    Text="Log in as someone else" CausesValidation="false" OnClick="btnSwitchUser_Click" />
            </div>
        </div>
    </div>
</asp:Content>
