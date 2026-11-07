<%@ Page Title="Report a Scam | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ReportScam.aspx.cs" Inherits="Member_ReportScam" %>
<%-- Owner: Lyu Jiaxin (Member 4) --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Report a Scam only (internal CSS) */
        .report-card { max-width: 48rem; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="site-page-header">
        <h1>Report a scam</h1>
        <p>Tell the community what happened so others can recognise it. Our team checks every report before it goes public.</p>
    </div>

    <div class="site-callout site-callout-danger report-card mb-4">
        <strong>Lost money?</strong> Report to the authorities first: call <a href="tel:997">997</a> (NSRC, 24 hours) and your bank.
        This form helps other people; it does not replace a police report.
    </div>

    <asp:Panel ID="pnlForm" runat="server" CssClass="site-card report-card" DefaultButton="btnSubmit">
        <div class="site-card-body p-4 p-md-5 site-form">
            <asp:Label ID="lblMessage" runat="server" Visible="false" EnableViewState="false" />
            <asp:Literal ID="litReviewNote" runat="server" />

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtTitle" CssClass="form-label">Short title <span class="text-danger">*</span></asp:Label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="150" ValidateRequestMode="Disabled"
                    placeholder="e.g. Caller claimed to be from LHDN and asked for my TAC" />
                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                    ErrorMessage="Give the report a short title." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revTitle" runat="server" ControlToValidate="txtTitle"
                    ValidationExpression="^[\s\S]{10,150}$" ErrorMessage="Use 10 to 150 characters." Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="ddlCategory" CssClass="form-label">Type of scam <span class="text-danger">*</span></asp:Label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" />
                <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory" InitialValue=""
                    ErrorMessage="Choose the type of scam." Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtDescription" CssClass="form-label">What happened? <span class="text-danger">*</span></asp:Label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" MaxLength="4000"
                    ValidateRequestMode="Disabled" placeholder="How they contacted you, what they said, and what they asked for." />
                <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription"
                    ErrorMessage="Describe what happened." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revDescription" runat="server" ControlToValidate="txtDescription"
                    ValidationExpression="^[\s\S]{50,4000}$" ErrorMessage="Write at least 50 characters (up to 4,000)." Display="Dynamic" CssClass="text-danger" />
            </div>

            <p class="form-label mb-1">Scammer's details <span class="text-muted fw-normal">(optional, but they help others)</span></p>
            <div class="row g-3 mb-3">
                <div class="col-md-4">
                    <asp:Label runat="server" AssociatedControlID="txtPhone" CssClass="form-label small" Text="Phone number" />
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="20" placeholder="012-345 6789" />
                    <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone"
                        ValidationExpression="^(\+?60[\s-]?|0)1\d[\s-]?\d{3,4}[\s-]?\d{4}$"
                        ErrorMessage="Enter a Malaysian mobile number." Display="Dynamic" CssClass="text-danger" />
                </div>
                <div class="col-md-4">
                    <asp:Label runat="server" AssociatedControlID="txtAccount" CssClass="form-label small" Text="Bank account" />
                    <asp:TextBox ID="txtAccount" runat="server" CssClass="form-control" MaxLength="24" placeholder="Digits only" />
                    <asp:RegularExpressionValidator ID="revAccount" runat="server" ControlToValidate="txtAccount"
                        ValidationExpression="^\d(?:[\s-]?\d){7,19}$"
                        ErrorMessage="Use 8 to 20 digits." Display="Dynamic" CssClass="text-danger" />
                </div>
                <div class="col-md-4">
                    <asp:Label runat="server" AssociatedControlID="txtUrl" CssClass="form-label small" Text="Website or link" />
                    <asp:TextBox ID="txtUrl" runat="server" CssClass="form-control" MaxLength="300" ValidateRequestMode="Disabled" placeholder="fake-bank.example" />
                    <asp:RegularExpressionValidator ID="revUrl" runat="server" ControlToValidate="txtUrl"
                        ValidationExpression="^([hH][tT][tT][pP][sS]?://)?[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+(/\S*)?$"
                        ErrorMessage="Enter a website address, like fake-bank.example/login." Display="Dynamic" CssClass="text-danger" />
                </div>
            </div>

            <div class="mb-4">
                <asp:Label runat="server" AssociatedControlID="fuEvidence" CssClass="form-label" Text="Screenshot (optional)" />
                <asp:FileUpload ID="fuEvidence" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png,image/jpeg,image/png" />
                <div class="form-text">JPG or PNG, up to 2 MB. Cover your own name, IC and account numbers first.</div>
                <asp:CustomValidator ID="cuvEvidence" runat="server" OnServerValidate="cuvEvidence_ServerValidate" EnableClientScript="false"
                    ErrorMessage="Upload a JPG or PNG image up to 2 MB." Display="Dynamic" CssClass="text-danger" />
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="Send report" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
        </div>
    </asp:Panel>

    <asp:PlaceHolder ID="phMine" runat="server" Visible="false">
        <h2 class="h5 mt-5">Reports you have sent</h2>
        <div class="table-responsive report-card">
            <table class="table align-middle site-table">
                <thead><tr><th scope="col">Report</th><th scope="col">Status</th><th scope="col">Sent</th></tr></thead>
                <tbody>
                    <asp:Repeater ID="rptMine" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><asp:HyperLink runat="server" NavigateUrl='<%# "~/ScamDetail.aspx?id=" + Eval("ReportID") %>' Text='<%# Server.HtmlEncode(Convert.ToString(Eval("Title"))) %>' /></td>
                                <td><span class='site-badge <%# StatusBadge(Eval("Status")) %>'><%# StatusText(Eval("Status")) %></span></td>
                                <td class="text-nowrap"><%# LessonHelpers.FormatDate(Eval("CreatedAt")) %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </asp:PlaceHolder>
</asp:Content>
