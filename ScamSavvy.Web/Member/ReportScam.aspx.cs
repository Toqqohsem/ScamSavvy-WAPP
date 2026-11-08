using System;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;

public partial class Member_ReportScam : MemberPage
{
    private const string EvidenceFolder = "~/Uploads/Evidence/";

    private bool PublishesDirectly
    {
        get { return Auth.CurrentRole == Auth.RoleContributor || Auth.IsAdmin; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        litReviewNote.Text = PublishesDirectly
            ? "<p class=\"site-meta\">You are a trusted contributor, so your report is published straight away.</p>"
            : "<p class=\"site-meta\">Your report will be published once our team has reviewed it.</p>";

        if (IsPostBack) return;
        ddlCategory.DataSource = Db.Query("SELECT CategoryID, Name FROM Categories ORDER BY SortOrder, Name");
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataBind();
        ddlCategory.Items.Insert(0, new ListItem("Choose a type", ""));
        BindMine();
    }

    private void BindMine()
    {
        DataTable mine = Db.Query(
            "SELECT TOP 10 ReportID, Title, Status, CreatedAt FROM ScamReports " +
            "WHERE UserID = @UserID ORDER BY CreatedAt DESC, ReportID DESC",
            Db.P("@UserID", Auth.CurrentUserId));
        rptMine.DataSource = mine;
        rptMine.DataBind();
        phMine.Visible = mine.Rows.Count > 0;
    }

    protected string StatusText(object status)
    {
        switch (Convert.ToString(status))
        {
            case "Approved": return "Published";
            case "Rejected": return "Not published";
            default: return "Waiting for review";
        }
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

    protected void cuvEvidence_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (!fuEvidence.HasFile)
        {
            args.IsValid = true;
            return;
        }
        // Check the real file type from its first bytes, not the name the browser sends.
        args.IsValid = fuEvidence.PostedFile.ContentLength <= LessonHelpers.MaxImageBytes &&
                       LessonHelpers.DetectImageExtension(fuEvidence.PostedFile.InputStream) != null;
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string evidencePath = SaveEvidence();
        string phone = txtPhone.Text.Trim();
        string account = txtAccount.Text.Trim();
        string url = txtUrl.Text.Trim();
        bool live = PublishesDirectly;

        object newId = Db.Scalar(
            "INSERT INTO ScamReports (UserID, CategoryID, Title, Description, ScammerPhone, ScammerAccount, ScammerUrl, " +
            "                         EvidencePath, Status, ReviewedBy, ReviewedAt) " +
            "VALUES (@UserID, @CategoryID, @Title, @Description, @Phone, @Account, @Url, @Evidence, @Status, @ReviewedBy, @ReviewedAt); " +
            "SELECT CAST(SCOPE_IDENTITY() AS INT);",
            Db.P("@UserID", Auth.CurrentUserId),
            Db.P("@CategoryID", int.Parse(ddlCategory.SelectedValue)),
            Db.P("@Title", txtTitle.Text.Trim()),
            Db.P("@Description", txtDescription.Text.Trim()),
            Db.P("@Phone", phone.Length == 0 ? null : ScamText.NormalisePhone(phone)),
            Db.P("@Account", account.Length == 0 ? null : ScamText.NormaliseAccount(account)),
            Db.P("@Url", url.Length == 0 ? null : ScamText.NormaliseUrl(url)),
            Db.P("@Evidence", evidencePath),
            Db.P("@Status", live ? "Approved" : "Pending"),
            Db.P("@ReviewedBy", live ? (object)Auth.CurrentUserId : null),
            Db.P("@ReviewedAt", live ? (object)DateTime.Now : null));

        // Redirect after the POST, so refreshing the page cannot send the report twice.
        Response.Redirect("~/ScamDetail.aspx?id=" + Convert.ToInt32(newId) + "&submitted=1", true);
    }

    private string SaveEvidence()
    {
        if (!fuEvidence.HasFile) return null;
        string ext = LessonHelpers.DetectImageExtension(fuEvidence.PostedFile.InputStream);
        if (ext == null) return null;

        string folder = Server.MapPath(EvidenceFolder);
        Directory.CreateDirectory(folder);
        string fileName = Guid.NewGuid().ToString("N") + ext;
        fuEvidence.PostedFile.InputStream.Position = 0;
        fuEvidence.PostedFile.SaveAs(Path.Combine(folder, fileName));
        return EvidenceFolder + fileName;
    }
}
