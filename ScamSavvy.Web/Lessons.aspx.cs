using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;

public partial class Lessons : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategories();

            // ?category= preselects the drop-down; ?q= keeps the search text
            int categoryId = LessonHelpers.QueryInt(Request, "category");
            string search = (Request.QueryString["q"] ?? "").Trim();
            if (search.Length > 100)
            {
                search = search.Substring(0, 100);
            }

            if (ddlCategory.Items.FindByValue(categoryId.ToString()) != null)
            {
                ddlCategory.SelectedValue = categoryId.ToString();
            }
            else
            {
                categoryId = 0;
            }
            txtSearch.Text = search;

            BindLessons(categoryId, search);
        }
    }

    private void LoadCategories()
    {
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(
            "SELECT CategoryID, Name FROM Categories ORDER BY SortOrder, Name", conn))
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            ddlCategory.DataSource = reader;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
        }
        ddlCategory.Items.Insert(0, new ListItem("All categories", "0"));
    }

    private void BindLessons(int categoryId, string search)
    {
        const string sql = @"
            SELECT l.LessonID, l.Title, l.Summary, l.ImagePath, c.Name AS CategoryName,
                   CAST(CASE WHEN lp.LessonID IS NULL THEN 0 ELSE 1 END AS BIT) AS IsCompleted
            FROM Lessons l
            INNER JOIN Categories c ON c.CategoryID = l.CategoryID
            LEFT JOIN LessonProgress lp ON lp.LessonID = l.LessonID AND lp.UserID = @UserID
            WHERE l.IsPublished = 1
              AND (@CategoryID = 0 OR l.CategoryID = @CategoryID)
              AND (@Search = '' OR l.Title LIKE '%' + @Search + '%')
            ORDER BY c.SortOrder, l.CreatedAt DESC;";

        DataTable lessons = new DataTable();
        using (SqlConnection conn = Db.Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Auth.IsLoggedIn ? Auth.CurrentUserId : 0;
            cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = categoryId;
            cmd.Parameters.Add("@Search", SqlDbType.NVarChar, 400).Value = LessonHelpers.EscapeLike(search);
            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                adapter.Fill(lessons);
            }
        }

        rptLessons.DataSource = lessons;
        rptLessons.DataBind();

        int count = lessons.Rows.Count;
        rptLessons.Visible = count > 0;
        pnlEmpty.Visible = count == 0;
        litResultCount.Text = count == 1 ? "1 lesson" : count + " lessons";
        if (search.Length > 0)
        {
            litResultCount.Text += " matching \"" + HttpUtility.HtmlEncode(search) + "\"";
        }
    }

    private void RedirectWithFilter()
    {
        string url = "~/Lessons.aspx";
        string separator = "?";
        if (ddlCategory.SelectedValue != "0")
        {
            url += separator + "category=" + ddlCategory.SelectedValue;
            separator = "&";
        }
        string search = txtSearch.Text.Trim();
        if (search.Length > 0)
        {
            url += separator + "q=" + HttpUtility.UrlEncode(search);
        }
        Response.Redirect(url, false);
        Context.ApplicationInstance.CompleteRequest();
    }

    protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        RedirectWithFilter();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Page.Validate("Search");
        if (!Page.IsValid)
        {
            return;
        }
        RedirectWithFilter();
    }
}
