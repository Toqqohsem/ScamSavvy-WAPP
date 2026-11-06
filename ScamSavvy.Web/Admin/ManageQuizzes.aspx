<%@ Page Title="Manage Quizzes | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageQuizzes.aspx.cs" Inherits="Admin_ManageQuizzes" %>
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
.quiz-admin-heading {
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:16px;
    flex-wrap:wrap;
    margin-bottom:12px
}
.quiz-admin-heading h1,.quiz-admin-heading h2 {
    margin:0
}
.quiz-editor-section {
    background:white;
    border:1px solid #d8e4dc;
    border-radius:12px;
    padding:24px;
    margin-top:28px
}
.quiz-editor-section:empty {
    display:none
}
.quiz-editor-section .table {
    margin-bottom:0
}
#assessment-details {
    scroll-margin-top:20px
}
.modal-body .table {
    width:100%
}
.modal-body td {
    overflow-wrap:anywhere
}
.quiz-grid td:last-child a {
    display:inline-block;
    margin:0 10px 6px 0;
    white-space:nowrap
}
.modal-body .quiz-grid {
    margin-top:12px
}
.member3-actions {
    display:inline-flex;
    align-items:center;
    gap:6px;
    white-space:nowrap
}
.member3-actions a {
    margin:0!important
}
.modal-body label {
    font-weight:700
}
.quiz-grid td:first-child {
    font-weight:600
}
.quiz-selected-row td {
    background:#eaf0f7
}
</style>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="quiz-admin-heading">
<h1>Manage Quizzes</h1>
<asp:Button ID="btnNewHeader" runat="server" Text="+ New quiz" CausesValidation="false" OnClick="btnNewHeader_Click" CssClass="btn btn-primary" />
</div>
<asp:Label ID="lblMessage" runat="server" Visible="false" role="status" />
<p>View quiz details, edit settings or manage questions. New quizzes start as drafts.</p>
<div class="quiz-grid">
<asp:GridView ID="gvQuizzes" runat="server" OnRowCommand="Header_RowCommand" DataSourceID="sdsQuizzes" DataKeyNames="QuizID" AutoGenerateColumns="false" AutoGenerateSelectButton="false" SelectedRowStyle-CssClass="quiz-selected-row" AllowPaging="true" PageSize="6" UseAccessibleHeader="true" CssClass="table table-striped" EmptyDataText="No records." OnSelectedIndexChanged="Header_SelectedIndexChanged" OnPageIndexChanging="Header_PageIndexChanging">
<Columns>
<asp:BoundField DataField="Title" HeaderText="Title" HtmlEncode="true" />
<asp:BoundField DataField="CategoryName" HeaderText="Category" HtmlEncode="true" />
<asp:BoundField DataField="Description" HeaderText="Description" HtmlEncode="true" />
<asp:BoundField DataField="ContentCount" HeaderText="Questions" />
<asp:TemplateField HeaderText="Status">
<ItemTemplate>
<%# Convert.ToBoolean(Eval("IsPublished")) ? "Published" : "Draft" %>
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Actions">
<ItemTemplate>
<span class="member3-actions">
<asp:LinkButton runat="server" Text="View" CommandName="ViewAssessment" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" /> <span aria-hidden="true">|</span> <asp:LinkButton runat="server" Text="Edit" CommandName="EditAssessment" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" /> <span aria-hidden="true">|</span> <asp:LinkButton runat="server" Text="Delete" CommandName="DeleteAssessment" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" /> <span aria-hidden="true">|</span> <asp:LinkButton runat="server" Text="Manage questions" CommandName="Questions" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
</span>
</ItemTemplate>
</asp:TemplateField>
</Columns>
</asp:GridView>
</div>
<div class="modal fade" id="<%= HeaderModalId %>" tabindex="-1" aria-labelledby="quizDialogTitle" aria-hidden="true">
<div class="modal-dialog modal-lg modal-dialog-scrollable">
<div class="modal-content">
<div class="modal-header">
<h2 class="modal-title h4" id="quizDialogTitle">
<%= HeaderDialogTitle %>
</h2>
<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
</button>
</div>
<div class="modal-body">
<asp:Label ID="lblHeaderFeedback" runat="server" CssClass="text-danger d-block" />
<asp:DetailsView ID="dvHeader" runat="server" OnItemInserted="Header_ItemInserted" OnItemUpdated="Header_ItemUpdated" OnItemDeleted="Header_ItemDeleted" OnModeChanging="Header_ModeChanging" DataSourceID="sdsHeaderDetails" DataKeyNames="QuizID" AutoGenerateRows="false" CssClass="table" OnItemInserting="Header_ItemInserting" OnItemUpdating="Header_ItemUpdating" OnDataBound="Details_DataBound">
<Fields>
<asp:BoundField DataField="QuizID" HeaderText="ID" ReadOnly="true" InsertVisible="false" />
<asp:TemplateField HeaderText="Title" ShowHeader="false">
<ItemTemplate>
<strong>Title</strong>
<br />
<%#: Eval("Title") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtTitle" Text="Title" />
<asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="150" Text='<%# Bind("Title") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Title is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtTitle" ValidationExpression="^[\s\S]{0,150}$" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Title exceeds 150 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtTitle" Text="Title" />
<asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="150" Text='<%# Bind("Title") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Title is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtTitle" ValidationExpression="^[\s\S]{0,150}$" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Title exceeds 150 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Category" ShowHeader="false">
<ItemTemplate>
<strong>Category</strong>
<br />
<%#: Eval("CategoryID") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="ddlCategory" Text="Category" />
<asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" DataSourceID="sdsCategories" DataTextField="Name" DataValueField="CategoryID" AppendDataBoundItems="true" SelectedValue='<%# Bind("CategoryID") %>'>
<asp:ListItem Value="">Choose a category</asp:ListItem>
</asp:DropDownList>
<asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCategory" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Category is required." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="ddlCategory" Text="Category" />
<asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" DataSourceID="sdsCategories" DataTextField="Name" DataValueField="CategoryID" AppendDataBoundItems="true" SelectedValue='<%# Bind("CategoryID") %>'>
<asp:ListItem Value="">Choose a category</asp:ListItem>
</asp:DropDownList>
<asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCategory" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Category is required." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Description" ShowHeader="false">
<ItemTemplate>
<strong>Description</strong>
<br />
<%#: Eval("Description") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtDescription" Text="Description" />
<asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" MaxLength="500" TextMode="MultiLine" Rows="3" Text='<%# Bind("Description") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescription" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Description is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtDescription" ValidationExpression="^[\s\S]{0,500}$" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Description exceeds 500 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtDescription" Text="Description" />
<asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" MaxLength="500" TextMode="MultiLine" Rows="3" Text='<%# Bind("Description") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtDescription" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Description is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtDescription" ValidationExpression="^[\s\S]{0,500}$" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Description exceeds 500 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Published" ShowHeader="false">
<ItemTemplate>
<asp:CheckBox runat="server" Text="Published" Enabled="false" Checked='<%# Eval("IsPublished") %>' />
</ItemTemplate>
<EditItemTemplate>
<asp:CheckBox ID="chkPublished" runat="server" Checked='<%# Bind("IsPublished") %>' Text="Published" />
</EditItemTemplate>
<InsertItemTemplate>
<asp:CheckBox ID="chkPublished" runat="server" Checked='<%# Bind("IsPublished") %>' Text="Published" />
</InsertItemTemplate>
</asp:TemplateField>
<asp:CommandField ShowEditButton="true" ShowInsertButton="true" InsertText="Save quiz" UpdateText="Save changes" ValidationGroup="Header" />

