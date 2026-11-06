<%@ Page Title="Register | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>
<%-- Owner: Ahmad (Accounts module) --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .account-card { max-width: 34rem; margin: 0 auto; }
        .account-hint { color: var(--ss-muted); font-size: 0.875rem; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card ss-card account-card">
        <div class="card-body p-4 p-md-5 ss-form">
            <h1 class="h3 mb-1">Create your account</h1>
            <p class="text-muted mb-4">Track your lessons, take the quizzes and report scams you come across.</p>

            <asp:Label ID="lblMessage" runat="server" EnableViewState="false" Visible="false" />

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtName" CssClass="form-label" Text="Full name" />
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100" autocomplete="name" />
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                    ErrorMessage="Enter your name." Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtEmail" CssClass="form-label" Text="Email" />
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" MaxLength="150" TextMode="Email" autocomplete="email" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Enter your email." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    ErrorMessage="Enter a valid email, like name@example.com." Display="Dynamic" CssClass="text-danger" />
                <asp:CustomValidator ID="cuvEmailTaken" runat="server" ControlToValidate="txtEmail"
                    OnServerValidate="cuvEmailTaken_ServerValidate" EnableClientScript="false"
                    ErrorMessage="An account with this email already exists. Log in instead." Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtPassword" CssClass="form-label" Text="Password" />
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="new-password" ValidateRequestMode="Disabled" />
                <div class="account-hint">At least 8 characters, with a letter and a number.</div>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Choose a password." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                    ValidationExpression="^(?=.*[A-Za-z])(?=.*\d).{8,}$"
                    ErrorMessage="Use at least 8 characters, with a letter and a number." Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtConfirm" CssClass="form-label" Text="Confirm password" />
                <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-control" TextMode="Password" autocomplete="new-password" ValidateRequestMode="Disabled" />
                <asp:RequiredFieldValidator ID="rfvConfirm" runat="server" ControlToValidate="txtConfirm"
                    ErrorMessage="Type your password again." Display="Dynamic" CssClass="text-danger" />
                <asp:CompareValidator ID="cvConfirm" runat="server" ControlToValidate="txtConfirm" ControlToCompare="txtPassword"
                    Operator="Equal" ErrorMessage="The passwords do not match." Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="mb-4">
                <asp:Label runat="server" AssociatedControlID="txtMobile" CssClass="form-label" Text="Mobile number" />
                <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" MaxLength="15" TextMode="Phone"
                    placeholder="012-3456789" autocomplete="tel" />
                <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ControlToValidate="txtMobile"
                    ErrorMessage="Enter your mobile number." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revMobile" runat="server" ControlToValidate="txtMobile"
                    ValidationExpression="^(\+?60|0)1\d-?\d{7,8}$"
                    ErrorMessage="Enter a Malaysian mobile number, like 012-3456789." Display="Dynamic" CssClass="text-danger" />
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Create account" CssClass="btn btn-primary w-100" OnClick="btnRegister_Click" />

            <p class="text-center mt-3 mb-0">
                Already have an account?
                <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx" Text="Log in" />
            </p>
        </div>
    </div>
</asp:Content>
