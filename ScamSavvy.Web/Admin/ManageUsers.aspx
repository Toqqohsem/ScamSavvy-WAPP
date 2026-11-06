<%@ Page Title="Manage Users | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageUsers.aspx.cs" Inherits="Admin_ManageUsers" %>
<%-- Owner: Ahmad (Accounts module) --%>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="ss-page-header d-flex flex-wrap justify-content-between align-items-end gap-2">
        <div>
            <h1 class="h2">Manage Users</h1>
            <p>Change roles, deactivate or unlock accounts, and remove users.</p>
        </div>
        <asp:HyperLink ID="lnkDashboard" runat="server" NavigateUrl="~/Admin/Dashboard.aspx" CssClass="btn btn-outline-primary" Text="Back to dashboard" />
    </div>

    <asp:Label ID="lblMessage" runat="server" EnableViewState="false" Visible="false" />

    <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch" CssClass="card ss-card mb-3">
        <div class="card-body row g-2 align-items-end">
            <div class="col-md-6">
                <asp:Label runat="server" AssociatedControlID="txtSearch" CssClass="form-label" Text="Name or email" />
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" MaxLength="150" />
            </div>
            <div class="col-md-3">
                <asp:Label runat="server" AssociatedControlID="ddlRole" CssClass="form-label" Text="Role" />
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                    <asp:ListItem Value="" Text="All roles" />
                    <asp:ListItem Value="Member" Text="Member" />
                    <asp:ListItem Value="Contributor" Text="Contributor" />
                    <asp:ListItem Value="Admin" Text="Admin" />
                </asp:DropDownList>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary flex-fill" CausesValidation="false" OnClick="btnSearch_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-secondary" CausesValidation="false" OnClick="btnClear_Click" />
            </div>
        </div>
    </asp:Panel>

    <p class="small text-muted"><asp:Literal ID="litCount" runat="server" /></p>

    <div class="table-responsive">
        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" DataKeyNames="UserID"
            CssClass="table table-hover align-middle ss-table" GridLines="None" UseAccessibleHeader="true"
            AllowPaging="true" PageSize="10" PagerStyle-CssClass="ss-pager"
            EmptyDataText="No users match your search."
            OnPageIndexChanging="gvUsers_PageIndexChanging"
            OnRowDataBound="gvUsers_RowDataBound"
            OnRowEditing="gvUsers_RowEditing"
            OnRowCancelingEdit="gvUsers_RowCancelingEdit"
            OnRowUpdating="gvUsers_RowUpdating"
            OnRowDeleting="gvUsers_RowDeleting"
            OnRowCommand="gvUsers_RowCommand">
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Name" ReadOnly="true" />
                <asp:BoundField DataField="Email" HeaderText="Email" ReadOnly="true" />
                <asp:TemplateField HeaderText="Role">
                    <ItemTemplate><%# Server.HtmlEncode(Convert.ToString(Eval("Role"))) %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-select form-select-sm" SelectedValue='<%# Eval("Role") %>'>
                            <asp:ListItem Value="Member" Text="Member" />
                            <asp:ListItem Value="Contributor" Text="Contributor" />
                            <asp:ListItem Value="Admin" Text="Admin" />
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class='badge <%# (bool)Eval("IsActive") ? "text-bg-success" : "text-bg-secondary" %>'><%# (bool)Eval("IsActive") ? "Active" : "Deactivated" %></span>
                        <asp:Label ID="lblLocked" runat="server" CssClass="badge text-bg-danger" Text="Locked"
                            Visible='<%# (bool)Eval("IsLocked") %>' />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:CheckBox ID="chkEditActive" runat="server" Text=" Active" Checked='<%# (bool)Eval("IsActive") %>' />
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CreatedAt" HeaderText="Joined" ReadOnly="true" DataFormatString="{0:dd MMM yyyy}" />
                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-nowrap">
                    <ItemTemplate>
                        <asp:Label ID="lblYou" runat="server" CssClass="text-muted small me-2" Text="This is you" Visible="false" />
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" Text="Edit"
                            CssClass="btn btn-sm btn-outline-primary" CausesValidation="false" />
                        <asp:LinkButton ID="btnUnlock" runat="server" CommandName="Unlock" CommandArgument='<%# Eval("UserID") %>' Text="Unlock"
                            CssClass="btn btn-sm btn-outline-warning" CausesValidation="false"
                            Visible='<%# (bool)Eval("IsLocked") %>' />
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" Text="Delete"
                            CssClass="btn btn-sm btn-outline-danger" CausesValidation="false"
                            OnClientClick="return confirm('Delete this user? Their progress and attempts are deleted too.');" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" Text="Save"
                            CssClass="btn btn-sm btn-primary" CausesValidation="false" />
                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" Text="Cancel"
                            CssClass="btn btn-sm btn-outline-secondary" CausesValidation="false" />
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
