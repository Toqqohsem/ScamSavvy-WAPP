<%@ Page Title="Lesson | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Lesson.aspx.cs" Inherits="Lesson" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Single lesson only (internal CSS) */
        .lesson-article { max-width: 820px; margin: 0 auto; }
        .lesson-hero-img { width: 100%; aspect-ratio: 16 / 9; object-fit: cover; border-radius: .75rem; }
        .lesson-summary { font-size: 1.15rem; color: #3b4656; }
        .lesson-keypoints { padding: 1.25rem 1.5rem; }
        .lesson-keypoints h2 { font-size: 1.1rem; margin-bottom: .75rem; }
        .lesson-keypoints ul { margin: 0; padding-left: 1.2rem; }
        .lesson-keypoints li { margin-bottom: .35rem; }
        .lesson-content { font-size: 1.05rem; }
        .lesson-content h2 { font-size: 1.35rem; margin-top: 2rem; }
        .lesson-content h3 { font-size: 1.1rem; margin-top: 1.5rem; }
        .lesson-content blockquote {
            border-left: 4px solid #c62828; background: #fdecea;
            padding: .75rem 1rem; border-radius: 0 .5rem .5rem 0; font-style: italic;
        }
        .lesson-video { aspect-ratio: 16 / 9; width: 100%; border: 0; border-radius: .75rem; background: #000; }
        .lesson-complete { padding: 1.25rem 1.5rem; }
        .lesson-next .btn { min-width: 12rem; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Unknown or unpublished id -->
    <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="site-empty my-5">
        <h1 class="h3">Lesson not found</h1>
        <p>This lesson does not exist or is no longer available.</p>
        <asp:HyperLink ID="lnkBackNotFound" runat="server" NavigateUrl="~/Lessons.aspx" CssClass="btn btn-primary">Back to lessons</asp:HyperLink>
    </asp:Panel>

    <asp:Panel ID="pnlLesson" runat="server" Visible="false">
        <article class="lesson-article">

            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><asp:HyperLink ID="lnkCrumbLessons" runat="server" NavigateUrl="~/Lessons.aspx">Lessons</asp:HyperLink></li>
                    <li class="breadcrumb-item"><asp:HyperLink ID="lnkCrumbCategory" runat="server" /></li>
                    <li class="breadcrumb-item active" aria-current="page"><asp:Literal ID="litCrumbTitle" runat="server" /></li>
                </ol>
            </nav>

            <asp:Panel ID="pnlDraft" runat="server" Visible="false" CssClass="alert alert-warning">
                <strong>Draft preview.</strong> This lesson is unpublished, so only admins can see it.
            </asp:Panel>

            <h1><asp:Literal ID="litTitle" runat="server" /></h1>
            <p class="site-meta mb-3">
                <asp:Literal ID="litCategoryBadge" runat="server" />
                <span class="ms-2"><asp:Literal ID="litReadTime" runat="server" /></span>
                <asp:Literal ID="litCompletedBadge" runat="server" />
            </p>
            <p class="lesson-summary"><asp:Literal ID="litSummary" runat="server" /></p>

            <asp:Image ID="imgLesson" runat="server" CssClass="lesson-hero-img my-3" />

            <!-- Key points -->
            <aside class="site-callout lesson-keypoints my-4" aria-labelledby="keyPointsTitle">
                <h2 id="keyPointsTitle">Key points</h2>
                <asp:Repeater ID="rptKeyPoints" runat="server">
                    <HeaderTemplate><ul></HeaderTemplate>
                    <ItemTemplate><li><%#: Container.DataItem %></li></ItemTemplate>
                    <FooterTemplate></ul></FooterTemplate>
                </asp:Repeater>
            </aside>

            <!-- Lesson body: HTML written by admins only (see build guide section 12) -->
            <div class="lesson-content">
                <asp:Literal ID="litContent" runat="server" Mode="PassThrough" />
            </div>

            <!-- Video -->
            <asp:PlaceHolder ID="phVideo" runat="server" Visible="false">
                <h2 class="h4 mt-4">Watch</h2>
                <asp:Literal ID="litVideo" runat="server" />
            </asp:PlaceHolder>

            <!-- Source -->
            <p class="site-meta mt-4">
                Source: <asp:HyperLink ID="lnkSource" runat="server" Target="_blank" rel="noopener noreferrer" />
            </p>

            <!-- Mark as complete -->
            <div class="site-card lesson-complete mt-4">
                <asp:Label ID="lblMessage" runat="server" Visible="false" />
                <asp:PlaceHolder ID="phMarkComplete" runat="server">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <div>
                            <strong>Finished reading?</strong>
                            <div class="site-meta"><asp:Literal ID="litCompleteHint" runat="server" /></div>
                        </div>
                        <asp:Button ID="btnComplete" runat="server" Text="Mark as complete" CssClass="btn btn-primary"
                            CausesValidation="false" OnClick="btnComplete_Click" />
                    </div>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="phCompleted" runat="server" Visible="false">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <div>
                            <span class="site-badge site-badge-success">&#10003; Completed</span>
                            <span class="site-meta ms-2"><asp:Literal ID="litCompletedOn" runat="server" /></span>
                        </div>
                        <asp:HyperLink ID="lnkMyProgress" runat="server" NavigateUrl="~/Member/MyProgress.aspx">View my progress &rarr;</asp:HyperLink>
                    </div>
                </asp:PlaceHolder>
            </div>

            <!-- Next steps (links agreed in build guide section 9) -->
            <section class="lesson-next mt-4" aria-labelledby="nextTitle">
                <h2 id="nextTitle" class="h4">Next steps</h2>
                <div class="d-flex flex-wrap gap-2">
                    <asp:HyperLink ID="lnkQuiz" runat="server" CssClass="btn btn-warning">Take the quiz</asp:HyperLink>
                    <asp:HyperLink ID="lnkCases" runat="server" CssClass="btn btn-outline-primary">See reported cases</asp:HyperLink>
                    <asp:HyperLink ID="lnkMoreLessons" runat="server" CssClass="btn btn-link">More lessons in this category</asp:HyperLink>
                </div>
            </section>

        </article>
    </asp:Panel>

</asp:Content>
