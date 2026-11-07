// Owner: Lyu Jiaxin (Feedback module). Rebuilt on the team template by Ahmad during integration.
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Admin_ManageFeedback : AdminPage
{
    private static readonly string[] Statuses = { "Pending", "Reviewed", "Resolved", "Rejected" };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindFeedback();
        }
    }

    private void BindFeedback()
    {
        DataTable rows = Db.Query(
            "SELECT FeedbackID, UserID, Name, Email, Category, Rating, Message, Status, CreatedAt " +
            "FROM Feedback WHERE (@Status = '' OR Status = @Status) " +
            "ORDER BY CreatedAt DESC, FeedbackID DESC",
            Db.P("@Status", ddlStatus.SelectedValue));
        gvFeedback.DataSource = rows;
        gvFeedback.DataBind();
        if (gvFeedback.HeaderRow != null)
        {
            gvFeedback.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        DataRow c = Db.Query(
            "SELECT COUNT(*) AS Total, " +
            " SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending, " +
            " AVG(CAST(Rating AS DECIMAL(4,2))) AS AvgRating FROM Feedback").Rows[0];
        int total = Convert.ToInt32(c["Total"]);
        litSummary.Text = total == 0
            ? "No feedback yet."
            : string.Format("{0} in total, {1} pending, average rating {2:0.0} out of 5.",
                total, Convert.ToInt32(c["Pending"]), Convert.ToDecimal(c["AvgRating"]));
    }

    protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        gvFeedback.PageIndex = 0;
        BindFeedback();
    }

    protected void gvFeedback_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvFeedback.PageIndex = e.NewPageIndex;
        BindFeedback();
    }

    protected void gvFeedback_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "SetStatus")
        {
            string[] parts = Convert.ToString(e.CommandArgument).Split('|');
            int id = Convert.ToInt32(parts[0]);
            string status = parts.Length > 1 ? parts[1] : "";
            if (Array.IndexOf(Statuses, status) < 0) return;

            Db.Execute("UPDATE Feedback SET Status = @Status WHERE FeedbackID = @FeedbackID",
                Db.P("@Status", status), Db.P("@FeedbackID", id));
            ShowMessage("Feedback marked " + status.ToLowerInvariant() + ".", "success");
            BindFeedback();
        }
        else if (e.CommandName == "DeleteFeedback")
        {
            Db.Execute("DELETE FROM Feedback WHERE FeedbackID = @FeedbackID",
                Db.P("@FeedbackID", Convert.ToInt32(e.CommandArgument)));
            ShowMessage("Feedback deleted.", "success");
            BindFeedback();
        }
    }

    protected string Stars(object rating)
    {
        int r = Math.Max(1, Math.Min(5, Convert.ToInt32(rating)));
        return new string('★', r) + new string('☆', 5 - r);
    }

    protected string StatusBadge(object status)
    {
        switch (Convert.ToString(status))
        {
            case "Resolved": return "site-badge-success";
            case "Rejected": return "site-badge-muted";
            case "Reviewed": return "site-badge-warning";
            default: return "site-badge-danger";
        }
    }

    protected string CategoryName(object category)
    {
        switch (Convert.ToString(category))
        {
            case "Lessons": return "Lessons and content";
            case "Quizzes": return "Quizzes";
            case "SpotTheScam": return "Spot the Scam";
            case "ScamRepository": return "Scam repository";
            case "Bug": return "Bug report";
            case "Suggestion": return "Feature idea";
            default: return "General";
        }
    }

    private void ShowMessage(string text, string kind)
    {
        lblMessage.Text = Server.HtmlEncode(text);
        lblMessage.CssClass = "alert alert-" + kind + " d-block";
        lblMessage.Visible = true;
    }
}
