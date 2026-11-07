<%@ Page Title="Spot the Scam | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="SpotTheScam.aspx.cs" Inherits="Member_SpotTheScam" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>

.quiz-grid-cards {
    display:grid;
    grid-template-columns:repeat(3,minmax(0,1fr));
    gap:18px;
    margin-top:24px
}
.quiz-tile {
    display:flex;
    flex-direction:column;
    padding:24px;
    border:1px solid #d8e4dc;
    border-radius:15px;
    background:white;
    text-decoration:none;
    color:#173330;
    min-height:255px;
    transition:transform .15s,box-shadow .15s
}
.quiz-tile:hover {
    transform:translateY(-3px);
    border-color:#60a18a;
    box-shadow:0 10px 25px #1733300c
}
.quiz-tile h2 {
    font-size:21px;
    margin:18px 0 12px;
    letter-spacing:-.4px
}
.quiz-tile p {
    font-size:14px;
    color:#617569
}
.quiz-tile .quiz-cta {
    margin-top:auto;
    padding-top:18px;
    color:#0a705d;
    font-weight:700;
    font-size:14px
}
.quiz-tile .quiz-badge {
    align-self:flex-start;
    display:inline-block;
    border-radius:20px;
    padding:4px 10px;
    background:#eef5ee;
    color:#356552;
    font-size:11px;
    font-weight:700
}

.quiz-card {
    border:1px solid #d6e2d9;
    border-radius:12px;
    padding:24px;
    margin:20px 0;
    background:white
}

.quiz-phone {
    max-width:560px;
    margin:24px auto;
    border:5px solid #224d40;
    border-radius:26px;
    padding:24px;
    background:#f0f6ef;
    box-shadow:0 14px 30px #19382c0d
}
.quiz-phone>p {
    border-bottom:1px solid #b5cdbd;
    padding-bottom:16px;
    font-size:14px
}
.quiz-part {
    display:block;
    width:100%;
    text-align:left;
    border:1px solid #bdcfc4;
    border-radius:12px;
    background:white;
    color:#173330;
    padding:16px;
    margin:12px 0;
    white-space:normal;
    overflow-wrap:anywhere;
    cursor:pointer;
    line-height:1.6
}
.quiz-part:hover {
    border-color:#368b70;
    background:#f7fcf8
}
.quiz-part.quiz-selected {
    background:#d9eee0;
    border:2px solid #1c7c56
}
.quiz-found {
    background:#e6f4e9;
    border-left:5px solid #258651
}
.quiz-missed {
    background:#fff5d9;
    border-left:5px solid #b78c28
}
.quiz-wrongclick {
    background:#ffeded;
    border-left:5px solid #b8424c
}
.quiz-email {
    border-radius:12px;
    background:white
}
.quiz-call {
    background:#eef2f6
}
.quiz-whatsapp {
    background:#e8f0e6
}

@media(max-width:960px) {
    .quiz-grid-cards {
        grid-template-columns:repeat(2,minmax(0,1fr))
    }
}
@media(max-width:600px) {
    .quiz-grid-cards {
        grid-template-columns:1fr;
        gap:14px
    }

    .quiz-tile {
        min-height:225px
    }
    .quiz-phone {
        padding:16px;
        border-width:3px
    }
    .quiz-card {
        padding:18px
    }

}

.scenario-results {
    display:block;
    color:#526a5b
}
.member3-banner {
    background:#0b2545;
    border-radius:12px;
    color:white;
    margin-bottom:24px;
    overflow:hidden
}
.member3-slide {
    display:flex;
    align-items:center;
    min-height:280px;
    padding:32px 65px;
    gap:24px
}
.member3-slide>div {
    flex:1
}
.member3-slide h1,.member3-slide h2 {
    font-size:clamp(28px,3.4vw,44px);
    font-weight:700;
    margin:12px 0
}
.member3-slide p {
    color:#d1dfef;
    max-width:620px
}
.member3-slide img {
    width:32%;
    max-height:250px
}
.member3-kicker {
    color:#f4a300;
    letter-spacing:2px;
    font-size:12px;
    font-weight:700
}
.member3-banner .carousel-control-prev,.member3-banner .carousel-control-next {
    width:44px
}
.member3-filters {
    background:white;
    border:1px solid #dce3ec;
    border-radius:12px;
    padding:20px;
    display:flex;
    gap:16px;
    flex-wrap:wrap;
    align-items:end;
    margin:24px 0
}
.member3-filters .filter-search {
    flex:2 1 300px
}
.member3-filters .filter-category {
    flex:1 1 230px
}
.member3-filters label {
    display:block;
    font-weight:600;
    margin-bottom:6px
}
.member3-filter-actions {
    display:flex;
    gap:8px
}
.quiz-tile {
    border-color:#dce3ec;
    color:#0b2545;
    min-height:250px
}
.quiz-tile:hover {
    border-color:#0b2545
}
.quiz-tile .quiz-badge {
    background:#eaf0f7;
    color:#0b2545
}
.quiz-tile .quiz-cta {
    color:#0b2545
}

