-- 07_Seed_ScamReports.sql (Lyu): sample scam reports, 18 approved and 2 pending.

SET NOCOUNT ON;

INSERT INTO dbo.ScamReports
    (UserID, CategoryID, Title, Description, ScammerPhone, ScammerAccount, ScammerUrl, Status, IsSample, CreatedAt, ReviewedBy, ReviewedAt)
VALUES
-- 1 Telecommunications scams
(2, 1, N'Caller claimed to be a police officer investigating money laundering',
 N'A man said he was from Bukit Aman and that my IC was linked to a money laundering case. He transferred the call to a "senior officer" who said a warrant would be issued unless I moved my savings to a "safe account" for checking. He told me not to tell anyone, including my family.',
 N'60123450101', N'514100000101', NULL, N'Approved', 1, DATEADD(DAY, -21, GETDATE()), 1, DATEADD(DAY, -20, GETDATE())),
(3, 1, N'"LHDN" call about unpaid tax and a refund needing my TAC',
 N'Recorded voice said I had unpaid income tax and pressed 1 to speak to an officer. The officer then said I was due a refund instead, but needed my online banking username and the TAC sent to my phone to "process" it. Within minutes RM4,800 left my account.',
 N'60193450102', NULL, NULL, N'Approved', 1, DATEADD(DAY, -18, GETDATE()), 1, DATEADD(DAY, -17, GETDATE())),
(2, 1, N'Courier call: parcel with illegal items in my name',
 N'Caller said a parcel under my name was held at customs with fake passports inside. She connected me to someone claiming to be a police inspector over WhatsApp video, who showed a fake ID card and asked for RM3,000 to "clear my name".',
 N'60113450103', N'164200000103', NULL, N'Approved', 1, DATEADD(DAY, -15, GETDATE()), 1, DATEADD(DAY, -14, GETDATE())),

-- 2 E-commerce fraud
(3, 2, N'Seller disappeared after payment for a used iPhone',
 N'Found a phone at a very low price on a social media marketplace. The seller asked for full payment by bank transfer before posting, sent a fake tracking number, then blocked me.',
 N'60173450201', N'864300000201', NULL, N'Approved', 1, DATEADD(DAY, -13, GETDATE()), 1, DATEADD(DAY, -12, GETDATE())),
(2, 2, N'Fake buyer sent a payment link to "receive" money',
 N'I was selling a stroller online. The "buyer" said payment was done and sent a link to "claim" it. The page asked for my card number and the OTP. Never click a link to receive money; real transfers need nothing from you.',
 N'60163450202', NULL, N'secure-pay-claim.example/receive', N'Approved', 1, DATEADD(DAY, -11, GETDATE()), 1, DATEADD(DAY, -10, GETDATE())),
(3, 2, N'Concert tickets that never arrived',
 N'Bought two concert tickets from a reseller on Telegram. After payment he asked for an extra "transfer fee" to send the e-tickets, then went silent.',
 N'60183450203', N'762100000203', NULL, N'Approved', 1, DATEADD(DAY, -9, GETDATE()), 1, DATEADD(DAY, -8, GETDATE())),

-- 3 Non-existent investment schemes
(2, 3, N'Crypto group promising guaranteed 30% weekly returns',
 N'Added to a WhatsApp group where "members" posted screenshots of big profits. The admin said returns were guaranteed and risk-free. I could see my "profit" on their website but could not withdraw without paying a 20% "tax" first.',
 N'60123450301', N'552200000301', N'cryptogain-pro.example', N'Approved', 1, DATEADD(DAY, -20, GETDATE()), 1, DATEADD(DAY, -19, GETDATE())),
(3, 3, N'"Like and earn" part-time job that turned into investing',
 N'Paid RM10 per video like at first. Then they moved me to "merchant tasks" that needed me to deposit money first, promising commission. Each task needed a bigger deposit. Lost RM12,000.',
 N'60143450302', N'110400000302', N'task-earn-my.example', N'Approved', 1, DATEADD(DAY, -16, GETDATE()), 1, DATEADD(DAY, -15, GETDATE())),
(2, 3, N'Gold savings plan with "Shariah-compliant" guaranteed profit',
 N'A friend introduced a gold plan paying 8% a month, "Shariah-compliant and guaranteed". Profit came for two months, then payments stopped and the office was empty. The company is not licensed by the Securities Commission.',
 N'60193450303', N'514100000303', NULL, N'Approved', 1, DATEADD(DAY, -12, GETDATE()), 1, DATEADD(DAY, -11, GETDATE())),

