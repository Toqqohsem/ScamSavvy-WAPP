/* ============================================================================
   Scam Savvy - 01_Schema.sql                                      Owner: Ahmad
   Drops and recreates all 14 tables. Running it wipes every table, so run the
   seed scripts 02 to 08 straight after it, in order.

   How to run: Server Explorer > right-click ScamSavvy.mdf > New Query >
   paste or open this file > Execute.

   Delete rules (kept exactly as in the build guide, so SQL Server never sees
   two cascade paths to the same table):
     CASCADE   : child rows go with the parent
     SET NULL  : ScamReports.UserID keeps the report when its author is deleted
     no cascade: the delete is blocked while child rows exist
   ============================================================================ */

-- Drop in reverse dependency order
IF OBJECT_ID('dbo.Feedback', 'U') IS NOT NULL DROP TABLE dbo.Feedback;
IF OBJECT_ID('dbo.QuizAnswers', 'U') IS NOT NULL DROP TABLE dbo.QuizAnswers;
IF OBJECT_ID('dbo.QuizAttempts', 'U') IS NOT NULL DROP TABLE dbo.QuizAttempts;
IF OBJECT_ID('dbo.Questions', 'U') IS NOT NULL DROP TABLE dbo.Questions;
IF OBJECT_ID('dbo.Quizzes', 'U') IS NOT NULL DROP TABLE dbo.Quizzes;
IF OBJECT_ID('dbo.ScenarioAttempts', 'U') IS NOT NULL DROP TABLE dbo.ScenarioAttempts;
IF OBJECT_ID('dbo.ScenarioParts', 'U') IS NOT NULL DROP TABLE dbo.ScenarioParts;
IF OBJECT_ID('dbo.Scenarios', 'U') IS NOT NULL DROP TABLE dbo.Scenarios;
IF OBJECT_ID('dbo.LessonProgress', 'U') IS NOT NULL DROP TABLE dbo.LessonProgress;
IF OBJECT_ID('dbo.Lessons', 'U') IS NOT NULL DROP TABLE dbo.Lessons;
IF OBJECT_ID('dbo.ScamReports', 'U') IS NOT NULL DROP TABLE dbo.ScamReports;
IF OBJECT_ID('dbo.RedFlagKeywords', 'U') IS NOT NULL DROP TABLE dbo.RedFlagKeywords;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

/* ---------- Accounts (Ahmad) ---------- */
CREATE TABLE dbo.Users (
    UserID        INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
    Name          NVARCHAR(100) NOT NULL,
    Email         NVARCHAR(150) NOT NULL CONSTRAINT UQ_Users_Email UNIQUE,
    PasswordHash  NVARCHAR(100) NOT NULL,
    PasswordSalt  NVARCHAR(50)  NOT NULL,
    Mobile        NVARCHAR(15)  NOT NULL,
    Role          NVARCHAR(20)  NOT NULL CONSTRAINT DF_Users_Role DEFAULT 'Member'
                  CONSTRAINT CK_Users_Role CHECK (Role IN ('Member', 'Contributor', 'Admin')),
    IsActive      BIT NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT 1,
    FailedLogins  INT NOT NULL CONSTRAINT DF_Users_FailedLogins DEFAULT 0,
    LockoutEnd    DATETIME NULL,   -- set for 15 minutes after 5 failed logins; an admin can clear it early
    CreatedAt     DATETIME NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT GETDATE()
);
GO

/* ---------- Lessons and progress (Member 2) ---------- */
CREATE TABLE dbo.Categories (
    CategoryID   INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Categories PRIMARY KEY,
    Name         NVARCHAR(100) NOT NULL CONSTRAINT UQ_Categories_Name UNIQUE,
    Description  NVARCHAR(500) NULL,
    SortOrder    INT NOT NULL CONSTRAINT DF_Categories_SortOrder DEFAULT 0
);
GO