@media(max-width:600px) {
    .member3-slide {
        padding:28px 44px;
        min-height:260px
    }
    .member3-slide img {
        display:none
    }
    .member3-filters {
        padding:16px
    }
    .member3-filter-actions {
        width:100%
    }
}
/* Match the shared site's navy, surface and amber colours. */
.quiz-phone {
    border-color:var(--ss-navy,#0b2545);
    background:var(--ss-bg,#f4f6fa);
    box-shadow:0 14px 30px rgba(11,37,69,.08)
}
.quiz-phone>p {
    border-bottom-color:#ccd7e5;
    color:var(--ss-navy,#0b2545)
}
.quiz-part {
    border-color:#ccd7e5;
    background:var(--ss-surface,#fff);
    color:var(--ss-navy,#0b2545)
}
.quiz-part:hover {
    border-color:var(--ss-navy,#0b2545);
    background:#eaf0f7
}
.quiz-part.quiz-selected {
    border-color:var(--ss-amber,#f4a300);
    background:var(--ss-navy,#0b2545);
    color:#fff
}
.quiz-part:focus-visible {
    outline:3px solid var(--ss-amber,#f4a300);
    outline-offset:3px
}
.quiz-phone.quiz-whatsapp,.quiz-phone.quiz-call {
    background:#eaf0f7
}
.quiz-phone.quiz-email {
    background:var(--ss-surface,#fff)
}
</style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<section id="scenarioIntro" class="carousel slide member3-banner" aria-label="Scenario introduction">
<div class="carousel-inner">
<div class="carousel-item active">
<div class="member3-slide">
<div>
<span class="member3-kicker">SPOT THE SCAM</span>
<h1>Read the message. Find the warning signs.</h1>
<p>Practise with fictional SMS, WhatsApp, email and call scenarios.</p>
</div>
<img src="<%= ResolveUrl("~/Images/Member3/shield.svg") %>" alt="" />
</div>
</div>
<div class="carousel-item">
<div class="member3-slide">
<div>
<span class="member3-kicker">PAUSE BEFORE YOU CLICK.</span>
<h2>A convincing message is not proof.</h2>
<p>Look for urgency, unexpected links and requests for personal details.</p>
</div>
<img src="<%= ResolveUrl("~/Images/Member3/message.svg") %>" alt="" />
</div>
</div>
<div class="carousel-item">
<div class="member3-slide">
<div>
<span class="member3-kicker">KEEP YOUR DETAILS PRIVATE.</span>
<h2>Your passwords and OTPs belong to you.</h2>
<p>Practise safer decisions before you face a real suspicious message.</p>
</div>
<img src="<%= ResolveUrl("~/Images/Member3/lock.svg") %>" alt="" />
</div>
</div>
</div>
<button type="button" class="carousel-control-prev" data-bs-target="#scenarioIntro" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true">
</span>
<span class="visually-hidden">Previous introduction</span>
</button>
<button type="button" class="carousel-control-next" data-bs-target="#scenarioIntro" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true">
</span>
<span class="visually-hidden">Next introduction</span>
</button>
</section>
<asp:Label ID="lblMessage" runat="server" Visible="false" role="status" />

<p>Practise identifying warning signs in fictional messages. These are training examples, not real reports.</p>
<asp:Panel ID="pnlList" runat="server">
<asp:Panel ID="pnlFilters" runat="server" DefaultButton="btnSearch" CssClass="member3-filters">
<div class="filter-search">
<asp:Label runat="server" AssociatedControlID="txtKeyword" Text="Search" />
<asp:TextBox ID="txtKeyword" runat="server" CssClass="form-control" MaxLength="100" ValidateRequestMode="Disabled" placeholder="Search titles, senders or message text" />
</div>
<div class="filter-category">
<asp:Label runat="server" AssociatedControlID="ddlCategory" Text="Scam category" />
<asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="Filters_Changed" />
</div>
<div class="member3-filter-actions">
<asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" CausesValidation="false" OnClick="Filters_Changed" />
<asp:Button ID="btnResetFilters" runat="server" Text="Clear filters" CssClass="btn btn-outline-primary" CausesValidation="false" OnClick="ResetFilters_Click" />
</div>
</asp:Panel>
<asp:Label ID="lblResults" runat="server" CssClass="scenario-results" role="status" />
<asp:Label ID="lblEmpty" runat="server" Visible="false" Text="No published scenarios are available." />
<div class="quiz-grid-cards">
<asp:Repeater ID="rptScenarios" runat="server">
<ItemTemplate>
<a class="quiz-tile" href='<%# ResolveUrl("~/Member/SpotTheScam.aspx?id="+Eval("ScenarioID")) %>'>
<span class="quiz-badge">
<%#: Eval("Channel") %> simulation</span>
<h2>
<%#: Eval("Title") %>
</h2>
<p>
<%#: Eval("CategoryName") %>
</p>
<span class="quiz-cta">Start scenario &rarr;</span>
</a>
</ItemTemplate>
</asp:Repeater>
</div>
</asp:Panel>
<asp:Panel ID="pnlScenario" runat="server" Visible="false">
<asp:HyperLink runat="server" NavigateUrl="~/Member/SpotTheScam.aspx" Text="&larr; All scenarios" CssClass="back-link"/>
<h2>
<asp:Literal ID="litTitle" runat="server" Mode="Encode" />
</h2>
<p id="quizInstructions">Select each suspicious part. Select it again to undo. Then check your answers.</p>
<asp:Panel ID="pnlPhone" runat="server" CssClass="quiz-phone">
<p>
<strong>
<asp:Literal ID="litChannel" runat="server" Mode="Encode" />
</strong> from <asp:Literal ID="litSender" runat="server" Mode="Encode" />
</p>
<div id="quizMessage" aria-describedby="quizInstructions">
<asp:Repeater ID="rptParts" runat="server" EnableViewState="false">
<ItemTemplate>
<button type="button" class="quiz-part" data-part-id='<%# Eval("PartID") %>' aria-pressed="false">
<%#: Eval("PartText") %>
</button>
</ItemTemplate>
</asp:Repeater>
</div>
</asp:Panel>
<asp:HiddenField ID="hfSelected" runat="server" ClientIDMode="Static" />
<p id="quizSelectionCount" aria-live="polite">0 parts selected.</p>
<asp:CustomValidator ID="cuvSelected" runat="server" ValidationGroup="Scenario" CssClass="text-danger" Display="Dynamic" ErrorMessage="Select at least one valid message part." OnServerValidate="cuvSelected_ServerValidate" ClientValidationFunction="quizValidateParts" />
<asp:Button ID="btnCheck" runat="server" Text="Check my answers" ValidationGroup="Scenario" CssClass="btn btn-primary" OnClick="btnCheck_Click" />
<noscript>
<p>Enable JavaScript to select message parts in this activity.</p>
</noscript>
<asp:Panel ID="pnlFeedback" runat="server" Visible="false" role="status">
<h2 class="h4 mt-4">Your feedback</h2>
<p>
<asp:Literal ID="litSummary" runat="server" Mode="Encode" />
</p>
<asp:Repeater ID="rptFeedback" runat="server">
<ItemTemplate>
<article class='<%# "quiz-card "+Eval("FeedbackClass") %>'>
<p>
<strong>
<%#: Eval("FeedbackLabel") %>
</strong>: <%#: Eval("PartText") %>
</p>
<p>
<%#: Eval("Explanation") %>
</p>
</article>
</ItemTemplate>
</asp:Repeater>
<asp:HyperLink ID="lnkRetry" runat="server" Text="Try this scenario again" CssClass="btn btn-outline-primary" />
</asp:Panel>
<asp:HyperLink runat="server" NavigateUrl="~/Member/SpotTheScam.aspx" Text="Choose another scenario" CssClass="d-block mt-3" />
</asp:Panel>

<script src="<%= ResolveUrl("~/Scripts/spotthescam.js") %>">
</script>
</asp:Content>
