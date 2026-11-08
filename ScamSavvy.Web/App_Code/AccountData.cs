using System;
using System.Data.SqlClient;

public static class AccountData
{
    public static int CountActiveAdmins()
    {
        return Convert.ToInt32(Db.Scalar(
            "SELECT COUNT(*) FROM Users WHERE Role = @Role AND IsActive = 1",
            Db.P("@Role", Auth.RoleAdmin)));
    }

    public static void DeleteUser(int userId)
    {
        using (SqlConnection conn = Db.Open())
        using (SqlTransaction tx = conn.BeginTransaction())
        {
            using (SqlCommand clear = new SqlCommand(
                "UPDATE ScamReports SET ReviewedBy = NULL WHERE ReviewedBy = @UserID", conn, tx))
            {
                clear.Parameters.Add(Db.P("@UserID", userId));
                clear.ExecuteNonQuery();
            }
            using (SqlCommand delete = new SqlCommand("DELETE FROM Users WHERE UserID = @UserID", conn, tx))
            {
                delete.Parameters.Add(Db.P("@UserID", userId));
                delete.ExecuteNonQuery();
            }
            tx.Commit();
        }
    }
}
