<%@ Page Title="Manage Categories | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageCategories.aspx.cs" Inherits="Admin_ManageCategories" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Manage Categories only (internal CSS) */
        .lesson-admin-form { padding: 1.25rem 1.5rem; }
        .lesson-usage { font-size: .82rem; color: #5b6676; white-space: nowrap; }
        .lesson-usage strong { color: #1b2430; }
        .lesson-desc { max-width: 28rem; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="site-page-header d-flex flex-wrap justify-content-between align-items-end gap-2">
        <div>
            <h1>Manage Categories</h1>
            <p>Scam categories group lessons, quizzes, scenarios and reports. A category cannot be deleted while anything uses it.</p>
        </div>
        <asp:HyperLink ID="lnkLessons" runat="server" NavigateUrl="~/Admin/ManageLessons.aspx" CssClass="btn btn-outline-primary">Manage lessons</asp:HyperLink>
    </div>

    <asp:Label ID="lblMessage" runat="server" Visible="false" role="status" />

    <!-- Add form -->
    <section class="site-card lesson-admin-form mb-4" aria-labelledby="addTitle">
        <h2 id="addTitle" class="h5 mb-3">Add a category</h2>
        <asp:ValidationSummary ID="vsAdd" runat="server" ValidationGroup="Add" CssClass="alert alert-danger"
            HeaderText="Please fix the following:" DisplayMode="BulletList" />
        <div class="row g-3">
            <div class="col-md-5">
                <asp:Label ID="lblName" runat="server" AssociatedControlID="txtName" CssClass="form-label" Text="Name" />
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100" />
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ValidationGroup="Add"
                    ErrorMessage="Name is required." Text="Name is required." Display="Dynamic" CssClass="text-danger" />
            </div>
            <div class="col-md-2">
                <asp:Label ID="lblSortOrder" runat="server" AssociatedControlID="txtSortOrder" CssClass="form-label" Text="Sort order" />
                <asp:TextBox ID="txtSortOrder" runat="server" CssClass="form-control" TextMode="Number" />
                <asp:RequiredFieldValidator ID="rfvSortOrder" runat="server" ControlToValidate="txtSortOrder" ValidationGroup="Add"
                    ErrorMessage="Sort order is required." Text="Required." Display="Dynamic" CssClass="text-danger" />
                <asp:RangeValidator ID="rvSortOrder" runat="server" ControlToValidate="txtSortOrder" ValidationGroup="Add"
                    Type="Integer" MinimumValue="0" MaximumValue="999"
                    ErrorMessage="Sort order must be a whole number from 0 to 999." Text="0 to 999." Display="Dynamic" CssClass="text-danger" />
            </div>
            <div class="col-12">
                <asp:Label ID="lblDescription" runat="server" AssociatedControlID="txtDescription" CssClass="form-label" Text="Description" />
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" data-counter="500" />
                <asp:RegularExpressionValidator ID="revDescription" runat="server" ControlToValidate="txtDescription" ValidationGroup="Add"
                    ValidationExpression="^[\s\S]{0,500}$"
                    ErrorMessage="Description can be up to 500 characters." Text="Up to 500 characters." Display="Dynamic" CssClass="text-danger" />
            </div>
            <div class="col-12">
                <asp:Button ID="btnAdd" runat="server" Text="Add category" CssClass="btn btn-primary" ValidationGroup="Add" OnClick="btnAdd_Click" />
            </div>
        </div>
    </section>

    <!-- List with edit and delete -->
    <asp:ValidationSummary ID="vsEdit" runat="server" ValidationGroup="Edit" CssClass="alert alert-danger"
        HeaderText="Please fix the following:" DisplayMode="BulletList" />

    <div class="table-responsive">
        <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="false" DataKeyNames="CategoryID"
            CssClass="table site-table align-middle" GridLines="None" UseAccessibleHeader="true"
            OnRowEditing="gvCategories_RowEditing" OnRowCancelingEdit="gvCategories_RowCancelingEdit"
            OnRowUpdating="gvCategories_RowUpdating" OnRowDeleting="gvCategories_RowDeleting">
            <Columns>
                <asp:BoundField DataField="CategoryID" HeaderText="ID" ReadOnly="true" />

                <asp:TemplateField HeaderText="Name">
                    <ItemTemplate><strong><%#: Eval("Name") %></strong></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditName" runat="server" CssClass="form-control" MaxLength="100" Text='<%# Eval("Name") %>' aria-label="Name" />
                        <asp:RequiredFieldValidator ID="rfvEditName" runat="server" ControlToValidate="txtEditName" ValidationGroup="Edit"
                            ErrorMessage="Name is required." Text="Required." Display="Dynamic" CssClass="text-danger" />
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Description">
                    <ItemTemplate><div class="lesson-desc small"><%#: Eval("Description") %></div></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" Text='<%# Eval("Description") %>' aria-label="Description" />
                        <asp:RegularExpressionValidator ID="revEditDescription" runat="server" ControlToValidate="txtEditDescription" ValidationGroup="Edit"
                            ValidationExpression="^[\s\S]{0,500}$" ErrorMessage="Description can be up to 500 characters." Text="Up to 500 characters."
                            Display="Dynamic" CssClass="text-danger" />
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Order">
                    <ItemTemplate><%#: Eval("SortOrder") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEditSortOrder" runat="server" CssClass="form-control" TextMode="Number" Text='<%# Eval("SortOrder") %>' aria-label="Sort order" />
                        <asp:RequiredFieldValidator ID="rfvEditSortOrder" runat="server" ControlToValidate="txtEditSortOrder" ValidationGroup="Edit"
                            ErrorMessage="Sort order is required." Text="Required." Display="Dynamic" CssClass="text-danger" />
                        <asp:RangeValidator ID="rvEditSortOrder" runat="server" ControlToValidate="txtEditSortOrder" ValidationGroup="Edit"
                            Type="Integer" MinimumValue="0" MaximumValue="999" ErrorMessage="Sort order must be 0 to 999." Text="0 to 999."
                            Display="Dynamic" CssClass="text-danger" />
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Used by">
                    <ItemTemplate>
                        <div class="lesson-usage">
                            <strong><%#: Eval("LessonCount") %></strong> lessons &middot;
                            <strong><%#: Eval("QuizCount") %></strong> quizzes<br />
                            <strong><%#: Eval("ScenarioCount") %></strong> scenarios &middot;
                            <strong><%#: Eval("ReportCount") %></strong> reports
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <div class="d-flex gap-1">
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CausesValidation="false"
                                CssClass="btn btn-sm btn-outline-primary">Edit</asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CausesValidation="false"
                                CssClass="btn btn-sm btn-outline-danger"
                                OnClientClick="return confirm('Delete this record?');">Delete</asp:LinkButton>
                        </div>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <div class="d-flex gap-1">
                            <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" ValidationGroup="Edit"
                                CssClass="btn btn-sm btn-primary">Save</asp:LinkButton>
                            <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CausesValidation="false"
                                CssClass="btn btn-sm btn-outline-secondary">Cancel</asp:LinkButton>
                        </div>
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="site-empty">No categories yet. Add one above.</div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>

</asp:Content>
