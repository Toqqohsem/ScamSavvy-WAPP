-- 04_Seed_Lessons.sql (Arshia): one lesson per category.

SET NOCOUNT ON;

SET IDENTITY_INSERT dbo.Lessons ON;

/* ---------- 1. Telecommunications scams ---------- */
INSERT INTO dbo.Lessons (LessonID, CategoryID, Title, Summary, KeyPoints, Content, ImagePath, VideoUrl, SourceTitle, SourceUrl, IsPublished, CreatedAt)
VALUES (1, 1,
N'Macau scams: when "the police" call you',
N'A caller claims to be from a courier, the police or Bank Negara and says you are linked to a crime. Learn how this script works and why no real officer will ever ask you to move your money.',
N'Real police, BNM, LHDN and courts never ask you to transfer money to a "safe account".
Scammers pass you from a "courier" to a "police officer" to make the story feel official.
Fear and secrecy are the tools: they tell you not to tell family or your bank.
Hang up, then call the agency yourself using a number from its official website.
If you already paid, call the NSRC on 997 immediately.',
N'<p>Telecommunications scams, often called <strong>Macau scams</strong>, are the most common scam type in Malaysia. PDRM recorded 28,698 cases from January to November 2025, with losses of about RM715 million. The script changes, but the pattern stays the same: frighten you, isolate you, then move your money.</p>
<h2>How the script works</h2>
<ol>
<li><strong>The hook.</strong> A recorded message or caller says a parcel in your name contains drugs, your IC was used to open a bank account, or you owe unpaid tax or a summons.</li>
<li><strong>The handover.</strong> You are "transferred" to someone claiming to be a police inspector, a BNM officer or a court official. They may send a fake warrant or a photo of a badge on WhatsApp.</li>
<li><strong>The isolation.</strong> You are told the case is confidential and that telling your family or bank will get you arrested.</li>
<li><strong>The money move.</strong> To "clear your name", you must move your savings to a "safe account" for checking, or share your online banking login so they can "freeze" your money.</li>
</ol>
<blockquote>"Encik, your account is linked to a money laundering case. Do not tell anyone. Transfer your savings to this account for verification and it will be returned within 24 hours."</blockquote>
<h2>Warning signs</h2>
<ul>
<li>An unexpected call about a crime you know nothing about.</li>
<li>Pressure to act right now, often with a deadline of hours.</li>
<li>Being told to keep it secret, even from your bank.</li>
<li>Any request to transfer money, buy gift cards or share a TAC or password.</li>
</ul>
<h2>What to do</h2>
<p>Hang up. You do not need to stay on the line to be polite. Find the agency''s official number yourself and call to check. If you have already transferred money or shared banking details, call the <strong>National Scam Response Centre (NSRC) on 997</strong> straight away so the money can be traced and blocked, then contact your bank.</p>',
N'~/Uploads/Lessons/seed-telecom.png', NULL,
N'MyGOV: NSRC 997 Hotline',
N'https://www.malaysia.gov.my/en/topics/nsrc-997-hotline',
1, DATEADD(DAY, -12, GETDATE()));

/* ---------- 2. E-commerce fraud ---------- */
INSERT INTO dbo.Lessons (LessonID, CategoryID, Title, Summary, KeyPoints, Content, ImagePath, VideoUrl, SourceTitle, SourceUrl, IsPublished, CreatedAt)
VALUES (2, 2,
N'Too-good-to-be-true deals and fake buyers',
N'Fake sellers take your money for goods that never arrive, and fake buyers send payment links that drain your account. Learn to check a seller before you pay and to keep every payment inside the platform.',
N'Very low prices, "only 2 left" and new seller accounts are classic red flags.
Pay only through the platform''s own checkout, never by direct bank transfer.
Check the seller''s phone number and bank account on Semak Mule before paying.
As a seller, never click a "buyer''s" link to "receive" payment; real buyers pay you, not the other way round.
Keep chat screenshots and receipts in case you need to report.',
N'<p>E-commerce fraud was the second most common scam in Malaysia in 2025, with 14,881 cases recorded by PDRM from January to November. It happens on marketplaces, in Facebook and Instagram shops, and in WhatsApp and Telegram groups.</p>
<h2>Two common versions</h2>
<h3>The fake seller</h3>
<p>A shop advertises a phone, concert ticket or branded bag far below the normal price. The seller asks you to pay by bank transfer "to save fees", or moves the chat to WhatsApp. After payment, the item never arrives, or a cheap substitute does, and the account disappears.</p>
<h3>The fake buyer</h3>
<p>You are selling something online. A "buyer" agrees quickly, then sends a link to a page that looks like a courier or marketplace payment page. The page asks for your online banking login or card details so you can "receive" the payment. It is a phishing page, and your account is emptied.</p>
<h2>Warning signs</h2>
<ul>
<li>A price that is much lower than every other shop.</li>
<li>Pressure: "last unit", "promo ends in 1 hour".</li>
<li>A request to pay outside the platform or to a personal account.</li>
<li>A seller account that is new, has no reviews, or has reviews that all look alike.</li>
<li>A buyer who sends you a link to "accept" a payment.</li>
</ul>
<h2>Before you pay</h2>
<p>Search the seller''s phone number and bank account on <strong>Semak Mule</strong> (semakmule.rmp.gov.my), the PDRM portal that lists accounts and numbers linked to police reports. A "no record" result does not prove the seller is safe, but a match is a clear stop sign. Pay through the platform''s checkout so its buyer protection applies.</p>
<p>If you have been cheated, keep the chat history, the listing and your receipt, call <strong>997</strong> if money has just left your account, and make a police report.</p>',
N'~/Uploads/Lessons/seed-ecommerce.png', NULL,
N'PDRM CCID: Semak Mule portal',
N'https://semakmule.rmp.gov.my/',
1, DATEADD(DAY, -10, GETDATE()));

