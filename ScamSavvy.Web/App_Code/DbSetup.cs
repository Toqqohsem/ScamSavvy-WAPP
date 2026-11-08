using System;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

public static class DbSetup
{
    private static readonly object Gate = new object();
    private static bool done;

    public static void EnsureDatabase()
    {
        if (done) return;
        string appPath = HttpRuntime.AppDomainAppPath;
        string dataDir = AppDomain.CurrentDomain.GetData("DataDirectory") as string;
        if (string.IsNullOrEmpty(dataDir)) dataDir = Path.Combine(appPath, "App_Data");
        EnsureDatabase(Db.ConnectionString, dataDir, appPath);
    }

    public static void EnsureDatabase(string connectionString, string dataDir, string appPath)
    {
        if (done) return;
        lock (Gate)
        {
            if (done) return;
            SqlConnectionStringBuilder cfg = new SqlConnectionStringBuilder(connectionString);
            if (string.IsNullOrEmpty(cfg.AttachDBFilename)) { done = true; return; }   // a server database: nothing to build

            string mdf = Path.GetFullPath(cfg.AttachDBFilename.Replace("|DataDirectory|", dataDir.TrimEnd('\\', '/') + Path.DirectorySeparatorChar)
                                                               .Replace(Path.DirectorySeparatorChar == '/' ? '\\' : '/', Path.DirectorySeparatorChar));
            if (File.Exists(mdf)) { done = true; return; }

            string scripts = FindScripts(appPath);
            if (scripts == null)
                throw new InvalidOperationException("App_Data\\ScamSavvy.mdf is missing and the Database scripts (01 to 08) were not found. See README.md.");

            Directory.CreateDirectory(Path.GetDirectoryName(mdf));
            string ldf = Path.Combine(Path.GetDirectoryName(mdf), Path.GetFileNameWithoutExtension(mdf) + "_log.ldf");
            string name = "ScamSavvySetup_" + Guid.NewGuid().ToString("N");

            SqlConnectionStringBuilder master = new SqlConnectionStringBuilder();
            master.DataSource = cfg.DataSource;
            master.IntegratedSecurity = cfg.IntegratedSecurity;
            if (!cfg.IntegratedSecurity) { master.UserID = cfg.UserID; master.Password = cfg.Password; }
            master.InitialCatalog = "master";
            master.ConnectTimeout = 90;
            master.Pooling = false;

            Execute(master.ConnectionString, "CREATE DATABASE [" + name + "] ON (NAME = N'ScamSavvy', FILENAME = N'" + mdf.Replace("'", "''") +
                    "') LOG ON (NAME = N'ScamSavvy_log', FILENAME = N'" + ldf.Replace("'", "''") + "')");
            try
            {
                SqlConnectionStringBuilder db = new SqlConnectionStringBuilder(master.ConnectionString);
                db.InitialCatalog = name;
                using (SqlConnection conn = new SqlConnection(db.ConnectionString))
                {
                    conn.Open();
                    string[] files = Directory.GetFiles(scripts, "0*.sql");
                    Array.Sort(files, StringComparer.OrdinalIgnoreCase);
                    foreach (string file in files)
                        RunScript(conn, File.ReadAllText(file, Encoding.UTF8));
                }
                Detach(master.ConnectionString, name);
            }
            catch
            {
                try { Detach(master.ConnectionString, name); } catch { }
                try { File.Delete(mdf); File.Delete(ldf); } catch { }
                throw;
            }
            done = true;
        }
    }

    private static string FindScripts(string appPath)
    {
        string[] candidates = {
            Path.Combine(Path.Combine(appPath, "App_Data"), "Setup"),
            Path.GetFullPath(Path.Combine(appPath, Path.Combine("..", "Database")))
        };
        foreach (string dir in candidates)
            if (File.Exists(Path.Combine(dir, "01_Schema.sql"))) return dir;
        return null;
    }

    private static void RunScript(SqlConnection conn, string script)
    {
        foreach (string batch in Regex.Split(script, @"^\s*GO\s*;?\s*$", RegexOptions.Multiline | RegexOptions.IgnoreCase))
        {
            if (batch.Trim().Length == 0) continue;
            using (SqlCommand cmd = new SqlCommand(batch, conn))
            {
                cmd.CommandTimeout = 300;
                cmd.ExecuteNonQuery();
            }
        }
    }

    private static void Detach(string masterConnection, string name)
    {
        SqlConnection.ClearAllPools();
        Execute(masterConnection, "IF DB_ID(N'" + name + "') IS NOT NULL BEGIN ALTER DATABASE [" + name +
                "] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; EXEC sp_detach_db N'" + name + "'; END");
    }

    private static void Execute(string connection, string sql)
    {
        using (SqlConnection conn = new SqlConnection(connection))
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.CommandTimeout = 300;
            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }
}
