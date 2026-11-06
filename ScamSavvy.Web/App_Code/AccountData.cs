// Owner: Ahmad (Accounts module). Used by Member/MyProfile.aspx and Admin/ManageUsers.aspx.
using System;
using System.Data.SqlClient;

public static class AccountData
{
    /// <summary>Active accounts with the Admin role.</summary>
    public static int CountActiveAdmins()
    {
        return Convert.ToInt32(Db.Scalar(
            "SELECT COUNT(*) FROM Users WHERE Role = @Role AND IsActive = 1",
            Db.P("@Role", Auth.RoleAdmin)));
    }

    /// <summary>
    /// Deletes a user in one transaction. Their lesson progress, quiz and Spot the Scam attempts
    /// cascade; their scam reports stay on the site with UserID set to NULL. ReviewedBy has no
    /// cascade, so it is cleared first.
    /// </summary>
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
