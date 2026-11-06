<%@ Page Title="Manage Lessons | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ManageLessons.aspx.cs" Inherits="Admin_ManageLessons" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Manage Lessons only (internal CSS) */
        .lesson-admin-form { padding: 1.5rem; border-top: 4px solid #f2a900; }
        .lesson-admin-thumb { width: 72px; height: 40px; object-fit: cover; border-radius: .35rem; }
        .lesson-admin-preview { width: 100%; max-width: 280px; aspect-ratio: 16 / 9; object-fit: cover; border-radius: .5rem; border: 1px solid #e3e7ee; }
        .lesson-admin-content { font-family: Consolas, "Courier New", monospace; font-size: .9rem; }
        .lesson-admin-toolbar { padding: .9rem 1.15rem; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="site-page-header d-flex flex-wrap justify-content-between align-items-end gap-2">
        <div>
            <h1>Manage Lessons</h1>
            <p>Write, publish and update the lessons learners see. Unpublished lessons are hidden from the public.</p>
        </div>
        <div class="d-flex gap-2">
            <asp:HyperLink ID="lnkCategories" runat="server" NavigateUrl="~/Admin/ManageCategories.aspx" CssClass="btn btn-outline-primary">Categories</asp:HyperLink>
            <asp:Button ID="btnNew" runat="server" Text="+ Add lesson" CssClass="btn btn-primary" CausesValidation="false" OnClick="btnNew_Click" />
        </div>
    </div>

    <asp:Label ID="lblMessage" runat="server" Visible="false" role="status" />

    <!-- ===== Add / edit form ===== -->
    <asp:Panel ID="pnlForm" runat="server" Visible="false" CssClass="site-card lesson-admin-form mb-4" DefaultButton="btnSave">
        <h2 class="h4 mb-3"><asp:Literal ID="litFormTitle" runat="server" Text="Add lesson" /></h2>
        <asp:HiddenField ID="hfLessonID" runat="server" Value="0" />

        <asp:ValidationSummary ID="vsLesson" runat="server" ValidationGroup="Lesson" CssClass="alert alert-danger"
            HeaderText="Please fix the following:" DisplayMode="BulletList" />

        <div class="row g-3">
            <div class="col-md-8">
                <asp:Label ID="lblTitle" runat="server" AssociatedControlID="txtTitle" CssClass="form-label" Text="Title" />
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="150" />
                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" ValidationGroup="Lesson"
                    ErrorMessage="Title is required." Text="Title is required." Display="Dynamic" CssClass="text-danger" />
            </div>
            <div class="col-md-4">
                <asp:Label ID="lblCategory" runat="server" AssociatedControlID="ddlCategory" CssClass="form-label" Text="Category" />
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" />
                <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory" InitialValue="" ValidationGroup="Lesson"
                    ErrorMessage="Choose a category." Text="Choose a category." Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="col-12">
                <asp:Label ID="lblSummary" runat="server" AssociatedControlID="txtSummary" CssClass="form-label" Text="Summary" />
                <asp:TextBox ID="txtSummary" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" data-counter="500" />
                <div class="form-text">One or two sentences shown on the lesson card.</div>
                <asp:RequiredFieldValidator ID="rfvSummary" runat="server" ControlToValidate="txtSummary" ValidationGroup="Lesson"
                    ErrorMessage="Summary is required." Text="Summary is required." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revSummary" runat="server" ControlToValidate="txtSummary" ValidationGroup="Lesson"
                    ValidationExpression="^[\s\S]{0,500}$" ErrorMessage="Summary can be up to 500 characters." Text="Up to 500 characters."
                    Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="col-12">
                <asp:Label ID="lblKeyPoints" runat="server" AssociatedControlID="txtKeyPoints" CssClass="form-label" Text="Key points" />
                <asp:TextBox ID="txtKeyPoints" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" data-counter="1000" />
                <div class="form-text">One point per line. Shown as a bulleted box at the top of the lesson.</div>
                <asp:RequiredFieldValidator ID="rfvKeyPoints" runat="server" ControlToValidate="txtKeyPoints" ValidationGroup="Lesson"
                    ErrorMessage="Key points are required." Text="Key points are required." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revKeyPoints" runat="server" ControlToValidate="txtKeyPoints" ValidationGroup="Lesson"
                    ValidationExpression="^[\s\S]{0,1000}$" ErrorMessage="Key points can be up to 1,000 characters." Text="Up to 1,000 characters."
                    Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="col-12">
                <asp:Label ID="lblContent" runat="server" AssociatedControlID="txtContent" CssClass="form-label" Text="Content (HTML)" />
                <%-- ValidateRequestMode="Disabled" lets this one box accept HTML; the page is admin-only --%>
                <asp:TextBox ID="txtContent" runat="server" CssClass="form-control lesson-admin-content" TextMode="MultiLine" Rows="14"
                    ValidateRequestMode="Disabled" />
                <div class="form-text">Use &lt;h2&gt;, &lt;h3&gt;, &lt;p&gt;, &lt;ul&gt;/&lt;ol&gt;/&lt;li&gt;, &lt;strong&gt;, &lt;em&gt;, &lt;blockquote&gt; and &lt;a&gt;. Scripts, iframes and event attributes are rejected.</div>
                <asp:RequiredFieldValidator ID="rfvContent" runat="server" ControlToValidate="txtContent" ValidationGroup="Lesson"
                    ErrorMessage="Content is required." Text="Content is required." Display="Dynamic" CssClass="text-danger" />
                <asp:CustomValidator ID="cuvContent" runat="server" ControlToValidate="txtContent" ValidationGroup="Lesson"
                    ClientValidationFunction="lessonCheckContent" OnServerValidate="cuvContent_ServerValidate"
                    ErrorMessage="Content contains a script, iframe, event attribute or javascript: link." Text="Remove scripts, iframes, on... attributes and javascript: links."
                    Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="col-md-6">
                <asp:Label ID="lblImage" runat="server" AssociatedControlID="fuImage" CssClass="form-label" Text="Image (JPG or PNG, up to 2 MB)" />
                <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png" data-max-mb="2" />
                <asp:RegularExpressionValidator ID="revImage" runat="server" ControlToValidate="fuImage" ValidationGroup="Lesson"
                    ValidationExpression="^.*\.([jJ][pP][eE]?[gG]|[pP][nN][gG])$" ErrorMessage="The image must be a JPG or PNG file."
                    Text="JPG or PNG only." Display="Dynamic" CssClass="text-danger" />
                <asp:CustomValidator ID="cuvImage" runat="server" ValidationGroup="Lesson" OnServerValidate="cuvImage_ServerValidate"
                    ErrorMessage="The image must be a real JPG or PNG file of 2 MB or less." Text="JPG or PNG, 2 MB or less."
                    Display="Dynamic" CssClass="text-danger" />
            </div>
            <div class="col-md-6">
                <asp:PlaceHolder ID="phCurrentImage" runat="server" Visible="false">
                    <span class="form-label d-block">Current image</span>
                    <asp:Image ID="imgCurrent" runat="server" CssClass="lesson-admin-preview" AlternateText="Current lesson image" />
                    <div class="form-check mt-2">
                        <asp:CheckBox ID="chkRemoveImage" runat="server" Text="Remove this image" />
                    </div>
                    <div class="form-text">Uploading a new image replaces this one.</div>
                </asp:PlaceHolder>
            </div>

            <div class="col-12">
                <asp:Label ID="lblVideoUrl" runat="server" AssociatedControlID="txtVideoUrl" CssClass="form-label" Text="YouTube embed URL (optional)" />
                <asp:TextBox ID="txtVideoUrl" runat="server" CssClass="form-control" MaxLength="300" placeholder="https://www.youtube.com/embed/VIDEO_ID" />
                <div class="form-text">On YouTube choose Share &rarr; Embed and copy the address inside src="...".</div>
                <asp:RegularExpressionValidator ID="revVideoUrl" runat="server" ControlToValidate="txtVideoUrl" ValidationGroup="Lesson"
                    ValidationExpression="^\s*https://www\.youtube\.com/embed/[\w-]+(\?[^\s]*)?\s*$"
                    ErrorMessage="Video URL must look like https://www.youtube.com/embed/VIDEO_ID." Text="Use the https://www.youtube.com/embed/... address."
                    Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="col-md-5">
                <asp:Label ID="lblSourceTitle" runat="server" AssociatedControlID="txtSourceTitle" CssClass="form-label" Text="Source title" />
                <asp:TextBox ID="txtSourceTitle" runat="server" CssClass="form-control" MaxLength="200" placeholder="e.g. Bank Negara Malaysia" />
                <asp:RequiredFieldValidator ID="rfvSourceTitle" runat="server" ControlToValidate="txtSourceTitle" ValidationGroup="Lesson"
                    ErrorMessage="Source title is required." Text="Source title is required." Display="Dynamic" CssClass="text-danger" />
            </div>
            <div class="col-md-7">
                <asp:Label ID="lblSourceUrl" runat="server" AssociatedControlID="txtSourceUrl" CssClass="form-label" Text="Source URL" />
                <asp:TextBox ID="txtSourceUrl" runat="server" CssClass="form-control" MaxLength="300" placeholder="https://" />
                <asp:RequiredFieldValidator ID="rfvSourceUrl" runat="server" ControlToValidate="txtSourceUrl" ValidationGroup="Lesson"
                    ErrorMessage="Source URL is required." Text="Source URL is required." Display="Dynamic" CssClass="text-danger" />
                <asp:RegularExpressionValidator ID="revSourceUrl" runat="server" ControlToValidate="txtSourceUrl" ValidationGroup="Lesson"
                    ValidationExpression="^https?://\S+$" ErrorMessage="Source URL must start with http:// or https://."
                    Text="Start with http:// or https://." Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="col-12">
                <div class="form-check form-switch">
                    <asp:CheckBox ID="chkPublished" runat="server" Text="Published (visible to everyone)" />
                </div>
                <div class="form-text">To check changes before learners see them: untick Published, save, use "View saved version", then tick Published and save again.</div>
            </div>

            <div class="col-12 d-flex flex-wrap gap-2">
                <asp:Button ID="btnSave" runat="server" Text="Save lesson" CssClass="btn btn-primary" ValidationGroup="Lesson" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary" CausesValidation="false" OnClick="btnCancel_Click" />
                <asp:HyperLink ID="lnkPreview" runat="server" CssClass="btn btn-link ms-auto" Target="_blank" Visible="false">View saved version &#8599;</asp:HyperLink>
            </div>
        </div>
    </asp:Panel>

    <!-- ===== List filtered by category ===== -->
    <div class="site-card lesson-admin-toolbar mb-3 d-flex flex-wrap align-items-center gap-2">
        <asp:Label ID="lblFilter" runat="server" AssociatedControlID="ddlFilterCategory" CssClass="form-label mb-0 me-1" Text="Show" />
        <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="form-select w-auto"
            AutoPostBack="true" OnSelectedIndexChanged="ddlFilterCategory_SelectedIndexChanged" />
        <span class="site-meta ms-auto"><asp:Literal ID="litCount" runat="server" /></span>
    </div>

    <div class="table-responsive">
        <asp:GridView ID="gvLessons" runat="server" AutoGenerateColumns="false" DataKeyNames="LessonID"
            CssClass="table site-table align-middle" GridLines="None" UseAccessibleHeader="true"
            AllowPaging="true" PageSize="10" PagerStyle-CssClass="site-pager"
            OnRowCommand="gvLessons_RowCommand" OnPageIndexChanging="gvLessons_PageIndexChanging">
            <Columns>
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <img class="lesson-admin-thumb" src='<%# LessonHelpers.ImageUrl(Eval("ImagePath")) %>' alt="" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Title">
                    <ItemTemplate>
                        <a href='<%# ResolveUrl("~/Lesson.aspx?id=" + Eval("LessonID")) %>' target="_blank"><%#: Eval("Title") %></a>
                        <%# Eval("VideoUrl") == DBNull.Value ? "" : "<span class='site-badge site-badge-muted ms-1'>Video</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="CategoryName" HeaderText="Category" HtmlEncode="true" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <%# (bool)Eval("IsPublished") ? "<span class='site-badge site-badge-success'>Published</span>" : "<span class='site-badge site-badge-warning'>Draft</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Completed by">
                    <ItemTemplate><%#: Eval("CompletedCount") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Created">
                    <ItemTemplate><span class="text-nowrap"><%#: LessonHelpers.FormatDate(Eval("CreatedAt")) %></span></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <div class="d-flex gap-1">
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditLesson" CommandArgument='<%# Eval("LessonID") %>'
                                CausesValidation="false" CssClass="btn btn-sm btn-outline-primary">Edit</asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteLesson" CommandArgument='<%# Eval("LessonID") %>'
                                CausesValidation="false" CssClass="btn btn-sm btn-outline-danger"
                                OnClientClick="return confirm('Delete this record?');">Delete</asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="site-empty">No lessons in this category yet.</div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>

    <script>
        // Client half of cuvContent; the server repeats the same check in cuvContent_ServerValidate.
        function lessonCheckContent(source, args) {
            args.IsValid = !/<\s*(script|iframe|object|embed|form)\b|\son\w+\s*=|javascript\s*:/i.test(args.Value);
        }
    </script>

</asp:Content>
