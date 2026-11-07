// Owner: Lyu Jiaxin (Feedback module). Rebuilt on the team template by Ahmad during integration.
using System;
using System.Data;

public partial class Feedback : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack || !Auth.IsLoggedIn) return;

        // Logged-in members get their name and email filled in.
        DataTable t = Db.Query("SELECT Name, Email, Mobile FROM Users WHERE UserID = @UserID",
            Db.P("@UserID", Auth.CurrentUserId));
        if (t.Rows.Count == 1)
        {
            txtName.Text = (string)t.Rows[0]["Name"];
            txtEmail.Text = (string)t.Rows[0]["Email"];
            txtPhone.Text = (string)t.Rows[0]["Mobile"];
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string phone = txtPhone.Text.Trim();
        Db.Execute(
            "INSERT INTO Feedback (UserID, Name, Email, Phone, Category, Rating, Message) " +
            "VALUES (@UserID, @Name, @Email, @Phone, @Category, @Rating, @Message)",
            Db.P("@UserID", Auth.IsLoggedIn ? (object)Auth.CurrentUserId : null),
            Db.P("@Name", txtName.Text.Trim()),
            Db.P("@Email", txtEmail.Text.Trim().ToLowerInvariant()),
            Db.P("@Phone", phone.Length == 0 ? null : phone),
            Db.P("@Category", ddlCategory.SelectedValue),
            Db.P("@Rating", int.Parse(rblRating.SelectedValue)),
            Db.P("@Message", txtFeedback.Text.Trim()));

        // Keep the member's details, clear the rest for a possible second message.
        ddlCategory.SelectedIndex = 0;
        rblRating.ClearSelection();
        txtFeedback.Text = "";
        if (!Auth.IsLoggedIn)
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
        }

        lblMessage.Text = "Thank you. Your feedback has been sent and our team will review it.";
        lblMessage.CssClass = "alert alert-success d-block";
        lblMessage.Visible = true;
    }
}
