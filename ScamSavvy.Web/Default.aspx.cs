using System;
using System.Data;
using System.Data.SqlClient;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // MyProfile sends users here after they delete their account
            if (Request.QueryString["deleted"] == "1")
            {
                lblMessage.Text = "Your account has been deleted. Thank you for learning with Scam Savvy.";
                lblMessage.CssClass = "alert alert-success d-block";
                lblMessage.Visible = true;
            }

            LoadHomeData();
        }
    }

    // One round trip to the database returns all three lists on the page.
    private void LoadHomeData()
    {
        const string sql = @"
            -- 1. Latest 3 approved scam reports
            SELECT TOP 3 r.ReportID, r.Title, r.CreatedAt, r.IsSample, c.Name AS CategoryName
            FROM ScamReports r
            INNER JOIN Categories c ON c.CategoryID = r.CategoryID
            WHERE r.Status = 'Approved'
            ORDER BY r.CreatedAt DESC, r.ReportID DESC;

            -- 2. Category tiles with their number of published lessons
            SELECT c.CategoryID, c.Name,
                   (SELECT COUNT(*) FROM Lessons l
                    WHERE l.CategoryID = c.CategoryID AND l.IsPublished = 1) AS LessonCount
            FROM Categories c
            ORDER BY c.SortOrder, c.Name;

            -- 3. Latest 3 published lessons
            SELECT TOP 3 l.LessonID, l.Title, l.Summary, l.ImagePath, c.Name AS CategoryName
            FROM Lessons l
            INNER JOIN Categories c ON c.CategoryID = l.CategoryID
            WHERE l.IsPublished = 1
            ORDER BY l.CreatedAt DESC, l.LessonID DESC;";

        DataSet data = new DataSet();
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
        {
            adapter.Fill(data);
        }

        DataTable reports = data.Tables[0];
        DataTable categories = data.Tables[1];
        DataTable lessons = data.Tables[2];

        rptReports.DataSource = reports;
        rptReports.DataBind();
        rptReports.Visible = reports.Rows.Count > 0;
        pnlNoReports.Visible = reports.Rows.Count == 0;

        rptCategories.DataSource = categories;
        rptCategories.DataBind();

        rptLatestLessons.DataSource = lessons;
        rptLatestLessons.DataBind();
        rptLatestLessons.Visible = lessons.Rows.Count > 0;
        pnlNoLessons.Visible = lessons.Rows.Count == 0;
    }
}
