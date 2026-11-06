
<!DOCTYPE html>
<html lang="en-MY">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="theme-color" content="#070b1d" />
  <meta name="description" content="Share your feedback with Scam Savvy to help us improve our scam awareness platform for all Malaysians." />
  <title>Feedback | Scam Savvy</title>
  <link rel="stylesheet" href="Assets/css/Style.css" />
  <style>
    .feedback-page .page-hero { padding: 60px 0 10px; text-align: center; }
    .feedback-page .page-hero h1 { font-family: var(--font-heading); font-size: clamp(32px, 5vw, 52px); letter-spacing: -.05em; margin: 0 0 12px; }
    .feedback-page .page-hero p { color: var(--muted); font-size: 14px; max-width: 540px; margin: 0 auto; }
  </style>
</head>
<body id="top" class="feedback-page">
  <form id="form1" runat="server">
  <a class="skip-link" href="#main-content">Skip to main content</a>
  <div class="site-shell">
    <header class="site-header">
      <div class="container header-inner">
        <a class="brand" href="Default.aspx" aria-label="Scam Savvy home">
          <span class="brand-mark" aria-hidden="true"><svg viewBox="0 0 36 40" fill="none"><path d="M18 2 33 8v11c0 9-6 15-15 19C9 34 3 28 3 19V8L18 2Z" stroke="currentColor" stroke-width="2.6"/><path d="m11 20 5 5 10-11" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/></svg></span>
          <span>SCAM <em>SAVVY</em></span>
        </a>
        <button class="menu-toggle" type="button" aria-label="Open navigation menu" aria-controls="primary-navigation" aria-expanded="false"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 6h16M4 12h16M4 18h16"/></svg></button>
        <nav id="primary-navigation" class="nav-links" aria-label="Primary navigation">
          <a href="Default.aspx">Home</a>
          <a href="Lessons.aspx">Lessons</a>
          <a href="ScamRepository.aspx">Scam Repository</a>
          <a href="Quiz.aspx">Quiz</a>
          <a class="active" href="Feedback.aspx" aria-current="page">Feedback</a>
          <a href="About.aspx">About</a>
          <a href="FAQ.aspx">FAQ</a>
          <a href="Contact.aspx">Contact</a>
          <a href="Login.aspx">Login</a>
          <a class="nav-join" href="Register.aspx">Join Now ↗</a>
          <details class="user-menu" hidden><summary>My Account</summary><div class="user-menu-list"><a href="MemberDashboard.aspx">Dashboard</a><a href="MemberDashboard.aspx#profile">Profile</a><a href="Login.aspx">Logout</a></div></details>
        </nav>
      </div>
    </header>

    <main id="main-content">
      <section class="page-hero">
        <div class="container">
          <span class="eyebrow">WE'RE LISTENING</span>
          <h1>Share Your <span style="color:var(--cyan)">Feedback</span></h1>
          <p>Help us make Scam Savvy better for every Malaysian. Your honest feedback shapes our lessons, tools and community.</p>
        </div>
      </section>

      <section class="feedback-section">
        <div class="container">
          <div class="glass-card feedback-card">

            <!-- Success message -->
            <div id="feedback-success" class="feedback-success" role="status" aria-live="polite" tabindex="-1">
              ✅ Thank you! Your feedback has been submitted successfully. We'll review it shortly.
            </div>

            <!-- Error summary (client-side) -->
            <div id="feedback-error-summary" class="feedback-error-summary" role="alert">
              <strong>Please fix the following errors:</strong>
              <ul>
                <li>Check that all required fields are filled in correctly.</li>
              </ul>
            </div>

            <!-- Server-side error summary -->
            <asp:Panel ID="pnlServerError" runat="server" CssClass="feedback-error-summary" Visible="false" role="alert">
              <strong>Please fix the following errors:</strong>
              <asp:Literal ID="litServerErrors" runat="server" />
            </asp:Panel>

            <!-- Server-side success message -->
            <asp:Panel ID="pnlSuccess" runat="server" CssClass="feedback-success" Visible="false" role="status" aria-live="polite" tabindex="-1">
              ✅ Thank you! Your feedback has been submitted successfully. We'll review it shortly.
            </asp:Panel>

            <div id="feedback-form-wrap">
              <h2>Tell us what you think</h2>
              <p class="subtitle">All fields marked with <span style="color:var(--danger)">*</span> are required.</p>

              <div class="form-row">
                <div class="form-group">
                  <label for="txtName">Full Name <span class="required">*</span></label>
                  <input type="text" id="txtName" runat="server" name="name"
                         data-validate="minlength" data-min="2"
                         placeholder="e.g. Aina N."
                         aria-describedby="txtName-error" />
                  <span id="txtName-error" class="field-error" role="alert"></span>
                </div>
                <div class="form-group">
                  <label for="txtEmail">Email Address <span class="required">*</span></label>
                  <input type="email" id="txtEmail" runat="server" name="email"
                         data-validate="email"
                         placeholder="you@example.com"
                         aria-describedby="txtEmail-error" />
                  <span id="txtEmail-error" class="field-error" role="alert"></span>
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label for="txtPhone">Phone Number</label>
                  <input type="tel" id="txtPhone" runat="server" name="phone"
                         data-validate="phone"
                         placeholder="+60 12-345 6789"
                         aria-describedby="txtPhone-error" />
                  <span id="txtPhone-error" class="field-error" role="alert"></span>
                </div>
                <div class="form-group">
                  <label for="ddlCategory">Feedback Category <span class="required">*</span></label>
                  <select id="ddlCategory" runat="server" name="category"
                          data-validate="select"
                          aria-describedby="ddlCategory-error">
                    <option value="">-- Select a category --</option>
                    <option value="General">General Feedback</option>
                    <option value="Lessons">Lessons &amp; Content</option>
                    <option value="ScamRepository">Scam Repository</option>
                    <option value="Quiz">Quiz Experience</option>
                    <option value="Bug">Report a Bug</option>
                    <option value="Suggestion">Feature Suggestion</option>
                  </select>
                  <span id="ddlCategory-error" class="field-error" role="alert"></span>
                </div>
              </div>

              <div class="form-group">
                <label>Overall Rating <span class="required">*</span></label>
                <div class="rating-stars" role="radiogroup" aria-label="Overall rating" id="rating-group">
                  <input type="radio" id="star5" name="rating" value="5" runat="server" />
                  <label for="star5" title="5 stars">★</label>
                  <input type="radio" id="star4" name="rating" value="4" runat="server" />
                  <label for="star4" title="4 stars">★</label>
                  <input type="radio" id="star3" name="rating" value="3" runat="server" />
                  <label for="star3" title="3 stars">★</label>
                  <input type="radio" id="star2" name="rating" value="2" runat="server" />
                  <label for="star2" title="2 stars">★</label>
                  <input type="radio" id="star1" name="rating" value="1" runat="server" />
                  <label for="star1" title="1 star">★</label>
                </div>
                <span id="rating-error" class="field-error" role="alert"></span>
              </div>

              <div class="form-group">
                <label for="txtMessage">Your Message <span class="required">*</span></label>
                <textarea id="txtMessage" runat="server" name="message"
                          data-validate="minlength" data-min="10"
                          placeholder="Tell us what you loved, what could be better, or what you'd like to see next..."
                          aria-describedby="txtMessage-error"></textarea>
                <span id="txtMessage-error" class="field-error" role="alert"></span>
              </div>

              <div class="hero-actions" style="margin-top:28px;">
                <asp:Button ID="btnSubmit" runat="server" Text="Submit Feedback ↗"
                            CssClass="btn btn-primary" OnClick="btnSubmit_Click"
                            UseSubmitBehavior="true" />
                <a class="btn btn-outline" href="Default.aspx">Cancel</a>
              </div>
            </div>

          </div>
        </div>
      </section>
    </main>

    <footer id="footer" class="site-footer"><div class="container footer-grid"><div class="footer-brand"><a class="brand" href="Default.aspx" aria-label="Scam Savvy home"><span class="brand-mark" aria-hidden="true"><svg viewBox="0 0 36 40" fill="none"><path d="M18 2 33 8v11c0 9-6 15-15 19C9 34 3 28 3 19V8L18 2Z" stroke="currentColor" stroke-width="2.6"/><path d="m11 20 5 5 10-11" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/></svg></span><span>SCAM <em>SAVVY</em></span></a><p>Empowering Malaysians with the knowledge to recognise, avoid, and report online scams. Stay sharp out there.</p><div class="social-links" aria-label="Social media"><a href="https://www.facebook.com/" aria-label="Facebook" target="_blank" rel="noopener noreferrer">f</a><a href="https://www.instagram.com/" aria-label="Instagram" target="_blank" rel="noopener noreferrer">◎</a><a href="https://www.youtube.com/" aria-label="YouTube" target="_blank" rel="noopener noreferrer">▶</a></div></div><div class="footer-col"><h3>Quick Links</h3><ul><li><a href="Default.aspx">Home</a></li><li><a href="Lessons.aspx">Lessons</a></li><li><a href="ScamRepository.aspx">Scam Repository</a></li><li><a href="Quiz.aspx">Take a Quiz</a></li></ul></div><div class="footer-col"><h3>Resources</h3><ul><li><a href="FAQ.aspx">FAQs</a></li><li><a href="Feedback.aspx">Feedback</a></li><li><a href="Contact.aspx">Report a Scam</a></li><li><a href="About.aspx">About Us</a></li></ul></div><div class="footer-col footer-newsletter"><h3>Stay in the know</h3><p class="section-copy">Get useful scam-safety tips in your inbox.</p><form id="newsletter-form" class="newsletter" novalidate><label class="sr-only" for="newsletter-email">Email address</label><input id="newsletter-email" name="email" type="email" required autocomplete="email" placeholder="Your email address" aria-describedby="newsletter-message" /><button type="submit" aria-label="Subscribe to scam safety tips">↗</button></form><p id="newsletter-message" class="newsletter-message" role="status" aria-live="polite"></p><address>Malaysia · Stay safe online</address></div></div><div class="footer-bottom"><div class="container footer-bottom-inner"><span>© 2026 Scam Savvy. Made for a scam-smart Malaysia.</span><a href="#top">Back to top ↑</a></div></div></footer>
  </div>
  </form>
  <script src="Assets/js/validation.js"></script>
</body>
</html>