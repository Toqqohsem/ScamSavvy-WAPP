/* ============================================================================
   Scam Savvy - 08_Seed_RedFlags.sql                     Owner: Lyu Jiaxin (Member 4)
   Words and phrases the Scam Checker looks for, in English and Bahasa Melayu.
   Weight: 1 = common in scams but also normal messages, 2 = suspicious,
           3 = very rarely legitimate.
   The checker adds up the weights: 0-2 Low, 3-5 Medium, 6+ High. Any phone
   number, account or link already in an approved report makes it High.
   Run after 07_Seed_ScamReports.sql.
   ============================================================================ */

SET NOCOUNT ON;

INSERT INTO dbo.RedFlagKeywords (Keyword, Language, Weight, Explanation)
VALUES
-- Pressure and secrecy
(N'urgent',                    'EN', 2, N'Scammers rush you so you act before you think or check.'),
(N'immediately',               'EN', 2, N'Real banks and agencies give you time to verify a request.'),
(N'within 24 hours',           'EN', 2, N'A short deadline is a classic pressure tactic.'),
(N'do not tell anyone',        'EN', 3, N'Asking you to keep it secret stops family or the bank from warning you.'),
(N'confidential',              'EN', 1, N'Scammers often call a case "confidential" to isolate you.'),
(N'segera',                    'BM', 2, N'"Segera" (immediately) is used to rush you into acting.'),
(N'jangan beritahu sesiapa',   'BM', 3, N'"Do not tell anyone" keeps you from asking for help.'),

-- Account and authority threats
(N'account suspended',         'EN', 3, N'Banks do not suspend accounts by SMS with a link to fix it.'),
(N'account frozen',            'EN', 3, N'A "frozen account" message with a link is a common phishing trick.'),
(N'akaun anda dibekukan',      'BM', 3, N'"Your account is frozen" is a common phishing SMS in Malaysia.'),
(N'akaun anda telah disekat',  'BM', 3, N'"Your account has been blocked" messages push you to a fake login page.'),
(N'warrant',                   'EN', 3, N'Police do not announce arrest warrants by phone or ask for money to cancel them.'),
(N'waran tangkap',             'BM', 3, N'Police do not cancel an arrest warrant for money over the phone.'),
(N'money laundering',          'EN', 3, N'Callers posing as police use money laundering claims to frighten you.'),
(N'pengubahan wang haram',     'BM', 3, N'"Money laundering" threats are the core of the Macau scam.'),
(N'safe account',              'EN', 3, N'No real officer asks you to move money to a "safe account".'),
(N'akaun selamat',             'BM', 3, N'"Akaun selamat" is a Macau scam phrase. Police never hold your money.'),

-- Codes and logins
(N'OTP',                       'EN', 3, N'Never share a one-time password. Banks never ask for it.'),
(N'TAC',                       'EN', 3, N'Your TAC approves transactions. Anyone asking for it wants your money.'),
(N'verify your account',       'EN', 3, N'Links asking you to verify your account lead to fake login pages.'),
(N'sahkan akaun',              'BM', 3, N'"Sahkan akaun" links usually lead to fake bank login pages.'),
(N'click the link',            'EN', 2, N'Links in unexpected messages often lead to fake sites or malware.'),
(N'klik pautan',               'BM', 2, N'"Klik pautan" in an unexpected message is a phishing warning sign.'),
(N'APK',                       'EN', 3, N'An APK file installs an app outside the app store and can read your bank SMS.'),
(N'kad jemputan',              'BM', 2, N'Fake wedding invitation files are a known way to spread banking malware.'),

-- Money for nothing
(N'guaranteed return',         'EN', 3, N'No real investment can guarantee returns.'),
(N'guaranteed profit',         'EN', 3, N'Promised profit is the main sign of an investment scam.'),
(N'risk-free',                 'EN', 2, N'Every real investment carries some risk.'),
(N'pulangan dijamin',          'BM', 3, N'"Guaranteed returns" in Bahasa Melayu. Check the SC Investor Alert List.'),
(N'keuntungan dijamin',        'BM', 3, N'"Guaranteed profit" is a red flag for unlicensed schemes.'),
(N'you have won',              'EN', 3, N'Prizes you never entered for are bait to collect fees or details.'),
(N'tahniah anda menang',       'BM', 3, N'"Congratulations, you won" messages ask for fees to release the prize.'),

-- Fees before you get something
(N'processing fee',            'EN', 3, N'Real lenders deduct fees from the loan; they never ask you to pay first.'),
(N'yuran pemprosesan',         'BM', 3, N'Paying a "processing fee" before a loan is released is a loan-scam sign.'),
(N'customs fee',               'EN', 3, N'A customs fee for a gift from someone you met online is a love-scam sign.'),
(N'no CTOS',                   'EN', 2, N'"No CTOS check" loans target people who cannot borrow from banks.'),
(N'pinjaman segera',           'BM', 2, N'"Instant loan" adverts often come from unlicensed lenders.'),

-- Delivery and parcels
(N'parcel',                    'EN', 1, N'Parcel and courier stories are used to start Macau and love scams.'),
(N'bungkusan',                 'BM', 1, N'Fake parcel problems are used to start impersonation scams.'),
(N'gift card',                 'EN', 2, N'Requests to pay with gift cards are almost always scams.');
GO
