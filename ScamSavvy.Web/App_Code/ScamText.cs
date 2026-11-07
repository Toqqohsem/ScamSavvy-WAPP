// Owner: Lyu Jiaxin (Member 4: scam repository, reporting and Scam Checker).
// Every phone number, account number and link is normalised here before it is saved and
// before it is searched, so a report and a pasted message always compare the same way.
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

public static class ScamText
{
    // Malaysian mobile numbers: 01X-XXX XXXX or 011-XXXX XXXX, optionally +60 / 60 (with or without a space) instead of 0.
    private static readonly Regex PhonePattern = new Regex(
        @"(?<![\d+])(?:\+?60[\s-]?|0)1\d[\s-]?\d{3,4}[\s-]?\d{4}(?!\d)", RegexOptions.Compiled);

    // Bank account numbers: 10 to 16 digits, possibly written in groups with spaces or dashes.
    private static readonly Regex AccountPattern = new Regex(
        @"(?<!\d)\d(?:[\s-]?\d){9,15}(?!\d)", RegexOptions.Compiled);

    // Links with a scheme or www., and bare domains on common scam TLDs (".example" is used by our sample data).
    private static readonly Regex UrlPattern = new Regex(
        @"\b(?:https?://|www\.)[^\s<>""']+" +
        @"|\b[a-z0-9-]+(?:\.[a-z0-9-]+)*\.(?:com|my|net|org|xyz|top|info|online|site|link|click|shop|app|cc|co|io|biz|live|example)(?:/[^\s<>""']*)?",
        RegexOptions.IgnoreCase | RegexOptions.Compiled);

    /// <summary>"+60 12-345 6789", "012-3456789" and "60123456789" all become "60123456789".</summary>
    public static string NormalisePhone(string s)
    {
        string digits = DigitsOnly(s);
        if (digits.StartsWith("0")) return "6" + digits;
        return digits;
    }

    /// <summary>Digits only.</summary>
    public static string NormaliseAccount(string s)
    {
        return DigitsOnly(s);
    }

    /// <summary>Lower case, without http(s)://, www. or a trailing slash: "https://www.Pay-Now.example/" becomes "pay-now.example".</summary>
    public static string NormaliseUrl(string s)
    {
        string u = (s ?? "").Trim().ToLowerInvariant();
        if (u.StartsWith("https://")) u = u.Substring(8);
        else if (u.StartsWith("http://")) u = u.Substring(7);
        if (u.StartsWith("www.")) u = u.Substring(4);
        u = u.TrimEnd('/', '.', ',', ')', ';');
        return u;
    }

    /// <summary>The domain part of a normalised link: "pay-now.example/login" becomes "pay-now.example".</summary>
    public static string Domain(string normalisedUrl)
    {
        string u = normalisedUrl ?? "";
        int cut = u.IndexOfAny(new[] { '/', '?', '#' });
        return cut < 0 ? u : u.Substring(0, cut);
    }

    public static List<string> FindPhones(string text)
    {
        List<string> found = new List<string>();
        foreach (Match m in PhonePattern.Matches(text ?? ""))
        {
            AddOnce(found, NormalisePhone(m.Value));
        }
        return found;
    }

    /// <summary>Account numbers, ignoring anything that is a phone number.</summary>
    public static List<string> FindAccounts(string text)
    {
        string withoutPhones = PhonePattern.Replace(text ?? "", " ");
        List<string> found = new List<string>();
        foreach (Match m in AccountPattern.Matches(withoutPhones))
        {
            string digits = NormaliseAccount(m.Value);
            if (digits.Length >= 10 && digits.Length <= 16) AddOnce(found, digits);
        }
        return found;
    }

    public static List<string> FindUrls(string text)
    {
        List<string> found = new List<string>();
        foreach (Match m in UrlPattern.Matches(text ?? ""))
        {
            string u = NormaliseUrl(m.Value);
            if (u.Length > 0 && u.Length <= 300) AddOnce(found, u);
        }
        return found;
    }

    /// <summary>Shows a stored phone number the way Malaysians write it: "60123456789" becomes "012-345 6789".</summary>
    public static string FormatPhone(object stored)
    {
        string d = Convert.ToString(stored);
        if (d.StartsWith("60")) d = d.Substring(1);
        if (d.Length == 10) return d.Substring(0, 3) + "-" + d.Substring(3, 3) + " " + d.Substring(6);
        if (d.Length == 11) return d.Substring(0, 3) + "-" + d.Substring(3, 4) + " " + d.Substring(7);
        return d;
    }

    private static string DigitsOnly(string s)
    {
        StringBuilder b = new StringBuilder();
        foreach (char c in s ?? "")
        {
            if (c >= '0' && c <= '9') b.Append(c);
        }
        return b.ToString();
    }

    private static void AddOnce(List<string> list, string value)
    {
        if (value.Length > 0 && !list.Contains(value)) list.Add(value);
    }
}
