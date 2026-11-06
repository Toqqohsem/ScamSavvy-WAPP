// Owner: Ahmad. Shared by every page; do not copy or change.
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Database access for Scam Savvy. Every query goes through the "ScamSavvyDB" connection string,
/// and every value goes in as a parameter (never joined into the SQL text).
/// </summary>
public static class Db
{
    public static string ConnectionString
    {
        get { return ConfigurationManager.ConnectionStrings["ScamSavvyDB"].ConnectionString; }
    }

    /// <summary>Returns an opened connection. Always wrap it in using { }.</summary>
    public static SqlConnection Open()
    {
        SqlConnection conn = new SqlConnection(ConnectionString);
        conn.Open();
        return conn;
    }

    /// <summary>Builds a parameter; null becomes DBNull.</summary>
    public static SqlParameter P(string name, object value)
    {
        return new SqlParameter(name, value ?? DBNull.Value);
    }

    /// <summary>Runs a SELECT and returns the rows.</summary>
    public static DataTable Query(string sql, params SqlParameter[] parameters)
    {
        using (SqlConnection conn = Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            AddParameters(cmd, parameters);
            DataTable table = new DataTable();
            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                adapter.Fill(table);
            }
            return table;
        }
    }

    /// <summary>Runs a query and returns the first column of the first row (or null).</summary>
    public static object Scalar(string sql, params SqlParameter[] parameters)
    {
        using (SqlConnection conn = Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            AddParameters(cmd, parameters);
            object result = cmd.ExecuteScalar();
            return result == DBNull.Value ? null : result;
        }
    }

    /// <summary>Runs an INSERT, UPDATE or DELETE and returns the number of rows affected.</summary>
    public static int Execute(string sql, params SqlParameter[] parameters)
    {
        using (SqlConnection conn = Open())
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            AddParameters(cmd, parameters);
            return cmd.ExecuteNonQuery();
        }
    }

    private static void AddParameters(SqlCommand cmd, SqlParameter[] parameters)
    {
        if (parameters == null) return;
        foreach (SqlParameter p in parameters)
        {
            cmd.Parameters.Add(p);
        }
    }
}
