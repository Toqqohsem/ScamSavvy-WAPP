<%@ Page Title="Scam Checker | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ScamChecker.aspx.cs" Inherits="ScamChecker" %>
<%-- Owner: Lyu Jiaxin (Member 4) --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Scam Checker only (internal CSS) */
        .checker-input textarea { min-height: 10rem; }
        .checker-risk { font-size: 1.1rem; padding: .45rem 1rem; }
        .checker-message {
            white-space: pre-wrap; word-break: break-word; background: #fff; border: 1px solid var(--ss-line);
            border-radius: var(--ss-radius); padding: 1rem 1.25rem; font-size: .95rem;
        }
        .checker-message mark { background: #ffe08a; padding: 0 .1rem; border-radius: .2rem; }
        .checker-message mark.checker-reported { background: #f8c9c9; }
        .checker-flag { border-left: 4px solid var(--ss-amber); padding-left: .75rem; margin-bottom: .75rem; }
        .checker-flag.checker-reported { border-left-color: var(--ss-red); }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="site-page-header">
        <h1>Scam Checker</h1>
        <p>Paste a suspicious SMS, WhatsApp message or email. We check it against scams reported on Scam Savvy and the warning signs scammers use.</p>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <asp:Panel ID="pnlInput" runat="server" CssClass="site-card checker-input" DefaultButton="btnCheck">
                <div class="site-card-body p-4">
                    <asp:Label runat="server" AssociatedControlID="txtMessage" CssClass="form-label" Text="Message to check" />
                    <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" MaxLength="2000"
                        ValidateRequestMode="Disabled" placeholder="Paste the message here" />
                    <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" ValidationGroup="Check"
                        ErrorMessage="Paste a message to check." Display="Dynamic" CssClass="text-danger" />
                    <asp:RegularExpressionValidator ID="revMessage" runat="server" ControlToValidate="txtMessage" ValidationGroup="Check"
                        ValidationExpression="^[\s\S]{1,2000}$" ErrorMessage="Keep the message under 2,000 characters." Display="Dynamic" CssClass="text-danger" />
                    <p class="form-text mb-3">We never store what you paste.</p>

                    <div class="d-flex flex-wrap gap-2">
                        <asp:Button ID="btnCheck" runat="server" Text="Check message" CssClass="btn btn-primary" ValidationGroup="Check" OnClick="btnCheck_Click" />
                        <asp:LinkButton ID="btnExampleScam" runat="server" CssClass="btn btn-outline-primary" CausesValidation="false"
                            OnClick="btnExampleScam_Click" Text="Try a scam example" />
                        <asp:LinkButton ID="btnExampleNormal" runat="server" CssClass="btn btn-outline-primary" CausesValidation="false"
                            OnClick="btnExampleNormal_Click" Text="Try a normal message" />
                    </div>
                </div>
            </asp:Panel>

            <div class="site-callout mt-4">
                <strong>Think you've been scammed?</strong> Call <a href="tel:997">997</a> (National Scam Response Centre, 24 hours)
                and your bank straight away. Check a phone number or bank account on
                <a href="https://semakmule.rmp.gov.my/" target="_blank" rel="noopener noreferrer">PDRM Semak Mule</a>.
            </div>
        </div>

        <div class="col-lg-6">
            <asp:Panel ID="pnlEmpty" runat="server" CssClass="site-empty">
                Your result will appear here.
            </asp:Panel>

            <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="site-card">
                <div class="site-card-body p-4">
                    <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                        <span class="h5 mb-0">Risk level</span>
                        <asp:Label ID="lblRisk" runat="server" CssClass="site-badge checker-risk" />
                    </div>
                    <p class="mb-3"><asp:Literal ID="litVerdict" runat="server" /></p>

                    <h2 class="h6">Your message, with warning signs highlighted</h2>
                    <div class="checker-message mb-4"><asp:Literal ID="litHighlighted" runat="server" Mode="PassThrough" /></div>

                    <asp:PlaceHolder ID="phReported" runat="server" Visible="false">
                        <h2 class="h6">Already reported on Scam Savvy</h2>
                        <asp:Repeater ID="rptReported" runat="server">
                            <ItemTemplate>
                                <div class="checker-flag checker-reported">
                                    <strong><%# Server.HtmlEncode(Convert.ToString(Eval("Found"))) %></strong>
                                    appears in a reported case:
                                    <asp:HyperLink runat="server" NavigateUrl='<%# "~/ScamDetail.aspx?id=" + Eval("ReportID") %>'
                                        Text='<%# Server.HtmlEncode(Convert.ToString(Eval("Title"))) %>' />
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </asp:PlaceHolder>

                    <asp:PlaceHolder ID="phFlags" runat="server" Visible="false">
                        <h2 class="h6">Warning signs found</h2>
                        <asp:Repeater ID="rptFlags" runat="server">
                            <ItemTemplate>
                                <div class="checker-flag">
                                    <strong>&ldquo;<%# Server.HtmlEncode(Convert.ToString(Eval("Keyword"))) %>&rdquo;</strong>
                                    <span class="site-meta">(<%# Eval("Language") %>)</span><br />
                                    <%# Server.HtmlEncode(Convert.ToString(Eval("Explanation"))) %>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </asp:PlaceHolder>

                    <p class="site-meta mt-3 mb-3"><strong>Low risk does not mean safe.</strong>
                        If a message asks for money, a code or your login, stop and check with the organisation directly.</p>

                    <div class="d-flex flex-wrap gap-2">
                        <asp:HyperLink ID="lnkReport" runat="server" NavigateUrl="~/Member/ReportScam.aspx" CssClass="btn btn-warning" Text="Report this scam" />
                        <asp:HyperLink ID="lnkRepository" runat="server" NavigateUrl="~/ScamRepository.aspx" CssClass="btn btn-outline-primary" Text="Browse reported scams" />
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
