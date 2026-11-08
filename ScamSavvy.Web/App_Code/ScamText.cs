using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

public static class ScamText
{
    private static readonly Regex PhonePattern = new Regex(
        @"(?<![\d+])(?:\+?60[\s-]?|0)1\d[\s-]?\d{3,4}[\s-]?\d{4}(?!\d)", RegexOptions.Compiled);

    private static readonly Regex AccountPattern = new Regex(
        @"(?<!\d)\d(?:[\s-]?\d){9,15}(?!\d)", RegexOptions.Compiled);

    private static readonly Regex UrlPattern = new Regex(
        @"\b(?:https?://|www\.)[^\s<>""']+" +
        @"|\b[a-z0-9-]+(?:\.[a-z0-9-]+)*\.(?:com|my|net|org|xyz|top|info|online|site|link|click|shop|app|cc|co|io|biz|live|example)(?:/[^\s<>""']*)?",
        RegexOptions.IgnoreCase | RegexOptions.Compiled);

    public static string NormalisePhone(string s)
    {
        string digits = DigitsOnly(s);
        if (digits.StartsWith("0")) return "6" + digits;
        return digits;
    }

    public static string NormaliseAccount(string s)
    {
        return DigitsOnly(s);
    }

    public static string NormaliseUrl(string s)
    {
        string u = (s ?? "").Trim().ToLowerInvariant();
        if (u.StartsWith("https://")) u = u.Substring(8);
        else if (u.StartsWith("http://")) u = u.Substring(7);
        if (u.StartsWith("www.")) u = u.Substring(4);
        u = u.TrimEnd('/', '.', ',', ')', ';');
        return u;
    }

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
