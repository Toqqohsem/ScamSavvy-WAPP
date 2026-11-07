using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

public partial class Admin_ManageLessons : AdminPage
{
    // Same rule as lessonCheckContent() in the page's script block
    private static readonly Regex UnsafeHtml = new Regex(
        @"<\s*(script|iframe|object|embed|form)\b|[\s/""']on\w+\s*=|javascript\s*:",
        RegexOptions.IgnoreCase | RegexOptions.Compiled);

    protected void Page_Init(object sender, EventArgs e)
    {
        // Bootstrap switch styling for the ASP.NET check boxes
        chkPublished.InputAttributes["class"] = "form-check-input";
        chkPublished.InputAttributes["role"] = "switch";
        chkPublished.LabelAttributes["class"] = "form-check-label";
        chkRemoveImage.InputAttributes["class"] = "form-check-input";
        chkRemoveImage.LabelAttributes["class"] = "form-check-label";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategoryLists();
            BindGrid();
        }
    }

    // =====================================================================
    // Display
    // =====================================================================

    private void LoadCategoryLists()
    {
        DataTable categories = new DataTable();
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand("SELECT CategoryID, Name FROM Categories ORDER BY SortOrder, Name", conn))
        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
        {
            adapter.Fill(categories);
        }

        ddlFilterCategory.DataSource = categories;
        ddlFilterCategory.DataTextField = "Name";
        ddlFilterCategory.DataValueField = "CategoryID";
        ddlFilterCategory.DataBind();
        ddlFilterCategory.Items.Insert(0, new ListItem("All categories", "0"));

        ddlCategory.DataSource = categories;
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataBind();
        ddlCategory.Items.Insert(0, new ListItem("Choose a category", ""));
    }

    private void BindGrid()
    {
        const string sql = @"
            SELECT l.LessonID, l.Title, l.ImagePath, l.VideoUrl, l.IsPublished, l.CreatedAt,
                   c.Name AS CategoryName,
                   (SELECT COUNT(*) FROM LessonProgress lp WHERE lp.LessonID = l.LessonID) AS CompletedCount
            FROM Lessons l
            INNER JOIN Categories c ON c.CategoryID = l.CategoryID
            WHERE (@CategoryID = 0 OR l.CategoryID = @CategoryID)
            ORDER BY c.SortOrder, l.CreatedAt DESC;";

        DataTable table = new DataTable();
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = int.Parse(ddlFilterCategory.SelectedValue);
            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                adapter.Fill(table);
            }
        }

        gvLessons.DataSource = table;
        gvLessons.DataBind();
        litCount.Text = table.Rows.Count == 1 ? "1 lesson" : table.Rows.Count + " lessons";
    }

    protected void ddlFilterCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        gvLessons.PageIndex = 0;
        BindGrid();
    }

    protected void gvLessons_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvLessons.PageIndex = e.NewPageIndex;
        BindGrid();
    }

    protected void gvLessons_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int lessonId;
        if (!int.TryParse(e.CommandArgument as string, out lessonId))
        {
            return; // pager commands carry page numbers, not lesson IDs
        }

        if (e.CommandName == "EditLesson")
        {
            LoadLessonIntoForm(lessonId);
        }
        else if (e.CommandName == "DeleteLesson")
        {
            DeleteLesson(lessonId);
        }
    }

    // =====================================================================
    // Form: open, fill, close
    // =====================================================================

    protected void btnNew_Click(object sender, EventArgs e)
    {
        ClearForm();
        litFormTitle.Text = "Add lesson";
        pnlForm.Visible = true;
        txtTitle.Focus();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        pnlForm.Visible = false;
    }

    private void ClearForm()
    {
        hfLessonID.Value = "0";
        txtTitle.Text = "";
        ddlCategory.SelectedValue = ddlFilterCategory.SelectedValue != "0" ? ddlFilterCategory.SelectedValue : "";
        txtSummary.Text = "";
        txtKeyPoints.Text = "";
        txtContent.Text = "";
        txtVideoUrl.Text = "";
        txtSourceTitle.Text = "";
        txtSourceUrl.Text = "";
        chkPublished.Checked = false;
        chkRemoveImage.Checked = false;
        phCurrentImage.Visible = false;
        lnkPreview.Visible = false;
    }

    private void LoadLessonIntoForm(int lessonId)
    {
        const string sql = @"
            SELECT LessonID, CategoryID, Title, Summary, KeyPoints, Content, ImagePath,
                   VideoUrl, SourceTitle, SourceUrl, IsPublished
            FROM Lessons WHERE LessonID = @LessonID;";

        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.Add("@LessonID", SqlDbType.Int).Value = lessonId;
            using (SqlDataReader r = cmd.ExecuteReader())
            {
                if (!r.Read())
                {
                    ShowMessage("That lesson no longer exists.", false);
                    BindGrid();
                    return;
                }

                ClearForm();
                hfLessonID.Value = lessonId.ToString();
                txtTitle.Text = r["Title"] as string;
                ddlCategory.SelectedValue = r["CategoryID"].ToString();
                txtSummary.Text = r["Summary"] as string;
                txtKeyPoints.Text = r["KeyPoints"] as string;
                txtContent.Text = r["Content"] as string;
                txtVideoUrl.Text = r["VideoUrl"] as string;
                txtSourceTitle.Text = r["SourceTitle"] as string;
                txtSourceUrl.Text = r["SourceUrl"] as string;
                chkPublished.Checked = (bool)r["IsPublished"];

                string imagePath = r["ImagePath"] as string;
                if (!string.IsNullOrEmpty(imagePath))
                {
                    phCurrentImage.Visible = true;
                    imgCurrent.ImageUrl = LessonHelpers.ImageUrl(imagePath);
                }
            }
        }

        litFormTitle.Text = "Edit lesson";
        lnkPreview.NavigateUrl = "~/Lesson.aspx?id=" + lessonId;
        lnkPreview.Visible = true;
        pnlForm.Visible = true;
        txtTitle.Focus();
    }

    // =====================================================================
    // Server-side validation (repeats the client checks; never trust the browser)
    // =====================================================================

    protected void cuvContent_ServerValidate(object source, ServerValidateEventArgs args)
    {
        // Decode entities first, so "javascript&#58;" is caught too (integration fix)
        args.IsValid = !UnsafeHtml.IsMatch(HttpUtility.HtmlDecode(args.Value ?? ""));
    }

    protected void cuvImage_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = true;
        if (!fuImage.HasFile)
        {
            return; // the image is optional
        }
        if (fuImage.PostedFile.ContentLength > LessonHelpers.MaxImageBytes)
        {
            args.IsValid = false;
            return;
        }
        // Check the file's first bytes, not just its name, so renamed files are rejected
        args.IsValid = LessonHelpers.DetectImageExtension(fuImage.PostedFile.InputStream) != null;
    }

    // =====================================================================
    // Insert and update
    // =====================================================================

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            pnlForm.Visible = true;
            return;
        }

        int lessonId = int.Parse(hfLessonID.Value);
        bool isNew = lessonId == 0;
        string oldImagePath = isNew ? null : GetImagePath(lessonId);

        if (!isNew && oldImagePath == null && !LessonExists(lessonId))
        {
            ShowMessage("That lesson was deleted by someone else. Your changes were not saved.", false);
            pnlForm.Visible = false;
            BindGrid();
            return;
        }

        // 1. Save the new image file first (if any), named <GUID>.<ext>
        string newImagePath = null;
        if (fuImage.HasFile)
        {
            newImagePath = SaveUploadedImage();
        }

        // 2. Work out which image the lesson should end up with
        string finalImagePath = oldImagePath;
        if (newImagePath != null)
        {
            finalImagePath = newImagePath;
        }
        else if (chkRemoveImage.Checked)
        {
            finalImagePath = null;
        }

        // 3. Insert or update the row
        try
        {
            using (SqlConnection conn = Db.Open())
            using (SqlCommand cmd = conn.CreateCommand())
            {
                if (isNew)
                {
                    cmd.CommandText = @"
                        INSERT INTO Lessons (CategoryID, Title, Summary, KeyPoints, Content, ImagePath,
                                             VideoUrl, SourceTitle, SourceUrl, IsPublished)
                        VALUES (@CategoryID, @Title, @Summary, @KeyPoints, @Content, @ImagePath,
                                @VideoUrl, @SourceTitle, @SourceUrl, @IsPublished);
                        SELECT CAST(SCOPE_IDENTITY() AS INT);";
                }
                else
                {
                    cmd.CommandText = @"
                        UPDATE Lessons
                        SET CategoryID = @CategoryID, Title = @Title, Summary = @Summary,
                            KeyPoints = @KeyPoints, Content = @Content, ImagePath = @ImagePath,
                            VideoUrl = @VideoUrl, SourceTitle = @SourceTitle, SourceUrl = @SourceUrl,
                            IsPublished = @IsPublished
                        WHERE LessonID = @LessonID;
                        SELECT @LessonID;";
                    cmd.Parameters.Add("@LessonID", SqlDbType.Int).Value = lessonId;
                }

                cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = int.Parse(ddlCategory.SelectedValue);
                cmd.Parameters.Add("@Title", SqlDbType.NVarChar, 150).Value = txtTitle.Text.Trim();
                cmd.Parameters.Add("@Summary", SqlDbType.NVarChar, 500).Value = txtSummary.Text.Trim();
                cmd.Parameters.Add("@KeyPoints", SqlDbType.NVarChar, 1000).Value = txtKeyPoints.Text.Trim();
                cmd.Parameters.Add("@Content", SqlDbType.NVarChar, -1).Value = txtContent.Text.Trim(); // -1 = MAX
                cmd.Parameters.Add("@ImagePath", SqlDbType.NVarChar, 260).Value = (object)finalImagePath ?? DBNull.Value;
                cmd.Parameters.Add("@VideoUrl", SqlDbType.NVarChar, 300).Value = NullIfEmpty(CleanVideoUrl(txtVideoUrl.Text));
                cmd.Parameters.Add("@SourceTitle", SqlDbType.NVarChar, 200).Value = txtSourceTitle.Text.Trim();
                cmd.Parameters.Add("@SourceUrl", SqlDbType.NVarChar, 300).Value = txtSourceUrl.Text.Trim();
                cmd.Parameters.Add("@IsPublished", SqlDbType.Bit).Value = chkPublished.Checked;

                lessonId = (int)cmd.ExecuteScalar();
            }
        }
        catch
        {
            // Do not leave an orphaned upload behind if the database step failed
            LessonHelpers.DeleteLessonImage(Server, newImagePath);
            throw;
        }

        // 4. Only now remove the old file, once the row no longer points to it
        if (oldImagePath != null && oldImagePath != finalImagePath)
        {
            LessonHelpers.DeleteLessonImage(Server, oldImagePath);
        }

        bool published = chkPublished.Checked;   // read before ClearForm() unticks it (integration fix)
        ClearForm();
        pnlForm.Visible = false;
        BindGrid();
        ShowMessage((isNew ? "Lesson added" : "Lesson updated")
            + (published ? "." : " as a draft. Tick Published when it is ready."), true);
    }

    private string SaveUploadedImage()
    {
        string folder = Server.MapPath(LessonHelpers.LessonUploadFolder);
        if (!Directory.Exists(folder))
        {
            Directory.CreateDirectory(folder); // build guide: create the folder if it is missing
        }

        // Use the extension of the real file type, not the one in the uploaded name
        string extension = LessonHelpers.DetectImageExtension(fuImage.PostedFile.InputStream);
        string fileName = Guid.NewGuid().ToString("N") + extension;
        fuImage.SaveAs(Path.Combine(folder, fileName));
        return LessonHelpers.LessonUploadFolder + fileName;
    }

    // =====================================================================
    // Delete
    // =====================================================================

    private void DeleteLesson(int lessonId)
    {
        string imagePath = GetImagePath(lessonId);
        string title;

        // LessonProgress rows go with the lesson (cascade in 01_Schema.sql)
        const string sql = @"
            DECLARE @Title NVARCHAR(150) = (SELECT Title FROM Lessons WHERE LessonID = @LessonID);
            DELETE FROM Lessons WHERE LessonID = @LessonID;
            SELECT @Title;";

        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.Add("@LessonID", SqlDbType.Int).Value = lessonId;
            title = cmd.ExecuteScalar() as string;
        }

        if (title == null)
        {
            ShowMessage("That lesson was already deleted.", false);
        }
        else
        {
            LessonHelpers.DeleteLessonImage(Server, imagePath);
            ShowMessage("Lesson \"" + title + "\" deleted.", true);
        }

        // If the deleted lesson was open in the form, close it
        if (hfLessonID.Value == lessonId.ToString())
        {
            ClearForm();
            pnlForm.Visible = false;
        }

        // Step back a page if the last row on this page was removed
        if (gvLessons.Rows.Count == 1 && gvLessons.PageIndex > 0)
        {
            gvLessons.PageIndex--;
        }
        BindGrid();
    }

    // =====================================================================
    // Helpers
    // =====================================================================

    private static string GetImagePath(int lessonId)
    {
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand("SELECT ImagePath FROM Lessons WHERE LessonID = @LessonID", conn))
        {
            cmd.Parameters.Add("@LessonID", SqlDbType.Int).Value = lessonId;
            return cmd.ExecuteScalar() as string;
        }
    }

    private static bool LessonExists(int lessonId)
    {
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Lessons WHERE LessonID = @LessonID", conn))
        {
            cmd.Parameters.Add("@LessonID", SqlDbType.Int).Value = lessonId;
            return (int)cmd.ExecuteScalar() > 0;
        }
    }

    // YouTube's Share > Embed adds "?si=..." (a tracking code). Drop everything after "?"
    // so the stored URL is exactly https://www.youtube.com/embed/VIDEO_ID.
    private static string CleanVideoUrl(string url)
    {
        url = (url ?? "").Trim();
        int question = url.IndexOf('?');
        return question >= 0 ? url.Substring(0, question) : url;
    }

    private static object NullIfEmpty(string value)
    {
        value = (value ?? "").Trim();
        return value.Length == 0 ? (object)DBNull.Value : value;
    }

    private void ShowMessage(string text, bool success)
    {
        lblMessage.Text = HttpUtility.HtmlEncode(text);
        lblMessage.CssClass = success ? "alert alert-success d-block" : "alert alert-danger d-block";
        lblMessage.Visible = true;
    }
}
