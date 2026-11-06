<%@ Page Title="Manage Scenarios | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageScenarios.aspx.cs" Inherits="Admin_ManageScenarios" %>
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
<h1>Manage Scenarios</h1>
<asp:Button ID="btnNewHeader" runat="server" Text="+ New scenario" CausesValidation="false" OnClick="btnNewHeader_Click" CssClass="btn btn-primary" />
</div>
<asp:Label ID="lblMessage" runat="server" Visible="false" role="status" />
<p>View scenario details, edit settings or manage message parts. New scenarios start as drafts.</p>
<div class="quiz-grid">
<asp:GridView ID="gvScenarios" runat="server" OnRowCommand="Header_RowCommand" DataSourceID="sdsScenarios" DataKeyNames="ScenarioID" AutoGenerateColumns="false" AutoGenerateSelectButton="false" SelectedRowStyle-CssClass="quiz-selected-row" AllowPaging="true" PageSize="6" UseAccessibleHeader="true" CssClass="table table-striped" EmptyDataText="No records." OnSelectedIndexChanged="Header_SelectedIndexChanged" OnPageIndexChanging="Header_PageIndexChanging">
<Columns>
<asp:BoundField DataField="Title" HeaderText="Title" HtmlEncode="true" />
<asp:BoundField DataField="CategoryName" HeaderText="Category" HtmlEncode="true" />
<asp:BoundField DataField="Channel" HeaderText="Channel" HtmlEncode="true" />
<asp:BoundField DataField="SenderName" HeaderText="Sender" HtmlEncode="true" />
<asp:BoundField DataField="ContentCount" HeaderText="Parts" />
<asp:TemplateField HeaderText="Status">
<ItemTemplate>
<%# Convert.ToBoolean(Eval("IsPublished")) ? "Published" : "Draft" %>
</ItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Actions">
<ItemTemplate>
<span class="member3-actions">
<asp:LinkButton runat="server" Text="View" CommandName="ViewAssessment" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" /> <span aria-hidden="true">|</span> <asp:LinkButton runat="server" Text="Edit" CommandName="EditAssessment" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" /> <span aria-hidden="true">|</span> <asp:LinkButton runat="server" Text="Delete" CommandName="DeleteAssessment" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" /> <span aria-hidden="true">|</span> <asp:LinkButton runat="server" Text="Manage parts" CommandName="Questions" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
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
<asp:DetailsView ID="dvHeader" runat="server" OnItemInserted="Header_ItemInserted" OnItemUpdated="Header_ItemUpdated" OnItemDeleted="Header_ItemDeleted" OnModeChanging="Header_ModeChanging" DataSourceID="sdsHeaderDetails" DataKeyNames="ScenarioID" AutoGenerateRows="false" CssClass="table" OnItemInserting="Header_ItemInserting" OnItemUpdating="Header_ItemUpdating" OnDataBound="Details_DataBound">
<Fields>
<asp:BoundField DataField="ScenarioID" HeaderText="ID" ReadOnly="true" InsertVisible="false" />
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
<asp:TemplateField HeaderText="Channel" ShowHeader="false">
<ItemTemplate>
<strong>Channel</strong>
<br />
<%#: Eval("Channel") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="ddlChannel" Text="Channel" />
<asp:DropDownList ID="ddlChannel" runat="server" CssClass="form-select" SelectedValue='<%# Bind("Channel") %>'>
<asp:ListItem Value="">Choose</asp:ListItem>
<asp:ListItem>SMS</asp:ListItem>
<asp:ListItem>WhatsApp</asp:ListItem>
<asp:ListItem>Email</asp:ListItem>
<asp:ListItem>Call</asp:ListItem>
</asp:DropDownList>
<asp:RequiredFieldValidator runat="server" ControlToValidate="ddlChannel" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Channel is required." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="ddlChannel" Text="Channel" />
<asp:DropDownList ID="ddlChannel" runat="server" CssClass="form-select" SelectedValue='<%# Bind("Channel") %>'>
<asp:ListItem Value="">Choose</asp:ListItem>
<asp:ListItem>SMS</asp:ListItem>
<asp:ListItem>WhatsApp</asp:ListItem>
<asp:ListItem>Email</asp:ListItem>
<asp:ListItem>Call</asp:ListItem>
</asp:DropDownList>
<asp:RequiredFieldValidator runat="server" ControlToValidate="ddlChannel" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Channel is required." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Sender name" ShowHeader="false">
<ItemTemplate>
<strong>Sender</strong>
<br />
<%#: Eval("SenderName") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtSenderName" Text="Sender name" />
<asp:TextBox ID="txtSenderName" runat="server" CssClass="form-control" MaxLength="100" Text='<%# Bind("SenderName") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtSenderName" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Sender name is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtSenderName" ValidationExpression="^[\s\S]{0,100}$" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Sender name exceeds 100 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtSenderName" Text="Sender name" />
<asp:TextBox ID="txtSenderName" runat="server" CssClass="form-control" MaxLength="100" Text='<%# Bind("SenderName") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtSenderName" InitialValue="" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Sender name is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtSenderName" ValidationExpression="^[\s\S]{0,100}$" ValidationGroup="Header" Display="Dynamic" CssClass="text-danger" ErrorMessage="Sender name exceeds 100 characters." />
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
<asp:CommandField ShowEditButton="true" ShowInsertButton="true" InsertText="Save scenario" UpdateText="Save changes" ValidationGroup="Header" />

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
<div class="modal fade" id="partsModal" tabindex="-1" aria-labelledby="questionsDialogTitle" aria-hidden="true">
<div class="modal-dialog modal-xl modal-dialog-scrollable">
<div class="modal-content">
<div class="modal-header">
<h2 class="modal-title h4" id="questionsDialogTitle">Message parts: <asp:Literal ID="litScenarioTitle" runat="server" Mode="Encode" />
</h2>
<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
</button>
</div>
<div class="modal-body">
<asp:Label ID="lblQuestionFeedback" runat="server" CssClass="text-danger d-block" />
<asp:Panel ID="pnlChildren" runat="server" Visible="false">
<asp:Panel ID="pnlQuestionList" runat="server">
<asp:HyperLink ID="lnkPreview" runat="server" Text="Open published scenario" CssClass="btn btn-outline-primary" />
<div class="quiz-admin-heading">
<h3 class="h5">Message parts</h3>
<asp:Button ID="btnNewChild" runat="server" Text="+ New part" CausesValidation="false" OnClick="btnNewChild_Click" CssClass="btn btn-primary" />
</div>
<p>Unpublish before changing content. Assessments with attempts retain their existing content; create a new assessment for revisions.</p>
<div class="quiz-grid">
<asp:GridView ID="gvParts" runat="server" OnRowCommand="Child_RowCommand" DataSourceID="sdsScenarioParts" DataKeyNames="PartID" AutoGenerateColumns="false" AutoGenerateSelectButton="false" SelectedRowStyle-CssClass="quiz-selected-row" AllowPaging="true" PageSize="6" UseAccessibleHeader="true" CssClass="table table-striped" EmptyDataText="No records." OnSelectedIndexChanged="Child_SelectedIndexChanged" OnPageIndexChanging="Child_PageIndexChanging">
<Columns>
<asp:BoundField DataField="PartOrder" HeaderText="Order" HtmlEncode="true" />
<asp:BoundField DataField="PartText" HeaderText="Text" HtmlEncode="true" />
<asp:BoundField DataField="IsRedFlag" HeaderText="Red flag" HtmlEncode="true" />
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
<h3>Delete part?</h3>
<p>
<asp:Literal ID="litDeleteChild" runat="server" Mode="Encode" />
</p>
<p>Content with attempts cannot be deleted.</p>
<asp:Button ID="btnCancelChildDelete" runat="server" Text="Cancel" OnClick="BackQuestions_Click" CausesValidation="false" CssClass="btn btn-outline-secondary" /> <asp:Button ID="btnConfirmChildDelete" runat="server" Text="Delete part" OnClick="ConfirmChildDelete_Click" CausesValidation="false" CssClass="btn btn-danger" />
</asp:Panel>
<asp:Panel ID="pnlQuestionEditor" runat="server" Visible="false">
<asp:Button ID="btnBackQuestions" runat="server" Text="Back to parts" OnClick="BackQuestions_Click" CausesValidation="false" CssClass="btn btn-outline-secondary mb-3" />
<asp:DetailsView ID="dvChild" runat="server" OnModeChanging="Child_ModeChanging" OnItemInserted="Child_ItemInserted" OnItemUpdated="Child_ItemUpdated" OnItemDeleted="Child_ItemDeleted" DataSourceID="sdsChildDetails" DataKeyNames="PartID" AutoGenerateRows="false" CssClass="table" OnItemInserting="Child_ItemInserting" OnItemUpdating="Child_ItemUpdating" OnDataBound="Details_DataBound">
<Fields>
<asp:BoundField DataField="PartID" HeaderText="ID" ReadOnly="true" InsertVisible="false" />
<asp:TemplateField HeaderText="Part order" ShowHeader="false">
<ItemTemplate>
<strong>Part order</strong>
<br />
<%#: Eval("PartOrder") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtPartOrder" Text="Part order" />
<asp:TextBox ID="txtPartOrder" runat="server" CssClass="form-control" MaxLength="0" Text='<%# Bind("PartOrder") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtPartOrder" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Part order is required." />
<asp:RangeValidator runat="server" ControlToValidate="txtPartOrder" Type="Integer" MinimumValue="1" MaximumValue="999" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Order must be from 1 to 999." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtPartOrder" Text="Part order" />
<asp:TextBox ID="txtPartOrder" runat="server" CssClass="form-control" MaxLength="0" Text='<%# Bind("PartOrder") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtPartOrder" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Part order is required." />
<asp:RangeValidator runat="server" ControlToValidate="txtPartOrder" Type="Integer" MinimumValue="1" MaximumValue="999" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Order must be from 1 to 999." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Message part" ShowHeader="false">
<ItemTemplate>
<strong>Message part</strong>
<br />
<%#: Eval("PartText") %>
</ItemTemplate>
<EditItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtPartText" Text="Message part" />
<asp:TextBox ID="txtPartText" runat="server" CssClass="form-control" MaxLength="500" TextMode="MultiLine" Rows="3" Text='<%# Bind("PartText") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtPartText" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Message part is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtPartText" ValidationExpression="^[\s\S]{0,500}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Message part exceeds 500 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtPartText" Text="Message part" />
<asp:TextBox ID="txtPartText" runat="server" CssClass="form-control" MaxLength="500" TextMode="MultiLine" Rows="3" Text='<%# Bind("PartText") %>' />
<asp:RequiredFieldValidator runat="server" ControlToValidate="txtPartText" InitialValue="" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Message part is required." />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtPartText" ValidationExpression="^[\s\S]{0,500}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Message part exceeds 500 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:TemplateField HeaderText="Red flag" ShowHeader="false">
<ItemTemplate>
<asp:CheckBox runat="server" Text="Red flag" Enabled="false" Checked='<%# Eval("IsRedFlag") %>' />
</ItemTemplate>
<EditItemTemplate>
<asp:CheckBox ID="chkRedFlag" runat="server" Checked='<%# Bind("IsRedFlag") %>' Text="Red flag" />
</EditItemTemplate>
<InsertItemTemplate>
<asp:CheckBox ID="chkRedFlag" runat="server" Checked='<%# Bind("IsRedFlag") %>' Text="Red flag" />
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
<asp:TextBox ID="txtExplanation" runat="server" CssClass="form-control" MaxLength="300" TextMode="MultiLine" Rows="3" Text='<%# Bind("Explanation") %>' />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtExplanation" ValidationExpression="^[\s\S]{0,300}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Explanation exceeds 300 characters." />
</EditItemTemplate>
<InsertItemTemplate>
<asp:Label runat="server" AssociatedControlID="txtExplanation" Text="Explanation" />
<asp:TextBox ID="txtExplanation" runat="server" CssClass="form-control" MaxLength="300" TextMode="MultiLine" Rows="3" Text='<%# Bind("Explanation") %>' />
<asp:RegularExpressionValidator runat="server" ControlToValidate="txtExplanation" ValidationExpression="^[\s\S]{0,300}$" ValidationGroup="Child" Display="Dynamic" CssClass="text-danger" ErrorMessage="Explanation exceeds 300 characters." />
</InsertItemTemplate>
</asp:TemplateField>
<asp:CommandField ShowEditButton="true" ShowInsertButton="true" InsertText="Save part" UpdateText="Save changes" ValidationGroup="Child" />

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
<div class="modal fade" id="deleteScenarioModal" tabindex="-1" aria-labelledby="deleteDialogTitle" aria-hidden="true">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header">
<h2 id="deleteDialogTitle" class="modal-title h4">Delete scenario?</h2>
<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
</button>
</div>
<div class="modal-body">
<p>Delete <strong>
<asp:Literal ID="litDeleteTitle" runat="server" Mode="Encode" />
</strong> and its message parts?</p>
<p>This cannot be undone. Scenarios with attempts cannot be deleted; unpublish them instead.</p>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
<asp:Button ID="btnConfirmDelete" runat="server" Text="Delete scenario" CssClass="btn btn-danger" CausesValidation="false" OnClick="ConfirmDelete_Click" />
</div>
</div>
</div>
</div>

