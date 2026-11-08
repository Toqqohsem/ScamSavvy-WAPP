-- 02_Seed_Users.sql (Ahmad): test accounts, password Test@1234.

SET IDENTITY_INSERT dbo.Users ON;

INSERT INTO dbo.Users (UserID, Name, Email, PasswordHash, PasswordSalt, Mobile, Role)
VALUES
    (1, N'Site Admin', N'admin@scamsavvy.test', N'hdNfH2tI10cqey7Lk6r05jx8aRYWY00Erbztc/qs5Yc=', N'83Nryg4Ia9wC0QVhtf5f5w==', N'012-3456701', N'Admin'),
    (2, N'Nur Contributor', N'contributor@scamsavvy.test', N'8EqSG+R3Nge2IwRLbaNp6wfEmYtCPf06yaTyqvG4Huo=', N'6x9SuHxpbvVsl+8GTEmtqw==', N'012-3456702', N'Contributor'),
    (3, N'Member One', N'member1@scamsavvy.test', N'UF17QwYwzzmI0GEa4FJL1KW6oaLdCy0U0fKHzBmerNM=', N'beMvtVl2BTGjmfNIFEd0cg==', N'012-3456703', N'Member'),
    (4, N'Member Two', N'member2@scamsavvy.test', N'uZplWo1Bed17TSeUkx4xdLl37MbX/iubydKBMCSD7Aw=', N'tMpbzM8ZoI78Hbqj1cScbg==', N'012-3456704', N'Member');

SET IDENTITY_INSERT dbo.Users OFF;
GO
