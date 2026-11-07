// Owner: Lyu Jiaxin (Member 4)
// Admins approve or reject members' scam reports. Only approved reports appear in the public
// repository and count as "reported" in the Scam Checker.
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;

public partial class Admin_ModerateReports : AdminPage
{
    private const string EvidenceFolder = "~/Uploads/Evidence/";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindReports();
        }
    }

    private void BindReports()
    {
        DataTable rows = Db.Query(
            "SELECT r.ReportID, r.Title, r.Description, r.ScammerPhone, r.ScammerAccount, r.ScammerUrl, r.EvidencePath, " +
            "       r.Status, r.IsSample, r.CreatedAt, c.Name AS CategoryName, u.Name AS SubmitterName, u.Role AS SubmitterRole " +
            "FROM ScamReports r JOIN Categories c ON c.CategoryID = r.CategoryID " +
            "LEFT JOIN Users u ON u.UserID = r.UserID " +
            "WHERE (@Status = '' OR r.Status = @Status) " +
            "ORDER BY r.CreatedAt DESC, r.ReportID DESC",
            Db.P("@Status", ddlStatus.SelectedValue));
        gvReports.DataSource = rows;
        gvReports.DataBind();
        if (gvReports.HeaderRow != null)
        {
            gvReports.HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        DataRow c = Db.Query(
            "SELECT COUNT(*) AS Total, " +
            " SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS Pending, " +
            " SUM(CASE WHEN Status = 'Approved' THEN 1 ELSE 0 END) AS Approved FROM ScamReports").Rows[0];
        int total = Convert.ToInt32(c["Total"]);
        litSummary.Text = total == 0
            ? "No reports yet."
            : string.Format("{0} in total, {1} waiting for review, {2} published.",
                total, Convert.ToInt32(c["Pending"]), Convert.ToInt32(c["Approved"]));
    }

    protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        gvReports.PageIndex = 0;
        BindReports();
    }

    protected void gvReports_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvReports.PageIndex = e.NewPageIndex;
        BindReports();
    }

    protected void gvReports_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "SetStatus")
        {
            string[] parts = Convert.ToString(e.CommandArgument).Split('|');
            int id = Convert.ToInt32(parts[0]);
            string status = parts.Length > 1 ? parts[1] : "";
            if (status != "Approved" && status != "Rejected") return;

            Db.Execute(
                "UPDATE ScamReports SET Status = @Status, ReviewedBy = @AdminID, ReviewedAt = GETDATE() WHERE ReportID = @ReportID",
                Db.P("@Status", status), Db.P("@AdminID", Auth.CurrentUserId), Db.P("@ReportID", id));
            ShowMessage(status == "Approved"
                ? "Report approved. It is now public in the repository."
                : "Report rejected. Only the person who sent it can still see it.", "success");
            BindReports();
        }
        else if (e.CommandName == "DeleteReport")
        {
            int id = Convert.ToInt32(e.CommandArgument);
            string evidence = Db.Scalar("SELECT EvidencePath FROM ScamReports WHERE ReportID = @ReportID",
                Db.P("@ReportID", id)) as string;
            Db.Execute("DELETE FROM ScamReports WHERE ReportID = @ReportID", Db.P("@ReportID", id));
            DeleteEvidence(evidence);
            ShowMessage("Report deleted.", "success");
            BindReports();
        }
    }

    /// <summary>Removes the screenshot file, but only if it sits in the evidence folder.</summary>
    private void DeleteEvidence(string path)
    {
        if (string.IsNullOrEmpty(path) || !path.StartsWith(EvidenceFolder)) return;
        string fileName = Path.GetFileName(path);
        if (fileName.Length == 0) return;
        try
        {
            string full = Path.Combine(Server.MapPath(EvidenceFolder), fileName);
            if (File.Exists(full)) File.Delete(full);
        }
        catch (IOException)
        {
            // The row is gone; a file left behind is harmless.
        }
        catch (UnauthorizedAccessException)
        {
        }
    }

    protected string EvidenceUrl(object path)
    {
        string p = path as string;
        return !string.IsNullOrEmpty(p) && p.StartsWith(EvidenceFolder) ? ResolveUrl(p) : "";
    }

    protected string Shorten(object text)
    {
        string s = Convert.ToString(text);
        return s.Length <= 180 ? s : s.Substring(0, 177).TrimEnd() + "...";
    }

    protected string Identifiers(object phone, object account, object url)
    {
        List<string> parts = new List<string>();
        if (phone != DBNull.Value) parts.Add("Phone " + ScamText.FormatPhone(phone));
        if (account != DBNull.Value) parts.Add("Account " + Convert.ToString(account));
        if (url != DBNull.Value) parts.Add("Website " + Convert.ToString(url));
        return parts.Count == 0 ? "<span class='text-muted'>None given</span>" : Server.HtmlEncode(string.Join("\n", parts.ToArray())).Replace("\n", "<br />");
    }

    protected string StatusBadge(object status)
    {
        switch (Convert.ToString(status))
        {
            case "Approved": return "site-badge-success";
            case "Rejected": return "site-badge-muted";
            default: return "site-badge-warning";
        }
    }

    private void ShowMessage(string text, string kind)
    {
        lblMessage.Text = Server.HtmlEncode(text);
        lblMessage.CssClass = "alert alert-" + kind + " d-block";
        lblMessage.Visible = true;
    }
}
