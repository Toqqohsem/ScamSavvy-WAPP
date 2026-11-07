// Owner: Lyu Jiaxin (Member 4)
// Approved reports are public. A pending or rejected report is shown only to the person who sent it
// and to admins; everyone else gets "Report not found".
using System;
using System.Data;

public partial class ScamDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        int id = LessonHelpers.QueryInt(Request, "id");
        DataTable t = id <= 0 ? new DataTable() : Db.Query(
            "SELECT r.*, c.Name AS CategoryName FROM ScamReports r " +
            "JOIN Categories c ON c.CategoryID = r.CategoryID WHERE r.ReportID = @ReportID",
            Db.P("@ReportID", id));

        DataRow r = t.Rows.Count == 1 ? t.Rows[0] : null;
        if (r == null || !CanView(r))
        {
            ShowNotFound();
            return;
        }

        string status = (string)r["Status"];
        int categoryId = (int)r["CategoryID"];
        Page.Title = Convert.ToString(r["Title"]) + " | Scam Savvy";

        lblCategory.Text = Server.HtmlEncode((string)r["CategoryName"]);
        litTitle.Text = (string)r["Title"];
        litDate.Text = LessonHelpers.FormatDate(r["CreatedAt"]);
        litDescription.Text = (string)r["Description"];
        lblSample.Visible = (bool)r["IsSample"];
        if (status != "Approved")
        {
            lblStatus.Text = status == "Pending" ? "Waiting for review" : "Rejected";
            lblStatus.Visible = true;
        }

        phPhone.Visible = r["ScammerPhone"] != DBNull.Value;
        litPhone.Text = ScamText.FormatPhone(r["ScammerPhone"]);
        phAccount.Visible = r["ScammerAccount"] != DBNull.Value;
        litAccount.Text = Convert.ToString(r["ScammerAccount"]);
        phUrl.Visible = r["ScammerUrl"] != DBNull.Value;
        litUrl.Text = Convert.ToString(r["ScammerUrl"]);   // shown as text, never as a clickable link
        phIds.Visible = phPhone.Visible || phAccount.Visible || phUrl.Visible;

        string evidence = r["EvidencePath"] as string;
        if (!string.IsNullOrEmpty(evidence) && evidence.StartsWith("~/Uploads/Evidence/"))
        {
            imgEvidence.ImageUrl = evidence;
            phEvidence.Visible = true;
        }

        // Extra checking sites for investment (3) and loan (4) scams
        phSc.Visible = categoryId == 3;
        phBnm.Visible = categoryId == 3 || categoryId == 4;
        lnkLesson.NavigateUrl = "~/Lessons.aspx?category=" + categoryId;

        if (Request.QueryString["submitted"] == "1" && Auth.IsOwnerOrAdmin(OwnerId(r)))
        {
            lblMessage.Text = status == "Approved"
                ? "Thank you. Your report is now live in the repository."
                : "Thank you. Your report has been sent and will appear once our team has reviewed it.";
            lblMessage.CssClass = "alert alert-success d-block";
            lblMessage.Visible = true;
        }
    }

    private static int OwnerId(DataRow r)
    {
        return r["UserID"] == DBNull.Value ? 0 : (int)r["UserID"];
    }

    private static bool CanView(DataRow r)
    {
        return (string)r["Status"] == "Approved" || (Auth.IsLoggedIn && Auth.IsOwnerOrAdmin(OwnerId(r)));
    }

    private void ShowNotFound()
    {
        Response.StatusCode = 404;
        Page.Title = "Report not found | Scam Savvy";
        pnlReport.Visible = false;
        pnlNotFound.Visible = true;
    }
}