/* ---------- 3. Non-existent investment schemes ---------- */
INSERT INTO dbo.Lessons (LessonID, CategoryID, Title, Summary, KeyPoints, Content, ImagePath, VideoUrl, SourceTitle, SourceUrl, IsPublished, CreatedAt)
VALUES (3, 3,
N'Guaranteed returns: how fake investment groups work',
N'Investment scams cause the biggest losses in Malaysia. They show you fake profits in an app, then invent fees and taxes when you try to withdraw. Learn the signs and how to check whether a company is licensed.',
N'No legitimate investment can guarantee high returns with no risk.
Fake apps show profits that only exist on the screen; withdrawals are always "delayed".
Paying a "tax" or "unlock fee" to withdraw is a sure sign of a scam.
Check every company and app against the SC Investor Alert List and its licence register.
Videos of celebrities or BNM officials promoting a scheme are often deepfakes.',
N'<p>Non-existent investment schemes cause the <strong>largest losses</strong> of any scam in Malaysia. PDRM recorded 9,296 cases from January to November 2025, but losses were about <strong>RM1.37 billion</strong>, more than half of all online scam losses in that period. Victims include professionals and retirees, not just first-time investors.</p>
<h2>How the scheme works</h2>
<ol>
<li><strong>Invitation.</strong> An advert, a deepfake video of a well-known person, or a friendly stranger invites you to a WhatsApp or Telegram "investment class" or "VIP group".</li>
<li><strong>Proof.</strong> The group is full of members posting screenshots of big profits. Most of them are the scammers.</li>
<li><strong>Small win.</strong> You invest a small amount through an app or website and are allowed to withdraw a little profit. This builds trust.</li>
<li><strong>Big deposit.</strong> You are encouraged to invest much more for a "limited" opportunity, often using savings or loans.</li>
<li><strong>The lock.</strong> When you try to withdraw, you are told to pay tax, a "risk deposit" or an account upgrade fee first. Each payment leads to another demand, until the group disappears.</li>
</ol>
<h2>Warning signs</h2>
<ul>
<li>Promises of fixed, high returns, such as "10% a week" or "300% in a month".</li>
<li>Pressure to recruit friends or family.</li>
<li>Payments to personal or unrelated company bank accounts.</li>
<li>An app that is not on the official app stores, or a website that was created recently.</li>
<li>Any fee demanded before you can withdraw your own money.</li>
</ul>
<h2>How to check</h2>
<p>Search the company, website and app name on the <strong>Securities Commission (SC) Investor Alert List</strong>, which lists unauthorised websites, investment products, companies and individuals, and check that the firm appears on the SC''s list of licensed entities. Bank Negara keeps a similar Financial Consumer Alert List. Remember that BNM and the SC do not promote private investment schemes.</p>',
N'~/Uploads/Lessons/seed-investment.png', NULL,
N'Securities Commission Malaysia: Investor Alert List',
N'https://www.sc.com.my/investor-alert',
1, DATEADD(DAY, -8, GETDATE()));

