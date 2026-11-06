using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Member_TakeQuiz : MemberPage
{
    private DataTable questions;
    private int quizId;
    protected void Page_Init(object sender, EventArgs e)
    {
        UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;
        // Bind before post data loads, otherwise the selected radio values are lost.
        ViewStateUserKey = Auth.CurrentUserId.ToString();
        if (!int.TryParse(Request.QueryString["id"], out quizId) || quizId < 1)
        {
            ShowMessage("Quiz not found.", false);
            return;
        }
        DataTable quiz = new DataTable();
        using (SqlConnection con = Db.Open())
        using (
            SqlCommand cmd =
                new SqlCommand("SELECT Title FROM Quizzes WHERE QuizID=@ID AND IsPublished=1", con))
        {
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = quizId;
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(quiz);
        }
        if (quiz.Rows.Count == 0)
        {
            ShowMessage("Quiz not found.", false);
            return;
        }
        questions = new DataTable();
        using (SqlConnection con = Db.Open())
        using (
            SqlCommand cmd =
                new SqlCommand(@"SELECT QuestionID,QuestionText,OptionA,OptionB,OptionC,OptionD
            FROM Questions WHERE QuizID=@ID ORDER BY QuestionID",
                               con))
        {
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = quizId;
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(questions);
        }
        if (questions.Rows.Count == 0)
        {
            ShowMessage("This quiz has no questions yet.", false);
            return;
        }
        litTitle.Text = quiz.Rows[0]["Title"].ToString();
        pnlQuiz.Visible = true;
        rptQuestions.DataSource = questions;
        rptQuestions.DataBind();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (questions == null)
        {
            pnlQuiz.Visible = false;
            ShowMessage("Quiz unavailable. Return to the quiz list and choose a published quiz.", false);
            return;
        }
        if (!IsPostBack && questions != null)
            ViewState["QuestionVersion"] = GetQuestionContent(questions);
        if (questions != null && IsPostBack &&
            !String.Equals(Convert.ToString(ViewState["QuestionVersion"]), GetQuestionContent(questions),
                           StringComparison.Ordinal))
        {
            pnlQuiz.Visible = false;
            ShowMessage("This quiz changed. Open it again before answering.", false);
        }
    }
    protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
            return;
        DataRowView row = (DataRowView)e.Item.DataItem;
        RadioButtonList answers = (RadioButtonList)e.Item.FindControl("rblAnswer");
        foreach (string letter in new string[] { "A", "B", "C", "D" })
            answers.Items.Add(new ListItem(
                System.Web.HttpUtility.HtmlEncode(letter + ". " + row["Option" + letter].ToString()),
                letter));
    }
    protected void cuvAnswered_ServerValidate(object source, ServerValidateEventArgs args)
    {
        CustomValidator validator = (CustomValidator)source;
        RadioButtonList answers = (RadioButtonList)validator.NamingContainer.FindControl("rblAnswer");
        args.IsValid = answers.SelectedValue.Length == 1 && "ABCD".Contains(answers.SelectedValue);
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!pnlQuiz.Visible || questions == null)
            return;
        Page.Validate("Quiz");
        if (!Page.IsValid)
            return;
        int attemptId = 0;
        try
        {
            using (SqlConnection con = Db.Open())
        using (SqlTransaction tx = con.BeginTransaction())
            {
                using (SqlCommand cmd = new SqlCommand("SELECT QuizID FROM Quizzes WHERE " +
                                                           "QuizID=@ID AND IsPublished=1",
                                                       con, tx))
                {
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = quizId;
                    if (cmd.ExecuteScalar() == null)
                        throw new InvalidOperationException("Quiz unavailable.");
                }
                DataTable key = new DataTable();
                using (SqlCommand cmd = new SqlCommand(
                           @"SELECT QuestionID,QuestionText,OptionA,OptionB,OptionC,OptionD,CorrectOption
                    FROM Questions WHERE QuizID=@ID ORDER BY QuestionID",
                           con, tx))
                {
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = quizId;
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd)) adapter.Fill(key);
                }
                if (key.Rows.Count == 0 ||
                    GetQuestionContent(key) != Convert.ToString(ViewState["QuestionVersion"]))
                    throw new InvalidOperationException("Quiz changed.");
                int score = 0;
                List<string> chosen = new List<string>();
                for (int i = 0; i < key.Rows.Count; i++)
                {
                    string answer =
                        ((RadioButtonList)rptQuestions.Items[i].FindControl("rblAnswer")).SelectedValue;
                    if (answer.Length != 1 || !"ABCD".Contains(answer))
                        throw new InvalidOperationException("Invalid answer.");
                    chosen.Add(answer);
                    if (answer == key.Rows[i]["CorrectOption"].ToString())
                        score++;
                }
                using (SqlCommand cmd =
                           new SqlCommand(@"INSERT INTO QuizAttempts(UserID,QuizID,Score,TotalQuestions)
                    VALUES(@UserID,@QuizID,@Score,@Total); SELECT CAST(SCOPE_IDENTITY() AS INT);",
                                          con, tx))
                {
                    cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = Auth.CurrentUserId;
                    cmd.Parameters.Add("@QuizID", SqlDbType.Int).Value = quizId;
                    cmd.Parameters.Add("@Score", SqlDbType.Int).Value = score;
                    cmd.Parameters.Add("@Total", SqlDbType.Int).Value = key.Rows.Count;
                    attemptId = Convert.ToInt32(cmd.ExecuteScalar());
                }
                for (int i = 0; i < key.Rows.Count; i++)
                    using (SqlCommand cmd = new SqlCommand(
                               "INSERT INTO QuizAnswers(AttemptID,QuestionID,ChosenOption) " +
                                   "VALUES(@Attempt,@Question,@Chosen)",
                               con, tx))
                    {
                        cmd.Parameters.Add("@Attempt", SqlDbType.Int).Value = attemptId;
                        cmd.Parameters.Add("@Question", SqlDbType.Int).Value =
                            Convert.ToInt32(key.Rows[i]["QuestionID"]);
                        cmd.Parameters.Add("@Chosen", SqlDbType.Char, 1).Value = chosen[i];
                        cmd.ExecuteNonQuery();
                    }
                tx.Commit();
            }
        }
        catch (Exception ex)
        {
            Trace.Warn("Member 3", "The database operation failed.", ex);
            ShowMessage("The quiz could not be saved. Reopen the quiz and try again.", false);
            return;
        }
        Response.Redirect(ResolveUrl("~/Member/QuizResult.aspx?id=" + attemptId));
    }
    private string GetQuestionContent(DataTable questions)
    {
        string value = "";
        foreach (DataRow row in questions.Rows)
            foreach (string col in new string[] { "QuestionID", "QuestionText", "OptionA", "OptionB",
                                                  "OptionC", "OptionD" })
            {
                string part = Convert.ToString(row[col]);
                value += part.Length + ":" + part;
            }
        return value;
    }

    private void ShowMessage(string text, bool success)
    {
        lblMessage.Text = Server.HtmlEncode(text);
        lblMessage.CssClass = success ? "alert alert-success" : "alert alert-danger";
        lblMessage.Visible = true;
    }
}
