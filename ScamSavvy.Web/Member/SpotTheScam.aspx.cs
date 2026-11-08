using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
public partial class Member_SpotTheScam : MemberPage
{
    private int scenarioId;
    private DataTable parts;
    private List<int> selected = new List<int>();
    protected void Page_Init(object sender, EventArgs e)
    {
        UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;
        ViewStateUserKey = Auth.CurrentUserId.ToString();
        if (Request.QueryString["id"] == null)
            return;
        pnlList.Visible = false;
        if (!int.TryParse(Request.QueryString["id"], out scenarioId) || scenarioId < 1)
        {
            ShowMessage("Scenario not found.", false);
            return;
        }
        DataTable scenario = new DataTable();
        using (SqlConnection con = Db.Open())
        using (
            SqlCommand cmd = new SqlCommand(
                "SELECT Title,Channel,SenderName FROM Scenarios WHERE ScenarioID=@ID AND IsPublished=1",
                con))
        {
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = scenarioId;
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(scenario);
        }
        if (scenario.Rows.Count == 0)
        {
            ShowMessage("Scenario not found.", false);
            return;
        }
        DataRow row = scenario.Rows[0];
        litTitle.Text = row["Title"].ToString();
        litChannel.Text = row["Channel"].ToString();
        litSender.Text = row["SenderName"].ToString();
        string channel = row["Channel"].ToString();
        pnlPhone.CssClass = "quiz-phone " + (channel == "WhatsApp" ? "quiz-whatsapp"
                                             : channel == "Email"  ? "quiz-email"
                                             : channel == "Call"   ? "quiz-call"
                                                                   : "quiz-sms");
        parts = new DataTable();
        using (SqlConnection con = Db.Open())
        using (
            SqlCommand cmd =
                new SqlCommand("SELECT PartID,PartOrder,PartText FROM ScenarioParts WHERE " +
                                   "ScenarioID=@ID ORDER BY PartOrder,PartID",
                               con))
        {
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = scenarioId;
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            adapter.Fill(parts);
        }
        if (parts.Rows.Count == 0)
        {
            ShowMessage("This scenario has no message parts yet.", false);
            return;
        }
        pnlScenario.Visible = true;
        rptParts.DataSource = parts;
        rptParts.DataBind();
    }
    private string GetPartContent(DataTable table)
    {
        string content = "";
        foreach (DataRow row in table.Rows)
            foreach (string col in new string[] { "PartID", "PartOrder", "PartText" })
            {
                string part = row[col].ToString();
                content += part.Length + ":" + part;
            }
        return content;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != null && parts == null)
        {
            pnlScenario.Visible = false;
            ShowMessage("Scenario unavailable. Choose a published scenario from the list.", false);
            return;
        }
        if (!IsPostBack && parts != null)
            ViewState["PartsVersion"] = GetPartContent(parts);
        if (!IsPostBack && Request.QueryString["id"] == null)
        {
            ddlCategory.Items.Add(new ListItem("All categories", "0"));
            using (SqlConnection con = Db.Open())
            using (SqlCommand cmd = new SqlCommand("SELECT CategoryID,Name FROM Categories ORDER BY SortOrder,CategoryID", con))
            using (SqlDataReader reader = cmd.ExecuteReader())
                while (reader.Read())
                    ddlCategory.Items.Add(new ListItem(reader["Name"].ToString(), reader["CategoryID"].ToString()));
            BindScenarios();
        }
    }
    protected void Filters_Changed(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] == null)
            BindScenarios();
    }
    protected void ResetFilters_Click(object sender, EventArgs e)
    {
        ddlCategory.SelectedIndex = 0;
        txtKeyword.Text = "";
        BindScenarios();
    }
    private void BindScenarios()
    {
            int categoryId;
            if (!int.TryParse(ddlCategory.SelectedValue, out categoryId))
            {
                categoryId = 0;
            }
            string keyword = txtKeyword.Text.Trim();
            if (keyword.Length > 100)
            {
                keyword = keyword.Substring(0, 100);
            }
            txtKeyword.Text = keyword;
            // Treat LIKE wildcard characters as ordinary search text.
            string pattern = "%" + keyword.Replace("~", "~~").Replace("%", "~%")
                .Replace("_", "~_").Replace("[", "~[") + "%";
            DataTable data = new DataTable();
            using (SqlConnection con = Db.Open())
        using (
                SqlCommand cmd = new SqlCommand(
                    @"SELECT s.ScenarioID,s.Title,s.Channel,c.Name AS CategoryName FROM Scenarios s
                INNER JOIN Categories c ON s.CategoryID=c.CategoryID
                WHERE s.IsPublished=1 AND (@Category=0 OR s.CategoryID=@Category)
                AND (@Keyword='' OR s.Title LIKE @Pattern ESCAPE '~'
                    OR c.Name LIKE @Pattern ESCAPE '~' OR s.Channel LIKE @Pattern ESCAPE '~'
                    OR s.SenderName LIKE @Pattern ESCAPE '~'
                    OR EXISTS (SELECT 1 FROM ScenarioParts p WHERE p.ScenarioID=s.ScenarioID
                        AND p.PartText LIKE @Pattern ESCAPE '~'))
                ORDER BY c.SortOrder,s.ScenarioID",
                    con))
            {
                cmd.Parameters.Add("@Category", SqlDbType.Int).Value = categoryId;
                cmd.Parameters.Add("@Keyword", SqlDbType.NVarChar, 100).Value = keyword;
                cmd.Parameters.Add("@Pattern", SqlDbType.NVarChar, 202).Value = pattern;
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(data);
            }
            rptScenarios.DataSource = data;
            rptScenarios.DataBind();
            lblEmpty.Visible = data.Rows.Count == 0;
            lblEmpty.Text = "No scenarios match your filters. Try another keyword or clear the filters.";
            lblResults.Text = data.Rows.Count + (data.Rows.Count == 1 ? " scenario found." : " scenarios found.");
    }
    protected void cuvSelected_ServerValidate(object source, ServerValidateEventArgs args)
    {
        selected.Clear();
        args.IsValid = false;
        if (parts == null || String.IsNullOrWhiteSpace(hfSelected.Value) ||
            hfSelected.Value.Length > 4000)
            return;
        List<int> valid = new List<int>();
        foreach (DataRow row in parts.Rows)
            valid.Add(Convert.ToInt32(row["PartID"]));
        foreach (string value in hfSelected.Value.Split(','))
        {
            int id;
            if (!int.TryParse(value, out id) || !valid.Contains(id) || selected.Contains(id))
                return;
            selected.Add(id);
        }
        args.IsValid = selected.Count > 0;
    }
    protected void btnCheck_Click(object sender, EventArgs e)
    {
        if (!pnlScenario.Visible || parts == null)
            return;
        Page.Validate("Scenario");
        if (!Page.IsValid)
            return;
        DataTable feedback = new DataTable();
        int found = 0, total = 0, wrong = 0;
        try
        {
            using (SqlConnection con = Db.Open())
            {
                using (SqlCommand cmd = new SqlCommand("SELECT ScenarioID FROM Scenarios " +
                                                           "WHERE ScenarioID=@ID AND IsPublished=1",
                                                       con))
                {
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = scenarioId;
                    if (cmd.ExecuteScalar() == null)
                        throw new InvalidOperationException("Scenario unavailable.");
                }
                using (SqlCommand cmd = new SqlCommand(
                           "SELECT PartID,PartOrder,PartText,IsRedFlag,Explanation FROM ScenarioParts " +
                               "WHERE ScenarioID=@ID ORDER BY PartOrder,PartID",
                           con))
                {
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = scenarioId;
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd)) da.Fill(feedback);
                }
                if (GetPartContent(feedback) != Convert.ToString(ViewState["PartsVersion"]))
                    throw new InvalidOperationException("Scenario changed.");
                feedback.Columns.Add("FeedbackClass");
                feedback.Columns.Add("FeedbackLabel");
                foreach (DataRow row in feedback.Rows)
                {
                    bool flag = Convert.ToBoolean(row["IsRedFlag"]),
                         clicked = selected.Contains(Convert.ToInt32(row["PartID"]));
                    if (flag)
                        total++;
                    if (flag && clicked)
                    {
                        found++;
                        row["FeedbackClass"] = "quiz-found";
                        row["FeedbackLabel"] = "Found red flag";
                    }
                    else if (flag)
                    {
                        row["FeedbackClass"] = "quiz-missed";
                        row["FeedbackLabel"] = "Missed red flag";
                    }
                    else if (clicked)
                    {
                        wrong++;
                        row["FeedbackClass"] = "quiz-wrongclick";
                        row["FeedbackLabel"] = "Incorrect selection";
                    }
                    else
                    {
                        row["FeedbackClass"] = "";
                        row["FeedbackLabel"] = "Not a red flag by itself";
                    }
                    if (row.IsNull("Explanation"))
                        row["Explanation"] =
                            "This part alone does not establish that a message is safe or unsafe.";
                }
                if (total == 0)
                    throw new InvalidOperationException("No red flags configured.");
                using (
                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO ScenarioAttempts(UserID,ScenarioID,FlagsFound,FlagsTotal,WrongClicks)
                    VALUES(@User,@Scenario,@Found,@Total,@Wrong)",
                        con))
                {
                    cmd.Parameters.Add("@User", SqlDbType.Int).Value = Auth.CurrentUserId;
                    cmd.Parameters.Add("@Scenario", SqlDbType.Int).Value = scenarioId;
                    cmd.Parameters.Add("@Found", SqlDbType.Int).Value = found;
                    cmd.Parameters.Add("@Total", SqlDbType.Int).Value = total;
                    cmd.Parameters.Add("@Wrong", SqlDbType.Int).Value = wrong;
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception ex)
        {
            Trace.Warn("Member 3", "The database operation failed.", ex);
            ShowMessage("This attempt could not be saved. Reopen the scenario and try again.", false);
            return;
        }
        litSummary.Text = "Found " + found + " of " + total + " red flags; missed " + (total - found) +
                          "; incorrect selections " + wrong + ".";
        rptFeedback.DataSource = feedback;
        rptFeedback.DataBind();
        pnlFeedback.Visible = true;
        btnCheck.Enabled = false;
        lnkRetry.NavigateUrl = "~/Member/SpotTheScam.aspx?id=" + scenarioId;
    }
    private void ShowMessage(string text, bool success)
    {
        lblMessage.Text = Server.HtmlEncode(text);
        lblMessage.CssClass = success ? "alert alert-success" : "alert alert-danger";
        lblMessage.Visible = true;
    }
}