/* ---------- 4. Non-existent loans ---------- */
INSERT INTO dbo.Lessons (LessonID, CategoryID, Title, Summary, KeyPoints, Content, ImagePath, VideoUrl, SourceTitle, SourceUrl, IsPublished, CreatedAt)
VALUES (4, 4,
N'"Loan approved, just pay the fee first"',
N'Fake lenders target people who urgently need cash. They approve you instantly, then keep asking for processing fees, insurance or deposits before releasing a loan that never comes.',
N'A real lender does not ask you to transfer money before the loan is released.
"No CTOS check", "approval in 5 minutes" and "blacklist OK" are bait, not benefits.
Licensed moneylenders are registered with KPKT; check the lender before you apply.
Never send your IC, payslip and bank login together to someone you met on social media.
Once you pay one fee, expect another; stop and report instead.',
N'<p>Non-existent loan scams target people under financial pressure: someone with a medical bill, a small business owner short on cash, or a person rejected by banks. Losses from fake loans reached about RM59.1 million in 2025.</p>
<h2>How it works</h2>
<p>An advert on Facebook, TikTok or a WhatsApp broadcast offers fast loans with no paperwork and no credit check. After you send your details, an "agent" says your loan is approved, often for more than you asked. Then the fees begin:</p>
<ul>
<li>a <strong>processing fee</strong> or <strong>stamp duty</strong>,</li>
<li><strong>insurance</strong> to "protect" the loan,</li>
<li>a <strong>deposit</strong> to prove you can repay,</li>
<li>a <strong>penalty</strong> because you "entered the wrong account number" on the form.</li>
</ul>
<p>Each payment is followed by a new reason to pay again. The loan is never released.</p>
<blockquote>"Tahniah! Pinjaman RM50,000 anda telah diluluskan. Sila bayar yuran guaman RM500 untuk proses pengeluaran hari ini."</blockquote>
<h2>Warning signs</h2>
<ul>
<li>Any request for money before you receive the loan.</li>
<li>Payment to a personal bank account rather than a company account.</li>
<li>Promises such as "no CTOS", "blacklist boleh", or "approved in minutes".</li>
<li>No physical office, no licence number, or a licence number that does not match the company name.</li>
</ul>
<h2>Safer ways to borrow</h2>
<p>Borrow from a bank, a co-operative, or a moneylender licensed by the Ministry of Local Government Development (KPKT), and check the lender''s name before you apply. If you are struggling with debt, AKPK (the Credit Counselling and Debt Management Agency) offers free advice. If you have paid a fake lender, call <strong>997</strong> and make a police report.</p>',
N'~/Uploads/Lessons/seed-loans.png', NULL,
N'Business Today: Biggest Scams in Malaysia in 2025',
N'https://www.businesstoday.com.my/2025/12/24/biggest-scams-in-malaysia-in-2025/',
1, DATEADD(DAY, -6, GETDATE()));

/* ---------- 5. E-finance fraud ---------- */
INSERT INTO dbo.Lessons (LessonID, CategoryID, Title, Summary, KeyPoints, Content, ImagePath, VideoUrl, SourceTitle, SourceUrl, IsPublished, CreatedAt)
VALUES (5, 5,
N'Phishing links, fake apps and your TAC',
N'Scammers do not need to hack your bank. They trick you into handing over your login, TAC or phone through fake websites and malicious APK files. Learn how to keep control of your online banking.',
N'Banks and BNM will never ask for your password, PIN or TAC by phone, SMS or email.
Type your bank''s address yourself or use its official app; do not log in from a link.
Never install APK files sent on WhatsApp or Telegram, even "wedding invitations" or "parcel tracking".
A TAC or in-app approval is your signature: approving it means you agreed to the transaction.
If money moves without your consent, call 997 and your bank''s hotline at once.',
N'<p>E-finance fraud is about taking over your bank account or e-wallet. Between 2024 and May 2026, e-financial crime cost Malaysians about RM660 million, one of the three costliest scam types.</p>
<h2>Three common tricks</h2>
<h3>1. Phishing links</h3>
<p>An SMS, email or social media message claims your account is suspended, a refund is waiting, or you have unpaid tolls or a parcel fee. The link opens a page that copies your bank''s login screen. Whatever you type goes straight to the scammer.</p>
<h3>2. Malicious apps (APK files)</h3>
<p>You receive a file that looks like a digital wedding card, a delivery note or a cleaning service booking. Installing it gives the scammer access to your SMS messages and screen, so they can read your TAC and approve transactions without you seeing.</p>
<h3>3. Asking for your TAC</h3>
<p>A caller pretends to be from your bank or an e-wallet and says a code will be sent "to verify your identity" or "to cancel a suspicious transaction". The code is actually approving a transfer out of your account.</p>
<h2>Warning signs</h2>
<ul>
<li>Spelling mistakes or odd web addresses, such as extra words, numbers or a different ending.</li>
<li>Urgent warnings that your account will be blocked today.</li>
<li>Anyone asking for a TAC, OTP, PIN or password, for any reason.</li>
<li>A request to install an app from outside the Google Play Store or Apple App Store.</li>
</ul>
<h2>Protect yourself</h2>
<ul>
<li>Use your bank''s official app and turn on transaction alerts.</li>
<li>Keep "install unknown apps" switched off on Android.</li>
<li>Learn your bank''s kill switch: most Malaysian banks let you freeze your account from the app or hotline.</li>
</ul>
<p>Bank Negara reminds the public that financial institutions will never ask for personal banking information when they contact you. If you suspect your account is compromised, use your bank''s kill switch and call <strong>997</strong>.</p>',
N'~/Uploads/Lessons/seed-efinance.png', NULL,
N'Bank Negara Malaysia: Beware of scams requesting banking information',
N'https://www.bnm.gov.my/-/beware-of-scams-requesting-for-banking-information',
1, DATEADD(DAY, -4, GETDATE()));

