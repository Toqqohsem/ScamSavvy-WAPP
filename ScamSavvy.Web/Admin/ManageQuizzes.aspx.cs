using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.UI.WebControls;

public partial class Admin_ManageQuizzes : AdminPage
{
    protected void Page_Init(object sender, EventArgs e)
    {
        UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None;
        ViewStateUserKey = Auth.CurrentUserId.ToString();
    }

    private string ActiveDialog
    {
        get { return Convert.ToString(ViewState["ActiveDialog"]); }
        set { ViewState["ActiveDialog"] = value; }
    }
    // ViewState keeps the selected dialog during a button postback.
    protected string HeaderModalId
    {
        get
        {
            if (ActiveDialog == "newQuizModal")
            {
                return "newQuizModal";
            }
            return "quizModal";
        }
    }
    protected string HeaderDialogTitle
    {
        get
        {
            if (dvHeader.CurrentMode == DetailsViewMode.Insert)
            {
                return "New quiz";
            }
            if (dvHeader.CurrentMode == DetailsViewMode.Edit)
            {
                return "Edit quiz";
            }
            return "View quiz";
        }
    }
    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        HideReadOnlyCommands(dvHeader);
        HideReadOnlyCommands(dvChild);
        lblHeaderFeedback.Text = lblMessage.Visible && ActiveDialog != "" ? lblMessage.Text : "";
        lblQuestionFeedback.Text = lblHeaderFeedback.Text;
        // Integration: show "Change saved" in green and errors in red (the labels were always red)
        string feedbackClass = lblMessage.CssClass.Contains("alert-success") ? "text-success d-block" : "text-danger d-block";
        lblHeaderFeedback.CssClass = feedbackClass;
        lblQuestionFeedback.CssClass = feedbackClass;
        if (ActiveDialog != "")
            ClientScript.RegisterStartupScript(GetType(), "openQuizDialog",
                "document.addEventListener('DOMContentLoaded',function(){bootstrap.Modal.getOrCreateInstance(document.getElementById('" + ActiveDialog + "')).show();});", true);
    }
    private void HideReadOnlyCommands(DetailsView view)
    {
        for (int i = 0; i < view.Fields.Count && i < view.Rows.Count; i++)
            if (view.Fields[i] is CommandField)
                view.Rows[i].Visible = view.CurrentMode != DetailsViewMode.ReadOnly;
    }
    protected void Header_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "ViewAssessment" && e.CommandName != "EditAssessment" && e.CommandName != "DeleteAssessment" && e.CommandName != "Questions")
        {
            return;
        }
        int itemIndex;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out itemIndex))
        {
            return;
        }
        // DataItemIndex includes earlier pages; the grid needs the index on this page.
        int row = itemIndex - gvQuizzes.PageIndex * gvQuizzes.PageSize;
        if (row < 0 || row >= gvQuizzes.Rows.Count)
        {
            return;
        }
        gvQuizzes.SelectedIndex = row;
        dvHeader.ChangeMode(DetailsViewMode.ReadOnly);
        dvHeader.DataBind();
        object title = Db.Scalar("SELECT Title FROM Quizzes WHERE QuizID=@ID", Db.P("@ID", gvQuizzes.SelectedValue));
        litQuizTitle.Text = Convert.ToString(title);
        litDeleteTitle.Text = Convert.ToString(title);
        pnlChildren.Visible = e.CommandName == "Questions";
        if (e.CommandName == "Questions")
        {
            gvQuestions.SelectedIndex = -1;
            gvQuestions.PageIndex = 0;
            gvQuestions.DataBind();
            BackQuestions_Click(sender, EventArgs.Empty);
        }
        else if (e.CommandName == "DeleteAssessment")
        {
            ActiveDialog = "deleteQuizModal";
        }
        else
        {
            ActiveDialog = "quizModal";
            if (e.CommandName == "EditAssessment")
            {
                dvHeader.ChangeMode(DetailsViewMode.Edit);
            }
        }
    }
    protected void ConfirmDelete_Click(object sender, EventArgs e)
    {
        if (ActiveDialog != "deleteQuizModal" || gvQuizzes.SelectedValue == null)
        {
            return;
        }
        dvHeader.DataBind();
        dvHeader.DeleteItem();
        ActiveDialog = "";
    }
    protected void Header_SelectedIndexChanged(object sender, EventArgs e)
    {
        ActiveDialog = "quizModal";
    }
    protected void Header_ModeChanging(object sender, DetailsViewModeEventArgs e)
    {
        if (e.CancelingEdit)
        {
            ActiveDialog = "";
        }
    }
    protected void Header_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvQuizzes.SelectedIndex = -1;
        ActiveDialog = "";
        pnlChildren.Visible = false;
    }
    protected void Child_SelectedIndexChanged(object sender, EventArgs e)
    {
        dvChild.ChangeMode(DetailsViewMode.ReadOnly);
        pnlQuestionList.Visible = false;
        pnlQuestionEditor.Visible = true;
        ActiveDialog = "questionsModal";
    }
    protected void Child_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvQuestions.SelectedIndex = -1;
        BackQuestions_Click(sender, EventArgs.Empty);
    }
    protected void btnNewHeader_Click(object sender, EventArgs e)
    {
        gvQuizzes.SelectedIndex = -1;
        dvHeader.ChangeMode(DetailsViewMode.Insert);
        pnlChildren.Visible = false;
        ActiveDialog = "newQuizModal";
    }
    protected void btnNewChild_Click(object sender, EventArgs e)
    {
        gvQuestions.SelectedIndex = -1;
        pnlDeleteChild.Visible = false;
        dvChild.ChangeMode(DetailsViewMode.Insert);
        pnlQuestionList.Visible = false;
        pnlQuestionEditor.Visible = true;
        ActiveDialog = "questionsModal";
    }
    protected void BackQuestions_Click(object sender, EventArgs e)
    {
        dvChild.ChangeMode(DetailsViewMode.ReadOnly);
        gvQuestions.SelectedIndex = -1;
        pnlDeleteChild.Visible = false;
        pnlQuestionList.Visible = true;
        pnlQuestionEditor.Visible = false;
        ActiveDialog = "questionsModal";
    }
    protected void Child_ModeChanging(object sender, DetailsViewModeEventArgs e)
    {
        if (e.CancelingEdit)
        {
            e.Cancel = true;
            BackQuestions_Click(sender, EventArgs.Empty);
        }
    }

    protected void Child_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName != "ViewChild" && e.CommandName != "EditChild" && e.CommandName != "DeleteChild")
        {
            return;
        }
        int index;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out index))
        {
            return;
        }
        int row = index - gvQuestions.PageIndex * gvQuestions.PageSize;
        if (row < 0 || row >= gvQuestions.Rows.Count)
        {
            return;
        }
        gvQuestions.SelectedIndex = row;
        dvChild.ChangeMode(DetailsViewMode.ReadOnly);
        dvChild.DataBind();
        pnlQuestionList.Visible = false;
        pnlDeleteChild.Visible = e.CommandName == "DeleteChild";
        pnlQuestionEditor.Visible = !pnlDeleteChild.Visible;
        if (pnlDeleteChild.Visible)
            litDeleteChild.Text = Convert.ToString(Db.Scalar("SELECT QuestionText FROM Questions WHERE QuestionID=@ID", Db.P("@ID", gvQuestions.SelectedValue)));
        if (e.CommandName == "EditChild")
        {
            dvChild.ChangeMode(DetailsViewMode.Edit);
        }
        ActiveDialog = "questionsModal";
    }
    protected void ConfirmChildDelete_Click(object sender, EventArgs e)
    {
        if (!pnlDeleteChild.Visible || gvQuestions.SelectedValue == null)
        {
            return;
        }
        dvChild.DataBind();
        dvChild.DeleteItem();
    }
    protected void Header_ItemInserting(object sender, DetailsViewInsertEventArgs e)
    {
        Page.Validate("Header");
        if (!Page.IsValid || !ValidHeader(e.Values) || Convert.ToBoolean(e.Values["IsPublished"]))
        {
            e.Cancel = true;
            ShowMessage("Check the fields and save new assessments as unpublished.", false);
        }
    }

    protected void Header_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
        Page.Validate("Header");
        if (!Page.IsValid || !ValidHeader(e.NewValues))
        {
            e.Cancel = true;
            ShowMessage("Check the assessment fields and their maximum lengths.", false);
        }
    }

    protected void Child_ItemInserting(object sender, DetailsViewInsertEventArgs e)
    {
        Page.Validate("Child");
        if (!Page.IsValid || !ValidChild(e.Values))
        {
            e.Cancel = true;
            ShowMessage("Check the content fields, allowed values and explanation.", false);
        }
    }

    protected void Child_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
        Page.Validate("Child");
        if (!Page.IsValid || !ValidChild(e.NewValues))
        {
            e.Cancel = true;
            ShowMessage("Check the content fields, allowed values and explanation.", false);
        }
    }

    private bool ValidHeader(IDictionary values)
    {
        if (Convert.ToString(values["Title"]).Trim().Length == 0)
            return false;
        if (Convert.ToString(values["Title"]).Trim().Length > 150)
            return false;
        values["Title"] = Convert.ToString(values["Title"]).Trim();
        if (Convert.ToString(values["CategoryID"]).Trim().Length == 0)
            return false;

        if (Convert.ToString(values["Description"]).Trim().Length == 0)
            return false;
        if (Convert.ToString(values["Description"]).Trim().Length > 500)
            return false;
        values["Description"] = Convert.ToString(values["Description"]).Trim();

        int category;
        // Any category that exists, including ones admins add later (integration fix: was "1 to 6 only")
        if (!int.TryParse(Convert.ToString(values["CategoryID"]), out category) || category < 1 ||
            Convert.ToInt32(Db.Scalar("SELECT COUNT(*) FROM Categories WHERE CategoryID = @CategoryID",
                Db.P("@CategoryID", category))) == 0)
            return false;
        return true;
    }

    private bool ValidChild(IDictionary values)
    {
        string questionText = Convert.ToString(values["QuestionText"]).Trim();
        if (questionText.Length > 500 || questionText.Length == 0)
            return false;
        values["QuestionText"] = questionText;
        string optionA = Convert.ToString(values["OptionA"]).Trim();
        if (optionA.Length > 200 || optionA.Length == 0)
            return false;
        values["OptionA"] = optionA;
        string optionB = Convert.ToString(values["OptionB"]).Trim();
        if (optionB.Length > 200 || optionB.Length == 0)
            return false;
        values["OptionB"] = optionB;
        string optionC = Convert.ToString(values["OptionC"]).Trim();
        if (optionC.Length > 200 || optionC.Length == 0)
            return false;
        values["OptionC"] = optionC;
        string optionD = Convert.ToString(values["OptionD"]).Trim();
        if (optionD.Length > 200 || optionD.Length == 0)
            return false;
        values["OptionD"] = optionD;
        string explanation = Convert.ToString(values["Explanation"]).Trim();
        if (explanation.Length > 500 || explanation.Length == 0)
            return false;
        values["Explanation"] = explanation;
        if (!new List<string> { "A", "B", "C", "D" }.Contains(Convert.ToString(values["CorrectOption"])))
            return false;
        return true;
    }

    protected void Details_DataBound(object sender, EventArgs e)
    {
        DetailsView view = (DetailsView)sender;
        view.HeaderText = "";
    }

    private void ShowMessage(string message, bool success)
    {
        lblMessage.Visible = true;
        lblMessage.Text = Server.HtmlEncode(message);
        lblMessage.CssClass = success ? "alert alert-success" : "alert alert-danger";
    }
    protected void Header_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            e.KeepInInsertMode = true;
            Trace.Warn("Member 3", "The database operation failed.", e.Exception);
            ShowMessage(
                "The change could not be saved. Check the input and whether the record is in use.",
                false);
            return;
        }
        if (e.AffectedRows == 0)
        {
            ShowMessage("No change was saved. Check publication requirements, unpublish before " +
                        "editing, and keep content with attempts.",
                        false);
            e.KeepInInsertMode = true;
            return;
        }
        gvQuizzes.DataBind();
        gvQuizzes.SelectedIndex = -1;
        pnlChildren.Visible = false;
        ActiveDialog = "";
        ShowMessage("Change saved. Select a row to continue.", true);
    }

    protected void Header_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            e.KeepInEditMode = true;
            Trace.Warn("Member 3", "The database operation failed.", e.Exception);
            ShowMessage(
                "The change could not be saved. Check the input and whether the record is in use.",
                false);
            return;
        }
        if (e.AffectedRows == 0)
        {
            ShowMessage("No change was saved. Check publication requirements, unpublish before " +
                        "editing, and keep content with attempts.",
                        false);
            e.KeepInEditMode = true;
            return;
        }
        gvQuizzes.DataBind();
        gvQuizzes.SelectedIndex = -1;
        pnlChildren.Visible = false;
        ActiveDialog = "";
        ShowMessage("Change saved. Select a row to continue.", true);
    }

    protected void Header_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            Trace.Warn("Member 3", "The database operation failed.", e.Exception);
            ShowMessage(
                "The change could not be saved. Check the input and whether the record is in use.",
                false);
            return;
        }
        if (e.AffectedRows == 0)
        {
            ShowMessage("No change was saved. Check publication requirements, unpublish before " +
                        "editing, and keep content with attempts.",
                        false);
            return;
        }
        gvQuizzes.DataBind();
        gvQuizzes.SelectedIndex = -1;
        pnlChildren.Visible = false;
        ActiveDialog = "";
        ShowMessage("Change saved. Select a row to continue.", true);
    }

    protected void Child_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            e.KeepInInsertMode = true;
            Trace.Warn("Member 3", "The database operation failed.", e.Exception);
            ShowMessage(
                "The change could not be saved. Check the input and whether the record is in use.",
                false);
            return;
        }
        if (e.AffectedRows == 0)
        {
            ShowMessage("No change was saved. Check publication requirements, unpublish before " +
                        "editing, and keep content with attempts.",
                        false);
            e.KeepInInsertMode = true;
            return;
        }
        gvQuestions.DataBind();
        gvQuestions.SelectedIndex = -1;
        BackQuestions_Click(sender, EventArgs.Empty);
        ShowMessage("Change saved. Select a row to continue.", true);
    }

    protected void Child_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            e.KeepInEditMode = true;
            Trace.Warn("Member 3", "The database operation failed.", e.Exception);
            ShowMessage(
                "The change could not be saved. Check the input and whether the record is in use.",
                false);
            return;
        }
        if (e.AffectedRows == 0)
        {
            ShowMessage("No change was saved. Check publication requirements, unpublish before " +
                        "editing, and keep content with attempts.",
                        false);
            e.KeepInEditMode = true;
            return;
        }
        gvQuestions.DataBind();
        gvQuestions.SelectedIndex = -1;
        BackQuestions_Click(sender, EventArgs.Empty);
        ShowMessage("Change saved. Select a row to continue.", true);
    }

    protected void Child_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
        if (e.Exception != null)
        {
            e.ExceptionHandled = true;
            Trace.Warn("Member 3", "The database operation failed.", e.Exception);
            ShowMessage(
                "The change could not be saved. Check the input and whether the record is in use.",
                false);
            return;
        }
        if (e.AffectedRows == 0)
        {
            ShowMessage("No change was saved. Check publication requirements, unpublish before " +
                        "editing, and keep content with attempts.",
                        false);
            return;
        }
        gvQuestions.DataBind();
        gvQuestions.SelectedIndex = -1;
        BackQuestions_Click(sender, EventArgs.Empty);
        ShowMessage("Change saved. Select a row to continue.", true);
    }
}
