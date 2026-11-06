using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ScamSavvy
{
    public partial class Feedback : Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["ScamSavvyDB"]?.ConnectionString
            ?? @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\ScamSavvy.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Pre-fill name/email if the user is logged in (session placeholders)
                if (Session["UserName"] != null)
                    txtName.Value = Session["UserName"].ToString();
                if (Session["UserEmail"] != null)
                    txtEmail.Value = Session["UserEmail"].ToString();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Clear previous messages
            pnlServerError.Visible = false;
            pnlSuccess.Visible = false;
            litServerErrors.Text = "";

            // ---- Server-side validation ----
            var errors = new StringBuilder();
            string name = txtName.Value?.Trim() ?? "";
            string email = txtEmail.Value?.Trim() ?? "";
            string phone = txtPhone.Value?.Trim() ?? "";
            string category = ddlCategory.Value ?? "";
            string message = txtMessage.Value?.Trim() ?? "";
            string rating = GetSelectedRating();

            if (string.IsNullOrWhiteSpace(name) || name.Length < 2)
                errors.Append("<li>Full name must be at least 2 characters.</li>");

            if (string.IsNullOrWhiteSpace(email) || !IsValidEmail(email))
                errors.Append("<li>A valid email address is required.</li>");

            if (!string.IsNullOrWhiteSpace(phone) && !IsValidPhone(phone))
                errors.Append("<li>Phone number must be 7–20 digits (may include +, -, spaces, parentheses).</li>");

            if (string.IsNullOrWhiteSpace(category))
                errors.Append("<li>Please select a feedback category.</li>");

            if (string.IsNullOrWhiteSpace(message) || message.Length < 10)
                errors.Append("<li>Message must be at least 10 characters.</li>");

            if (string.IsNullOrWhiteSpace(rating))
                errors.Append("<li>Please choose an overall rating (1–5 stars).</li>");

            if (errors.Length > 0)
            {
                litServerErrors.Text = "<ul>" + errors + "</ul>";
                pnlServerError.Visible = true;
                return;
            }

            // ---- Save to database ----
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                using (var cmd = new SqlCommand(@"
                    INSERT INTO Feedback
                        (Name, Email, Phone, Category, Rating, Message, Status, SubmittedOn)
                    VALUES
                        (@Name, @Email, @Phone, @Category, @Rating, @Message, 'Pending', GETDATE())", conn))
                {
                    cmd.Parameters.Add("@Name", SqlDbType.NVarChar, 120).Value = name;
                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 200).Value = email;
                    cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 40).Value = (object)phone ?? DBNull.Value;
                    cmd.Parameters.Add("@Category", SqlDbType.NVarChar, 80).Value = category;
                    cmd.Parameters.Add("@Rating", SqlDbType.Int).Value = int.Parse(rating);
                    cmd.Parameters.Add("@Message", SqlDbType.NVarChar, -1).Value = message;

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Clear fields after successful save
                txtName.Value = "";
                txtEmail.Value = "";
                txtPhone.Value = "";
                ddlCategory.Value = "";
                txtMessage.Value = "";
                ClearRatingSelection();

                pnlSuccess.Visible = true;
            }
            catch (Exception ex)
            {
                // In production, log ex and show a friendly message.
                litServerErrors.Text = "<ul><li>Sorry, we couldn't save your feedback right now. Please try again later.</li></ul>";
                pnlServerError.Visible = true;
            }
        }

        private string GetSelectedRating()
        {
            // Find the selected radio button in the rating group
            if (star5.Checked) return "5";
            if (star4.Checked) return "4";
            if (star3.Checked) return "3";
            if (star2.Checked) return "2";
            if (star1.Checked) return "1";
            return "";
        }

        private void ClearRatingSelection()
        {
            star5.Checked = false;
            star4.Checked = false;
            star3.Checked = false;
            star2.Checked = false;
            star1.Checked = false;
        }

        private static bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch { return false; }
        }

        private static bool IsValidPhone(string phone)
        {
            return System.Text.RegularExpressions.Regex.IsMatch(
                phone, @"^[0-9+\-\s()]{7,20}$");
        }
    }
}