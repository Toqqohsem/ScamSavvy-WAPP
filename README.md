# Scam Savvy

Online scam awareness platform for Malaysians. CT050-3-2 Web Applications group assignment, LAB-36 Group 07.
ASP.NET Web Forms (C#, .NET Framework 4.8) with SQL Server LocalDB.

The full rules are in **Scam Savvy — Build Guide and Sync Rules** (shared with the group). This page is the short version.

## Get started

1. **Clone:** Visual Studio > *Clone a repository* > `https://github.com/Toqqohsem/ScamSavvy-WAPP.git`
2. **Open the site:** *File > Open > Web Site* and choose the `ScamSavvy.Web` folder.
3. **Create the database (first time only):** right-click `App_Data` > *Add > New Item > SQL Server Database*, name it `ScamSavvy.mdf`. (If Visual Studio offers to put it in App_Data, say Yes.)
4. **Fill it:** in Server Explorer, right-click `ScamSavvy.mdf` > *New Query*. Open and run each script in `Database/` in number order, 01 to 08. Re-run all of them whenever any script changes; 01 wipes every table.
5. **Run:** Ctrl+F5, then log in with a test account.

| Email | Role | Password |
|---|---|---|
| admin@scamsavvy.test | Admin | Test@1234 |
| contributor@scamsavvy.test | Contributor | Test@1234 |
| member1@scamsavvy.test | Member | Test@1234 |
| member2@scamsavvy.test | Member | Test@1234 |

## Rules that keep everyone's work in sync

- **Edit only files you own.** Shared files and their owners:

  | File | Owner |
  |---|---|
  | `Web.config`, `.gitignore`, `App_Code/Db.cs`, `Auth.cs`, `MemberPage.cs`, `AdminPage.cs`, `Database/01_Schema.sql`, `02_Seed_Users.sql` | Ahmad |
  | `Site.Master`, `Styles/site.css`, `Database/03_Seed_Categories.sql`, `04_Seed_Lessons.sql` | Member 2 |
  | `Database/05_Seed_Quizzes.sql`, `06_Seed_Scenarios.sql` | Member 3 |
  | `App_Code/ScamText.cs`, `Database/07_Seed_ScamReports.sql`, `08_Seed_RedFlags.sql` | Member 4 |

- **C# 5 only.** The site is compiled by the .NET Framework's built-in compiler, which stops at C# 5. Do not use `$"..."` strings, `?.`, `=>` methods or properties, `nameof`, or `out var`. Use `string.Format(...)` or `+` instead. Build the site before every commit to catch these.
- **New pages:** *Add New Item > Web Form*, tick *Select master page*, choose `Site.Master`. Pages in `Member/` inherit `MemberPage`; pages in `Admin/` inherit `AdminPage`. No `<form>` tag in your page; the master page has the only one.
- **Database:** use `Db.Open()`, `Db.Query`, `Db.Scalar` or `Db.Execute` with parameters (`Db.P("@Email", value)`). Never paste a connection string. Ask Ahmad for schema changes.
- **Login state:** use `Auth.IsLoggedIn`, `Auth.CurrentUserId`, `Auth.CurrentRole`, `Auth.IsOwnerOrAdmin(...)`. Never read `Session[...]` directly.
- **Links:** always app-relative: `NavigateUrl="~/Lessons.aspx"`, or `ResolveUrl("~/...")` in plain HTML.
- **Git:** pull before you start, build before you commit, push at least once a day. Never commit `App_Data/*.mdf`.