-- 4 Non-existent loans
(3, 4, N'Loan approved, but I had to pay a "processing fee" first',
 N'Applied for a RM20,000 personal loan from a Facebook ad. "Approved within an hour", but they asked for a processing fee, then a stamp duty fee, then an insurance fee. No loan ever came.',
 N'60113450401', N'164200000401', N'pinjaman-segera.example', N'Approved', 1, DATEADD(DAY, -19, GETDATE()), 1, DATEADD(DAY, -18, GETDATE())),
(2, 4, N'"No CTOS check" loan asking for my online banking login',
 N'The lender said they did not check CTOS or CCRIS, so approval was guaranteed. To "verify my salary" they wanted my online banking username and password.',
 N'60173450402', NULL, NULL, N'Approved', 1, DATEADD(DAY, -10, GETDATE()), 1, DATEADD(DAY, -9, GETDATE())),
(3, 4, N'Loan "frozen" until I paid to unlock it',
 N'After I signed, the agent said my loan was frozen because I typed my IC number wrongly. To unfreeze it I had to pay RM1,500 as proof of repayment ability.',
 N'60163450403', N'862300000403', NULL, N'Approved', 1, DATEADD(DAY, -7, GETDATE()), 1, DATEADD(DAY, -6, GETDATE())),

-- 5 E-finance fraud
(2, 5, N'SMS: "Your account has been frozen", with a login link',
 N'SMS said my bank account was frozen and I must verify within 24 hours at a link. The page looked like my bank''s login and asked for my username, password and TAC.',
 N'60183450501', NULL, N'mybank-verify.example/login', N'Approved', 1, DATEADD(DAY, -17, GETDATE()), 1, DATEADD(DAY, -16, GETDATE())),
(3, 5, N'Wedding invitation file (APK) that took over my phone',
 N'Received a WhatsApp "kad jemputan kahwin" file from an unknown number. It was an app (APK). After I installed it, it read my SMS and my bank TAC codes, and money was transferred out overnight.',
 N'60123450502', NULL, NULL, N'Approved', 1, DATEADD(DAY, -14, GETDATE()), 1, DATEADD(DAY, -13, GETDATE())),
(2, 5, N'Fake e-wallet rebate link',
 N'A message offered an RM100 e-wallet rebate for registering at a link. The site asked for my e-wallet PIN and OTP, then emptied my balance.',
 N'60143450503', NULL, N'ewallet-rebate.example', N'Approved', 1, DATEADD(DAY, -8, GETDATE()), 1, DATEADD(DAY, -7, GETDATE())),

-- 6 Love scams
(3, 6, N'Overseas engineer needed money for a "customs fee"',
 N'Met a man on a dating app who said he was an engineer on an oil rig. After two months of daily chats he sent me a gift parcel, then a "courier" asked for a customs fee and then an anti-money-laundering fee.',
 N'60113450601', N'514100000601', NULL, N'Approved', 1, DATEADD(DAY, -22, GETDATE()), 1, DATEADD(DAY, -21, GETDATE())),
(2, 6, N'"Army doctor" overseas asked for help with leave fees',
 N'Someone claiming to be a foreign army doctor said he wanted to marry me but needed money to pay for his leave and flight. Video calls never worked "because of security".',
 N'60193450602', N'164200000602', NULL, N'Approved', 1, DATEADD(DAY, -12, GETDATE()), 1, DATEADD(DAY, -11, GETDATE())),
(3, 6, N'Online gaming friend asked to "borrow" for a hospital bill',
 N'A friend I met in an online game for months suddenly had a family emergency and asked to borrow RM2,000 for a hospital deposit, then more. The account vanished after I paid.',
 N'60173450603', N'762100000603', NULL, N'Approved', 1, DATEADD(DAY, -5, GETDATE()), 1, DATEADD(DAY, -4, GETDATE())),

-- Waiting for review (Moderate Reports demo)
(3, 5, N'SMS about an unpaid traffic summons with a payment link',
 N'SMS said I had an unpaid summons and would be blacklisted unless I paid within 24 hours at a link. The link asked for my card details.',
 N'60163450701', NULL, N'saman-bayar.example/pay', N'Pending', 1, DATEADD(DAY, -1, GETDATE()), NULL, NULL),
(4, 3, N'Investment "mentor" on Instagram promising forex profits',
 N'An account sent me screenshots of forex profits and offered to trade for me with guaranteed returns if I deposited RM5,000 first.',
 N'60183450702', N'552200000702', NULL, N'Pending', 1, DATEADD(HOUR, -5, GETDATE()), NULL, NULL);
GO
