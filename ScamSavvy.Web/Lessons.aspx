<%@ Page Title="Lessons | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Lessons.aspx.cs" Inherits="Lessons" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Lessons list only (internal CSS) */
        .lesson-filter { padding: 1rem 1.15rem; }
        .lesson-card { position: relative; }
        .lesson-done {
            position: absolute; top: .75rem; right: .75rem;
            box-shadow: 0 2px 6px rgba(0,0,0,.15);
        }
        .lesson-card .site-card-text {
            display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;
        }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="site-page-header">
        <h1>Lessons</h1>
        <p>Short reads on how each type of scam works, the warning signs, and what to do.</p>
    </div>

    <!-- Filter: category drop-down and title search -->
    <asp:Panel ID="pnlFilter" runat="server" CssClass="site-card lesson-filter mb-4" DefaultButton="btnSearch">
        <div class="row g-2 align-items-end">
            <div class="col-md-4">
                <asp:Label ID="lblCategory" runat="server" AssociatedControlID="ddlCategory" CssClass="form-label" Text="Category" />
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" />
            </div>
            <div class="col-md-5">
                <asp:Label ID="lblSearch" runat="server" AssociatedControlID="txtSearch" CssClass="form-label" Text="Search titles" />
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" MaxLength="100" placeholder="e.g. parcel, TAC, investment" />
                <asp:RegularExpressionValidator ID="revSearch" runat="server" ControlToValidate="txtSearch"
                    ValidationExpression="^[^<>]{0,100}$" ErrorMessage="Use up to 100 characters, without &lt; or &gt;."
                    Display="Dynamic" CssClass="text-danger" ValidationGroup="Search" />
            </div>
            <div class="col-md-3 d-flex gap-2">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary flex-fill"
                    ValidationGroup="Search" OnClick="btnSearch_Click" />
                <asp:HyperLink ID="lnkClear" runat="server" NavigateUrl="~/Lessons.aspx" CssClass="btn btn-outline-secondary">Clear</asp:HyperLink>
            </div>
        </div>
    </asp:Panel>

    <p class="site-meta" role="status"><asp:Literal ID="litResultCount" runat="server" /></p>

    <asp:Repeater ID="rptLessons" runat="server">
        <HeaderTemplate><div class="row g-4"></HeaderTemplate>
        <ItemTemplate>
            <div class="col-sm-6 col-lg-4">
                <a class="site-card site-card-link lesson-card" href='<%# ResolveUrl("~/Lesson.aspx?id=" + Eval("LessonID")) %>'>
                    <img class="site-card-img" src='<%# LessonHelpers.ImageUrl(Eval("ImagePath")) %>' alt="" loading="lazy" />
                    <%# (bool)Eval("IsCompleted") ? "<span class='site-badge site-badge-success lesson-done'>&#10003; Completed</span>" : "" %>
                    <div class="site-card-body">
                        <span class="site-badge mb-2"><%#: Eval("CategoryName") %></span>
                        <h2 class="site-card-title h5"><%#: Eval("Title") %></h2>
                        <p class="site-card-text"><%#: Eval("Summary") %></p>
                    </div>
                </a>
            </div>
        </ItemTemplate>
        <FooterTemplate></div></FooterTemplate>
    </asp:Repeater>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="site-empty">
        No lessons match your filter.
        <asp:HyperLink ID="lnkShowAll" runat="server" NavigateUrl="~/Lessons.aspx">Show all lessons</asp:HyperLink>
    </asp:Panel>

</asp:Content>
