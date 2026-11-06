// Owner: Ahmad (Accounts module)
using System;

public partial class AccessDenied : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Auth.IsLoggedIn)
        {
            litSignedInAs.Text = "You are logged in as " + Auth.CurrentUserName + " (" + Auth.CurrentRole + ").";
        }
        else
        {
            btnSwitchUser.Text = "Log in";
        }
    }

    protected void btnSwitchUser_Click(object sender, EventArgs e)
    {
        Auth.SignOut();
        Response.Redirect("~/Login.aspx", true);
    }
}
