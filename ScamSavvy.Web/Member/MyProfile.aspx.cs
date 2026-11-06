// Owner: Ahmad (Accounts module)
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Member_MyProfile : MemberPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadProfile();
        }
    }

    private void LoadProfile()
    {
        DataTable t = Db.Query(
            "SELECT Name, Email, Mobile, Role, CreatedAt FROM Users WHERE UserID = @UserID",
            Db.P("@UserID", Auth.CurrentUserId));
        DataRow u = t.Rows[0];

        txtName.Text = (string)u["Name"];
        txtMobile.Text = (string)u["Mobile"];
        lblEmail.Text = Server.HtmlEncode((string)u["Email"]);
        lblRole.Text = Server.HtmlEncode((string)u["Role"]);
        lblJoined.Text = ((DateTime)u["CreatedAt"]).ToString("dd MMM yyyy");
    }

    protected void btnSaveProfile_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string name = txtName.Text.Trim();
        Db.Execute("UPDATE Users SET Name = @Name, Mobile = @Mobile WHERE UserID = @UserID",
            Db.P("@Name", name),
            Db.P("@Mobile", txtMobile.Text.Trim()),
            Db.P("@UserID", Auth.CurrentUserId));

        // Keep the name in the menu up to date.
        Auth.SignIn(Auth.CurrentUserId, name, Auth.CurrentRole);
        Show(lblProfileMessage, "Your details have been saved.", "success");
    }

    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        if (!CurrentPasswordMatches(txtCurrentPassword.Text))
        {
            Show(lblPasswordMessage, "Your current password is incorrect.", "danger");
            return;
        }

        string salt = Auth.NewSalt();
        Db.Execute("UPDATE Users SET PasswordHash = @PasswordHash, PasswordSalt = @PasswordSalt WHERE UserID = @UserID",
            Db.P("@PasswordHash", Auth.HashPassword(txtNewPassword.Text, salt)),
            Db.P("@PasswordSalt", salt),
            Db.P("@UserID", Auth.CurrentUserId));

        Show(lblPasswordMessage, "Your password has been changed.", "success");
    }

    protected void btnDeleteAccount_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        if (!CurrentPasswordMatches(txtDeletePassword.Text))
        {
            Show(lblDeleteMessage, "That password is incorrect, so your account was not deleted.", "danger");
            return;
        }

        if (Auth.IsAdmin && AccountData.CountActiveAdmins() <= 1)
        {
            Show(lblDeleteMessage, "You are the only admin. Make another user an admin before deleting your account.", "danger");
            return;
        }

        AccountData.DeleteUser(Auth.CurrentUserId);
        Auth.SignOut();
        Response.Redirect("~/Login.aspx?deleted=1", true);
    }

    private bool CurrentPasswordMatches(string password)
    {
        DataTable t = Db.Query("SELECT PasswordHash, PasswordSalt FROM Users WHERE UserID = @UserID",
            Db.P("@UserID", Auth.CurrentUserId));
        return t.Rows.Count == 1 &&
               Auth.VerifyPassword(password, (string)t.Rows[0]["PasswordSalt"], (string)t.Rows[0]["PasswordHash"]);
    }

    private void Show(Label label, string text, string kind)
    {
        label.Text = Server.HtmlEncode(text);
        label.CssClass = "alert alert-" + kind + " d-block";
        label.Visible = true;
    }
}
