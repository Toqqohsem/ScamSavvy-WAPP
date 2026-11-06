<%@ Page Title="My Progress | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="MyProgress.aspx.cs" Inherits="Member_MyProgress" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* My Progress only (internal CSS) */
        .lesson-progress-card { padding: 1.5rem; }
        .lesson-progress-big { font-size: 2.5rem; font-weight: 800; color: #0f2a44; line-height: 1; }
        .lesson-progress-bar { height: 1rem; border-radius: 999px; background: #e3e7ee; }
        .lesson-progress-bar .progress-bar { background: linear-gradient(90deg, #f2a900, #1e7d4f); }
        .lesson-stat { padding: 1.25rem; height: 100%; }
        .lesson-stat-value { font-size: 1.8rem; font-weight: 800; color: #0f2a44; line-height: 1.1; }
        .lesson-list { list-style: none; margin: 0; padding: 0; }
        .lesson-list li { display: flex; justify-content: space-between; gap: 1rem; padding: .75rem 1.15rem; border-top: 1px solid #e3e7ee; }
        .lesson-list li:first-child { border-top: 0; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="site-page-header">
        <h1>My Progress</h1>
        <p><asp:Literal ID="litGreeting" runat="server" /></p>
    </div>

    <!-- Lesson progress bar -->
    <section class="site-card lesson-progress-card" aria-labelledby="lessonProgressTitle">
        <div class="row g-4 align-items-center">
            <div class="col-md-4">
                <h2 id="lessonProgressTitle" class="h6 text-uppercase site-meta mb-1">Lessons completed</h2>
                <div class="lesson-progress-big"><asp:Literal ID="litCompleted" runat="server" /></div>
                <div class="site-meta"><asp:Literal ID="litPercent" runat="server" /></div>
            </div>
            <div class="col-md-8">
                <asp:Literal ID="litProgressBar" runat="server" />
                <asp:PlaceHolder ID="phNextLesson" runat="server" Visible="false">
                    <p class="mt-3 mb-0">
                        Up next:
                        <asp:HyperLink ID="lnkNextLesson" runat="server" CssClass="fw-semibold" />
                    </p>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="phAllDone" runat="server" Visible="false">
                    <p class="mt-3 mb-0 text-success fw-semibold">You have completed every published lesson. Well done!</p>
                </asp:PlaceHolder>
            </div>
        </div>
    </section>

    <!-- Activity totals -->
    <section class="site-section" aria-labelledby="totalsTitle">
        <h2 id="totalsTitle" class="visually-hidden">Activity totals</h2>
        <div class="row g-3">
            <div class="col-sm-6 col-lg-3">
                <div class="site-card lesson-stat">
                    <div class="lesson-stat-value"><asp:Literal ID="litQuizAttempts" runat="server" /></div>
                    <div class="site-meta">quiz attempts</div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="site-card lesson-stat">
                    <div class="lesson-stat-value"><asp:Literal ID="litQuizPassed" runat="server" /></div>
                    <div class="site-meta">quizzes passed (70% or more)</div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="site-card lesson-stat">
                    <div class="lesson-stat-value"><asp:Literal ID="litScenariosTried" runat="server" /></div>
                    <div class="site-meta">Spot the Scam scenarios tried</div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="site-card lesson-stat">
                    <div class="lesson-stat-value"><asp:Literal ID="litFlagsFound" runat="server" /></div>
                    <div class="site-meta">red flags found</div>
                </div>
            </div>
        </div>
    </section>

    <div class="row g-4 site-section">

        <!-- Latest 5 quiz attempts -->
        <section class="col-lg-7" aria-labelledby="quizTitle">
            <div class="site-section-title">
                <h2 id="quizTitle">Recent quiz attempts</h2>
                <asp:HyperLink ID="lnkQuizzes" runat="server" NavigateUrl="~/Quizzes.aspx">Take a quiz &rarr;</asp:HyperLink>
            </div>
            <asp:Repeater ID="rptQuizAttempts" runat="server">
                <HeaderTemplate>
                    <div class="table-responsive">
                    <table class="table site-table mb-0">
                        <thead><tr><th scope="col">Quiz</th><th scope="col">Score</th><th scope="col">Result</th><th scope="col">Date</th></tr></thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><a href='<%# ResolveUrl("~/Member/QuizResult.aspx?id=" + Eval("AttemptID")) %>'><%#: Eval("QuizTitle") %></a></td>
                        <td><%#: Eval("Score") %>/<%#: Eval("TotalQuestions") %> (<%#: Percent(Eval("Score"), Eval("TotalQuestions")) %>%)</td>
                        <td><%# PassBadge(Eval("Score"), Eval("TotalQuestions")) %></td>
                        <td class="text-nowrap"><%#: LessonHelpers.FormatDate(Eval("AttemptedAt")) %></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate></tbody></table></div></FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoQuizzes" runat="server" Visible="false" CssClass="site-empty">
                You have not taken a quiz yet.
            </asp:Panel>
        </section>

        <!-- Completed lessons -->
        <section class="col-lg-5" aria-labelledby="completedTitle">
            <div class="site-section-title">
                <h2 id="completedTitle">Completed lessons</h2>
            </div>
            <asp:Repeater ID="rptCompleted" runat="server">
                <HeaderTemplate><ul class="site-card lesson-list"></HeaderTemplate>
                <ItemTemplate>
                    <li>
                        <span>
                            <a href='<%# ResolveUrl("~/Lesson.aspx?id=" + Eval("LessonID")) %>'><%#: Eval("Title") %></a>
                            <span class="d-block site-meta"><%#: Eval("CategoryName") %></span>
                        </span>
                        <span class="site-meta text-nowrap"><%#: LessonHelpers.FormatDate(Eval("CompletedAt")) %></span>
                    </li>
                </ItemTemplate>
                <FooterTemplate></ul></FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoCompleted" runat="server" Visible="false" CssClass="site-empty">
                No lessons completed yet.
                <asp:HyperLink ID="lnkStart" runat="server" NavigateUrl="~/Lessons.aspx">Start learning</asp:HyperLink>
            </asp:Panel>
        </section>

    </div>

</asp:Content>
