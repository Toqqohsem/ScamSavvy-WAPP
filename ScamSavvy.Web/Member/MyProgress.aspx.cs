using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

public partial class Member_MyProgress : MemberPage
{
    private const int PassMark = 70; // percent, from the build guide

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            litGreeting.Text = "Hi " + HttpUtility.HtmlEncode(Auth.CurrentUserName)
                + ", here is everything you have done on Scam Savvy so far.";
            LoadProgress();
        }
    }

    private void LoadProgress()
    {
        // Every query is filtered by the logged-in user's ID, so users only ever see their own data.
        const string sql = @"
            -- 0. Lesson totals (published lessons only)
            SELECT
                (SELECT COUNT(*) FROM Lessons WHERE IsPublished = 1) AS PublishedCount,
                (SELECT COUNT(*) FROM LessonProgress lp
                 INNER JOIN Lessons l ON l.LessonID = lp.LessonID
                 WHERE lp.UserID = @UserID AND l.IsPublished = 1) AS CompletedCount;

            -- 1. Completed lessons with dates
            SELECT l.LessonID, l.Title, c.Name AS CategoryName, lp.CompletedAt
            FROM LessonProgress lp
            INNER JOIN Lessons l ON l.LessonID = lp.LessonID
            INNER JOIN Categories c ON c.CategoryID = l.CategoryID
            WHERE lp.UserID = @UserID AND l.IsPublished = 1
            ORDER BY lp.CompletedAt DESC;

            -- 2. Latest 5 quiz attempts
            SELECT TOP 5 a.AttemptID, q.Title AS QuizTitle, a.Score, a.TotalQuestions, a.AttemptedAt
            FROM QuizAttempts a
            INNER JOIN Quizzes q ON q.QuizID = a.QuizID
            WHERE a.UserID = @UserID
            ORDER BY a.AttemptedAt DESC, a.AttemptID DESC;

            -- 3. Quiz totals: attempts, and distinct quizzes passed at 70% or more
            SELECT COUNT(*) AS Attempts,
                   COUNT(DISTINCT CASE WHEN a.TotalQuestions > 0
                                        AND a.Score * 100 >= @PassMark * a.TotalQuestions
                                       THEN a.QuizID END) AS QuizzesPassed
            FROM QuizAttempts a
            WHERE a.UserID = @UserID;

            -- 4. Spot the Scam totals
            SELECT COUNT(DISTINCT ScenarioID) AS ScenariosTried,
                   ISNULL(SUM(FlagsFound), 0) AS FlagsFound,
                   ISNULL(SUM(FlagsTotal), 0) AS FlagsTotal
            FROM ScenarioAttempts
            WHERE UserID = @UserID;

            -- 5. Suggested next lesson: first published lesson not yet completed
            SELECT TOP 1 l.LessonID, l.Title
            FROM Lessons l
            INNER JOIN Categories c ON c.CategoryID = l.CategoryID
            WHERE l.IsPublished = 1
              AND NOT EXISTS (SELECT 1 FROM LessonProgress lp
                              WHERE lp.LessonID = l.LessonID AND lp.UserID = @UserID)
            ORDER BY c.SortOrder, l.CreatedAt;";

        DataSet data = new DataSet();
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Auth.CurrentUserId;
            cmd.Parameters.Add("@PassMark", SqlDbType.Int).Value = PassMark;
            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                adapter.Fill(data);
            }
        }

        ShowLessonTotals(data.Tables[0].Rows[0], data.Tables[5]);

        DataTable completed = data.Tables[1];
        rptCompleted.DataSource = completed;
        rptCompleted.DataBind();
        rptCompleted.Visible = completed.Rows.Count > 0;
        pnlNoCompleted.Visible = completed.Rows.Count == 0;

        DataTable attempts = data.Tables[2];
        rptQuizAttempts.DataSource = attempts;
        rptQuizAttempts.DataBind();
        rptQuizAttempts.Visible = attempts.Rows.Count > 0;
        pnlNoQuizzes.Visible = attempts.Rows.Count == 0;

        DataRow quiz = data.Tables[3].Rows[0];
        litQuizAttempts.Text = Convert.ToInt32(quiz["Attempts"]).ToString();
        litQuizPassed.Text = Convert.ToInt32(quiz["QuizzesPassed"]).ToString();

        DataRow spot = data.Tables[4].Rows[0];
        litScenariosTried.Text = Convert.ToInt32(spot["ScenariosTried"]).ToString();
        int flagsTotal = Convert.ToInt32(spot["FlagsTotal"]);
        litFlagsFound.Text = Convert.ToInt32(spot["FlagsFound"]) + (flagsTotal > 0 ? " / " + flagsTotal : "");
    }

    private void ShowLessonTotals(DataRow totals, DataTable nextLesson)
    {
        int published = Convert.ToInt32(totals["PublishedCount"]);
        int done = Convert.ToInt32(totals["CompletedCount"]);
        int percent = published == 0 ? 0 : (int)Math.Round(done * 100.0 / published);

        litCompleted.Text = done + " / " + published;
        litPercent.Text = percent + "% of published lessons";

        // Inline style sets the bar width (the brief asks for inline CSS as well)
        litProgressBar.Text =
            "<div class=\"progress lesson-progress-bar\" role=\"progressbar\" aria-label=\"Lessons completed\""
            + " aria-valuenow=\"" + percent + "\" aria-valuemin=\"0\" aria-valuemax=\"100\">"
            + "<div class=\"progress-bar\" style=\"width: " + percent + "%;\"></div></div>";

        if (nextLesson.Rows.Count > 0)
        {
            phNextLesson.Visible = true;
            lnkNextLesson.Text = HttpUtility.HtmlEncode((string)nextLesson.Rows[0]["Title"]);
            lnkNextLesson.NavigateUrl = "~/Lesson.aspx?id=" + nextLesson.Rows[0]["LessonID"];
        }
        else if (published > 0)
        {
            phAllDone.Visible = true;
        }
    }

    protected int Percent(object score, object total)
    {
        int t = Convert.ToInt32(total);
        return t == 0 ? 0 : (int)Math.Round(Convert.ToInt32(score) * 100.0 / t);
    }

    protected string PassBadge(object score, object total)
    {
        // Exact comparison (no rounding), same rule as the SQL above
        int t = Convert.ToInt32(total);
        return t > 0 && Convert.ToInt32(score) * 100 >= PassMark * t
            ?"<span class=\"site-badge site-badge-success\">Pass</span>"
            : "<span class=\"site-badge site-badge-danger\">Fail</span>";
    }
}
