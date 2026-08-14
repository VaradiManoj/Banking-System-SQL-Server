/* ============================================================
   22. DIGITAL BANKING
   ============================================================ */
CREATE TABLE DigitalBanking (
    DigitalBankingID       INT IDENTITY(1,1) PRIMARY KEY,
    AccountID              INT             NOT NULL UNIQUE,   -- one digital profile per account
    InternetBankingEnabled BIT             NOT NULL DEFAULT 0,
    MobileBankingEnabled   BIT             NOT NULL DEFAULT 0,
    UPIEnabled             BIT             NOT NULL DEFAULT 0,
    UPIID                  VARCHAR(50)     NULL UNIQUE,
    LastPasswordReset      DATETIME2       NULL,
    LastLogin              DATETIME2       NULL,
    LoginStatus            VARCHAR(15)     NOT NULL DEFAULT 'LoggedOut' CHECK (LoginStatus IN ('LoggedIn','LoggedOut','Locked')),
    DeviceRegistered       NVARCHAR(100)   NULL,
    CONSTRAINT FK_DigitalBanking_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
GO