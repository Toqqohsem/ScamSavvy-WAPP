// Owner: Member 2. Keeps Ahmad's baseline behaviour (role refresh on every page, menu set in
// PreRender, logout) and adds the redesigned layout.
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SiteMaster : System.Web.UI.MasterPage
{
    // Pages that are not in the menu but belong to a menu item, so that item stays highlighted.
    private static readonly Dictionary<string, string> ParentMenuItem =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            { "~/Lesson.aspx", "~/Lessons.aspx" },
            { "~/ScamDetail.aspx", "~/ScamRepository.aspx" },
            { "~/Member/TakeQuiz.aspx", "~/Quizzes.aspx" },
            { "~/Member/QuizResult.aspx", "~/Quizzes.aspx" }
        };

    // Runs before the page's own Init, so every page (public ones too) sees the user's current
    // role and status, and a deactivated or deleted user is signed out straight away. (Ahmad)
    protected void Page_Init(object sender, EventArgs e)
    {
        if (Auth.IsLoggedIn)
        {
            Auth.RefreshFromDatabase();
        }
    }

    // PreRender runs after the page's click handlers, so the menu reflects a login,
    // logout or name change made during this request. (Ahmad)
    protected void Page_PreRender(object sender, EventArgs e)
    {
        bool loggedIn = Auth.IsLoggedIn;

        // Show or hide menu groups (menu contract in the build guide)
        phLoggedOut.Visible = !loggedIn;
        phLoggedIn.Visible = loggedIn;
        phMemberLinks.Visible = loggedIn;
        phAdmin.Visible = Auth.IsAdmin;

        if (loggedIn)
        {
            string name = Auth.CurrentUserName;
            litUserName.Text = HttpUtility.HtmlEncode(name);
            litInitial.Text = name.Length > 0
                ? HttpUtility.HtmlEncode(name.Substring(0, 1).ToUpperInvariant())
                : "?";
        }

        litYear.Text = DateTime.Now.Year.ToString();

        HighlightCurrentPage();
    }

    // Adds Bootstrap's "active" class to the menu link for the page being viewed.
    private void HighlightCurrentPage()
    {
        string current = Request.AppRelativeCurrentExecutionFilePath; // e.g. "~/Member/MyProgress.aspx"
        string target;
        if (!ParentMenuItem.TryGetValue(current, out target))
        {
            target = current;
        }

        foreach (HyperLink link in FindLinks(pnlNav))
        {
            if (string.Equals(link.NavigateUrl, target, StringComparison.OrdinalIgnoreCase))
            {
                link.CssClass = WithActive(link.CssClass);
                link.Attributes["aria-current"] = "page";
            }
        }
    }

    // CssClass is kept in ViewState, so only add "active" once across postbacks. (Ahmad)
    private static string WithActive(string css)
    {
        css = css ?? "";
        return (" " + css + " ").Contains(" active ") ? css : (css + " active").Trim();
    }

    private static IEnumerable<HyperLink> FindLinks(Control parent)
    {
        foreach (Control child in parent.Controls)
        {
            HyperLink link = child as HyperLink;
            if (link != null)
            {
                yield return link;
            }
            foreach (HyperLink nested in FindLinks(child))
            {
                yield return nested;
            }
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Auth.SignOut();
        Response.Redirect("~/Default.aspx", true);
    }
}
