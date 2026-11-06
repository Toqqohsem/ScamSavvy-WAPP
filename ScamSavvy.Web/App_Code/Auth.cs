// Owner: Ahmad. Shared by every page; do not copy or change.
using System;
using System.Data;
using System.Security.Cryptography;
using System.Web;
using System.Web.SessionState;

/// <summary>
/// Login state, roles and password hashing. Pages never read Session[...] directly; they call Auth.
/// </summary>
public static class Auth
{
    public const string RoleMember = "Member";
    public const string RoleContributor = "Contributor";
    public const string RoleAdmin = "Admin";

    /// <summary>Failed logins in a row before the account is locked.</summary>
    public const int MaxFailedLogins = 5;

    /// <summary>How long a lock lasts. An admin can unlock early from Manage Users.</summary>
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

    /// <summary>0 when logged out.</summary>
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

    /// <summary>"" when logged out.</summary>
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

        // Drop the session cookie too, so the next login in this browser gets a new session ID.
        HttpCookie expired = new HttpCookie("ASP.NET_SessionId", "");
        expired.Expires = DateTime.Now.AddDays(-1);
        HttpContext.Current.Response.Cookies.Add(expired);
    }

    /// <summary>
    /// Re-reads the logged-in user's role and status from the database, so a role change or
    /// deactivation by an admin takes effect on the user's next page. Returns false (and signs
    /// out) when the account no longer exists or has been deactivated.
    /// </summary>
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

    /// <summary>16 random bytes, Base64.</summary>
    public static string NewSalt()
    {
        byte[] salt = new byte[SaltBytes];
        using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(salt);
        }
        return Convert.ToBase64String(salt);
    }

    /// <summary>PBKDF2 with SHA-256, 100,000 rounds, 32-byte result, Base64.</summary>
    public static string HashPassword(string password, string salt)
    {
        using (Rfc2898DeriveBytes kdf = new Rfc2898DeriveBytes(
            password, Convert.FromBase64String(salt), Iterations, HashAlgorithmName.SHA256))
        {
            return Convert.ToBase64String(kdf.GetBytes(HashBytes));
        }
    }

    /// <summary>Checks a password against a stored salt and hash in constant time.</summary>
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

    /// <summary>True for a path on this site ("/Member/TakeQuiz.aspx?id=2"), false for other sites.</summary>
    public static bool IsLocalUrl(string url)
    {
        if (string.IsNullOrEmpty(url)) return false;
        if (url[0] != '/') return false;
        if (url.Length > 1 && (url[1] == '/' || url[1] == '\\')) return false;
        return true;
    }

    /// <summary>Where a user lands after logging in when there is no returnUrl.</summary>
    public static string HomeFor(string role)
    {
        return role == RoleAdmin ? "~/Admin/Dashboard.aspx" : "~/Default.aspx";
    }
}
