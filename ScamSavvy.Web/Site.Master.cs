// Owner: Member 2. Baseline set up by Ahmad; keep the menu contract and logout behaviour.
using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class SiteMaster : MasterPage
{
    // Runs before the page's own Init, so every page (public ones too) sees the user's current
    // role and status, and a deactivated or deleted user is signed out straight away.
    protected void Page_Init(object sender, EventArgs e)
    {
        if (Auth.IsLoggedIn)
        {
            Auth.RefreshFromDatabase();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Page.ClientScript.RegisterClientScriptInclude(typeof(SiteMaster), "bootstrap",
            ResolveUrl("~/Scripts/bootstrap.bundle.min.js"));
    }

    // PreRender runs after the page's click handlers, so the menu reflects a login,
    // logout or name change made during this request.
    protected void Page_PreRender(object sender, EventArgs e)
    {
        bool loggedIn = Auth.IsLoggedIn;
        phGuest.Visible = !loggedIn;
        phMember.Visible = loggedIn;
        phAccount.Visible = loggedIn;
        phAdmin.Visible = Auth.IsAdmin;
        litUserName.Text = Auth.CurrentUserName;

        string current = Request.AppRelativeCurrentExecutionFilePath;
        HyperLink[] links =
        {
            lnkHome, lnkLessons, lnkQuizzes, lnkRepository, lnkChecker, lnkSpotTheScam, lnkReportScam,
            lnkLogin, lnkRegister, lnkMyProgress, lnkMyReports, lnkMyProfile,
            lnkAdminDashboard, lnkAdminUsers, lnkAdminCategories, lnkAdminLessons, lnkAdminQuizzes,
            lnkAdminScenarios, lnkAdminReports, lnkAdminRedFlags
        };
        foreach (HyperLink link in links)
        {
            if (string.Equals(link.NavigateUrl, current, StringComparison.OrdinalIgnoreCase))
            {
                link.CssClass = WithActive(link.CssClass);
                link.Attributes["aria-current"] = "page";
            }
        }

        MarkMenuActive(lnkAdminMenu, current.StartsWith("~/Admin/", StringComparison.OrdinalIgnoreCase));
        MarkMenuActive(lnkAccountMenu, current.StartsWith("~/Member/My", StringComparison.OrdinalIgnoreCase));
    }

    private static void MarkMenuActive(HtmlAnchor menu, bool active)
    {
        if (active)
        {
            menu.Attributes["class"] = WithActive(menu.Attributes["class"]);
        }
    }

    // CssClass is kept in ViewState, so only add "active" once across postbacks.
    private static string WithActive(string css)
    {
        css = css ?? "";
        return (" " + css + " ").Contains(" active ") ? css : (css + " active").Trim();
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Auth.SignOut();
        Response.Redirect("~/Default.aspx", true);
    }
}