CREATE TABLE dbo.Lessons (
    LessonID     INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Lessons PRIMARY KEY,
    CategoryID   INT NOT NULL CONSTRAINT FK_Lessons_Categories REFERENCES dbo.Categories (CategoryID),
    Title        NVARCHAR(150)  NOT NULL,
    Summary      NVARCHAR(500)  NOT NULL,
    KeyPoints    NVARCHAR(1000) NULL,
    Content      NVARCHAR(MAX)  NOT NULL,
    ImagePath    NVARCHAR(260)  NULL,
    VideoUrl     NVARCHAR(300)  NULL,
    SourceTitle  NVARCHAR(200)  NULL,
    SourceUrl    NVARCHAR(300)  NOT NULL,
    IsPublished  BIT NOT NULL CONSTRAINT DF_Lessons_IsPublished DEFAULT 1,
    CreatedAt    DATETIME NOT NULL CONSTRAINT DF_Lessons_CreatedAt DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.LessonProgress (
    UserID       INT NOT NULL CONSTRAINT FK_LessonProgress_Users
                 REFERENCES dbo.Users (UserID) ON DELETE CASCADE,
    LessonID     INT NOT NULL CONSTRAINT FK_LessonProgress_Lessons
                 REFERENCES dbo.Lessons (LessonID) ON DELETE CASCADE,
    CompletedAt  DATETIME NOT NULL CONSTRAINT DF_LessonProgress_CompletedAt DEFAULT GETDATE(),
    CONSTRAINT PK_LessonProgress PRIMARY KEY (UserID, LessonID)
);
GO

/* ---------- Quizzes and Spot the Scam (Member 3) ---------- */
CREATE TABLE dbo.Quizzes (
    QuizID       INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Quizzes PRIMARY KEY,
    CategoryID   INT NOT NULL CONSTRAINT FK_Quizzes_Categories REFERENCES dbo.Categories (CategoryID),
    Title        NVARCHAR(150) NOT NULL,
    Description  NVARCHAR(500) NULL,
    IsPublished  BIT NOT NULL CONSTRAINT DF_Quizzes_IsPublished DEFAULT 1
);
GO

CREATE TABLE dbo.Questions (
    QuestionID     INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Questions PRIMARY KEY,
    QuizID         INT NOT NULL CONSTRAINT FK_Questions_Quizzes
                   REFERENCES dbo.Quizzes (QuizID) ON DELETE CASCADE,
    QuestionText   NVARCHAR(500) NOT NULL,
    OptionA        NVARCHAR(200) NOT NULL,
    OptionB        NVARCHAR(200) NOT NULL,
    OptionC        NVARCHAR(200) NOT NULL,
    OptionD        NVARCHAR(200) NOT NULL,
    CorrectOption  CHAR(1) NOT NULL CONSTRAINT CK_Questions_CorrectOption CHECK (CorrectOption IN ('A', 'B', 'C', 'D')),
    Explanation    NVARCHAR(500) NOT NULL
);
GO

CREATE TABLE dbo.QuizAttempts (
    AttemptID       INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_QuizAttempts PRIMARY KEY,
    UserID          INT NOT NULL CONSTRAINT FK_QuizAttempts_Users
                    REFERENCES dbo.Users (UserID) ON DELETE CASCADE,
    QuizID          INT NOT NULL CONSTRAINT FK_QuizAttempts_Quizzes REFERENCES dbo.Quizzes (QuizID),
    Score           INT NOT NULL,
    TotalQuestions  INT NOT NULL,
    AttemptedAt     DATETIME NOT NULL CONSTRAINT DF_QuizAttempts_AttemptedAt DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.QuizAnswers (
    AttemptID     INT NOT NULL CONSTRAINT FK_QuizAnswers_QuizAttempts
                  REFERENCES dbo.QuizAttempts (AttemptID) ON DELETE CASCADE,
    QuestionID    INT NOT NULL CONSTRAINT FK_QuizAnswers_Questions REFERENCES dbo.Questions (QuestionID),
    ChosenOption  CHAR(1) NOT NULL CONSTRAINT CK_QuizAnswers_ChosenOption CHECK (ChosenOption IN ('A', 'B', 'C', 'D')),
    CONSTRAINT PK_QuizAnswers PRIMARY KEY (AttemptID, QuestionID)
);
GO

CREATE TABLE dbo.Scenarios (
    ScenarioID   INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Scenarios PRIMARY KEY,
    CategoryID   INT NOT NULL CONSTRAINT FK_Scenarios_Categories REFERENCES dbo.Categories (CategoryID),
    Title        NVARCHAR(150) NOT NULL,
    Channel      NVARCHAR(20)  NOT NULL CONSTRAINT CK_Scenarios_Channel CHECK (Channel IN ('SMS', 'WhatsApp', 'Email', 'Call')),
    SenderName   NVARCHAR(100) NOT NULL,
    IsPublished  BIT NOT NULL CONSTRAINT DF_Scenarios_IsPublished DEFAULT 1
);
GO

CREATE TABLE dbo.ScenarioParts (
    PartID       INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ScenarioParts PRIMARY KEY,
    ScenarioID   INT NOT NULL CONSTRAINT FK_ScenarioParts_Scenarios
                 REFERENCES dbo.Scenarios (ScenarioID) ON DELETE CASCADE,
    PartOrder    INT NOT NULL,
    PartText     NVARCHAR(500) NOT NULL,
    IsRedFlag    BIT NOT NULL CONSTRAINT DF_ScenarioParts_IsRedFlag DEFAULT 0,
    Explanation  NVARCHAR(300) NULL
);
GO

CREATE TABLE dbo.ScenarioAttempts (
    ScenarioAttemptID  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ScenarioAttempts PRIMARY KEY,
    UserID             INT NOT NULL CONSTRAINT FK_ScenarioAttempts_Users
                       REFERENCES dbo.Users (UserID) ON DELETE CASCADE,
    ScenarioID         INT NOT NULL CONSTRAINT FK_ScenarioAttempts_Scenarios REFERENCES dbo.Scenarios (ScenarioID),
    FlagsFound         INT NOT NULL,
    FlagsTotal         INT NOT NULL,
    WrongClicks        INT NOT NULL,
    AttemptedAt        DATETIME NOT NULL CONSTRAINT DF_ScenarioAttempts_AttemptedAt DEFAULT GETDATE()
);
GO

/* ---------- Scam repository and checker (Member 4) ---------- */
CREATE TABLE dbo.ScamReports (
    ReportID        INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ScamReports PRIMARY KEY,
    UserID          INT NULL CONSTRAINT FK_ScamReports_Users
                    REFERENCES dbo.Users (UserID) ON DELETE SET NULL,
    CategoryID      INT NOT NULL CONSTRAINT FK_ScamReports_Categories REFERENCES dbo.Categories (CategoryID),
    Title           NVARCHAR(150) NOT NULL,
    Description     NVARCHAR(MAX) NOT NULL,
    ScammerPhone    NVARCHAR(15)  NULL,   -- normalised, e.g. 60123456789
    ScammerAccount  NVARCHAR(20)  NULL,   -- digits only
    ScammerUrl      NVARCHAR(300) NULL,   -- lower case, no http(s)://, www. or trailing /
    EvidencePath    NVARCHAR(260) NULL,
    Status          NVARCHAR(20)  NOT NULL CONSTRAINT DF_ScamReports_Status DEFAULT 'Pending'
                    CONSTRAINT CK_ScamReports_Status CHECK (Status IN ('Pending', 'Approved', 'Rejected')),
    IsSample        BIT NOT NULL CONSTRAINT DF_ScamReports_IsSample DEFAULT 0,
    CreatedAt       DATETIME NOT NULL CONSTRAINT DF_ScamReports_CreatedAt DEFAULT GETDATE(),
    ReviewedBy      INT NULL CONSTRAINT FK_ScamReports_ReviewedBy REFERENCES dbo.Users (UserID),
    ReviewedAt      DATETIME NULL
);
GO

-- The repository search and the Scam Checker look reports up by these columns.
CREATE INDEX IX_ScamReports_Status ON dbo.ScamReports (Status);
CREATE INDEX IX_ScamReports_ScammerPhone ON dbo.ScamReports (ScammerPhone);
CREATE INDEX IX_ScamReports_ScammerAccount ON dbo.ScamReports (ScammerAccount);
CREATE INDEX IX_ScamReports_ScammerUrl ON dbo.ScamReports (ScammerUrl);
GO

CREATE TABLE dbo.RedFlagKeywords (
    KeywordID    INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_RedFlagKeywords PRIMARY KEY,
    Keyword      NVARCHAR(100) NOT NULL CONSTRAINT UQ_RedFlagKeywords_Keyword UNIQUE,
    Language     CHAR(2) NOT NULL CONSTRAINT CK_RedFlagKeywords_Language CHECK (Language IN ('EN', 'BM')),
    Weight       INT NOT NULL CONSTRAINT CK_RedFlagKeywords_Weight CHECK (Weight BETWEEN 1 AND 3),
    Explanation  NVARCHAR(300) NOT NULL
);
GO

/* ---------- Feedback (Lyu Jiaxin) ---------- */
CREATE TABLE dbo.Feedback (
    FeedbackID  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Feedback PRIMARY KEY,
    UserID      INT NULL CONSTRAINT FK_Feedback_Users
                REFERENCES dbo.Users (UserID) ON DELETE SET NULL,   -- set when a logged-in member sends it
    Name        NVARCHAR(100)  NOT NULL,
    Email       NVARCHAR(150)  NOT NULL,
    Phone       NVARCHAR(20)   NULL,
    Category    NVARCHAR(30)   NOT NULL CONSTRAINT CK_Feedback_Category
                CHECK (Category IN ('General', 'Lessons', 'Quizzes', 'SpotTheScam', 'ScamRepository', 'Bug', 'Suggestion')),
    Rating      INT NOT NULL CONSTRAINT CK_Feedback_Rating CHECK (Rating BETWEEN 1 AND 5),
    Message     NVARCHAR(2000) NOT NULL,
    Status      NVARCHAR(20)   NOT NULL CONSTRAINT DF_Feedback_Status DEFAULT 'Pending'
                CONSTRAINT CK_Feedback_Status CHECK (Status IN ('Pending', 'Reviewed', 'Resolved', 'Rejected')),
    CreatedAt   DATETIME NOT NULL CONSTRAINT DF_Feedback_CreatedAt DEFAULT GETDATE()
);
GO