</Fields>
</asp:DetailsView>
<asp:ValidationSummary runat="server" ValidationGroup="Header" CssClass="text-danger" />
</div>
<div class="modal-footer">
<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
</div>
</div>
</div>
</div>
<div class="modal fade" id="questionsModal" tabindex="-1" aria-labelledby="questionsDialogTitle" aria-hidden="true">
<div class="modal-dialog modal-xl modal-dialog-scrollable">
<div class="modal-content">
<div class="modal-header">
<h2 class="modal-title h4" id="questionsDialogTitle">Questions: <asp:Literal ID="litQuizTitle" runat="server" Mode="Encode" />
</h2>
<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
</button>
</div>
<div class="modal-body">
<asp:Label ID="lblQuestionFeedback" runat="server" CssClass="text-danger d-block" />
<asp:Panel ID="pnlChildren" runat="server" Visible="false">
<asp:Panel ID="pnlQuestionList" runat="server">
<div class="quiz-admin-heading">
<h3 class="h5">Question list</h3>
<asp:Button ID="btnNewChild" runat="server" Text="+ New question" CausesValidation="false" OnClick="btnNewChild_Click" CssClass="btn btn-primary" />
</div>
<p>Unpublish before changing content. Assessments with attempts retain their existing content; create a new assessment for revisions.</p>
<div class="quiz-grid">
<asp:GridView ID="gvQuestions" runat="server" OnRowCommand="Child_RowCommand" DataSourceID="sdsQuestions" DataKeyNames="QuestionID" AutoGenerateColumns="false" AutoGenerateSelectButton="false" SelectedRowStyle-CssClass="quiz-selected-row" AllowPaging="true" PageSize="6" UseAccessibleHeader="true" CssClass="table table-striped" EmptyDataText="No records." OnSelectedIndexChanged="Child_SelectedIndexChanged" OnPageIndexChanging="Child_PageIndexChanging">
<Columns>
<asp:BoundField DataField="QuestionText" HeaderText="Question" HtmlEncode="true" />
<asp:TemplateField HeaderText="Actions">
<ItemTemplate>
<span class="member3-actions">
<asp:LinkButton runat="server" Text="View" CommandName="ViewChild" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" /> <span aria-hidden="true">|</span> <asp:LinkButton runat="server" Text="Delete" CommandName="DeleteChild" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" /> <span aria-hidden="true">|</span> <asp:LinkButton runat="server" Text="Edit" CommandName="EditChild" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
</span>
</ItemTemplate>
</asp:TemplateField>
</Columns>
</asp:GridView>
</div>
</asp:Panel>
<asp:Panel ID="pnlDeleteChild" runat="server" Visible="false">
<h3>Delete question?</h3>
<p>
<asp:Literal ID="litDeleteChild" runat="server" Mode="Encode" />
</p>
<p>Content with attempts cannot be deleted.</p>
<asp:Button ID="btnCancelChildDelete" runat="server" Text="Cancel" OnClick="BackQuestions_Click" CausesValidation="false" CssClass="btn btn-outline-secondary" /> <asp:Button ID="btnConfirmChildDelete" runat="server" Text="Delete question" OnClick="ConfirmChildDelete_Click" CausesValidation="false" CssClass="btn btn-danger" />
</asp:Panel>
<asp:Panel ID="pnlQuestionEditor" runat="server" Visible="false">
<asp:Button ID="btnBackQuestions" runat="server" Text="Back to questions" OnClick="BackQuestions_Click" CausesValidation="false" CssClass="btn btn-outline-secondary mb-3" />
<asp:DetailsView ID="dvChild" runat="server" OnModeChanging="Child_ModeChanging" OnItemInserted="Child_ItemInserted" OnItemUpdated="Child_ItemUpdated" OnItemDeleted="Child_ItemDeleted" DataSourceID="sdsChildDetails" DataKeyNames="QuestionID" AutoGenerateRows="false" CssClass="table" OnItemInserting="Child_ItemInserting" OnItemUpdating="Child_ItemUpdating" OnDataBound="Details_DataBound">
<Fields>
<asp:BoundField DataField="QuestionID" HeaderText="ID" ReadOnly="true" InsertVisible="false" />
<asp:TemplateField HeaderText="Question" ShowHeader="false">
<ItemTemplate>
<strong>Question</strong>
<br />
<%#: Eval("QuestionText") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtQuestion" Text="Question" />
<asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control" MaxLength="500" TextMode="MultiLine" Rows="3" Text='<%# Bind("QuestionText") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtQuestion" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Question is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtQuestion" ValidationExpression="^[\s\S]{0,500}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Question exceeds 500 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtQuestion" Text="Question" />
<asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control" MaxLength="500" TextMode="MultiLine" Rows="3" Text='<%# Bind("QuestionText") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtQuestion" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Question is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtQuestion" ValidationExpression="^[\s\S]{0,500}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Question exceeds 500 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Option A" ShowHeader="false">
<ItemTemplate>
<strong>Option A</strong>
<br />
<%#: Eval("OptionA") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtOptionA" Text="Option A" />
<asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" MaxLength="200" Text='<%# Bind("OptionA") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtOptionA" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option A is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtOptionA" ValidationExpression="^[\s\S]{0,200}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option A exceeds 200 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtOptionA" Text="Option A" />
<asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" MaxLength="200" Text='<%# Bind("OptionA") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtOptionA" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option A is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtOptionA" ValidationExpression="^[\s\S]{0,200}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option A exceeds 200 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Option B" ShowHeader="false">
<ItemTemplate>
<strong>Option B</strong>
<br />
<%#: Eval("OptionB") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtOptionB" Text="Option B" />
<asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" MaxLength="200" Text='<%# Bind("OptionB") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtOptionB" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option B is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtOptionB" ValidationExpression="^[\s\S]{0,200}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option B exceeds 200 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtOptionB" Text="Option B" />
<asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" MaxLength="200" Text='<%# Bind("OptionB") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtOptionB" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option B is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtOptionB" ValidationExpression="^[\s\S]{0,200}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option B exceeds 200 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Option C" ShowHeader="false">
<ItemTemplate>
<strong>Option C</strong>
<br />
<%#: Eval("OptionC") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtOptionC" Text="Option C" />
<asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" MaxLength="200" Text='<%# Bind("OptionC") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtOptionC" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option C is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtOptionC" ValidationExpression="^[\s\S]{0,200}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option C exceeds 200 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtOptionC" Text="Option C" />
<asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" MaxLength="200" Text='<%# Bind("OptionC") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtOptionC" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option C is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtOptionC" ValidationExpression="^[\s\S]{0,200}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option C exceeds 200 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Option D" ShowHeader="false">
<ItemTemplate>
<strong>Option D</strong>
<br />
<%#: Eval("OptionD") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtOptionD" Text="Option D" />
<asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" MaxLength="200" Text='<%# Bind("OptionD") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtOptionD" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option D is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtOptionD" ValidationExpression="^[\s\S]{0,200}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option D exceeds 200 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtOptionD" Text="Option D" />
<asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" MaxLength="200" Text='<%# Bind("OptionD") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtOptionD" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option D is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtOptionD" ValidationExpression="^[\s\S]{0,200}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Option D exceeds 200 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Correct option" ShowHeader="false">
<ItemTemplate>
<strong>Correct option</strong>
<br />
<%#: Eval("CorrectOption") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="ddlCorrectOption" Text="Correct option" />
<asp:DropDownList ID="ddlCorrectOption" runat="server" CssClass="form-select" SelectedValue='<%# Bind("CorrectOption") %>'>
<asp:ListItem Value="">Choose</asp:ListItem>
<asp:ListItem>A</asp:ListItem>
<asp:ListItem>B</asp:ListItem>
<asp:ListItem>C</asp:ListItem>
<asp:ListItem>D</asp:ListItem>
</asp:DropDownList>
<asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCorrectOption" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Correct option is required." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="ddlCorrectOption" Text="Correct option" />
<asp:DropDownList ID="ddlCorrectOption" runat="server" CssClass="form-select" SelectedValue='<%# Bind("CorrectOption") %>'>
<asp:ListItem Value="">Choose</asp:ListItem>
<asp:ListItem>A</asp:ListItem>
<asp:ListItem>B</asp:ListItem>
<asp:ListItem>C</asp:ListItem>
<asp:ListItem>D</asp:ListItem>
</asp:DropDownList>
<asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCorrectOption" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Correct option is required." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Explanation" ShowHeader="false">
<ItemTemplate>
<strong>Explanation</strong>
<br />
<%#: Eval("Explanation") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtExplanation" Text="Explanation" />
<asp:TextBox ID="txtExplanation" runat="server" CssClass="form-control" MaxLength="500" TextMode="MultiLine" Rows="3" Text='<%# Bind("Explanation") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtExplanation" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Explanation is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtExplanation" ValidationExpression="^[\s\S]{0,500}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Explanation exceeds 500 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtExplanation" Text="Explanation" />
<asp:TextBox ID="txtExplanation" runat="server" CssClass="form-control" MaxLength="500" TextMode="MultiLine" Rows="3" Text='<%# Bind("Explanation") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtExplanation" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Explanation is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtExplanation" ValidationExpression="^[\s\S]{0,500}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Explanation exceeds 500 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:CommandField ShowEditButton="true" ShowInsertButton="true" InsertText="Save question" UpdateText="Save changes" ValidationGroup="Child" />

