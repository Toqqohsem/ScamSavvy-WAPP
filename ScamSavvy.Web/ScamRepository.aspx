<%@ Page Title="Scam Repository | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ScamRepository.aspx.cs" Inherits="ScamRepository" %>
<%-- Owner: Lyu Jiaxin (Member 4) --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Scam Repository only (internal CSS) */
        .repo-case .site-card-text { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
        .repo-ids { font-size: .85rem; color: var(--ss-muted); word-break: break-all; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="site-page-header d-flex flex-wrap justify-content-between align-items-end gap-2">
        <div>
            <h1>Scam Repository</h1>
            <p>Scams reported by the Scam Savvy community and checked by our team. Search by keyword, phone number, bank account or website.</p>
        </div>
        <asp:HyperLink ID="lnkReport" runat="server" NavigateUrl="~/Member/ReportScam.aspx" CssClass="btn btn-warning" Text="Report a scam" />
    </div>

    <asp:Panel ID="pnlFilter" runat="server" CssClass="site-card mb-4" DefaultButton="btnSearch">
        <div class="site-card-body row g-2 align-items-end">
            <div class="col-md-4">
                <asp:Label runat="server" AssociatedControlID="ddlCategory" CssClass="form-label" Text="Type of scam" />
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed" />
            </div>
            <div class="col-md-5">
                <asp:Label runat="server" AssociatedControlID="txtSearch" CssClass="form-label" Text="Search" />
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" MaxLength="100" ValidateRequestMode="Disabled"
                    placeholder="e.g. 012-345 0101, LHDN, loan fee" />
            </div>
            <div class="col-md-3 d-flex gap-2">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary flex-fill" CausesValidation="false" OnClick="Filter_Changed" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-primary" CausesValidation="false" OnClick="btnClear_Click" />
            </div>
        </div>
    </asp:Panel>

    <p class="site-meta"><asp:Literal ID="litCount" runat="server" /></p>

    <asp:Panel ID="pnlEmpty" runat="server" CssClass="site-empty" Visible="false">
        No reported scams match your search. That does not mean a number or website is safe.
    </asp:Panel>

    <div class="row g-3">
        <asp:Repeater ID="rptCases" runat="server">
            <ItemTemplate>
                <div class="col-md-6">
                    <asp:HyperLink runat="server" NavigateUrl='<%# "~/ScamDetail.aspx?id=" + Eval("ReportID") %>' CssClass="site-card site-card-link repo-case d-block h-100">
                        <div class="site-card-body">
                            <div class="d-flex flex-wrap gap-1 mb-2">
                                <span class="site-badge"><%# Server.HtmlEncode(Convert.ToString(Eval("CategoryName"))) %></span>
                                <%# (bool)Eval("IsSample") ? "<span class='site-badge site-badge-muted'>Sample data</span>" : "" %>
                            </div>
                            <h2 class="site-card-title h6"><%# Server.HtmlEncode(Convert.ToString(Eval("Title"))) %></h2>
                            <p class="site-card-text"><%# Server.HtmlEncode(Convert.ToString(Eval("Description"))) %></p>
                            <div class="repo-ids mt-2"><%# Identifiers(Eval("ScammerPhone"), Eval("ScammerAccount"), Eval("ScammerUrl")) %></div>
                            <div class="site-meta mt-2">Reported <%# LessonHelpers.FormatDate(Eval("CreatedAt")) %></div>
                        </div>
                    </asp:HyperLink>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="pnlPager" runat="server" CssClass="d-flex justify-content-between align-items-center mt-4">
        <asp:LinkButton ID="btnPrev" runat="server" CssClass="btn btn-outline-primary" CausesValidation="false" OnClick="btnPrev_Click" Text="&larr; Newer" />
        <span class="site-meta"><asp:Literal ID="litPage" runat="server" /></span>
        <asp:LinkButton ID="btnNext" runat="server" CssClass="btn btn-outline-primary" CausesValidation="false" OnClick="btnNext_Click" Text="Older &rarr;" />
    </asp:Panel>
</asp:Content>
