<%@ Page Title="Quizzes | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Quizzes.aspx.cs" Inherits="Quizzes" %>
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
    color:#fff; /* white text on the navy banner */
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
.quiz-score {
    padding:10px 12px;
    border-radius:7px;
    font-weight:700;
    min-height:44px;
    margin-top:8px
}
.quiz-score-pass {
    color:#14623d;
    background:#e7f4ec
}
.quiz-score-fail {
    color:#a52531;
    background:#fff0f1
}
.quiz-score-new {
    color:#53647a;
    background:#f0f3f7
}
.member3-results {
    display:block;
    color:#5b6b80
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
</style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<section id="quizIntro" class="carousel slide member3-banner" aria-label="Quiz introduction">
<div class="carousel-inner">
<div class="carousel-item active">
<div class="member3-slide">
<div>
<span class="member3-kicker">QUIZZES</span>
<h1>How strong is your scam awareness?</h1>
<p>Choose a category, answer six questions and learn from every explanation.</p>
</div>
<img src="<%= ResolveUrl("~/Images/Member3/shield.svg") %>" alt="" />
</div>
</div>
<div class="carousel-item">
<div class="member3-slide">
<div>
<span class="member3-kicker">THINK BEFORE YOU TRUST.</span>
<h2>Recognise the warning signs.</h2>
<p>Practise identifying suspicious messages, offers and requests.</p>
</div>
<img src="<%= ResolveUrl("~/Images/Member3/message.svg") %>" alt="" />
</div>
</div>
<div class="carousel-item">
<div class="member3-slide">
<div>
<span class="member3-kicker">LEARN. CHECK. IMPROVE.</span>
<h2>Build safer online habits.</h2>
<p>Review your answers and try again. A score of 70% or above is a pass.</p>
</div>
<img src="<%= ResolveUrl("~/Images/Member3/lock.svg") %>" alt="" />
</div>
</div>
</div>
<button type="button" class="carousel-control-prev" data-bs-target="#quizIntro" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true">
</span>
<span class="visually-hidden">Previous introduction</span>
</button>
<button type="button" class="carousel-control-next" data-bs-target="#quizIntro" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true">
</span>
<span class="visually-hidden">Next introduction</span>
</button>
</section>
<asp:Label ID="lblMessage" runat="server" Visible="false" role="status" />

<p>Choose a category and test what you have learned. A score of 70% or above is a pass.</p>
<asp:Panel ID="pnlFilters" runat="server" DefaultButton="btnSearch" CssClass="member3-filters">
<div class="filter-search">
<asp:Label runat="server" AssociatedControlID="txtSearch" Text="Search" />
<asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" MaxLength="100" ValidateRequestMode="Disabled" placeholder="Search quizzes, categories or question text" />
</div>
<div class="filter-category">
<asp:Label runat="server" AssociatedControlID="ddlCategory" Text="Scam category" />
<asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_Changed" />
</div>
<div class="member3-filter-actions">
<asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" CausesValidation="false" OnClick="Search_Click" />
<asp:Button ID="btnClear" runat="server" Text="Clear filters" CssClass="btn btn-outline-primary" CausesValidation="false" OnClick="Clear_Click" />
</div>
</asp:Panel>
<asp:Label ID="lblResults" runat="server" CssClass="member3-results" role="status" />
<asp:Label ID="lblEmpty" runat="server" Visible="false" Text="No published quizzes are available for this category." />
<div class="quiz-grid-cards">
<asp:Repeater ID="rptQuizzes" runat="server">
<ItemTemplate>
<a class="quiz-tile" href='<%# ResolveUrl("~/Member/TakeQuiz.aspx?id="+Eval("QuizID")) %>'>
<span class="quiz-badge">
<%#: Eval("CategoryName") %>
</span>
<h2>
<%#: Eval("Title") %>
</h2>
<p>
<%#: Eval("QuestionCount") %> questions &middot; Pass at 70%</p>
<p class='<%# BestClass(Eval("BestPercentage")) %>'>
<%#: BestText(Eval("BestPercentage")) %>
</p>
<span class="quiz-cta">Take quiz &rarr;</span>
</a>
</ItemTemplate>
</asp:Repeater>
</div>

</asp:Content>