</Fields>
</asp:DetailsView>
<asp:ValidationSummary runat="server" ValidationGroup="Child" CssClass="text-danger" />
</asp:Panel>
</asp:Panel>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
</div>
</div>
</div>
</div>
<div class="modal fade" id="deleteQuizModal" tabindex="-1" aria-labelledby="deleteDialogTitle" aria-hidden="true">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header">
<h2 id="deleteDialogTitle" class="modal-title h4">Delete quiz?</h2>
<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
</button>
</div>
<div class="modal-body">
<p>Delete <strong>
<asp:Literal ID="litDeleteTitle" runat="server" Mode="Encode" />
</strong> and its questions?</p>
<p>This cannot be undone. Quizzes with attempts cannot be deleted; unpublish them instead.</p>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
<asp:Button ID="btnConfirmDelete" runat="server" Text="Delete quiz" CssClass="btn btn-danger" CausesValidation="false" OnClick="ConfirmDelete_Click" />
</div>
</div>
</div>
</div>

<asp:SqlDataSource ID="sdsCategories" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT CategoryID,Name FROM Categories ORDER BY SortOrder,CategoryID">
<SelectParameters>
</SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsQuizzes" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT p.*,c.Name AS CategoryName,(SELECT COUNT(*) FROM Questions x WHERE x.QuizID=p.QuizID) AS ContentCount FROM Quizzes p INNER JOIN Categories c ON p.CategoryID=c.CategoryID ORDER BY p.QuizID DESC">
<SelectParameters>
</SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsHeaderDetails" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT * FROM Quizzes WHERE QuizID=@QuizID" InsertCommand="INSERT INTO Quizzes(Title,CategoryID,Description,IsPublished) VALUES(@Title,@CategoryID,@Description,@IsPublished)" UpdateCommand="UPDATE Quizzes SET Title=@Title, CategoryID=@CategoryID, Description=@Description, IsPublished=@IsPublished WHERE QuizID=@QuizID AND (@IsPublished=0 OR (EXISTS(SELECT 1 FROM Questions WHERE QuizID=@QuizID)))" DeleteCommand="DELETE FROM Quizzes WHERE QuizID=@QuizID AND NOT EXISTS(SELECT 1 FROM QuizAttempts WHERE QuizID=@QuizID)">
<SelectParameters>
<asp:ControlParameter Name="QuizID" Type="Int32" ControlID="gvQuizzes" PropertyName="SelectedValue" DefaultValue="0" />
</SelectParameters>
<InsertParameters>
<asp:Parameter Name="Title" Type="String" />
<asp:Parameter Name="CategoryID" Type="Int32" />
<asp:Parameter Name="Description" Type="String" />
<asp:Parameter Name="IsPublished" Type="Boolean" />
</InsertParameters>
<UpdateParameters>
<asp:Parameter Name="Title" Type="String" />
<asp:Parameter Name="CategoryID" Type="Int32" />
<asp:Parameter Name="Description" Type="String" />
<asp:Parameter Name="IsPublished" Type="Boolean" />
<asp:Parameter Name="QuizID" Type="Int32" />
</UpdateParameters>
<DeleteParameters>
<asp:Parameter Name="QuizID" Type="Int32" />
</DeleteParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsQuestions" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT * FROM Questions WHERE QuizID=@QuizID ORDER BY QuestionID">
<SelectParameters>
<asp:ControlParameter Name="QuizID" Type="Int32" ControlID="gvQuizzes" PropertyName="SelectedValue" DefaultValue="0" />
</SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsChildDetails" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT * FROM Questions WHERE QuestionID=@QuestionID AND QuizID=@QuizID" InsertCommand="INSERT INTO Questions(QuizID,QuestionText,OptionA,OptionB,OptionC,OptionD,CorrectOption,Explanation) SELECT @QuizID,@QuestionText,@OptionA,@OptionB,@OptionC,@OptionD,@CorrectOption,@Explanation WHERE EXISTS(SELECT 1 FROM Quizzes WHERE QuizID=@QuizID AND IsPublished=0) AND NOT EXISTS(SELECT 1 FROM QuizAttempts WHERE QuizID=@QuizID)" UpdateCommand="UPDATE Questions SET QuestionText=@QuestionText, OptionA=@OptionA, OptionB=@OptionB, OptionC=@OptionC, OptionD=@OptionD, CorrectOption=@CorrectOption, Explanation=@Explanation WHERE QuestionID=@QuestionID AND QuizID=@QuizID AND EXISTS(SELECT 1 FROM Quizzes WHERE QuizID=@QuizID AND IsPublished=0) AND NOT EXISTS(SELECT 1 FROM QuizAttempts WHERE QuizID=@QuizID)" DeleteCommand="DELETE FROM Questions WHERE QuestionID=@QuestionID AND QuizID=@QuizID AND EXISTS(SELECT 1 FROM Quizzes WHERE QuizID=@QuizID AND IsPublished=0) AND NOT EXISTS(SELECT 1 FROM QuizAttempts WHERE QuizID=@QuizID)">
<SelectParameters>
<asp:ControlParameter Name="QuestionID" Type="Int32" ControlID="gvQuestions" PropertyName="SelectedValue" DefaultValue="0" />
<asp:ControlParameter Name="QuizID" Type="Int32" ControlID="gvQuizzes" PropertyName="SelectedValue" DefaultValue="0" />
</SelectParameters>
<InsertParameters>
<asp:Parameter Name="QuestionText" Type="String" />
<asp:Parameter Name="OptionA" Type="String" />
<asp:Parameter Name="OptionB" Type="String" />
<asp:Parameter Name="OptionC" Type="String" />
<asp:Parameter Name="OptionD" Type="String" />
<asp:Parameter Name="CorrectOption" Type="String" />
<asp:Parameter Name="Explanation" Type="String" />
<asp:ControlParameter Name="QuizID" Type="Int32" ControlID="gvQuizzes" PropertyName="SelectedValue" DefaultValue="0" />
</InsertParameters>
<UpdateParameters>
<asp:Parameter Name="QuestionText" Type="String" />
<asp:Parameter Name="OptionA" Type="String" />
<asp:Parameter Name="OptionB" Type="String" />
<asp:Parameter Name="OptionC" Type="String" />
<asp:Parameter Name="OptionD" Type="String" />
<asp:Parameter Name="CorrectOption" Type="String" />
<asp:Parameter Name="Explanation" Type="String" />
<asp:ControlParameter Name="QuizID" Type="Int32" ControlID="gvQuizzes" PropertyName="SelectedValue" DefaultValue="0" />
<asp:Parameter Name="QuestionID" Type="Int32" />
</UpdateParameters>
<DeleteParameters>
<asp:Parameter Name="QuestionID" Type="Int32" />
<asp:ControlParameter Name="QuizID" Type="Int32" ControlID="gvQuizzes" PropertyName="SelectedValue" DefaultValue="0" />
</DeleteParameters>
</asp:SqlDataSource>
</asp:Content>
