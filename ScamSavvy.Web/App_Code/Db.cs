// Owner: Ahmad. Shared by every page; do not copy or change.
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public static class Db
{
    public static string ConnectionString
    {
        get { return ConfigurationManager.ConnectionStrings["ScamSavvyDB"].ConnectionString; }
    }

    public static SqlConnection Open()
    {
        SqlConnection conn = new SqlConnection(ConnectionString);
        conn.Open();
        return conn;
    }

    public static SqlParameter P(string name, object value)
    {
        return new SqlParameter(name, value ?? DBNull.Value);
    }

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
