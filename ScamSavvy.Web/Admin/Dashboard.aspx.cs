// Owner: Ahmad (Admin module)
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Admin_Dashboard : AdminPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        litAdminName.Text = Auth.CurrentUserName;
        LoadCounts();
        LoadLatestUsers();
        LoadPendingReports();
    }

    private void LoadCounts()
    {
        // One round trip for every card.
        DataRow c = Db.Query(
            "SELECT " +
            " (SELECT COUNT(*) FROM Users) AS TotalUsers," +
            " (SELECT COUNT(*) FROM Users WHERE Role = 'Member') AS Members," +
            " (SELECT COUNT(*) FROM Users WHERE Role = 'Contributor') AS Contributors," +
            " (SELECT COUNT(*) FROM Users WHERE Role = 'Admin') AS Admins," +
            " (SELECT COUNT(*) FROM Lessons WHERE IsPublished = 1) AS PublishedLessons," +
            " (SELECT COUNT(*) FROM QuizAttempts) AS QuizAttempts," +
            " (SELECT COUNT(*) FROM ScenarioAttempts) AS ScenarioAttempts," +
            " (SELECT COUNT(*) FROM ScamReports WHERE Status = 'Pending') AS PendingReports," +
            " (SELECT COUNT(*) FROM ScamReports WHERE Status = 'Approved') AS ApprovedReports," +
            " (SELECT COUNT(*) FROM Feedback WHERE Status = 'Pending') AS PendingFeedback").Rows[0];

        litTotalUsers.Text = c["TotalUsers"].ToString();
        litUsersByRole.Text = Count(c["Members"], "member") + ", " +
            Count(c["Contributors"], "contributor") + ", " + Count(c["Admins"], "admin");
        litLessons.Text = c["PublishedLessons"].ToString();
        litQuizAttempts.Text = c["QuizAttempts"].ToString();
        litScenarioAttempts.Text = c["ScenarioAttempts"].ToString();
        litPendingReports.Text = c["PendingReports"].ToString();
        litApprovedReports.Text = c["ApprovedReports"].ToString();
        litPendingFeedback.Text = c["PendingFeedback"].ToString();
    }

    private static string Count(object value, string noun)
    {
        int n = Convert.ToInt32(value);
        return n + " " + noun + (n == 1 ? "" : "s");
    }

    private void LoadLatestUsers()
    {
        Bind(gvLatestUsers, Db.Query(
            "SELECT TOP 5 Name, Role, CreatedAt FROM Users ORDER BY CreatedAt DESC, UserID DESC"));
    }

    private void LoadPendingReports()
    {
        Bind(gvPendingReports, Db.Query(
            "SELECT TOP 5 r.ReportID, r.Title, c.Name AS Category, " +
            "       ISNULL(u.Name, 'Deleted user') AS SubmittedBy, r.CreatedAt " +
            "FROM ScamReports r " +
            "JOIN Categories c ON c.CategoryID = r.CategoryID " +
            "LEFT JOIN Users u ON u.UserID = r.UserID " +
            "WHERE r.Status = 'Pending' " +
            "ORDER BY r.CreatedAt DESC"));
    }

    private static void Bind(GridView grid, DataTable data)
    {
        grid.DataSource = data;
        grid.DataBind();
        if (grid.HeaderRow != null)
        {
            grid.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}
