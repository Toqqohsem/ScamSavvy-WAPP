
<!DOCTYPE html>
<html lang="en-MY">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="theme-color" content="#070b1d" />
  <meta name="description" content="Admin panel to manage Scam Savvy user feedback." />
  <title>Manage Feedback | Scam Savvy Admin</title>
  <link rel="stylesheet" href="Assets/css/Style.css" />
</head>
<body id="top" class="admin-page">
  <form id="form1" runat="server">
  <a class="skip-link" href="#main-content">Skip to main content</a>
  <div class="site-shell">
    <header class="site-header">
      <div class="container header-inner">
        <a class="brand" href="Default.aspx" aria-label="Scam Savvy home">
          <span class="brand-mark" aria-hidden="true"><svg viewBox="0 0 36 40" fill="none"><path d="M18 2 33 8v11c0 9-6 15-15 19C9 34 3 28 3 19V8L18 2Z" stroke="currentColor" stroke-width="2.6"/><path d="m11 20 5 5 10-11" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/></svg></span>
          <span>SCAM <em>SAVVY</em></span>
        </a>
        <nav id="primary-navigation" class="nav-links" aria-label="Primary navigation">
          <a href="Default.aspx">Home</a>
          <a href="Feedback.aspx">Feedback</a>
          <a class="active" href="ManageFeedback.aspx" aria-current="page">Manage Feedback</a>
        </nav>
      </div>
    </header>

    <main id="main-content">
      <section class="admin-section">
        <div class="container">
          <div class="admin-header">
            <div>
              <span class="eyebrow">ADMIN PANEL</span>
              <h2>Manage User Feedback</h2>
            </div>
            <div style="display:flex;gap:12px;align-items:center;flex-wrap:wrap;">
              <label for="status-filter" style="font-size:12px;color:var(--muted);">Filter:</label>
              <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged"
                                style="min-width:150px;">
                <asp:ListItem Value="All" Text="All Statuses" />
                <asp:ListItem Value="Pending" Text="Pending" />
                <asp:ListItem Value="Reviewed" Text="Reviewed" />
                <asp:ListItem Value="Resolved" Text="Resolved" />
                <asp:ListItem Value="Rejected" Text="Rejected" />
              </asp:DropDownList>
            </div>
          </div>

          <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="feedback-success visible" role="status" aria-live="polite">
            <asp:Literal ID="litMessage" runat="server" />
          </asp:Panel>

          <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
            <span class="icon">📭</span>
            No feedback records found.
          </asp:Panel>

          <asp:Repeater ID="rptFeedback" runat="server"
                        OnItemCommand="rptFeedback_ItemCommand">
            <HeaderTemplate>
              <div class="admin-table-wrap">
                <table class="admin-table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Category</th>
                      <th>Rating</th>
                      <th>Message</th>
                      <th>Status</th>
                      <th>Submitted</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
            </HeaderTemplate>

            <ItemTemplate>
              <tr>
                <td><%# Eval("Id") %></td>
                <td><%# Server.HtmlEncode(Eval("Name") as string) %></td>
                <td><%# Server.HtmlEncode(Eval("Email") as string) %></td>
                <td><%# Server.HtmlEncode(Eval("Category") as string) %></td>
                <td><%# RenderStars(Eval("Rating")) %></td>
                <td class="message-cell"><%# Server.HtmlEncode(Eval("Message") as string) %></td>
                <td>
                  <span class='<%# GetBadgeClass(Eval("Status") as string) %>'>
                    <%# Eval("Status") %>
                  </span>
                </td>
                <td><%# Eval("SubmittedOn", "{0:dd MMM yyyy HH:mm}") %></td>
                <td>
                  <div class="admin-actions">
                    <asp:LinkButton ID="lnkReview" runat="server"
                                    CssClass="btn-status"
                                    CommandName="SetStatus"
                                    CommandArgument='<%# Eval("Id") + "|Reviewed" %>'
                                    Text="Review" />
                    <asp:LinkButton ID="lnkResolve" runat="server"
                                    CssClass="btn-status"
                                    CommandName="SetStatus"
                                    CommandArgument='<%# Eval("Id") + "|Resolved" %>'
                                    Text="Resolve" />
                    <asp:LinkButton ID="lnkReject" runat="server"
                                    CssClass="btn-status"
                                    CommandName="SetStatus"
                                    CommandArgument='<%# Eval("Id") + "|Rejected" %>'
                                    Text="Reject" />
                    <asp:LinkButton ID="lnkDelete" runat="server"
                                    CssClass="btn-delete"
                                    CommandName="DeleteItem"
                                    CommandArgument='<%# Eval("Id") %>'
                                    Text="Delete"
                                    OnClientClick="return confirm('Are you sure you want to delete this feedback?');" />
                  </div>
                </td>
              </tr>
            </ItemTemplate>

            <FooterTemplate>
                  </tbody>
                </table>
              </div>
            </FooterTemplate>
          </asp:Repeater>

        </div>
      </section>
    </main>

    <footer id="footer" class="site-footer"><div class="container footer-grid"><div class="footer-brand"><a class="brand" href="Default.aspx" aria-label="Scam Savvy home"><span class="brand-mark" aria-hidden="true"><svg viewBox="0 0 36 40" fill="none"><path d="M18 2 33 8v11c0 9-6 15-15 19C9 34 3 28 3 19V8L18 2Z" stroke="currentColor" stroke-width="2.6"/><path d="m11 20 5 5 10-11" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/></svg></span><span>SCAM <em>SAVVY</em></span></a><p>Empowering Malaysians with the knowledge to recognise, avoid, and report online scams. Stay sharp out there.</p></div><div class="footer-col"><h3>Quick Links</h3><ul><li><a href="Default.aspx">Home</a></li><li><a href="Feedback.aspx">Feedback</a></li><li><a href="ManageFeedback.aspx">Manage Feedback</a></li></ul></div></div><div class="footer-bottom"><div class="container footer-bottom-inner"><span>© 2026 Scam Savvy. Admin Panel.</span><a href="#top">Back to top ↑</a></div></div></footer>
  </div>
  </form>
  <script src="Assets/js/validation.js"></script>
</body>
</html>