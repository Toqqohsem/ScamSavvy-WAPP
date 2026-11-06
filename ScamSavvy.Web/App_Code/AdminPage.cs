// Owner: Ahmad. Pages in /Admin inherit this instead of System.Web.UI.Page.

/// <summary>Admins only. Logged out goes to Login; logged in without the Admin role goes to AccessDenied.</summary>
public class AdminPage : MemberPage
{
    protected override void CheckAccess()
    {
        base.CheckAccess();
        if (!Auth.IsAdmin)
        {
            Response.Redirect("~/AccessDenied.aspx", true);
        }
    }
}
