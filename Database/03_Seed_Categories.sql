/* ============================================================================
   Scam Savvy - 03_Seed_Categories.sql                          Owner: Member 2
   The six PDRM online-crime categories at fixed IDs 1-6. Lessons, quizzes,
   scenarios and scam reports all refer to these IDs, so do not renumber them.
   Set up by Ahmad so everyone can seed against the same IDs; Member 2 may edit
   the descriptions. Run after 02_Seed_Users.sql.
   ============================================================================ */

SET IDENTITY_INSERT dbo.Categories ON;

INSERT INTO dbo.Categories (CategoryID, Name, Description, SortOrder)
VALUES
    (1, N'Telecommunications scams',
        N'Callers posing as police, LHDN, banks or courier companies, often called Macau scams.', 1),
    (2, N'E-commerce fraud',
        N'Fake sellers and buyers on online marketplaces and social media.', 2),
    (3, N'Non-existent investment schemes',
        N'Fake investment platforms and get-rich-quick schemes that promise high, guaranteed returns.', 3),
    (4, N'Non-existent loans',
        N'Fake lenders who ask for fees before releasing a loan that never comes.', 4),
    (5, N'E-finance fraud',
        N'Phishing links, fake banking apps and account takeovers that empty a victim''s account.', 5),
    (6, N'Love scams',
        N'Online romance used to build trust and then ask for money.', 6);

SET IDENTITY_INSERT dbo.Categories OFF;
GO
