/* =====================================================================
   03_Seed_Categories.sql  (owner: Member 2)
   Six scam categories with FIXED IDs 1-6. Other seed scripts
   (lessons, quizzes, scenarios, reports) refer to these IDs.
   Run after 01_Schema.sql and 02_Seed_Users.sql.
   Category names follow the PDRM CCID online-crime categories.
   ===================================================================== */

SET NOCOUNT ON;

SET IDENTITY_INSERT dbo.Categories ON;

INSERT INTO dbo.Categories (CategoryID, Name, Description, SortOrder) VALUES
(1, N'Telecommunications scams',
    N'Calls and messages from people pretending to be police, Bank Negara, LHDN, a court, a courier or your bank, who frighten you into moving money to a "safe" account. Includes Macau scams and voice phishing.',
    1),
(2, N'E-commerce fraud',
    N'Fake sellers, buyers and online shops. You pay for goods that never arrive, or a "buyer" sends a fake payment link that empties your account.',
    2),
(3, N'Non-existent investment schemes',
    N'Investment groups and apps promising high, guaranteed returns in shares, forex, gold or crypto. They show fake profits, then block withdrawals until you pay more.',
    3),
(4, N'Non-existent loans',
    N'Easy loans advertised on social media that ask for a processing fee, insurance or a deposit before releasing money that never comes.',
    4),
(5, N'E-finance fraud',
    N'Phishing links, fake banking apps, malicious APK files and requests for your TAC or password that let scammers take over your online banking or e-wallet.',
    5),
(6, N'Love scams',
    N'Someone you meet online builds a romantic relationship, then asks for money for an emergency, a parcel held at customs, or a joint investment.',
    6);

SET IDENTITY_INSERT dbo.Categories OFF;

PRINT 'Categories seeded: 6 rows.';
