using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System;
using System.Data;
public partial class Member_QuizResult : MemberPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id) || id < 1)
        {
            ShowMessage("Result not found.", false);
            return;
        }
        DataTable result = new DataTable();
        using (SqlConnection con = Db.Open())
        using (
            SqlCommand cmd = new SqlCommand(@"SELECT a.*,q.Title,q.CategoryID FROM QuizAttempts a
            INNER JOIN Quizzes q ON a.QuizID=q.QuizID WHERE a.AttemptID=@ID",
                                            con))
        {
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = id;
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(result);
        }
        if (result.Rows.Count == 0)
        {
            ShowMessage("Result not found.", false);
            return;
        }
        DataRow row = result.Rows[0];
        if (!Auth.IsOwnerOrAdmin(Convert.ToInt32(row["UserID"])))
        {
            Response.Redirect(ResolveUrl("~/AccessDenied.aspx"));
            return;
        }
        pnlResult.Visible = true;
        litTitle.Text = row["Title"].ToString();
        int score = Convert.ToInt32(row["Score"]), total = Convert.ToInt32(row["TotalQuestions"]);
        double percentage = total == 0 ? 0 : 100.0 * score / total;
        litScore.Text = score + " / " + total + " (" + percentage.ToString("0.0") + "%" + ") - " +
                        (score * 100 >= total * 70 ? "Pass" : "Not yet passed");
        lnkRevise.NavigateUrl = "~/Lessons.aspx?category=" + row["CategoryID"];
        lnkRetry.NavigateUrl = "~/Member/TakeQuiz.aspx?id=" + row["QuizID"];
        // Authorisation is repeated in SQL, not only checked by the page's buttons.
        DataTable answerDetails = new DataTable();
        using (SqlConnection con = Db.Open())
        using (
            SqlCommand cmd =
                new SqlCommand(@"SELECT q.QuestionText,q.OptionA,q.OptionB,q.OptionC,q.OptionD,
            q.CorrectOption,q.Explanation,ans.ChosenOption FROM QuizAnswers ans
            INNER JOIN Questions q ON q.QuestionID=ans.QuestionID
            INNER JOIN QuizAttempts a ON a.AttemptID=ans.AttemptID
            WHERE a.AttemptID=@ID AND (a.UserID=@UserID OR @IsAdmin=1) ORDER BY q.QuestionID",
                               con))
        {
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = id;
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Auth.CurrentUserId;
            cmd.Parameters.Add("@IsAdmin", SqlDbType.Int).Value =
                Auth.CurrentRole == Auth.RoleAdmin ? 1 : 0;
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(answerDetails);
        }
        rptAnswers.DataSource = answerDetails;
        rptAnswers.DataBind();
        // Even an admin viewing another user's result sees only their own attempt history.
        DataTable attemptHistory = new DataTable();
        using (SqlConnection con = Db.Open())
        using (
            SqlCommand cmd =
                new SqlCommand(@"SELECT AttemptID,Score,TotalQuestions,AttemptedAt FROM QuizAttempts
            WHERE QuizID=@QuizID AND UserID=@UserID ORDER BY AttemptedAt DESC,AttemptID DESC",
                               con))
        {
            cmd.Parameters.Add("@QuizID", SqlDbType.Int).Value = Convert.ToInt32(row["QuizID"]);
            cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Auth.CurrentUserId;
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(attemptHistory);
        }
        gvHistory.DataSource = attemptHistory;
        gvHistory.DataBind();
    }
    protected string AnswerText(object item, string column)
    {
        DataRowView row = (DataRowView)item;
        string letter = row[column].ToString();
        return letter + ". " + row["Option" + letter].ToString();
    }
    private void ShowMessage(string text, bool success)
    {
        lblMessage.Text = Server.HtmlEncode(text);
        lblMessage.CssClass = success ? "alert alert-success" : "alert alert-danger";
        lblMessage.Visible = true;
    }
}
