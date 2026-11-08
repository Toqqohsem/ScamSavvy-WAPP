// Owner: Ahmad. Pages in /Admin inherit this instead of System.Web.UI.Page.

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