/* ---------- 6. Love scams ---------- */
INSERT INTO dbo.Lessons (LessonID, CategoryID, Title, Summary, KeyPoints, Content, ImagePath, VideoUrl, SourceTitle, SourceUrl, IsPublished, CreatedAt)
VALUES (6, 6,
N'Love scams and the parcel "stuck at customs"',
N'A love scammer spends weeks building a relationship online before the money requests begin: an emergency, a gift held at customs, or a shared investment. Learn the pattern so you can protect yourself and the people you care about.',
N'Love scammers often claim to work overseas: engineer, doctor, soldier, oil-rig worker.
They avoid video calls or always have a reason the camera "is broken".
The first request is often small; later ones are bigger and more urgent.
Customs never collects fees through a personal bank account or a stranger''s phone call.
Talk to someone you trust before sending money to anyone you have only met online.',
N'<p>Love scams (also called romance scams) cause deep emotional harm as well as financial loss. Between 2024 and May 2026, Malaysians lost about RM111 million to love scams. Victims are often lonely, recently divorced or widowed, but anyone can be targeted.</p>
<h2>How it works</h2>
<ol>
<li><strong>Contact.</strong> A friendly message arrives on Facebook, Instagram, a dating app or even a "wrong number" WhatsApp. The profile photos are attractive and professional, often stolen from someone else.</li>
<li><strong>Grooming.</strong> For weeks, the scammer messages every day, remembers details about your life and quickly talks about love, marriage or moving to Malaysia.</li>
<li><strong>The parcel.</strong> They say they have sent you an expensive gift, cash or jewellery. Soon a "courier" or "customs officer" calls: the parcel is held and you must pay tax, an anti-money-laundering certificate, or a fine.</li>
<li><strong>The emergency.</strong> Other versions involve a hospital bill, a frozen bank account abroad, or a "joint investment" for your future together.</li>
</ol>
<blockquote>"Sayang, I sent you a gift for our anniversary. Customs called me, they need RM8,000 to release it. I will pay you back as soon as I land."</blockquote>
<h2>Warning signs</h2>
<ul>
<li>They profess strong feelings very quickly.</li>
<li>They never meet in person or turn on a live video call.</li>
<li>Their story has small inconsistencies that grow over time.</li>
<li>Any request for money, gift cards or crypto, however emotional the reason.</li>
<li>Payment to a personal account for "customs" or "courier" fees.</li>
</ul>
<h2>What to do</h2>
<p>Do a reverse image search on their profile photos. Tell a friend or family member what is happening; scammers rely on secrecy. Stop sending money, keep the messages as evidence, call <strong>997</strong> if you have just transferred money, and make a police report. If a relative is involved, listen without blame: shame keeps many victims silent.</p>',
N'~/Uploads/Lessons/seed-love.png', NULL,
N'theSun: 90% of scam losses linked to investment, telecom and e-financial fraud',
N'https://thesun.my/news/malaysia-news/crime/scam-losses-investment-fraud/',
1, DATEADD(DAY, -2, GETDATE()));

SET IDENTITY_INSERT dbo.Lessons OFF;

PRINT 'Lessons seeded: 6 rows.';
