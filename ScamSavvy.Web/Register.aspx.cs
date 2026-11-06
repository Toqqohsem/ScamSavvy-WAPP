// Owner: Ahmad (Accounts module)
using System;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Auth.IsLoggedIn)
        {
            Response.Redirect("~/Default.aspx", true);
        }
    }

    protected void cuvEmailTaken_ServerValidate(object source, ServerValidateEventArgs args)
    {
        object count = Db.Scalar("SELECT COUNT(*) FROM Users WHERE Email = @Email",
            Db.P("@Email", NormaliseEmail(args.Value)));
        args.IsValid = Convert.ToInt32(count) == 0;
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string salt = Auth.NewSalt();
        try
        {
            Db.Execute(
                "INSERT INTO Users (Name, Email, PasswordHash, PasswordSalt, Mobile, Role) " +
                "VALUES (@Name, @Email, @PasswordHash, @PasswordSalt, @Mobile, @Role)",
                Db.P("@Name", txtName.Text.Trim()),
                Db.P("@Email", NormaliseEmail(txtEmail.Text)),
                Db.P("@PasswordHash", Auth.HashPassword(txtPassword.Text, salt)),
                Db.P("@PasswordSalt", salt),
                Db.P("@Mobile", txtMobile.Text.Trim()),
                Db.P("@Role", Auth.RoleMember));
        }
        catch (SqlException ex)
        {
            // 2627 / 2601: unique key violation, if two sign-ups race for the same email.
            if (ex.Number == 2627 || ex.Number == 2601)
            {
                ShowError("An account with this email already exists. Log in instead.");
                return;
            }
            throw;
        }

        Response.Redirect("~/Login.aspx?registered=1", true);
    }

    private static string NormaliseEmail(string email)
    {
        return (email ?? "").Trim().ToLowerInvariant();
    }

    private void ShowError(string text)
    {
        lblMessage.Text = Server.HtmlEncode(text);
        lblMessage.CssClass = "alert alert-danger d-block";
        lblMessage.Visible = true;
    }
}
