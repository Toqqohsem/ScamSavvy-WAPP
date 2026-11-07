<%@ Page Title="Moderate Reports | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ModerateReports.aspx.cs" Inherits="Admin_ModerateReports" %>
<%-- Owner: Lyu Jiaxin (Member 4) --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Moderate Reports only (internal CSS) */
        .moderate-text { max-width: 30rem; white-space: pre-line; }
        .moderate-ids { word-break: break-all; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="site-page-header d-flex flex-wrap justify-content-between align-items-end gap-2">
        <div>
            <h1>Moderate Reports</h1>
            <p>Check each scam report before it appears in the public repository. Approve real reports, reject spam or reports with personal details.</p>
        </div>
        <asp:HyperLink ID="lnkDashboard" runat="server" NavigateUrl="~/Admin/Dashboard.aspx" CssClass="btn btn-outline-primary" Text="Back to dashboard" />
    </div>

    <asp:Label ID="lblMessage" runat="server" Visible="false" EnableViewState="false" />

    <div class="site-card mb-3">
        <div class="site-card-body d-flex flex-wrap align-items-end gap-3">
            <div>
                <asp:Label runat="server" AssociatedControlID="ddlStatus" CssClass="form-label" Text="Show" />
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                    <asp:ListItem Value="Pending" Text="Waiting for review" Selected="True" />
                    <asp:ListItem Value="Approved" Text="Approved" />
                    <asp:ListItem Value="Rejected" Text="Rejected" />
                    <asp:ListItem Value="" Text="All reports" />
                </asp:DropDownList>
            </div>
            <p class="small text-muted mb-1"><asp:Literal ID="litSummary" runat="server" /></p>
        </div>
    </div>

    <div class="table-responsive">
        <asp:GridView ID="gvReports" runat="server" AutoGenerateColumns="false" DataKeyNames="ReportID"
            CssClass="table align-middle site-table" GridLines="None" UseAccessibleHeader="true"
            AllowPaging="true" PageSize="10" PagerStyle-CssClass="site-pager"
            EmptyDataText="No reports with this status."
            OnPageIndexChanging="gvReports_PageIndexChanging"
            OnRowCommand="gvReports_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="Report">
                    <ItemTemplate>
                        <asp:HyperLink runat="server" CssClass="fw-semibold" NavigateUrl='<%# "~/ScamDetail.aspx?id=" + Eval("ReportID") %>'
                            Text='<%# Server.HtmlEncode(Convert.ToString(Eval("Title"))) %>' Target="_blank" />
                        <div class="small text-muted"><%# Server.HtmlEncode(Convert.ToString(Eval("CategoryName"))) %></div>
                        <div class="small moderate-text"><%# Server.HtmlEncode(Shorten(Eval("Description"))) %></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Scammer's details">
                    <ItemTemplate>
                        <div class="small moderate-ids"><%# Identifiers(Eval("ScammerPhone"), Eval("ScammerAccount"), Eval("ScammerUrl")) %></div>
                        <asp:HyperLink runat="server" CssClass="small" Text="View screenshot" Target="_blank"
                            NavigateUrl='<%# EvidenceUrl(Eval("EvidencePath")) %>' Visible='<%# EvidenceUrl(Eval("EvidencePath")).Length > 0 %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Sent by">
                    <ItemTemplate>
                        <%# Eval("SubmitterName") == DBNull.Value ? "<span class='text-muted'>Deleted user</span>" : Server.HtmlEncode(Convert.ToString(Eval("SubmitterName"))) %>
                        <div class="small text-muted"><%# Convert.ToString(Eval("SubmitterRole")) %></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='site-badge <%# StatusBadge(Eval("Status")) %>'><%# Eval("Status") %></span>
                        <%# (bool)Eval("IsSample") ? "<span class='site-badge site-badge-muted'>Sample</span>" : "" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CreatedAt" HeaderText="Sent" DataFormatString="{0:dd MMM yyyy}" ItemStyle-CssClass="text-nowrap" />
                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-nowrap">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnApprove" runat="server" CommandName="SetStatus" CommandArgument='<%# Eval("ReportID") + "|Approved" %>'
                            Text="Approve" CssClass="btn btn-sm btn-outline-success" CausesValidation="false" Visible='<%# (string)Eval("Status") != "Approved" %>' />
                        <asp:LinkButton ID="btnReject" runat="server" CommandName="SetStatus" CommandArgument='<%# Eval("ReportID") + "|Rejected" %>'
                            Text="Reject" CssClass="btn btn-sm btn-outline-secondary" CausesValidation="false" Visible='<%# (string)Eval("Status") != "Rejected" %>' />
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteReport" CommandArgument='<%# Eval("ReportID") %>'
                            Text="Delete" CssClass="btn btn-sm btn-outline-danger" CausesValidation="false"
                            OnClientClick="return confirm('Delete this report and its screenshot permanently?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
