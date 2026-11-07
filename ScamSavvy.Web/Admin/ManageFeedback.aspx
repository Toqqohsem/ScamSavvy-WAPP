<%@ Page Title="Manage Feedback | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageFeedback.aspx.cs" Inherits="Admin_ManageFeedback" %>
<%-- Owner: Lyu Jiaxin (Feedback module). Rebuilt on the team template by Ahmad during integration. --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Manage Feedback only (internal CSS) */
        .feedback-stars { color: #f4a300; letter-spacing: 1px; white-space: nowrap; }
        .feedback-text { max-width: 28rem; white-space: pre-line; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="site-page-header d-flex flex-wrap justify-content-between align-items-end gap-2">
        <div>
            <h1>Manage Feedback</h1>
            <p>Review what visitors and members have told us, then mark each item reviewed, resolved or rejected.</p>
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
                    <asp:ListItem Value="" Text="All feedback" />
                    <asp:ListItem Value="Pending" Text="Pending" Selected="True" />
                    <asp:ListItem Value="Reviewed" Text="Reviewed" />
                    <asp:ListItem Value="Resolved" Text="Resolved" />
                    <asp:ListItem Value="Rejected" Text="Rejected" />
                </asp:DropDownList>
            </div>
            <p class="small text-muted mb-1"><asp:Literal ID="litSummary" runat="server" /></p>
        </div>
    </div>

    <div class="table-responsive">
        <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="false" DataKeyNames="FeedbackID"
            CssClass="table align-middle site-table" GridLines="None" UseAccessibleHeader="true"
            AllowPaging="true" PageSize="10" PagerStyle-CssClass="site-pager"
            EmptyDataText="No feedback with this status."
            OnPageIndexChanging="gvFeedback_PageIndexChanging"
            OnRowCommand="gvFeedback_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="From">
                    <ItemTemplate>
                        <div class="fw-semibold"><%# Server.HtmlEncode(Convert.ToString(Eval("Name"))) %></div>
                        <div class="small text-muted"><%# Server.HtmlEncode(Convert.ToString(Eval("Email"))) %></div>
                        <%# Eval("UserID") == DBNull.Value ? "" : "<span class='site-badge site-badge-muted'>Member</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="About">
                    <ItemTemplate><%# CategoryName(Eval("Category")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Rating">
                    <ItemTemplate>
                        <span class="feedback-stars" title='<%# Eval("Rating") + " out of 5" %>'><%# Stars(Eval("Rating")) %></span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Feedback">
                    <ItemTemplate><div class="feedback-text"><%# Server.HtmlEncode(Convert.ToString(Eval("Message"))) %></div></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate><span class='site-badge <%# StatusBadge(Eval("Status")) %>'><%# Eval("Status") %></span></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CreatedAt" HeaderText="Sent" DataFormatString="{0:dd MMM yyyy}" />
                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-nowrap">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnReviewed" runat="server" CommandName="SetStatus" CommandArgument='<%# Eval("FeedbackID") + "|Reviewed" %>'
                            Text="Reviewed" CssClass="btn btn-sm btn-outline-primary" CausesValidation="false" Visible='<%# (string)Eval("Status") != "Reviewed" %>' />
                        <asp:LinkButton ID="btnResolved" runat="server" CommandName="SetStatus" CommandArgument='<%# Eval("FeedbackID") + "|Resolved" %>'
                            Text="Resolved" CssClass="btn btn-sm btn-outline-success" CausesValidation="false" Visible='<%# (string)Eval("Status") != "Resolved" %>' />
                        <asp:LinkButton ID="btnRejected" runat="server" CommandName="SetStatus" CommandArgument='<%# Eval("FeedbackID") + "|Rejected" %>'
                            Text="Reject" CssClass="btn btn-sm btn-outline-secondary" CausesValidation="false" Visible='<%# (string)Eval("Status") != "Rejected" %>' />
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteFeedback" CommandArgument='<%# Eval("FeedbackID") %>'
                            Text="Delete" CssClass="btn btn-sm btn-outline-danger" CausesValidation="false"
                            OnClientClick="return confirm('Delete this feedback permanently?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
