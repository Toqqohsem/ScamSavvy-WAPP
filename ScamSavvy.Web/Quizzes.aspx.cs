using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System;
using System.Data;
using System.Globalization;
using System.Web.UI;
public partial class Quizzes : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable categories = new DataTable();
            using (SqlConnection con = Db.Open())
        using (
                SqlCommand cmd = new SqlCommand(
                    "SELECT CategoryID,Name FROM Categories ORDER BY SortOrder,CategoryID", con))
            {
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(categories);
            }
            ddlCategory.DataSource = categories;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("All categories", "0"));

            int categoryId;
            if (int.TryParse(Request.QueryString["category"], out categoryId))
            {
                ListItem category = ddlCategory.Items.FindByValue(categoryId.ToString());
                if (category != null)
                    ddlCategory.SelectedValue = category.Value;
            }
            BindQuizzes();
        }
    }
    protected void ddlCategory_Changed(object sender, EventArgs e)
    {
        BindQuizzes();
    }
    protected void Search_Click(object sender, EventArgs e)
    {
        BindQuizzes();
    }
    protected void Clear_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        ddlCategory.SelectedIndex = 0;
        BindQuizzes();
    }
    private void BindQuizzes()
    {
        string keyword = txtSearch.Text.Trim();
        if (keyword.Length > 100)
        {
            keyword = keyword.Substring(0, 100);
        }
        txtSearch.Text = keyword;
        string pattern = "%" + keyword.Replace("~", "~~").Replace("%", "~%")
            .Replace("_", "~_").Replace("[", "~[") + "%";
        DataTable data = new DataTable();
        using (SqlConnection con = Db.Open())
        using (
            SqlCommand cmd =
                new SqlCommand(@"SELECT q.QuizID,q.Title,q.Description,c.Name AS CategoryName,
            (SELECT COUNT(*) FROM Questions x WHERE x.QuizID=q.QuizID) AS QuestionCount,
            (SELECT MAX(100.0*a.Score/NULLIF(a.TotalQuestions,0)) FROM QuizAttempts a
             WHERE a.QuizID=q.QuizID AND a.UserID=@UserID) AS BestPercentage
            FROM Quizzes q INNER JOIN Categories c ON q.CategoryID=c.CategoryID
            WHERE q.IsPublished=1 AND (@CategoryID=0 OR q.CategoryID=@CategoryID)
            AND (@Search='' OR q.Title LIKE @Pattern ESCAPE '~'
                OR q.Description LIKE @Pattern ESCAPE '~' OR c.Name LIKE @Pattern ESCAPE '~'
                OR EXISTS (SELECT 1 FROM Questions x WHERE x.QuizID=q.QuizID AND x.QuestionText LIKE @Pattern ESCAPE '~'))
            ORDER BY c.SortOrder,q.QuizID",
                               con))
        {
            cmd.Parameters.Add("@Search", SqlDbType.NVarChar, 100).Value = keyword;
            cmd.Parameters.Add("@Pattern", SqlDbType.NVarChar, 202).Value = pattern;
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Auth.CurrentUserId;
            cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value =
                Convert.ToInt32(ddlCategory.SelectedValue);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(data);
        }
        rptQuizzes.DataSource = data;
        rptQuizzes.DataBind();
        lblEmpty.Visible = data.Rows.Count == 0;
        lblEmpty.Text = "No quizzes match your filters. Try another search or clear the filters.";
        lblResults.Text = data.Rows.Count + (data.Rows.Count == 1 ? " quiz found." : " quizzes found.");
    }
    protected string BestClass(object value)
    {
        if (!Auth.IsLoggedIn || value == null || value == DBNull.Value)
        {
            return "quiz-score quiz-score-new";
        }
        return Convert.ToDecimal(value) >= 70 ? "quiz-score quiz-score-pass" : "quiz-score quiz-score-fail";
    }
    protected string BestText(object value)
    {
        if (!Auth.IsLoggedIn)
            return "Log in to save your results.";
        return value == null || value == DBNull.Value
                   ? "Not attempted yet."
                   : "Your best score: " +
                         Convert.ToDecimal(value).ToString("0.0", CultureInfo.InvariantCulture) + "%";
    }
}
