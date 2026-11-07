<%@ Page Title="Quiz Result | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="QuizResult.aspx.cs" Inherits="Member_QuizResult" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>

.quiz-card {
    border:1px solid #d6e2d9;
    border-radius:12px;
    padding:24px;
    margin:20px 0;
    background:white
}

.quiz-wrong {
    border-left:5px solid #ac3043
}
.quiz-correct {
    border-left:5px solid #28865a
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

.quiz-grid a {
    font-weight:600
}

@media(max-width:600px) {

    .quiz-card {
        padding:18px
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
