// Owner: Ahmad. Pages in /Member inherit this instead of System.Web.UI.Page.
using System;
using System.Web;

/// <summary>Any logged-in user. Logged-out visitors are sent to Login and brought back afterwards.</summary>
public class MemberPage : System.Web.UI.Page
{
    protected override void OnInit(EventArgs e)
    {
        CheckAccess();
        base.OnInit(e);
    }

    protected virtual void CheckAccess()
    {
        if (!Auth.IsLoggedIn || !Auth.RefreshFromDatabase())
        {
            Response.Redirect("~/Login.aspx?returnUrl=" + HttpUtility.UrlEncode(Request.RawUrl), true);
        }
    }
}
