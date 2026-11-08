using System;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;

public partial class Lesson : System.Web.UI.Page
{
    private int lessonId;

    protected void Page_Load(object sender, EventArgs e)
    {
        lessonId = LessonHelpers.QueryInt(Request, "id");
        if (lessonId == 0 || !LoadLesson())
        {
            ShowNotFound();
        }
    }

    private void ShowNotFound()
    {
        Title = "Lesson not found | Scam Savvy";
        pnlLesson.Visible = false;
        pnlNotFound.Visible = true;
        Response.StatusCode = 404;
        Response.TrySkipIisCustomErrors = true;
    }

    private bool IsAdmin
    {
        get { return Auth.IsLoggedIn && Auth.CurrentRole == Auth.RoleAdmin; }
    }

    private bool LoadLesson()
    {
        const string sql = @"
            SELECT l.LessonID, l.CategoryID, l.Title, l.Summary, l.KeyPoints, l.Content,
                   l.ImagePath, l.VideoUrl, l.SourceTitle, l.SourceUrl, l.IsPublished,
                   c.Name AS CategoryName,
                   lp.CompletedAt
            FROM Lessons l
            INNER JOIN Categories c ON c.CategoryID = l.CategoryID
            LEFT JOIN LessonProgress lp ON lp.LessonID = l.LessonID AND lp.UserID = @UserID
            WHERE l.LessonID = @LessonID
              AND (l.IsPublished = 1 OR @IsAdmin = 1);";

        DataRow row;
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.Add("@LessonID", SqlDbType.Int).Value = lessonId;
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Auth.IsLoggedIn ? Auth.CurrentUserId : 0;
            cmd.Parameters.Add("@IsAdmin", SqlDbType.Bit).Value = IsAdmin;

            DataTable table = new DataTable();
            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                adapter.Fill(table);
            }
            if (table.Rows.Count == 0)
            {
                return false;
            }
            row = table.Rows[0];
        }

        string title = (string)row["Title"];
        int categoryId = (int)row["CategoryID"];
        string categoryName = (string)row["CategoryName"];
        string content = row["Content"] as string ?? "";

        Title = title + " | Scam Savvy";
        pnlLesson.Visible = true;
        pnlDraft.Visible = !(bool)row["IsPublished"];

        // Everything typed into a form is HTML-encoded before display...
        litTitle.Text = HttpUtility.HtmlEncode(title);
        litCrumbTitle.Text = HttpUtility.HtmlEncode(title);
        litSummary.Text = HttpUtility.HtmlEncode(row["Summary"] as string ?? "");
        litCategoryBadge.Text = "<span class=\"site-badge\">" + HttpUtility.HtmlEncode(categoryName) + "</span>";
        litReadTime.Text = ReadingTime(content);

        lnkCrumbCategory.Text = HttpUtility.HtmlEncode(categoryName);
        lnkCrumbCategory.NavigateUrl = "~/Lessons.aspx?category=" + categoryId;

        // Content is HTML written by admins only, so it is not encoded
        litContent.Text = content;

        rptKeyPoints.DataSource = LessonHelpers.SplitKeyPoints(row["KeyPoints"]);
        rptKeyPoints.DataBind();

        imgLesson.ImageUrl = LessonHelpers.ImageUrl(row["ImagePath"]);
        imgLesson.AlternateText = "Illustration for " + title;

        ShowVideo(row["VideoUrl"] as string, title);
        ShowSource(row["SourceTitle"] as string, row["SourceUrl"] as string);

        lnkQuiz.NavigateUrl = "~/Quizzes.aspx?category=" + categoryId;
        lnkCases.NavigateUrl = "~/ScamRepository.aspx?category=" + categoryId;
        lnkMoreLessons.NavigateUrl = "~/Lessons.aspx?category=" + categoryId;

        if (row["CompletedAt"] == DBNull.Value)
        {
            ShowNotCompleted();
        }
        else
        {
            ShowCompleted((DateTime)row["CompletedAt"]);
        }
        return true;
    }

    private void ShowVideo(string url, string title)
    {
        if (string.IsNullOrWhiteSpace(url) || !LessonHelpers.YouTubeEmbed.IsMatch(url))
        {
            phVideo.Visible = false;
            return;
        }
        phVideo.Visible = true;

        // Play through youtube-nocookie.com (more reliable embed, fewer cookies) and
        // always offer a plain YouTube link in case the player is blocked.
        string videoId = url.Substring(url.LastIndexOf('/') + 1);
        string embedUrl = "https://www.youtube-nocookie.com/embed/" + videoId;
        string watchUrl = "https://www.youtube.com/watch?v=" + videoId;

        litVideo.Text = "<iframe class=\"lesson-video\" src=\"" + HttpUtility.HtmlAttributeEncode(embedUrl) + "\""
            + " title=\"Video: " + HttpUtility.HtmlAttributeEncode(title) + "\""
            + " loading=\"lazy\" referrerpolicy=\"strict-origin-when-cross-origin\""
            + " allow=\"accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture\""
            + " allowfullscreen></iframe>"
            + "<p class=\"site-meta mt-2 mb-0\">Video not playing? <a href=\"" + HttpUtility.HtmlAttributeEncode(watchUrl) + "\""
            + " target=\"_blank\" rel=\"noopener noreferrer\">Watch it on YouTube</a>.</p>";
    }

    private void ShowSource(string sourceTitle, string sourceUrl)
    {
        if (string.IsNullOrWhiteSpace(sourceTitle))
        {
            sourceTitle = sourceUrl;
        }
        lnkSource.Text = HttpUtility.HtmlEncode(sourceTitle);
        if (LessonHelpers.IsWebUrl(sourceUrl))
        {
            lnkSource.NavigateUrl = sourceUrl;
        }
    }

    // About 200 words a minute, counted on the text without HTML tags
    private static string ReadingTime(string html)
    {
        string text = Regex.Replace(html, "<[^>]+>", " ");
        int words = Regex.Matches(text, @"\S+").Count;
        int minutes = Math.Max(1, (int)Math.Round(words / 200.0));
        return minutes + " min read";
    }

    private void ShowNotCompleted()
    {
        phMarkComplete.Visible = true;
        phCompleted.Visible = false;
        litCompletedBadge.Text = "";
        litCompleteHint.Text = Auth.IsLoggedIn
            ? "Track it in My Progress."
            : "You will be asked to log in first, then brought back here.";
    }

    private void ShowCompleted(DateTime completedAt)
    {
        phMarkComplete.Visible = false;
        phCompleted.Visible = true;
        litCompletedOn.Text = "on " + LessonHelpers.FormatDate(completedAt);
        litCompletedBadge.Text = " <span class=\"site-badge site-badge-success ms-2\">&#10003; Completed</span>";
    }

    protected void btnComplete_Click(object sender, EventArgs e)
    {
        if (!pnlLesson.Visible)
        {
            return; // lesson not found; nothing to complete
        }

        if (!Auth.IsLoggedIn)
        {
            // Back to this lesson after logging in
            Response.Redirect("~/Login.aspx?returnUrl=" + HttpUtility.UrlEncode(Request.RawUrl), false);
            Context.ApplicationInstance.CompleteRequest();
            return;
        }

        // Insert only if the row is not already there; only published lessons count.
        const string sql = @"
            IF NOT EXISTS (SELECT 1 FROM LessonProgress WHERE UserID = @UserID AND LessonID = @LessonID)
               AND EXISTS (SELECT 1 FROM Lessons WHERE LessonID = @LessonID AND IsPublished = 1)
            BEGIN
                INSERT INTO LessonProgress (UserID, LessonID, CompletedAt)
                VALUES (@UserID, @LessonID, GETDATE());
            END
            SELECT CompletedAt FROM LessonProgress WHERE UserID = @UserID AND LessonID = @LessonID;";

        object completedAt;
        try
        {
            using (SqlConnection conn = Db.Open())
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Auth.CurrentUserId;
                cmd.Parameters.Add("@LessonID", SqlDbType.Int).Value = lessonId;
                completedAt = cmd.ExecuteScalar();
            }
        }
        catch (SqlException ex)
        {
            if (ex.Number != 2627)
            {
                throw;
            }
            completedAt = DateTime.Now;
        }

        if (completedAt == null || completedAt == DBNull.Value)
        {
            // Draft lessons previewed by an admin cannot be completed
            ShowMessage("Only published lessons can be marked as complete.", false);
            return;
        }

        ShowCompleted((DateTime)completedAt);
        ShowMessage("Nice work! This lesson is now in your progress.", true);
    }

    private void ShowMessage(string text, bool success)
    {
        lblMessage.Text = HttpUtility.HtmlEncode(text);
        lblMessage.CssClass = success ? "alert alert-success d-block" : "alert alert-danger d-block";
        lblMessage.Visible = true;
    }
}
