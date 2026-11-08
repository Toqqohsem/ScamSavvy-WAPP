<%@ Application Language="C#" %>
<script runat="server">
    // Owner: Ahmad. Creates App_Data\ScamSavvy.mdf from the Database scripts on the first request if it is missing.
    void Application_BeginRequest(object sender, EventArgs e)
    {
        DbSetup.EnsureDatabase();
    }
</script>
