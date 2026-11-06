<%@ Page Title="Quiz Result | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="QuizResult.aspx.cs" Inherits="Member_QuizResult" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>
.quiz-hero {
    display:flex;
    gap:32px;
    align-items:center;
    justify-content:space-between;
    padding:34px 38px;
    border:1px solid #d6e7dc;
    border-radius:20px;
    background:#eaf4ed;
    margin-bottom:28px
}
.quiz-hero p {
    max-width:620px;
    color:#506a5e;
    margin-bottom:0
}
.quiz-hero .quiz-symbol {
    font-size:78px;
    font-weight:800;
    color:#398575;
    line-height:1;
    padding:10px
}
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
.quiz-filter {
    display:flex;
    gap:14px;
    align-items:center;
    flex-wrap:wrap
}
.quiz-filter select {
    max-width:380px
}
.quiz-card {
    border:1px solid #d6e2d9;
    border-radius:12px;
    padding:24px;
    margin:20px 0;
    background:white
}
.quiz-muted {
    color:#526a5b
}
.quiz-options label {
    display:inline-block;
    margin-left:10px;
    padding:8px 0
}
.quiz-options table,.quiz-options td {
    border:0
}
.quiz-wrong {
    border-left:5px solid #ac3043
}
.quiz-correct {
    border-left:5px solid #28865a
}
.quiz-field {
    margin-bottom:16px
}
.quiz-field label {
    display:block;
    font-weight:600;
    margin-bottom:6px
}
.quiz-grid {
    overflow-x:auto;
    margin:20px 0;
    border-radius:10px;
    border:1px solid #d8e4dc
}
.quiz-grid table {
    min-width:650px
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
.quiz-section-head {
    margin-top:34px;
    padding-top:12px;
    border-top:1px solid #d4e2d8
}
.quiz-admin-tip {
    padding:12px 16px;
    background:#edf4ef;
    border-radius:8px;
    font-size:14px
}
.quiz-selected-row td {
    background:#e4f2e9
}
.quiz-grid a {
    font-weight:600
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
    .quiz-hero {
        padding:24px
    }
    .quiz-hero .quiz-symbol {
        display:none
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
    .quiz-filter {
        display:block
    }
    .quiz-filter select {
        margin-top:8px
    }
    .quiz-options label {
        max-width:85%
    }
}
</style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<h1>Quiz Result</h1>
<asp:Label ID="lblMessage" runat="server" Visible="false" role="status" />

<asp:Panel ID="pnlResult" runat="server" Visible="false">
<h2>
<asp:Literal ID="litTitle" runat="server" Mode="Encode" />
</h2>
<p class="fs-4" style="font-weight:600;">
<asp:Literal ID="litScore" runat="server" Mode="Encode" />
</p>
<asp:HyperLink ID="lnkRevise" runat="server" Text="Revise the lesson" CssClass="btn btn-outline-primary" />
<asp:HyperLink ID="lnkRetry" runat="server" Text="Try this quiz again" CssClass="btn btn-primary" />
<h2 class="h4 mt-4">Answer review</h2>
<asp:Repeater ID="rptAnswers" runat="server">
<ItemTemplate>
<article class='<%# Convert.ToString(Eval("ChosenOption"))==Convert.ToString(Eval("CorrectOption")) ? "quiz-card quiz-correct" : "quiz-card quiz-wrong" %>'>
<h3 class="h5">
<%# Container.ItemIndex+1 %>. <%#: Eval("QuestionText") %>
</h3>
<p>
<strong>Your answer:</strong> <%#: AnswerText(Container.DataItem,"ChosenOption") %>
</p>
<p>
<strong>Correct answer:</strong> <%#: AnswerText(Container.DataItem,"CorrectOption") %>
</p>
<p>
<%#: Eval("Explanation") %>
</p>
<asp:HyperLink runat="server" NavigateUrl='<%# lnkRevise.NavigateUrl %>' Text="Review the related lesson" />
</article>
</ItemTemplate>
</asp:Repeater>
<h2 class="h4">Your attempts for this quiz</h2>
<div class="quiz-grid">
<asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="false" CssClass="table table-striped" UseAccessibleHeader="true" EmptyDataText="No attempts.">
<Columns>
<asp:BoundField DataField="AttemptedAt" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" />
<asp:BoundField DataField="Score" HeaderText="Correct" />
<asp:BoundField DataField="TotalQuestions" HeaderText="Questions" />
<asp:HyperLinkField DataNavigateUrlFields="AttemptID" DataNavigateUrlFormatString="~/Member/QuizResult.aspx?id={0}" Text="View result" HeaderText="Result" />
</Columns>
</asp:GridView>
</div>
</asp:Panel>
<asp:HyperLink runat="server" NavigateUrl="~/Quizzes.aspx" Text="Back to quizzes" />


</asp:Content>
