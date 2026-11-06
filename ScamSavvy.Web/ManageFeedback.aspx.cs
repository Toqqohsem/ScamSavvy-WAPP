using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ScamSavvy
{
    public partial class ManageFeedback : Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["ScamSavvyDB"]?.ConnectionString
            ?? @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\ScamSavvy.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindFeedback();
            }
        }

        private void BindFeedback()
        {
            string filter = ddlStatusFilter.SelectedValue ?? "All";

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    if (filter == "All")
                    {
                        cmd.CommandText = @"SELECT Id, Name, Email, Category, Rating, Message, Status, SubmittedOn
                                            FROM Feedback ORDER BY SubmittedOn DESC";
                    }
                    else
                    {
                        cmd.CommandText = @"SELECT Id, Name, Email, Category, Rating, Message, Status, SubmittedOn
                                            FROM Feedback WHERE Status = @Status ORDER BY SubmittedOn DESC";
                        cmd.Parameters.AddWithValue("@Status", filter);
                    }

                    var dt = new DataTable();
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }

                    rptFeedback.DataSource = dt;
                    rptFeedback.DataBind();

                    pnlEmpty.Visible = dt.Rows.Count == 0;
                }
            }
            catch
            {
                pnlEmpty.Visible = true;
            }
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindFeedback();
        }

        protected void rptFeedback_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                DeleteFeedback(id);
                ShowMessage("Feedback #" + id + " has been deleted.");
                BindFeedback();
            }
            else if (e.CommandName == "SetStatus")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                int id = Convert.ToInt32(parts[0]);
                string status = parts[1];
                UpdateStatus(id, status);
                ShowMessage("Feedback #" + id + " status updated to " + status + ".");
                BindFeedback();
            }
        }

        private void UpdateStatus(int id, string status)
        {
            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("UPDATE Feedback SET Status = @Status WHERE Id = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void DeleteFeedback(int id)
        {
            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("DELETE FROM Feedback WHERE Id = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void ShowMessage(string text)
        {
            litMessage.Text = Server.HtmlEncode(text);
            pnlMessage.Visible = true;
        }

        /* ---------- Helper methods for Repeater data binding ---------- */

        protected string RenderStars(object rating)
        {
            int r;
            if (rating == null || !int.TryParse(rating.ToString(), out r)) return "—";
            r = Math.Max(1, Math.Min(5, r));
            return new string('★', r) + new string('☆', 5 - r);
        }

        protected string GetBadgeClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "badge badge-pending";
            switch (status.ToLowerInvariant())
            {
                case "reviewed": return "badge badge-reviewed";
                case "resolved": return "badge badge-resolved";
                case "rejected": return "badge badge-rejected";
                default: return "badge badge-pending";
            }
        }
    }
}