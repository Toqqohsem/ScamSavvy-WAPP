// Owner: Ahmad (Accounts module)
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_ManageUsers : AdminPage
{
    private static readonly string[] Roles = { Auth.RoleMember, Auth.RoleContributor, Auth.RoleAdmin };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindUsers();
        }
    }

    // The filter last applied with Search or Clear. Edit, Delete and paging rebind with this,
    // not with whatever is currently typed in the search box.
    private string AppliedSearch
    {
        get { return (ViewState["AppliedSearch"] as string) ?? ""; }
        set { ViewState["AppliedSearch"] = value; }
    }

    private string AppliedRole
    {
        get { return (ViewState["AppliedRole"] as string) ?? ""; }
        set { ViewState["AppliedRole"] = value; }
    }

    private void BindUsers()
    {
        string search = AppliedSearch;
        DataTable users = Db.Query(
            "SELECT UserID, Name, Email, Role, IsActive, CreatedAt, " +
            "       CAST(CASE WHEN LockoutEnd > GETDATE() THEN 1 ELSE 0 END AS BIT) AS IsLocked " +
            "FROM Users " +
            "WHERE (@Search = '' OR Name LIKE @Like OR Email LIKE @Like) " +
            "AND (@Role = '' OR Role = @Role) " +
            "ORDER BY CreatedAt DESC, UserID DESC",
            Db.P("@Search", search),
            Db.P("@Like", "%" + EscapeLike(search) + "%"),
            Db.P("@Role", AppliedRole));

        gvUsers.DataSource = users;
        gvUsers.DataBind();
        if (gvUsers.HeaderRow != null)
        {
            gvUsers.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
        litCount.Text = users.Rows.Count + (users.Rows.Count == 1 ? " user" : " users");
    }

    // Treat %, _ and [ in the search box as plain text, not LIKE wildcards.
    private static string EscapeLike(string s)
    {
        return s.Replace("[", "[[]").Replace("%", "[%]").Replace("_", "[_]");
    }

    private int UserIdAt(int rowIndex)
    {
        return (int)gvUsers.DataKeys[rowIndex].Value;
    }

    protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow) return;

        int userId = (int)DataBinder.Eval(e.Row.DataItem, "UserID");
        if (userId != Auth.CurrentUserId) return;

        // An admin cannot change their own role or status, or delete themselves, from here.
        SetVisible(e.Row, "btnEdit", false);
        SetVisible(e.Row, "btnDelete", false);
        SetVisible(e.Row, "lblYou", true);
    }

    private static void SetVisible(GridViewRow row, string id, bool visible)
    {
        Control c = row.FindControl(id);
        if (c != null) c.Visible = visible;
    }

    protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvUsers.PageIndex = e.NewPageIndex;
        gvUsers.EditIndex = -1;
        BindUsers();
    }

    protected void gvUsers_RowEditing(object sender, GridViewEditEventArgs e)
    {
        if (UserIdAt(e.NewEditIndex) == Auth.CurrentUserId)
        {
            e.Cancel = true;
            ShowMessage("You cannot change your own role or status.", "danger");
            return;
        }
        gvUsers.EditIndex = e.NewEditIndex;
        BindUsers();
    }

    protected void gvUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvUsers.EditIndex = -1;
        BindUsers();
    }

    protected void gvUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int userId = UserIdAt(e.RowIndex);
        GridViewRow row = gvUsers.Rows[e.RowIndex];
        string role = ((DropDownList)row.FindControl("ddlEditRole")).SelectedValue;
        bool active = ((CheckBox)row.FindControl("chkEditActive")).Checked;

        if (userId == Auth.CurrentUserId)
        {
            ShowMessage("You cannot change your own role or status.", "danger");
        }
        else if (Array.IndexOf(Roles, role) < 0)
        {
            ShowMessage("Choose a valid role.", "danger");
        }
        else
        {
            Db.Execute("UPDATE Users SET Role = @Role, IsActive = @IsActive WHERE UserID = @UserID",
                Db.P("@Role", role),
                Db.P("@IsActive", active),
                Db.P("@UserID", userId));
            ShowMessage("User updated.", "success");
        }

        gvUsers.EditIndex = -1;
        BindUsers();
    }

    protected void gvUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int userId = UserIdAt(e.RowIndex);
        if (userId == Auth.CurrentUserId)
        {
            e.Cancel = true;
            ShowMessage("You cannot delete your own account here. Use My Profile.", "danger");
            return;
        }

        AccountData.DeleteUser(userId);
        ShowMessage("User deleted.", "success");
        gvUsers.EditIndex = -1;
        BindUsers();
    }

    protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "Unlock") return;

        Db.Execute("UPDATE Users SET FailedLogins = 0, LockoutEnd = NULL WHERE UserID = @UserID",
            Db.P("@UserID", Convert.ToInt32(e.CommandArgument)));
        ShowMessage("Account unlocked. The user can log in again.", "success");
        BindUsers();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        AppliedSearch = txtSearch.Text.Trim();
        AppliedRole = ddlRole.SelectedValue;
        gvUsers.PageIndex = 0;
        gvUsers.EditIndex = -1;
        BindUsers();
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        ddlRole.SelectedIndex = 0;
        AppliedSearch = "";
        AppliedRole = "";
        gvUsers.PageIndex = 0;
        gvUsers.EditIndex = -1;
        BindUsers();
    }

    private void ShowMessage(string text, string kind)
    {
        lblMessage.Text = Server.HtmlEncode(text);
        lblMessage.CssClass = "alert alert-" + kind + " d-block";
        lblMessage.Visible = true;
    }
}
