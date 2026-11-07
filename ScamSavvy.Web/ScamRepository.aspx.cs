// Owner: Lyu Jiaxin (Member 4)
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class ScamRepository : System.Web.UI.Page
{
    private const int PageSize = 10;

    // Filters last applied, kept across postbacks so paging uses the same search.
    private int PageIndex
    {
        get { return ViewState["PageIndex"] == null ? 0 : (int)ViewState["PageIndex"]; }
        set { ViewState["PageIndex"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;

        DataTable cats = Db.Query("SELECT CategoryID, Name FROM Categories ORDER BY SortOrder, Name");
        ddlCategory.DataSource = cats;
        ddlCategory.DataTextField = "Name";
        ddlCategory.DataValueField = "CategoryID";
        ddlCategory.DataBind();
        ddlCategory.Items.Insert(0, new ListItem("All types", "0"));

        // ?category= from a lesson page preselects the filter
        int categoryId = LessonHelpers.QueryInt(Request, "category");
        if (ddlCategory.Items.FindByValue(categoryId.ToString()) != null)
        {
            ddlCategory.SelectedValue = categoryId.ToString();
        }
        BindCases();
    }

    protected void Filter_Changed(object sender, EventArgs e)
    {
        PageIndex = 0;
        BindCases();
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        ddlCategory.SelectedIndex = 0;
        PageIndex = 0;
        BindCases();
    }

    protected void btnPrev_Click(object sender, EventArgs e)
    {
        PageIndex = Math.Max(0, PageIndex - 1);
        BindCases();
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        PageIndex = PageIndex + 1;
        BindCases();
    }

    private void BindCases()
    {
        string search = txtSearch.Text.Trim();
        if (search.Length > 100) search = search.Substring(0, 100);

        List<SqlParameter> ps = new List<SqlParameter>();
        string where = "r.Status = 'Approved' AND (@CategoryID = 0 OR r.CategoryID = @CategoryID)";
        ps.Add(Db.P("@CategoryID", int.Parse(ddlCategory.SelectedValue)));

        if (search.Length > 0)
        {
            // A phone number, account or link is matched exactly after normalising; anything else searches the text.
            List<string> phones = ScamText.FindPhones(search);
            List<string> accounts = ScamText.FindAccounts(search);
            List<string> urls = ScamText.FindUrls(search);
            if (phones.Count > 0)
            {
                where += " AND r.ScammerPhone = @Phone";
                ps.Add(Db.P("@Phone", phones[0]));
            }
            else if (accounts.Count > 0)
            {
                where += " AND r.ScammerAccount = @Account";
                ps.Add(Db.P("@Account", accounts[0]));
            }
            else if (urls.Count > 0)
            {
                where += " AND LEFT(r.ScammerUrl, CHARINDEX('/', r.ScammerUrl + '/') - 1) = @Domain";
                ps.Add(Db.P("@Domain", ScamText.Domain(urls[0])));
            }
            else
            {
                where += " AND (r.Title LIKE @Like OR r.Description LIKE @Like)";
                ps.Add(Db.P("@Like", "%" + LessonHelpers.EscapeLike(search) + "%"));
            }
        }

        int total = Convert.ToInt32(Db.Scalar("SELECT COUNT(*) FROM ScamReports r WHERE " + where, Clone(ps).ToArray()));
        int pages = Math.Max(1, (total + PageSize - 1) / PageSize);
        if (PageIndex >= pages) PageIndex = pages - 1;

        List<SqlParameter> pagePs = Clone(ps);
        pagePs.Add(Db.P("@Skip", PageIndex * PageSize));
        pagePs.Add(Db.P("@Take", PageSize));
        DataTable rows = Db.Query(
            "SELECT r.ReportID, r.Title, r.Description, r.ScammerPhone, r.ScammerAccount, r.ScammerUrl, " +
            "       r.IsSample, r.CreatedAt, c.Name AS CategoryName " +
            "FROM ScamReports r JOIN Categories c ON c.CategoryID = r.CategoryID " +
            "WHERE " + where + " ORDER BY r.CreatedAt DESC, r.ReportID DESC " +
            "OFFSET @Skip ROWS FETCH NEXT @Take ROWS ONLY",
            pagePs.ToArray());

        rptCases.DataSource = rows;
        rptCases.DataBind();
        pnlEmpty.Visible = total == 0;
        litCount.Text = total == 1 ? "1 reported scam" : total + " reported scams";
        pnlPager.Visible = pages > 1;
        litPage.Text = "Page " + (PageIndex + 1) + " of " + pages;
        btnPrev.Enabled = PageIndex > 0;
        btnNext.Enabled = PageIndex < pages - 1;
    }

    // A SqlParameter can belong to one command only, so each query gets its own copies.
    private static List<SqlParameter> Clone(List<SqlParameter> source)
    {
        List<SqlParameter> copy = new List<SqlParameter>();
        foreach (SqlParameter p in source) copy.Add(Db.P(p.ParameterName, p.Value));
        return copy;
    }

    protected string Identifiers(object phone, object account, object url)
    {
        List<string> parts = new List<string>();
        if (phone != DBNull.Value) parts.Add("Phone " + ScamText.FormatPhone(phone));
        if (account != DBNull.Value) parts.Add("Account " + Convert.ToString(account));
        if (url != DBNull.Value) parts.Add("Website " + Convert.ToString(url));
        return Server.HtmlEncode(string.Join(" · ", parts.ToArray()));
    }
}
