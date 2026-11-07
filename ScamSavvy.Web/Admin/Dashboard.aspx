<%@ Page Title="Admin Dashboard | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Admin_Dashboard" %>
<%-- Owner: Ahmad (Admin module) --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-card-link { text-decoration: none; color: inherit; display: block; height: 100%; }
        .admin-card-link:hover .ss-card, .admin-card-link:focus .ss-card { box-shadow: 0 0 0 2px var(--ss-amber); }
        .admin-pending .ss-stat { color: #9a6700; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="ss-page-header">
        <h1 class="h2">Admin Dashboard</h1>
        <p>Live figures from every module. Welcome, <asp:Literal ID="litAdminName" runat="server" Mode="Encode" />.</p>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-6 col-lg-3">
            <asp:HyperLink ID="lnkUsersCard" runat="server" NavigateUrl="~/Admin/ManageUsers.aspx" CssClass="admin-card-link">
                <div class="card ss-card h-100"><div class="card-body">
                    <div class="ss-stat"><asp:Literal ID="litTotalUsers" runat="server" /></div>
                    <div class="ss-stat-label">Users</div>
                    <div class="small text-muted mt-1"><asp:Literal ID="litUsersByRole" runat="server" /></div>
                </div></div>
            </asp:HyperLink>
        </div>
        <div class="col-6 col-lg-3">
            <asp:HyperLink ID="lnkLessonsCard" runat="server" NavigateUrl="~/Admin/ManageLessons.aspx" CssClass="admin-card-link">
                <div class="card ss-card h-100"><div class="card-body">
                    <div class="ss-stat"><asp:Literal ID="litLessons" runat="server" /></div>
                    <div class="ss-stat-label">Published lessons</div>
                </div></div>
            </asp:HyperLink>
        </div>
        <div class="col-6 col-lg-3">
            <asp:HyperLink ID="lnkQuizCard" runat="server" NavigateUrl="~/Admin/ManageQuizzes.aspx" CssClass="admin-card-link">
                <div class="card ss-card h-100"><div class="card-body">
                    <div class="ss-stat"><asp:Literal ID="litQuizAttempts" runat="server" /></div>
                    <div class="ss-stat-label">Quiz attempts</div>
                </div></div>
            </asp:HyperLink>
        </div>
        <div class="col-6 col-lg-3">
            <asp:HyperLink ID="lnkScenarioCard" runat="server" NavigateUrl="~/Admin/ManageScenarios.aspx" CssClass="admin-card-link">
                <div class="card ss-card h-100"><div class="card-body">
                    <div class="ss-stat"><asp:Literal ID="litScenarioAttempts" runat="server" /></div>
                    <div class="ss-stat-label">Spot the Scam attempts</div>
                </div></div>
            </asp:HyperLink>
        </div>
        <div class="col-6 col-lg-3">
            <asp:HyperLink ID="lnkPendingCard" runat="server" NavigateUrl="~/Admin/ModerateReports.aspx" CssClass="admin-card-link admin-pending">
                <div class="card ss-card h-100"><div class="card-body">
                    <div class="ss-stat"><asp:Literal ID="litPendingReports" runat="server" /></div>
                    <div class="ss-stat-label">Reports waiting for review</div>
                </div></div>
            </asp:HyperLink>
        </div>
        <div class="col-6 col-lg-3">
            <asp:HyperLink ID="lnkApprovedCard" runat="server" NavigateUrl="~/ScamRepository.aspx" CssClass="admin-card-link">
                <div class="card ss-card h-100"><div class="card-body">
                    <div class="ss-stat"><asp:Literal ID="litApprovedReports" runat="server" /></div>
                    <div class="ss-stat-label">Published scam reports</div>
                </div></div>
            </asp:HyperLink>
        </div>
        <div class="col-6 col-lg-3">
            <asp:HyperLink ID="lnkFeedbackCard" runat="server" NavigateUrl="~/Admin/ManageFeedback.aspx" CssClass="admin-card-link admin-pending">
                <div class="card ss-card h-100"><div class="card-body">
                    <div class="ss-stat"><asp:Literal ID="litPendingFeedback" runat="server" /></div>
                    <div class="ss-stat-label">Feedback waiting for review</div>
                </div></div>
            </asp:HyperLink>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-6">
            <h2 class="h5">Newest sign-ups</h2>
            <div class="table-responsive">
                <asp:GridView ID="gvLatestUsers" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-sm align-middle ss-table" GridLines="None" UseAccessibleHeader="true"
                    EmptyDataText="No users yet.">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Name" />
                        <asp:BoundField DataField="Role" HeaderText="Role" />
                        <asp:BoundField DataField="CreatedAt" HeaderText="Joined" DataFormatString="{0:dd MMM yyyy}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="col-lg-6">
            <h2 class="h5">Waiting for review</h2>
            <div class="table-responsive">
                <asp:GridView ID="gvPendingReports" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-sm align-middle ss-table" GridLines="None" UseAccessibleHeader="true"
                    EmptyDataText="Nothing waiting. All reports are reviewed.">
                    <Columns>
                        <asp:TemplateField HeaderText="Report">
                            <ItemTemplate>
                                <asp:HyperLink ID="lnkReport" runat="server" NavigateUrl="~/Admin/ModerateReports.aspx" Text='<%# Server.HtmlEncode(Convert.ToString(Eval("Title"))) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Category" HeaderText="Category" />
                        <asp:BoundField DataField="SubmittedBy" HeaderText="From" />
                        <asp:BoundField DataField="CreatedAt" HeaderText="Sent" DataFormatString="{0:dd MMM yyyy}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <h2 class="h5">Manage the site</h2>
    <div class="d-flex flex-wrap gap-2">
        <asp:HyperLink ID="lnkUsers" runat="server" NavigateUrl="~/Admin/ManageUsers.aspx" CssClass="btn btn-outline-primary" Text="Users" />
        <asp:HyperLink ID="lnkCategories" runat="server" NavigateUrl="~/Admin/ManageCategories.aspx" CssClass="btn btn-outline-primary" Text="Categories" />
        <asp:HyperLink ID="lnkLessons" runat="server" NavigateUrl="~/Admin/ManageLessons.aspx" CssClass="btn btn-outline-primary" Text="Lessons" />
        <asp:HyperLink ID="lnkQuizzes" runat="server" NavigateUrl="~/Admin/ManageQuizzes.aspx" CssClass="btn btn-outline-primary" Text="Quizzes" />
        <asp:HyperLink ID="lnkScenarios" runat="server" NavigateUrl="~/Admin/ManageScenarios.aspx" CssClass="btn btn-outline-primary" Text="Scenarios" />
        <asp:HyperLink ID="lnkReports" runat="server" NavigateUrl="~/Admin/ModerateReports.aspx" CssClass="btn btn-outline-primary" Text="Scam reports" />
        <asp:HyperLink ID="lnkRedFlags" runat="server" NavigateUrl="~/Admin/ManageRedFlags.aspx" CssClass="btn btn-outline-primary" Text="Red-flag keywords" />
        <asp:HyperLink ID="lnkFeedbackAdmin" runat="server" NavigateUrl="~/Admin/ManageFeedback.aspx" CssClass="btn btn-outline-primary" Text="Feedback" />
    </div>
</asp:Content>
