using System;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;

public static class LessonHelpers
{
    public const string LessonUploadFolder = "~/Uploads/Lessons/";
    public const string PlaceholderImage = "~/Images/lesson-placeholder.png";
    public const int MaxImageBytes = 2 * 1024 * 1024; // 2 MB

    public static readonly Regex YouTubeEmbed =
        new Regex(@"^https://www\.youtube\.com/embed/[\w-]+$", RegexOptions.Compiled);

    private static readonly CultureInfo English = CultureInfo.GetCultureInfo("en-GB");

    public static string FormatDate(object value)
    {
        if (value == null || value == DBNull.Value)
        {
            return "";
        }
        return ((DateTime)value).ToString("dd MMM yyyy", English);
    }

    public static string ImageUrl(object path)
    {
        string p = path as string;
        if (string.IsNullOrWhiteSpace(p) || !p.StartsWith("~/"))
        {
            p = PlaceholderImage;
        }
        return VirtualPathUtility.ToAbsolute(p);
    }

    public static int QueryInt(HttpRequest request, string name)
    {
        int value;
        if (int.TryParse(request.QueryString[name], out value) && value > 0)
        {
            return value;
        }
        return 0;
    }

    public static string EscapeLike(string text)
    {
        return text.Replace("[", "[[]").Replace("%", "[%]").Replace("_", "[_]");
    }

    public static string[] SplitKeyPoints(object text)
    {
        string s = text as string ?? "";
        return s.Split(new[] { "\r\n", "\n" }, StringSplitOptions.RemoveEmptyEntries);
    }

    public static bool IsWebUrl(string url)
    {
        Uri uri;
        return Uri.TryCreate(url, UriKind.Absolute, out uri)
            && (uri.Scheme == Uri.UriSchemeHttp || uri.Scheme == Uri.UriSchemeHttps);
    }

    public static string DetectImageExtension(Stream stream)
    {
        byte[] head = new byte[8];
        int read = stream.Read(head, 0, head.Length);
        stream.Position = 0;

        if (read >= 3 && head[0] == 0xFF && head[1] == 0xD8 && head[2] == 0xFF)
        {
            return ".jpg";
        }
        if (read >= 8 && head[0] == 0x89 && head[1] == 0x50 && head[2] == 0x4E && head[3] == 0x47
            && head[4] == 0x0D && head[5] == 0x0A && head[6] == 0x1A && head[7] == 0x0A)
        {
            return ".png";
        }
        return null;
    }

    public static void DeleteLessonImage(HttpServerUtility server, string imagePath)
    {
        if (string.IsNullOrWhiteSpace(imagePath)
            || !imagePath.StartsWith(LessonUploadFolder, StringComparison.OrdinalIgnoreCase))
        {
            return;
        }
        string file = server.MapPath(imagePath);
        if (File.Exists(file))
        {
            File.Delete(file);
        }
    }

    public static string CategoryIcon(object categoryId)
    {
        int id = Convert.ToInt32(categoryId);
        string path;
        switch (id)
        {
            case 1: // phone
                path = "<rect x='7' y='2' width='10' height='20' rx='2'/><line x1='11' y1='18' x2='13' y2='18'/>";
                break;
            case 2: // shopping cart
                path = "<circle cx='9' cy='20' r='1.5'/><circle cx='18' cy='20' r='1.5'/><path d='M2 3h3l2.7 12.4a2 2 0 0 0 2 1.6h7.6a2 2 0 0 0 2-1.5L21 8H6'/>";
                break;
            case 3: // rising chart
                path = "<polyline points='3 17 9 11 13 15 21 7'/><polyline points='15 7 21 7 21 13'/>";
                break;
            case 4: // banknote
                path = "<rect x='2' y='6' width='20' height='12' rx='2'/><circle cx='12' cy='12' r='2.5'/>";
                break;
            case 5: // card / lock
                path = "<rect x='4' y='10' width='16' height='11' rx='2'/><path d='M8 10V7a4 4 0 0 1 8 0v3'/>";
                break;
            case 6: // heart
                path = "<path d='M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.7l-1-1.1a5.5 5.5 0 0 0-7.8 7.8L12 21l8.8-8.6a5.5 5.5 0 0 0 0-7.8z'/>";
                break;
            default: // shield
                path = "<path d='M12 2l8 3v6c0 5-3.4 9.3-8 11-4.6-1.7-8-6-8-11V5z'/>";
                break;
        }
        return "<svg viewBox='0 0 24 24' width='28' height='28' fill='none' stroke='currentColor' stroke-width='2' "
             + "stroke-linecap='round' stroke-linejoin='round' aria-hidden='true'>" + path + "</svg>";
    }
}
