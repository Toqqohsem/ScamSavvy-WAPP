// Owner: Lyu Jiaxin (Member 4)
// Checks a pasted message in three ways:
//   1. phone numbers, account numbers and links already in an approved report (ScamText finds and normalises them);
//   2. red-flag words and phrases from RedFlagKeywords (English and Bahasa Melayu);
//   3. adds up the keyword weights for a risk level.
// The message is never stored.
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Text.RegularExpressions;

public partial class ScamChecker : System.Web.UI.Page
{
    private const string ScamExample =
        "URGENT: Akaun anda dibekukan. To avoid suspension, verify your account within 24 hours at " +
        "https://mybank-verify.example/login and enter the TAC we send you. Do not tell anyone. " +
        "Enquiries: 018-345 0501";

    private const string NormalExample =
        "Hi Aina, your parcel from our shop was delivered today. Thank you for shopping with us!";

    protected void btnExampleScam_Click(object sender, EventArgs e)
    {
        txtMessage.Text = ScamExample;
        Check(ScamExample);
    }

    protected void btnExampleNormal_Click(object sender, EventArgs e)
    {
        txtMessage.Text = NormalExample;
        Check(NormalExample);
    }

    protected void btnCheck_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        Check(txtMessage.Text);
    }

    private void Check(string message)
    {
        // 1. Identifiers already reported
        DataTable reported = FindReportedMatches(message);

        // 2. Red-flag keywords
        DataTable keywords = Db.Query("SELECT Keyword, Language, Weight, Explanation FROM RedFlagKeywords ORDER BY Weight DESC, Keyword");
        DataTable flags = keywords.Clone();
        List<Regex> flagPatterns = new List<Regex>();
        int score = 0;
        foreach (DataRow k in keywords.Rows)
        {
            Regex rx = KeywordPattern((string)k["Keyword"]);
            if (rx.IsMatch(message))
            {
                flags.ImportRow(k);
                flagPatterns.Add(rx);
                score += (int)k["Weight"];
            }
        }

        // 3. Risk level
        string level;
        if (reported.Rows.Count > 0 || score >= 6) level = "High";
        else if (score >= 3) level = "Medium";
        else level = "Low";

        lblRisk.Text = level;
        lblRisk.CssClass = "site-badge checker-risk site-risk-" + level.ToLowerInvariant();
        if (reported.Rows.Count > 0)
        {
            litVerdict.Text = "This message contains details that other people have already reported as a scam. Do not reply, click or pay.";
        }
        else if (level == "High")
        {
            litVerdict.Text = "This message has several strong signs of a scam. Do not reply, click links or share any code.";
        }
        else if (level == "Medium")
        {
            litVerdict.Text = "Some warning signs. Contact the organisation through its official number or app before doing anything.";
        }
        else
        {
            litVerdict.Text = "We found few or no warning signs, but scammers change their wording all the time.";
        }

        litHighlighted.Text = Highlight(message, flagPatterns, ReportedTexts(reported));

        rptReported.DataSource = reported;
        rptReported.DataBind();
        phReported.Visible = reported.Rows.Count > 0;

        rptFlags.DataSource = flags;
        rptFlags.DataBind();
        phFlags.Visible = flags.Rows.Count > 0;

        pnlEmpty.Visible = false;
        pnlResult.Visible = true;
    }

    // Whole-word, case-insensitive match, so "TAC" does not match "contact".
    private static Regex KeywordPattern(string keyword)
    {
        return new Regex(@"(?<![\p{L}\p{N}])" + Regex.Escape(keyword) + @"(?![\p{L}\p{N}])", RegexOptions.IgnoreCase);
    }

    /// <summary>Approved reports whose phone, account or link (same domain) appears in the message.</summary>
    private static DataTable FindReportedMatches(string message)
    {
        List<string> phones = ScamText.FindPhones(message);
        List<string> accounts = ScamText.FindAccounts(message);
        List<string> domains = new List<string>();
        foreach (string u in ScamText.FindUrls(message))
        {
            string d = ScamText.Domain(u);
            if (!domains.Contains(d)) domains.Add(d);
        }

        DataTable result = new DataTable();
        result.Columns.Add("ReportID", typeof(int));
        result.Columns.Add("Title", typeof(string));
        result.Columns.Add("Found", typeof(string));
        result.Columns.Add("Raw", typeof(string));
        if (phones.Count + accounts.Count + domains.Count == 0) return result;

        // Parameterised IN lists: one @p per value, never the values themselves in the SQL text.
        List<SqlParameter> ps = new List<SqlParameter>();
        string sql =
            "SELECT ReportID, Title, ScammerPhone, ScammerAccount, ScammerUrl FROM ScamReports " +
            "WHERE Status = 'Approved' AND (" +
            "ScammerPhone IN (" + Placeholders("ph", phones, ps) + ") OR " +
            "ScammerAccount IN (" + Placeholders("ac", accounts, ps) + ") OR " +
            "LEFT(ScammerUrl, CHARINDEX('/', ScammerUrl + '/') - 1) IN (" + Placeholders("dm", domains, ps) + ")) " +
            "ORDER BY CreatedAt DESC";
        DataTable rows = Db.Query(sql, ps.ToArray());

        foreach (DataRow r in rows.Rows)
        {
            string phone = Convert.ToString(r["ScammerPhone"]);
            string account = Convert.ToString(r["ScammerAccount"]);
            string domain = ScamText.Domain(Convert.ToString(r["ScammerUrl"]));
            if (phone.Length > 0 && phones.Contains(phone))
                result.Rows.Add(r["ReportID"], r["Title"], "Phone number " + ScamText.FormatPhone(phone), phone);
            if (account.Length > 0 && accounts.Contains(account))
                result.Rows.Add(r["ReportID"], r["Title"], "Bank account " + account, account);
            if (domain.Length > 0 && domains.Contains(domain))
                result.Rows.Add(r["ReportID"], r["Title"], "Website " + domain, domain);
        }
        return result;
    }

    private static string Placeholders(string prefix, List<string> values, List<SqlParameter> ps)
    {
        if (values.Count == 0) return "NULL";   // "x IN (NULL)" matches nothing
        StringBuilder names = new StringBuilder();
        for (int i = 0; i < values.Count; i++)
        {
            string name = "@" + prefix + i;
            if (i > 0) names.Append(", ");
            names.Append(name);
            ps.Add(Db.P(name, values[i]));
        }
        return names.ToString();
    }

    private static List<string> ReportedTexts(DataTable reported)
    {
        List<string> list = new List<string>();
        foreach (DataRow r in reported.Rows) list.Add((string)r["Raw"]);
        return list;
    }

    /// <summary>
    /// HTML-encodes the message and wraps keyword matches in &lt;mark&gt;. Matches are found on the
    /// original text and every piece is encoded separately, so nothing the user typed is ever output raw.
    /// Phone numbers, accounts and links that were already reported get a red mark.
    /// </summary>
    private string Highlight(string message, List<Regex> flagPatterns, List<string> reportedValues)
    {
        bool[] flagged = new bool[message.Length];
        bool[] reported = new bool[message.Length];
        foreach (Regex rx in flagPatterns)
        {
            foreach (Match m in rx.Matches(message)) Mark(flagged, m.Index, m.Length);
        }
        if (reportedValues.Count > 0)
        {
            foreach (Match m in new Regex(@"(?:\+?\d[\d\s-]{8,}\d)|(?:https?://|www\.)?[a-z0-9-]+(?:\.[a-z0-9-]+)+(?:/\S*)?", RegexOptions.IgnoreCase).Matches(message))
            {
                string digits = ScamText.NormaliseAccount(m.Value);
                string asPhone = ScamText.NormalisePhone(m.Value);
                string domain = ScamText.Domain(ScamText.NormaliseUrl(m.Value));
                if (reportedValues.Contains(digits) || reportedValues.Contains(asPhone) || reportedValues.Contains(domain))
                {
                    Mark(reported, m.Index, m.Length);
                }
            }
        }

        StringBuilder html = new StringBuilder();
        int i = 0;
        while (i < message.Length)
        {
            string kind = reported[i] ? "reported" : (flagged[i] ? "flag" : "");
            int j = i;
            while (j < message.Length && (reported[j] ? "reported" : (flagged[j] ? "flag" : "")) == kind) j++;
            string piece = Server.HtmlEncode(message.Substring(i, j - i));
            if (kind == "reported") html.Append("<mark class=\"checker-reported\">").Append(piece).Append("</mark>");
            else if (kind == "flag") html.Append("<mark>").Append(piece).Append("</mark>");
            else html.Append(piece);
            i = j;
        }
        return html.ToString();
    }

    private static void Mark(bool[] map, int start, int length)
    {
        for (int k = start; k < start + length && k < map.Length; k++) map[k] = true;
    }
}
