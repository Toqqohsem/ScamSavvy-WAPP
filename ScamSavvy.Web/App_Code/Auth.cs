// Owner: Ahmad. Shared by every page; do not copy or change.
using System;
using System.Data;
using System.Security.Cryptography;
using System.Web;
using System.Web.SessionState;

public static class Auth
{
    public const string RoleMember = "Member";
    public const string RoleContributor = "Contributor";
    public const string RoleAdmin = "Admin";

    public const int MaxFailedLogins = 5;

    public const int LockoutMinutes = 15;

    private const string KeyUserId = "UserID";
    private const string KeyUserName = "UserName";
    private const string KeyRole = "Role";

    private const int SaltBytes = 16;
    private const int HashBytes = 32;
    private const int Iterations = 100000;

    private static HttpSessionState Session
    {
        get { return HttpContext.Current == null ? null : HttpContext.Current.Session; }
    }

    private static object Read(string key)
    {
        HttpSessionState s = Session;
        return s == null ? null : s[key];
    }

    public static bool IsLoggedIn
    {
        get { return CurrentUserId > 0; }
    }

    public static int CurrentUserId
    {
        get
        {
            object v = Read(KeyUserId);
            return v == null ? 0 : (int)v;
        }
    }

    public static string CurrentUserName
    {
        get { return (Read(KeyUserName) as string) ?? ""; }
    }

    public static string CurrentRole
    {
        get { return (Read(KeyRole) as string) ?? ""; }
    }

    public static bool IsAdmin
    {
        get { return CurrentRole == RoleAdmin; }
    }

    public static void SignIn(int userId, string name, string role)
    {
        HttpSessionState s = Session;
        s.Clear();
        s[KeyUserId] = userId;
        s[KeyUserName] = name;
        s[KeyRole] = role;
    }

    public static void SignOut()
    {
        HttpSessionState s = Session;
        if (s == null) return;
        s.Clear();
        s.Abandon();

        HttpCookie expired = new HttpCookie("ASP.NET_SessionId", "");
        expired.Expires = DateTime.Now.AddDays(-1);
        HttpContext.Current.Response.Cookies.Add(expired);
    }

    public static bool RefreshFromDatabase()
    {
        if (!IsLoggedIn) return false;
        DataTable t = Db.Query("SELECT Name, Role, IsActive FROM Users WHERE UserID = @UserID",
            Db.P("@UserID", CurrentUserId));
        if (t.Rows.Count == 0 || !(bool)t.Rows[0]["IsActive"])
        {
            SignOut();
            return false;
        }
        HttpSessionState s = Session;
        s[KeyUserName] = (string)t.Rows[0]["Name"];
        s[KeyRole] = (string)t.Rows[0]["Role"];
        return true;
    }

    public static string NewSalt()
    {
        byte[] salt = new byte[SaltBytes];
        using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(salt);
        }
        return Convert.ToBase64String(salt);
    }

    public static string HashPassword(string password, string salt)
    {
        using (Rfc2898DeriveBytes kdf = new Rfc2898DeriveBytes(
            password, Convert.FromBase64String(salt), Iterations, HashAlgorithmName.SHA256))
        {
            return Convert.ToBase64String(kdf.GetBytes(HashBytes));
        }
    }

    public static bool VerifyPassword(string password, string salt, string expectedHash)
    {
        byte[] actual = Convert.FromBase64String(HashPassword(password, salt));
        byte[] expected = Convert.FromBase64String(expectedHash);
        if (actual.Length != expected.Length) return false;
        int diff = 0;
        for (int i = 0; i < actual.Length; i++)
        {
            diff |= actual[i] ^ expected[i];
        }
        return diff == 0;
    }

    public static bool IsOwnerOrAdmin(int recordUserId)
    {
        return IsLoggedIn && (recordUserId == CurrentUserId || IsAdmin);
    }

    public static bool IsLocalUrl(string url)
    {
        if (string.IsNullOrEmpty(url)) return false;
        if (url[0] != '/') return false;
        if (url.Length > 1 && (url[1] == '/' || url[1] == '\\')) return false;
        return true;
    }

    public static string HomeFor(string role)
    {
        return role == RoleAdmin ? "~/Admin/Dashboard.aspx" : "~/Default.aspx";
    }
}
