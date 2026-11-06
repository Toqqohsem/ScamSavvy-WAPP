<%@ Page Title="Home | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Home page only (internal CSS) */
        .home-hero {
            background: linear-gradient(135deg, #0f2a44 0%, #1d4a73 100%);
            color: #fff;
            border-radius: 1rem;
            padding: clamp(1.5rem, 4vw, 3rem);
            overflow: hidden;
        }
        .home-hero h1 { color: #fff; font-size: clamp(1.9rem, 1.3rem + 2.4vw, 3rem); line-height: 1.15; }
        .home-hero h1 span { color: #f2a900; }
        .home-hero .lead { color: rgba(255,255,255,.85); max-width: 34rem; }

        /* A sample scam SMS with the warning signs marked */
        .home-phone {
            max-width: 320px;
            margin: 0 auto;
            background: #f5f7fa;
            color: #1b2430;
            border: 10px solid #08182a;
            border-radius: 2rem;
            padding: 1rem;
            box-shadow: 0 20px 40px rgba(0,0,0,.35);
            transform: rotate(2deg);
        }
        .home-phone-sender { font-size: .8rem; color: #5b6676; text-align: center; margin-bottom: .5rem; }
        .home-bubble { background: #fff; border-radius: 1rem 1rem 1rem .25rem; padding: .75rem .9rem; font-size: .9rem; line-height: 1.5; }
        .home-flag { background: #fdecea; color: #a31515; border-bottom: 2px solid #c62828; padding: 0 .15rem; border-radius: .2rem; }
        .home-phone-note { font-size: .78rem; color: #5b6676; margin-top: .6rem; text-align: center; }

        .home-stats { margin-top: -1px; }
        .home-stat { padding: 1.25rem; height: 100%; }
        .home-stat-value { font-size: 1.9rem; font-weight: 800; color: #c62828; line-height: 1.1; }
        .home-stat-label { color: #5b6676; font-size: .92rem; }

        .home-category { padding: 1.1rem; display: flex; gap: .9rem; align-items: flex-start; }
        .home-category-icon {
            flex: 0 0 3rem; height: 3rem; border-radius: .75rem;
            display: flex; align-items: center; justify-content: center;
            background: #fff4d6; color: #0f2a44;
        }
        .home-report { padding: 1rem 1.15rem; height: 100%; display: flex; flex-direction: column; gap: .35rem; }
        .home-report-title { font-weight: 700; color: #0f2a44; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Label ID="lblMessage" runat="server" Visible="false" />

    <!-- Hero -->
    <section class="home-hero" aria-labelledby="heroTitle">
        <div class="row align-items-center g-5">
            <div class="col-lg-7">
                <h1 id="heroTitle">Spot the scam <span>before it spots you.</span></h1>
                <p class="lead my-3">
                    Short lessons, real Malaysian cases and hands-on practice to help you recognise,
                    avoid and report online scams.
                </p>
                <div class="d-flex flex-wrap gap-2">
                    <asp:HyperLink ID="lnkCheck" runat="server" NavigateUrl="~/ScamChecker.aspx" CssClass="btn btn-warning btn-lg">Check a message</asp:HyperLink>
                    <asp:HyperLink ID="lnkLearn" runat="server" NavigateUrl="~/Lessons.aspx" CssClass="btn btn-outline-light btn-lg">Start learning</asp:HyperLink>
                </div>
            </div>
            <div class="col-lg-5 d-none d-md-block">
                <figure class="home-phone mb-0" aria-label="Example scam text message with warning signs highlighted">
                    <div class="home-phone-sender">+60 11-xxxx xxxx &middot; SMS</div>
                    <div class="home-bubble">
                        <span class="home-flag">[PDRM]</span> Akaun bank anda dikaitkan dengan kes pengubahan wang haram.
                        <span class="home-flag">Hubungi Insp. Rahman segera</span> atau akaun anda akan
                        <span class="home-flag">dibekukan dalam 24 jam</span>.
                    </div>
                    <figcaption class="home-phone-note">Highlighted: a fake sender, a pushy contact request and a deadline.</figcaption>
                </figure>
            </div>
        </div>
    </section>

    <!-- PDRM figure strip -->
    <section class="site-section" aria-labelledby="statsTitle">
        <h2 id="statsTitle" class="visually-hidden">Scam losses in Malaysia</h2>
        <div class="row g-3 home-stats">
            <div class="col-md-4">
                <div class="site-card home-stat">
                    <div class="home-stat-value">RM2.7 billion+</div>
                    <div class="home-stat-label">lost to online scams in Malaysia, January to November 2025</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="site-card home-stat">
                    <div class="home-stat-value">67,735</div>
                    <div class="home-stat-label">online crime cases recorded by PDRM in the same period</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="site-card home-stat">
                    <div class="home-stat-value">RM1.37 billion</div>
                    <div class="home-stat-label">lost to non-existent investment schemes alone, the costliest category</div>
                </div>
            </div>
        </div>
        <p class="site-meta mt-2 mb-0">
            Source: Royal Malaysia Police (PDRM) CCID, reported in
            <a href="https://www.thestar.com.my/news/nation/2025/12/08/online-scams-cost-malaysians-over-rm27bil-as-of-november" target="_blank" rel="noopener noreferrer">The Star, 8 Dec 2025</a>.
        </p>
    </section>

    <!-- Latest approved scam reports -->
    <section class="site-section" aria-labelledby="alertsTitle">
        <div class="site-section-title">
            <h2 id="alertsTitle">Latest scam alerts</h2>
            <asp:HyperLink ID="lnkAllReports" runat="server" NavigateUrl="~/ScamRepository.aspx">See all reported cases &rarr;</asp:HyperLink>
        </div>
        <asp:Repeater ID="rptReports" runat="server">
            <HeaderTemplate><div class="row g-3"></HeaderTemplate>
            <ItemTemplate>
                <div class="col-md-4">
                    <a class="site-card site-card-link home-report" href='<%# ResolveUrl("~/ScamDetail.aspx?id=" + Eval("ReportID")) %>'>
                        <span><span class="site-badge site-badge-danger"><%#: Eval("CategoryName") %></span>
                            <%# (bool)Eval("IsSample") ? "<span class='site-badge site-badge-muted ms-1'>Sample data</span>" : "" %></span>
                        <span class="home-report-title"><%#: Eval("Title") %></span>
                        <span class="site-meta mt-auto">Reported <%#: LessonHelpers.FormatDate(Eval("CreatedAt")) %></span>
                    </a>
                </div>
            </ItemTemplate>
            <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
        <asp:Panel ID="pnlNoReports" runat="server" Visible="false" CssClass="site-empty">
            No scam reports have been approved yet.
        </asp:Panel>
    </section>

    <!-- Category tiles -->
    <section class="site-section" aria-labelledby="categoriesTitle">
        <div class="site-section-title">
            <h2 id="categoriesTitle">Learn by scam type</h2>
        </div>
        <asp:Repeater ID="rptCategories" runat="server">
            <HeaderTemplate><div class="row g-3"></HeaderTemplate>
            <ItemTemplate>
                <div class="col-sm-6 col-lg-4">
                    <a class="site-card site-card-link home-category" href='<%# ResolveUrl("~/Lessons.aspx?category=" + Eval("CategoryID")) %>'>
                        <span class="home-category-icon"><%# LessonHelpers.CategoryIcon(Eval("CategoryID")) %></span>
                        <span>
                            <span class="site-card-title d-block"><%#: Eval("Name") %></span>
                            <span class="site-meta"><%#: Eval("LessonCount") %> lesson<%# Convert.ToInt32(Eval("LessonCount")) == 1 ? "" : "s" %></span>
                        </span>
                    </a>
                </div>
            </ItemTemplate>
            <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
    </section>

    <!-- Latest lessons -->
    <section class="site-section" aria-labelledby="lessonsTitle">
        <div class="site-section-title">
            <h2 id="lessonsTitle">New lessons</h2>
            <asp:HyperLink ID="lnkAllLessons" runat="server" NavigateUrl="~/Lessons.aspx">All lessons &rarr;</asp:HyperLink>
        </div>
        <asp:Repeater ID="rptLatestLessons" runat="server">
            <HeaderTemplate><div class="row g-3"></HeaderTemplate>
            <ItemTemplate>
                <div class="col-md-4">
                    <a class="site-card site-card-link" href='<%# ResolveUrl("~/Lesson.aspx?id=" + Eval("LessonID")) %>'>
                        <img class="site-card-img" src='<%# LessonHelpers.ImageUrl(Eval("ImagePath")) %>' alt="" loading="lazy" />
                        <div class="site-card-body">
                            <span class="site-badge mb-2"><%#: Eval("CategoryName") %></span>
                            <div class="site-card-title"><%#: Eval("Title") %></div>
                            <p class="site-card-text"><%#: Eval("Summary") %></p>
                        </div>
                    </a>
                </div>
            </ItemTemplate>
            <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
        <asp:Panel ID="pnlNoLessons" runat="server" Visible="false" CssClass="site-empty">
            Lessons are on their way. Check back soon.
        </asp:Panel>
    </section>

</asp:Content>