<asp:SqlDataSource ID="sdsCategories" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT CategoryID,Name FROM Categories ORDER BY SortOrder,CategoryID">
<SelectParameters>
</SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsScenarios" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT p.*,c.Name AS CategoryName,(SELECT COUNT(*) FROM ScenarioParts x WHERE x.ScenarioID=p.ScenarioID) AS ContentCount FROM Scenarios p INNER JOIN Categories c ON p.CategoryID=c.CategoryID ORDER BY p.ScenarioID DESC">
<SelectParameters>
</SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsHeaderDetails" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT * FROM Scenarios WHERE ScenarioID=@ScenarioID" InsertCommand="INSERT INTO Scenarios(Title,CategoryID,Channel,SenderName,IsPublished) VALUES(@Title,@CategoryID,@Channel,@SenderName,@IsPublished)" UpdateCommand="UPDATE Scenarios SET Title=@Title, CategoryID=@CategoryID, Channel=@Channel, SenderName=@SenderName, IsPublished=@IsPublished WHERE ScenarioID=@ScenarioID AND (@IsPublished=0 OR ((SELECT COUNT(*) FROM ScenarioParts WHERE ScenarioID=@ScenarioID AND IsRedFlag=1) BETWEEN 3 AND 5 AND NOT EXISTS(SELECT 1 FROM ScenarioParts WHERE ScenarioID=@ScenarioID AND IsRedFlag=1 AND NULLIF(LTRIM(RTRIM(Explanation)),&#x27;&#x27;) IS NULL)))" DeleteCommand="DELETE FROM Scenarios WHERE ScenarioID=@ScenarioID AND NOT EXISTS(SELECT 1 FROM ScenarioAttempts WHERE ScenarioID=@ScenarioID)">
<SelectParameters>
<asp:ControlParameter Name="ScenarioID" Type="Int32" ControlID="gvScenarios" PropertyName="SelectedValue" DefaultValue="0" />
</SelectParameters>
<InsertParameters>
<asp:Parameter Name="Title" Type="String" />
<asp:Parameter Name="CategoryID" Type="Int32" />
<asp:Parameter Name="Channel" Type="String" />
<asp:Parameter Name="SenderName" Type="String" />
<asp:Parameter Name="IsPublished" Type="Boolean" />
</InsertParameters>
<UpdateParameters>
<asp:Parameter Name="Title" Type="String" />
<asp:Parameter Name="CategoryID" Type="Int32" />
<asp:Parameter Name="Channel" Type="String" />
<asp:Parameter Name="SenderName" Type="String" />
<asp:Parameter Name="IsPublished" Type="Boolean" />
<asp:Parameter Name="ScenarioID" Type="Int32" />
</UpdateParameters>
<DeleteParameters>
<asp:Parameter Name="ScenarioID" Type="Int32" />
</DeleteParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsScenarioParts" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT * FROM ScenarioParts WHERE ScenarioID=@ScenarioID ORDER BY PartOrder,PartID">
<SelectParameters>
<asp:ControlParameter Name="ScenarioID" Type="Int32" ControlID="gvScenarios" PropertyName="SelectedValue" DefaultValue="0" />
</SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsChildDetails" runat="server" ConnectionString="<%$ ConnectionStrings:ScamSavvyDB %>" SelectCommand="SELECT * FROM ScenarioParts WHERE PartID=@PartID AND ScenarioID=@ScenarioID" InsertCommand="INSERT INTO ScenarioParts(ScenarioID,PartOrder,PartText,IsRedFlag,Explanation) SELECT @ScenarioID,@PartOrder,@PartText,@IsRedFlag,@Explanation WHERE EXISTS(SELECT 1 FROM Scenarios WHERE ScenarioID=@ScenarioID AND IsPublished=0) AND NOT EXISTS(SELECT 1 FROM ScenarioAttempts WHERE ScenarioID=@ScenarioID)" UpdateCommand="UPDATE ScenarioParts SET PartOrder=@PartOrder, PartText=@PartText, IsRedFlag=@IsRedFlag, Explanation=@Explanation WHERE PartID=@PartID AND ScenarioID=@ScenarioID AND EXISTS(SELECT 1 FROM Scenarios WHERE ScenarioID=@ScenarioID AND IsPublished=0) AND NOT EXISTS(SELECT 1 FROM ScenarioAttempts WHERE ScenarioID=@ScenarioID)" DeleteCommand="DELETE FROM ScenarioParts WHERE PartID=@PartID AND ScenarioID=@ScenarioID AND EXISTS(SELECT 1 FROM Scenarios WHERE ScenarioID=@ScenarioID AND IsPublished=0) AND NOT EXISTS(SELECT 1 FROM ScenarioAttempts WHERE ScenarioID=@ScenarioID)">
<SelectParameters>
<asp:ControlParameter Name="PartID" Type="Int32" ControlID="gvParts" PropertyName="SelectedValue" DefaultValue="0" />
<asp:ControlParameter Name="ScenarioID" Type="Int32" ControlID="gvScenarios" PropertyName="SelectedValue" DefaultValue="0" />
</SelectParameters>
<InsertParameters>
<asp:Parameter Name="PartOrder" Type="Int32" />
<asp:Parameter Name="PartText" Type="String" />
<asp:Parameter Name="IsRedFlag" Type="Boolean" />
<asp:Parameter Name="Explanation" Type="String" />
<asp:ControlParameter Name="ScenarioID" Type="Int32" ControlID="gvScenarios" PropertyName="SelectedValue" DefaultValue="0" />
</InsertParameters>
<UpdateParameters>
<asp:Parameter Name="PartOrder" Type="Int32" />
<asp:Parameter Name="PartText" Type="String" />
<asp:Parameter Name="IsRedFlag" Type="Boolean" />
<asp:Parameter Name="Explanation" Type="String" />
<asp:ControlParameter Name="ScenarioID" Type="Int32" ControlID="gvScenarios" PropertyName="SelectedValue" DefaultValue="0" />
<asp:Parameter Name="PartID" Type="Int32" />
</UpdateParameters>
<DeleteParameters>
<asp:Parameter Name="PartID" Type="Int32" />
<asp:ControlParameter Name="ScenarioID" Type="Int32" ControlID="gvScenarios" PropertyName="SelectedValue" DefaultValue="0" />
</DeleteParameters>
</asp:SqlDataSource>
</asp:Content>
