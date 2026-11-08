# Scam Savvy

Online scam awareness platform for Malaysians. CT050-3-2 Web Applications, LAB-36 Group 07.
ASP.NET Web Forms (C#, .NET Framework 4.8) with SQL Server LocalDB.

## How to run

1. In Visual Studio, choose *File > Open > Web Site* and select the `ScamSavvy.Web` folder.
2. Press Ctrl+F5. On the first run the site creates `App_Data\ScamSavvy.mdf` from the scripts in `Database` (01 to 08). This takes a few seconds.
3. Log in with one of the test accounts below.

To reset the data, stop the site, delete `ScamSavvy.mdf` and `ScamSavvy_log.ldf` from `App_Data`, and run it again.

| Email | Role | Password |
|---|---|---|
| admin@scamsavvy.test | Admin | Test@1234 |
| contributor@scamsavvy.test | Contributor | Test@1234 |
| member1@scamsavvy.test | Member | Test@1234 |
| member2@scamsavvy.test | Member | Test@1234 |

## Folders

- `ScamSavvy.Web` - the website (pages, `App_Code`, styles, images)
- `Database` - SQL scripts that create the tables and sample data
