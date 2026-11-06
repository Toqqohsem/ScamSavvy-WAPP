<%@ Page Title="My Profile | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="MyProfile.aspx.cs" Inherits="Member_MyProfile" %>
<%-- Owner: Ahmad (Accounts module) --%>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .account-section { max-width: 40rem; }
        .account-danger { border-top: 3px solid var(--bs-danger); }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="ss-page-header">
        <h1 class="h2">My Profile</h1>
        <p>
            <asp:Label ID="lblEmail" runat="server" /> &middot;
            <asp:Label ID="lblRole" runat="server" /> &middot;
            member since <asp:Label ID="lblJoined" runat="server" />
        </p>
    </div>

    <%-- Profile details --%>
    <asp:Panel ID="pnlProfile" runat="server" DefaultButton="btnSaveProfile" CssClass="card ss-card account-section mb-4">
        <div class="card-body p-4 ss-form">
            <h2 class="h5 mb-3">Your details</h2>
            <asp:Label ID="lblProfileMessage" runat="server" EnableViewState="false" Visible="false" />

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtName" CssClass="form-label" Text="Full name" />
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100" />
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ValidationGroup="Profile"
                    ErrorMessage="Enter your name." Display="Dynamic" CssClass="text-danger" />
            </div>
            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtMobile" CssClass="form-label" Text="Mobile number" />
                <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" MaxLength="15" TextMode="Phone" />
                <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ControlToValidate="txtMobile" ValidationGroup="Profile"
                    ErrorMessage="Enter your mobile number." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revMobile" runat="server" ControlToValidate="txtMobile" ValidationGroup="Profile"
                    ValidationExpression="^(\+?60|0)1\d-?\d{7,8}$"
                    ErrorMessage="Enter a Malaysian mobile number, like 012-3456789." Display="Dynamic" CssClass="text-danger" />
            </div>
            <asp:Button ID="btnSaveProfile" runat="server" Text="Save details" CssClass="btn btn-primary"
                ValidationGroup="Profile" OnClick="btnSaveProfile_Click" />
        </div>
    </asp:Panel>

    <%-- Change password --%>
    <asp:Panel ID="pnlPassword" runat="server" DefaultButton="btnChangePassword" CssClass="card ss-card account-section mb-4">
        <div class="card-body p-4 ss-form">
            <h2 class="h5 mb-3">Change password</h2>
            <asp:Label ID="lblPasswordMessage" runat="server" EnableViewState="false" Visible="false" />

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtCurrentPassword" CssClass="form-label" Text="Current password" />
                <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="current-password" ValidateRequestMode="Disabled" />
                <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server" ControlToValidate="txtCurrentPassword" ValidationGroup="Password"
                    ErrorMessage="Enter your current password." Display="Dynamic" CssClass="text-danger" />
            </div>
            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtNewPassword" CssClass="form-label" Text="New password" />
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="new-password" ValidateRequestMode="Disabled" />
                <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword" ValidationGroup="Password"
                    ErrorMessage="Choose a new password." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revNewPassword" runat="server" ControlToValidate="txtNewPassword" ValidationGroup="Password"
                    ValidationExpression="^(?=.*[A-Za-z])(?=.*\d).{8,}$"
                    ErrorMessage="Use at least 8 characters, with a letter and a number." Display="Dynamic" CssClass="text-danger" />
            </div>
            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtConfirmPassword" CssClass="form-label" Text="Confirm new password" />
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="new-password" ValidateRequestMode="Disabled" />
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ValidationGroup="Password"
                    ErrorMessage="Type the new password again." Display="Dynamic" CssClass="text-danger" />
                <asp:CompareValidator ID="cvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword"
                    Operator="Equal" ValidationGroup="Password"
                    ErrorMessage="The new passwords do not match." Display="Dynamic" CssClass="text-danger" />
            </div>
            <asp:Button ID="btnChangePassword" runat="server" Text="Change password" CssClass="btn btn-primary"
                ValidationGroup="Password" OnClick="btnChangePassword_Click" />
        </div>
    </asp:Panel>

    <%-- Delete account --%>
    <asp:Panel ID="pnlDelete" runat="server" DefaultButton="btnDeleteAccount" CssClass="card ss-card account-section account-danger">
        <div class="card-body p-4 ss-form">
            <h2 class="h5 mb-2">Delete account</h2>
            <p class="text-muted">
                This removes your account, lesson progress and quiz attempts. Scam reports you submitted stay on the
                site without your name, so others can still learn from them.
            </p>
            <asp:Label ID="lblDeleteMessage" runat="server" EnableViewState="false" Visible="false" />

            <div class="mb-3">
                <asp:Label runat="server" AssociatedControlID="txtDeletePassword" CssClass="form-label" Text="Enter your password to confirm" />
                <asp:TextBox ID="txtDeletePassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="current-password" ValidateRequestMode="Disabled" />
                <asp:RequiredFieldValidator ID="rfvDeletePassword" runat="server" ControlToValidate="txtDeletePassword" ValidationGroup="Delete"
                    ErrorMessage="Enter your password to delete your account." Display="Dynamic" CssClass="text-danger" />
            </div>
            <asp:Button ID="btnDeleteAccount" runat="server" Text="Delete my account" CssClass="btn btn-outline-danger"
                ValidationGroup="Delete" OnClick="btnDeleteAccount_Click"
                OnClientClick="if (!Page_ClientValidate('Delete')) return false; return confirm('Delete your account permanently?');" />
        </div>
    </asp:Panel>
</asp:Content>
