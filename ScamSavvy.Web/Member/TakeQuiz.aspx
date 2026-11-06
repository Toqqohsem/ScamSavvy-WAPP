<%@ Page Title="Take Quiz | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="TakeQuiz.aspx.cs" Inherits="Member_TakeQuiz" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
<style>

.quiz-card {
    border:1px solid #d6e2d9;
    border-radius:12px;
    padding:24px;
    margin:20px 0;
    background:white
}

.quiz-options label {
    display:inline-block;
    margin-left:10px;
    padding:8px 0
}
.quiz-options table,.quiz-options td {
    border:0
}

@media(max-width:600px) {

    .quiz-card {
        padding:18px
    }

    .quiz-options label {
        max-width:85%
    }
}
</style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<h1>Take Quiz</h1>
<asp:Label ID="lblMessage" runat="server" Visible="false" role="status" />

<asp:Panel ID="pnlQuiz" runat="server" Visible="false">
<h2>
<asp:Literal ID="litTitle" runat="server" Mode="Encode" />
</h2>
<p>Answer every question. Choose one answer for each question before submitting.</p>
<asp:ValidationSummary runat="server" ValidationGroup="Quiz" CssClass="text-danger" HeaderText="Please complete the following:" />
<asp:Repeater ID="rptQuestions" runat="server" EnableViewState="false" OnItemDataBound="rptQuestions_ItemDataBound">
<ItemTemplate>
<fieldset class="quiz-card">
<legend class="h5">
<%# Container.ItemIndex + 1 %>. <%#: Eval("QuestionText") %>
</legend>
<asp:RadioButtonList ID="rblAnswer" runat="server" CssClass="quiz-options" RepeatLayout="Flow" />
<asp:CustomValidator ID="cuvAnswered" runat="server" Display="Dynamic" CssClass="text-danger" ValidationGroup="Quiz" ErrorMessage="Answer this question." OnServerValidate="cuvAnswered_ServerValidate" />
</fieldset>
</ItemTemplate>
</asp:Repeater>
<asp:Button ID="btnSubmit" runat="server" Text="Submit quiz" CssClass="btn btn-primary" ValidationGroup="Quiz" OnClick="btnSubmit_Click" />
</asp:Panel>
<asp:HyperLink runat="server" NavigateUrl="~/Quizzes.aspx" Text="Back to quizzes" CssClass="d-block mt-3" />


</asp:Content>
