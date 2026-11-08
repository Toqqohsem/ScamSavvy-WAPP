<%@ Page Title="Feedback | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Feedback.aspx.cs" Inherits="Feedback" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Feedback page only (internal CSS) */
        .feedback-card { max-width: 46rem; margin: 0 auto; }
        .feedback-rating { display: inline-flex; gap: .5rem; flex-wrap: wrap; }
        .feedback-rating input { position: absolute; opacity: 0; width: 1px; height: 1px; }
        .feedback-rating label {
            min-width: 3rem; padding: .45rem .8rem; border: 1px solid var(--bs-border-color);
            border-radius: .5rem; text-align: center; cursor: pointer; margin: 0;
        }
        .feedback-rating label::after { content: " \2605"; color: #f4a300; }
        .feedback-rating input:checked + label { background: #0b2545; border-color: #0b2545; color: #fff; }
        .feedback-rating input:focus-visible + label { outline: 3px solid #f4a300; outline-offset: 2px; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="site-page-header text-center">
        <h1>Share your feedback</h1>
        <p>Help us make Scam Savvy better for every Malaysian. Your feedback shapes our lessons, tools and quizzes.</p>
    </div>

    <asp:Panel ID="pnlForm" runat="server" CssClass="site-card feedback-card" DefaultButton="btnSubmit">
        <div class="site-card-body p-4 p-md-5 site-form">
            <asp:Label ID="lblMessage" runat="server" Visible="false" EnableViewState="false" />
            <p class="text-muted small">Fields marked <span class="text-danger">*</span> are required.</p>

            <div class="row g-3">
                <div class="col-md-6">
                    <asp:Label runat="server" AssociatedControlID="txtName" CssClass="form-label">Full name <span class="text-danger">*</span></asp:Label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100" autocomplete="name" />
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                        ErrorMessage="Enter your name." Display="Dynamic" CssClass="text-danger" />
                    <asp:RegularExpressionValidator ID="revName" runat="server" ControlToValidate="txtName"
                        ValidationExpression="^[\s\S]{2,100}$"
                        ErrorMessage="Use at least 2 characters." Display="Dynamic" CssClass="text-danger" />
                </div>
                <div class="col-md-6">
                    <asp:Label runat="server" AssociatedControlID="txtEmail" CssClass="form-label">Email <span class="text-danger">*</span></asp:Label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" MaxLength="150" TextMode="Email" autocomplete="email" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Enter your email." Display="Dynamic" CssClass="text-danger" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                        ErrorMessage="Enter a valid email, like name@example.com." Display="Dynamic" CssClass="text-danger" />
                </div>

                <div class="col-md-6">
                    <asp:Label runat="server" AssociatedControlID="txtPhone" CssClass="form-label" Text="Mobile number (optional)" />
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="20" TextMode="Phone"
                        placeholder="012-3456789" autocomplete="tel" />
                    <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone"
                        ValidationExpression="^(\+?60|0)1\d-?\d{7,8}$"
                        ErrorMessage="Enter a Malaysian mobile number, like 012-3456789." Display="Dynamic" CssClass="text-danger" />
                </div>
                <div class="col-md-6">
                    <asp:Label runat="server" AssociatedControlID="ddlCategory" CssClass="form-label">What is it about? <span class="text-danger">*</span></asp:Label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                        <asp:ListItem Value="" Text="Select a category" />
                        <asp:ListItem Value="General" Text="General feedback" />
                        <asp:ListItem Value="Lessons" Text="Lessons and content" />
                        <asp:ListItem Value="Quizzes" Text="Quizzes" />
                        <asp:ListItem Value="SpotTheScam" Text="Spot the Scam" />
                        <asp:ListItem Value="ScamRepository" Text="Scam repository" />
                        <asp:ListItem Value="Bug" Text="Report a bug" />
                        <asp:ListItem Value="Suggestion" Text="Suggest a feature" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory" InitialValue=""
                        ErrorMessage="Choose a category." Display="Dynamic" CssClass="text-danger" />
                </div>

                <div class="col-12">
                    <span class="form-label d-block" id="ratingLabel">Overall rating <span class="text-danger">*</span>
                        <span class="text-muted small">(1 = poor, 5 = excellent)</span></span>
                    <asp:RadioButtonList ID="rblRating" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal"
                        CssClass="feedback-rating" aria-labelledby="ratingLabel">
                        <asp:ListItem Value="1" Text="1" />
                        <asp:ListItem Value="2" Text="2" />
                        <asp:ListItem Value="3" Text="3" />
                        <asp:ListItem Value="4" Text="4" />
                        <asp:ListItem Value="5" Text="5" />
                    </asp:RadioButtonList>
                    <asp:RequiredFieldValidator ID="rfvRating" runat="server" ControlToValidate="rblRating"
                        ErrorMessage="Choose a rating from 1 to 5." Display="Dynamic" CssClass="text-danger" />
                </div>

                <div class="col-12">
                    <asp:Label runat="server" AssociatedControlID="txtFeedback" CssClass="form-label">Your feedback <span class="text-danger">*</span></asp:Label>
                    <asp:TextBox ID="txtFeedback" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" MaxLength="2000" ValidateRequestMode="Disabled"
                        placeholder="What did you find useful, what could be better, or what would you like to see next?" />
                    <asp:RequiredFieldValidator ID="rfvFeedback" runat="server" ControlToValidate="txtFeedback"
                        ErrorMessage="Write your feedback." Display="Dynamic" CssClass="text-danger" />
                    <asp:RegularExpressionValidator ID="revFeedback" runat="server" ControlToValidate="txtFeedback"
                        ValidationExpression="^[\s\S]{10,2000}$"
                        ErrorMessage="Write between 10 and 2,000 characters." Display="Dynamic" CssClass="text-danger" />
                </div>
            </div>

            <div class="d-flex flex-wrap gap-2 mt-4">
                <asp:Button ID="btnSubmit" runat="server" Text="Send feedback" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
                <asp:HyperLink ID="lnkCancel" runat="server" NavigateUrl="~/Default.aspx" CssClass="btn btn-outline-primary" Text="Cancel" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>
