<%@ Page Title="Home | Scam Savvy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<%-- Owner: Member 2. Starter home page set up by Ahmad so links have somewhere to land.
     Replace with the dynamic version from the build guide (latest alerts, category tiles, lessons). --%>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="p-4 p-md-5 mb-4 ss-card">
        <h1 class="display-6 fw-bold">Spot a scam before it costs you.</h1>
        <p class="lead col-lg-8">
            Scam Savvy helps Malaysians recognise, avoid and report online scams through short lessons,
            a searchable scam repository and quick self-checks.
        </p>
        <div class="d-flex flex-wrap gap-2">
            <asp:HyperLink ID="lnkCheck" runat="server" NavigateUrl="~/ScamChecker.aspx" CssClass="btn btn-primary btn-lg" Text="Check a message" />
            <asp:HyperLink ID="lnkLearn" runat="server" NavigateUrl="~/Lessons.aspx" CssClass="btn btn-outline-primary btn-lg" Text="Start learning" />
        </div>
    </section>

    <section class="p-4 mb-4 ss-card">
        <div class="ss-stat">Over RM2.7 billion</div>
        <p class="mb-1">lost to online scams in Malaysia from January to November 2025, across 67,735 cases.</p>
        <p class="small text-muted mb-0">
            Source: PDRM figures reported by
            <a href="https://www.malaymail.com/news/malaysia/2025/12/08/malaysians-swindled-out-of-rm27b-in-cyber-scams-police-data-reveals/201156" target="_blank" rel="noopener">Malay Mail, 8 Dec 2025</a>.
        </p>
    </section>
</asp:Content>
