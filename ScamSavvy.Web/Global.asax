<%@ Application Language="C#" %>
<script runat="server">
    // Builds the database on first run if App_Data has none
    void Application_BeginRequest(object sender, EventArgs e)
    {
        DbSetup.EnsureDatabase();
    }
</script>
