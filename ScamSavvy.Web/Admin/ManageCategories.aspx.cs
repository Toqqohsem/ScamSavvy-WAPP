using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;

public partial class Admin_ManageCategories : AdminPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSortOrder.Text = "0";
            BindGrid();
        }
    }

    private void BindGrid()
    {
        // The counts show admins why a delete would be blocked before they try it
        const string sql = @"
            SELECT c.CategoryID, c.Name, c.Description, c.SortOrder,
                   (SELECT COUNT(*) FROM Lessons    WHERE CategoryID = c.CategoryID) AS LessonCount,
                   (SELECT COUNT(*) FROM Quizzes    WHERE CategoryID = c.CategoryID) AS QuizCount,
                   (SELECT COUNT(*) FROM Scenarios  WHERE CategoryID = c.CategoryID) AS ScenarioCount,
                   (SELECT COUNT(*) FROM ScamReports WHERE CategoryID = c.CategoryID) AS ReportCount
            FROM Categories c
            ORDER BY c.SortOrder, c.Name;";

        DataTable table = new DataTable();
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
        {
            adapter.Fill(table);
        }
        gvCategories.DataSource = table;
        gvCategories.DataBind();
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return; // server-side check of the same validators
        }

        string name = txtName.Text.Trim();
        string description = txtDescription.Text.Trim();
        int sortOrder = int.Parse(txtSortOrder.Text);

        if (NameExists(name, 0))
        {
            ShowMessage("A category called \"" + name + "\" already exists.", false);
            return;
        }

        const string sql = @"
            INSERT INTO Categories (Name, Description, SortOrder)
            VALUES (@Name, @Description, @SortOrder);";

        try
        {
            using (SqlConnection conn = Db.Open())
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                AddFields(cmd, name, description, sortOrder);
                cmd.ExecuteNonQuery();
            }
        }
        catch (SqlException ex)
        {
            if (IsDuplicateKey(ex))
            {
                ShowMessage("A category called \"" + name + "\" already exists.", false);
                return;
            }
            throw;
        }

        txtName.Text = "";
        txtDescription.Text = "";
        txtSortOrder.Text = "0";
        gvCategories.EditIndex = -1;
        BindGrid();
        ShowMessage("Category \"" + name + "\" added.", true);
    }

    protected void gvCategories_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvCategories.EditIndex = e.NewEditIndex;
        BindGrid();
    }

    protected void gvCategories_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvCategories.EditIndex = -1;
        BindGrid();
    }

    protected void gvCategories_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        Page.Validate("Edit");
        if (!Page.IsValid)
        {
            e.Cancel = true;
            return;
        }

        int categoryId = (int)gvCategories.DataKeys[e.RowIndex].Value;
        GridViewRow row = gvCategories.Rows[e.RowIndex];
        string name = ((TextBox)row.FindControl("txtEditName")).Text.Trim();
        string description = ((TextBox)row.FindControl("txtEditDescription")).Text.Trim();
        int sortOrder = int.Parse(((TextBox)row.FindControl("txtEditSortOrder")).Text);

        if (NameExists(name, categoryId))
        {
            e.Cancel = true;
            ShowMessage("Another category is already called \"" + name + "\".", false);
            return;
        }

        const string sql = @"
            UPDATE Categories
            SET Name = @Name, Description = @Description, SortOrder = @SortOrder
            WHERE CategoryID = @CategoryID;";

        try
        {
            using (SqlConnection conn = Db.Open())
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                AddFields(cmd, name, description, sortOrder);
                cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = categoryId;
                cmd.ExecuteNonQuery();
            }
        }
        catch (SqlException ex)
        {
            if (IsDuplicateKey(ex))
            {
                e.Cancel = true;
                ShowMessage("Another category is already called \"" + name + "\".", false);
                return;
            }
            throw;
        }

        gvCategories.EditIndex = -1;
        BindGrid();
        ShowMessage("Category \"" + name + "\" updated.", true);
    }

    protected void gvCategories_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        e.Cancel = true;
        int categoryId = (int)gvCategories.DataKeys[e.RowIndex].Value;

        // Check usage on the server, never trust the counts already on screen
        const string usageSql = @"
            SELECT (SELECT COUNT(*) FROM Lessons     WHERE CategoryID = @CategoryID),
                   (SELECT COUNT(*) FROM Quizzes     WHERE CategoryID = @CategoryID),
                   (SELECT COUNT(*) FROM Scenarios   WHERE CategoryID = @CategoryID),
                   (SELECT COUNT(*) FROM ScamReports WHERE CategoryID = @CategoryID),
                   (SELECT Name FROM Categories WHERE CategoryID = @CategoryID);";

        using (SqlConnection conn = Db.Open())
        {
            int lessons, quizzes, scenarios, reports;
            string name;
            using (SqlCommand cmd = new SqlCommand(usageSql, conn))
            {
                cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = categoryId;
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    r.Read();
                    lessons = r.GetInt32(0);
                    quizzes = r.GetInt32(1);
                    scenarios = r.GetInt32(2);
                    reports = r.GetInt32(3);
                    name = r.IsDBNull(4) ? null : r.GetString(4);
                }
            }

            if (name == null)
            {
                ShowMessage("That category no longer exists.", false);
                BindGrid();
                return;
            }

            List<string> uses = new List<string>();
            if (lessons > 0) uses.Add(Plural(lessons, "lesson"));
            if (quizzes > 0) uses.Add(Plural(quizzes, "quiz", "quizzes"));
            if (scenarios > 0) uses.Add(Plural(scenarios, "scenario"));
            if (reports > 0) uses.Add(Plural(reports, "scam report"));

            if (uses.Count > 0)
            {
                ShowMessage("\"" + name + "\" cannot be deleted because it is used by "
                    + string.Join(", ", uses) + ". Move or delete those first.", false);
                return;
            }

            try
            {
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Categories WHERE CategoryID = @CategoryID;", conn))
                {
                    cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = categoryId;
                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 547)
                {
                    ShowMessage("\"" + name + "\" is now in use and cannot be deleted.", false);
                    BindGrid();
                    return;
                }
                throw;
            }

            gvCategories.EditIndex = -1;
            BindGrid();
            ShowMessage("Category \"" + name + "\" deleted.", true);
        }
    }

    private static void AddFields(SqlCommand cmd, string name, string description, int sortOrder)
    {
        cmd.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = name;
        cmd.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value = description;
        cmd.Parameters.Add("@SortOrder", SqlDbType.Int).Value = sortOrder;
    }

    private static bool NameExists(string name, int exceptCategoryId)
    {
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(
            "SELECT COUNT(*) FROM Categories WHERE Name = @Name AND CategoryID <> @CategoryID", conn))
        {
            cmd.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = name;
            cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = exceptCategoryId;
            return (int)cmd.ExecuteScalar() > 0;
        }
    }

    private static bool IsDuplicateKey(SqlException ex)
    {
        return ex.Number == 2627 || ex.Number == 2601; // unique constraint / unique index
    }

    private static string Plural(int count, string one, string many = null)
    {
        return count + " " + (count == 1 ? one : (many ?? one + "s"));
    }

    private void ShowMessage(string text, bool success)
    {
        lblMessage.Text = HttpUtility.HtmlEncode(text);
        lblMessage.CssClass = success ? "alert alert-success d-block" : "alert alert-danger d-block";
        lblMessage.Visible = true;
    }
}
