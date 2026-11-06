// Owner: Ahmad (Accounts module)
// The class is LoginPage, not Login, so it never clashes with System.Web.UI.WebControls.Login when the site is published.
using System;
using System.Data;

public partial class LoginPage : System.Web.UI.Page
{
    // One message for a wrong email, a wrong password and a locked account, so the form never
    // reveals which emails have accounts.
    private static readonly string FailedMessage = string.Format(
        "Email or password is incorrect. After {0} failed attempts the account is locked for {1} minutes.",
        Auth.MaxFailedLogins, Auth.LockoutMinutes);

    // Hashed when the email is unknown, so every failed login takes the same time.
    private const string DummySalt = "AAAAAAAAAAAAAAAAAAAAAA==";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Auth.IsLoggedIn)
        {
            Response.Redirect(Auth.HomeFor(Auth.CurrentRole), true);
        }

        if (!IsPostBack)
        {
            if (Request.QueryString["registered"] == "1")
            {
                ShowMessage("Account created. Please log in.", "success");
            }
            else if (Request.QueryString["deleted"] == "1")
            {
                ShowMessage("Your account has been deleted.", "info");
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string email = txtEmail.Text.Trim().ToLowerInvariant();
        DataTable t = Db.Query(
            "SELECT UserID, Name, PasswordHash, PasswordSalt, Role, IsActive, " +
            "       CAST(CASE WHEN LockoutEnd > GETDATE() THEN 1 ELSE 0 END AS BIT) AS IsLocked " +
            "FROM Users WHERE Email = @Email",
            Db.P("@Email", email));

        if (t.Rows.Count == 0)
        {
            Auth.HashPassword(txtPassword.Text, DummySalt);
            ShowMessage(FailedMessage, "danger");
            return;
        }

        DataRow user = t.Rows[0];
        int userId = (int)user["UserID"];
        bool passwordOk = Auth.VerifyPassword(txtPassword.Text, (string)user["PasswordSalt"], (string)user["PasswordHash"]);

        if ((bool)user["IsLocked"])
        {
            ShowMessage(FailedMessage, "danger");
            return;
        }

        if (!passwordOk)
        {
            // The 5th failure starts a 15-minute lock and resets the counter for afterwards.
            // (SQL Server evaluates every SET expression against the row as it was before the update.)
            Db.Execute(
                "UPDATE Users SET " +
                " LockoutEnd = CASE WHEN FailedLogins + 1 >= @Max THEN DATEADD(MINUTE, @Minutes, GETDATE()) ELSE LockoutEnd END, " +
                " FailedLogins = CASE WHEN FailedLogins + 1 >= @Max THEN 0 ELSE FailedLogins + 1 END " +
                "WHERE UserID = @UserID",
                Db.P("@Max", Auth.MaxFailedLogins),
                Db.P("@Minutes", Auth.LockoutMinutes),
                Db.P("@UserID", userId));
            ShowMessage(FailedMessage, "danger");
            return;
        }

        if (!(bool)user["IsActive"])
        {
            ShowMessage("This account has been deactivated. Contact the admin.", "danger");
            return;
        }

        Db.Execute("UPDATE Users SET FailedLogins = 0, LockoutEnd = NULL WHERE UserID = @UserID", Db.P("@UserID", userId));

        string role = (string)user["Role"];
        Auth.SignIn(userId, (string)user["Name"], role);

        string returnUrl = Request.QueryString["returnUrl"];
        Response.Redirect(Auth.IsLocalUrl(returnUrl) ? returnUrl : Auth.HomeFor(role), true);
    }

    private void ShowMessage(string text, string kind)
    {
        lblMessage.Text = Server.HtmlEncode(text);
        lblMessage.CssClass = "alert alert-" + kind + " d-block";
        lblMessage.Visible = true;
    }
}
