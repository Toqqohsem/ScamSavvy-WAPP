<%@ Page Title="Scam Report | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ScamDetail.aspx.cs" Inherits="ScamDetail" %>
<%-- Owner: Lyu Jiaxin (Member 4) --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Scam Detail only (internal CSS) */
        .detail-text { white-space: pre-line; }
        .detail-ids dt { font-weight: 600; }
        .detail-ids dd { word-break: break-all; }
        .detail-evidence { max-width: 100%; max-height: 28rem; border-radius: var(--ss-radius); border: 1px solid var(--ss-line); }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/ScamRepository.aspx" CssClass="d-inline-block mb-3" Text="&larr; All reported scams" />

    <asp:Panel ID="pnlNotFound" runat="server" Visible="false" CssClass="site-empty">
        <h1 class="h4">Report not found</h1>
        <p class="mb-0">This report does not exist or is not public.</p>
    </asp:Panel>

    <asp:Panel ID="pnlReport" runat="server">
        <asp:Label ID="lblMessage" runat="server" Visible="false" EnableViewState="false" />

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="site-card">
                    <div class="site-card-body p-4">
                        <div class="d-flex flex-wrap gap-1 mb-2">
                            <asp:Label ID="lblCategory" runat="server" CssClass="site-badge" />
                            <asp:Label ID="lblStatus" runat="server" CssClass="site-badge site-badge-warning" Visible="false" />
                            <asp:Label ID="lblSample" runat="server" CssClass="site-badge site-badge-muted" Text="Sample data" Visible="false" />
                        </div>
                        <h1 class="h3"><asp:Literal ID="litTitle" runat="server" Mode="Encode" /></h1>
                        <p class="site-meta">Reported <asp:Literal ID="litDate" runat="server" /></p>
                        <p class="detail-text"><asp:Literal ID="litDescription" runat="server" Mode="Encode" /></p>

                        <asp:PlaceHolder ID="phIds" runat="server">
                            <h2 class="h6 mt-4">Reported details</h2>
                            <p class="site-meta">Do not call, pay or visit these. They are shown so you can recognise them.</p>
                            <dl class="row detail-ids mb-0">
                                <asp:PlaceHolder ID="phPhone" runat="server">
                                    <dt class="col-sm-4">Phone number</dt><dd class="col-sm-8"><asp:Literal ID="litPhone" runat="server" Mode="Encode" /></dd>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="phAccount" runat="server">
                                    <dt class="col-sm-4">Bank account</dt><dd class="col-sm-8"><asp:Literal ID="litAccount" runat="server" Mode="Encode" /></dd>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="phUrl" runat="server">
                                    <dt class="col-sm-4">Website</dt><dd class="col-sm-8"><asp:Literal ID="litUrl" runat="server" Mode="Encode" /></dd>
                                </asp:PlaceHolder>
                            </dl>
                        </asp:PlaceHolder>

                        <asp:PlaceHolder ID="phEvidence" runat="server" Visible="false">
                            <h2 class="h6 mt-4">Screenshot</h2>
                            <asp:Image ID="imgEvidence" runat="server" CssClass="detail-evidence" AlternateText="Screenshot sent with this report" />
                        </asp:PlaceHolder>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="site-callout site-callout-danger mb-3">
                    <h2 class="h6">Where to report</h2>
                    <ul class="mb-0 ps-3">
                        <li>Lost money? Call <a href="tel:997">997</a> (NSRC, 24 hours) and your bank now.</li>
                        <li>Check numbers and accounts on <a href="https://semakmule.rmp.gov.my/" target="_blank" rel="noopener noreferrer">PDRM Semak Mule</a>.</li>
                        <asp:PlaceHolder ID="phSc" runat="server" Visible="false">
                            <li>Check the company on the <a href="https://www.sc.com.my/investor-empowerment/investor-alert-list" target="_blank" rel="noopener noreferrer">SC Investor Alert List</a>.</li>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phBnm" runat="server" Visible="false">
                            <li>Check the lender or scheme on Bank Negara's <a href="https://www.bnm.gov.my/financial-consumer-alert-list" target="_blank" rel="noopener noreferrer">Financial Consumer Alert List</a>.</li>
                        </asp:PlaceHolder>
                    </ul>
                </div>
                <div class="d-grid gap-2">
                    <asp:HyperLink ID="lnkLesson" runat="server" CssClass="btn btn-primary" Text="Learn about this scam" />
                    <asp:HyperLink ID="lnkChecker" runat="server" NavigateUrl="~/ScamChecker.aspx" CssClass="btn btn-outline-primary" Text="Check a message" />
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
