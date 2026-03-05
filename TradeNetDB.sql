CREATE DATABASE tradenet;
USE tradenet;



-- Business table
CREATE TABLE Business (
    BusinessID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Type VARCHAR(50),
    Address VARCHAR(200),
    ContactInfo VARCHAR(100),
    Status VARCHAR(50)
);


-- AppUser table (renamed from User)
CREATE TABLE AppUser (
    UserID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Status VARCHAR(50)
);

-- BusinessTransaction table (renamed from Transaction)
CREATE TABLE BusinessTransaction (
    TransactionID INT PRIMARY KEY,
    BusinessID INT,
    Type VARCHAR(50),
    Amount DECIMAL(15,2),
    Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (BusinessID) REFERENCES Business(BusinessID)
);

-- TradeLicense table
CREATE TABLE TradeLicense (
    LicenseID INT PRIMARY KEY,
    BusinessID INT,
    Type VARCHAR(50),
    IssuedDate DATE,
    ExpiryDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (BusinessID) REFERENCES Business(BusinessID)
);

-- TradeProgram table
CREATE TABLE TradeProgram (
    ProgramID INT PRIMARY KEY,
    Title VARCHAR(100),
    Description TEXT,
    StartDate DATE,
    EndDate DATE,
    Budget DECIMAL(15,2),
    Status VARCHAR(50)
);

-- Resource table
CREATE TABLE Resource (
    ResourceID INT PRIMARY KEY,
    ProgramID INT,
    Type VARCHAR(50),
    Quantity INT,
    Status VARCHAR(50),
    FOREIGN KEY (ProgramID) REFERENCES TradeProgram(ProgramID)
);

-- BusinessDocument table
CREATE TABLE BusinessDocument (
    DocumentID INT PRIMARY KEY,
    BusinessID INT,
    DocType VARCHAR(50),
    FileURI VARCHAR(200),
    UploadedDate DATE,
    VerificationStatus VARCHAR(50),
    FOREIGN KEY (BusinessID) REFERENCES Business(BusinessID)
);

-- LicenseDocument table
CREATE TABLE LicenseDocument (
    DocumentID INT PRIMARY KEY,
    LicenseID INT,
    DocType VARCHAR(50),
    FileURI VARCHAR(200),
    UploadedDate DATE,
    VerificationStatus VARCHAR(50),
    FOREIGN KEY (LicenseID) REFERENCES TradeLicense(LicenseID)
);

-- ComplianceRecord table
CREATE TABLE ComplianceRecord (
    ComplianceID INT PRIMARY KEY,
    EntityID INT,
    Type VARCHAR(50),
    Result VARCHAR(50),
    Date DATE,
    Notes TEXT,
    LicenseID INT,
    ProgramID INT,
    TransactionID INT,
    FOREIGN KEY (LicenseID) REFERENCES TradeLicense(LicenseID),
    FOREIGN KEY (ProgramID) REFERENCES TradeProgram(ProgramID),
    FOREIGN KEY (TransactionID) REFERENCES BusinessTransaction(TransactionID)
);

-- Audit table
CREATE TABLE Audit (
    AuditID INT PRIMARY KEY,
    OfficerID INT,
    Scope VARCHAR(100),
    Findings TEXT,
    Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (OfficerID) REFERENCES AppUser(UserID)
);

-- AuditLog table
CREATE TABLE AuditLog (
    AuditID INT,
    UserID INT,
    Action VARCHAR(100),
    Resource VARCHAR(100),
    Timestamp DATETIME,
    PRIMARY KEY (AuditID, UserID),
    FOREIGN KEY (AuditID) REFERENCES Audit(AuditID),
    FOREIGN KEY (UserID) REFERENCES AppUser(UserID)
);

-- Notification table
CREATE TABLE Notification (
    NotificationID INT PRIMARY KEY,
    UserID INT,
    EntityID INT,
    Message TEXT,
    Category VARCHAR(50),
    Status VARCHAR(50),
    CreatedDate DATETIME,
    FOREIGN KEY (UserID) REFERENCES AppUser(UserID)
);

-- MarketRecord table
CREATE TABLE MarketRecord (
    RecordID INT PRIMARY KEY,
    TransactionID INT,
    OfficerID INT,
    Notes TEXT,
    Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (TransactionID) REFERENCES BusinessTransaction(TransactionID),
    FOREIGN KEY (OfficerID) REFERENCES AppUser(UserID)
);

-- Report table
CREATE TABLE Report (
    ReportID INT PRIMARY KEY,
    Scope VARCHAR(100),
    Metrics TEXT,
    GeneratedDate DATE
);

--adding some dummy data to the DB so it can be understood clearly

-- Business
INSERT INTO Business (BusinessID, Name, Type, Address, ContactInfo, Status)
VALUES 
(1, 'Global Traders Ltd', 'Retail', '123 Market Street, Chennai', 'info@globaltraders.com', 'Active'),
(2, 'Sunrise Exports', 'Export', '45 Harbor Road, Mumbai', 'contact@sunriseexports.com', 'Active'),
(3, 'Evergreen Imports', 'Import', '78 Green Lane, Delhi', 'evergreen@imports.com', 'Active'),
(4, 'Blue Ocean Shipping', 'Logistics', '12 Dockyard Road, Kochi', 'blueocean@shipping.com', 'Inactive'),
(5, 'Silverline Textiles', 'Manufacturing', '56 Textile Park, Surat', 'silverline@textiles.com', 'Active');

-- AppUser
INSERT INTO AppUser (UserID, Name, Role, Email, Phone, Status)
VALUES
(1, 'Ravi Kumar', 'Admin', 'ravi.kumar@tradenet.com', '9876543210', 'Active'),
(2, 'Anita Sharma', 'Officer', 'anita.sharma@tradenet.com', '9123456780', 'Active'),
(3, 'Sai Raju', 'Manager', 'sai.raju@tradenet.com', '9876543211', 'Active'),
(4, 'Chaitanya Kumar', 'Compliance', 'chaitanya.kumar@tradenet.com', '9876543212', 'Active'),
(5, 'Meera Nair', 'Auditor', 'meera.nair@tradenet.com', '9876543213', 'Active');

-- BusinessTransaction
INSERT INTO BusinessTransaction (TransactionID, BusinessID, Type, Amount, Date, Status)
VALUES
(1, 1, 'Sale', 150000.00, '2026-02-15', 'Completed'),
(2, 2, 'Purchase', 250000.00, '2026-02-20', 'Pending'),
(3, 3, 'Sale', 100000.00, '2026-02-22', 'Completed'),
(4, 4, 'Purchase', 50000.00, '2026-02-25', 'Cancelled'),
(5, 5, 'Sale', 300000.00, '2026-03-01', 'Completed');

-- TradeLicense
INSERT INTO TradeLicense (LicenseID, BusinessID, Type, IssuedDate, ExpiryDate, Status)
VALUES
(1, 1, 'Import License', '2025-01-01', '2026-01-01', 'Valid'),
(2, 2, 'Export License', '2025-06-01', '2026-06-01', 'Valid'),
(3, 3, 'Local License', '2025-07-01', '2026-07-01', 'Expired'),
(4, 4, 'Import License', '2025-08-01', '2026-08-01', 'Valid'),
(5, 5, 'Export License', '2025-09-01', '2026-09-01', 'Valid');

-- TradeProgram
INSERT INTO TradeProgram (ProgramID, Title, Description, StartDate, EndDate, Budget, Status)
VALUES
(1, 'Market Expansion Program', 'Expand into new regions', '2025-09-01', '2026-09-01', 500000.00, 'Ongoing'),
(2, 'Export Promotion Scheme', 'Support exporters with subsidies', '2025-01-01', '2026-01-01', 300000.00, 'Completed'),
(3, 'Logistics Upgrade', 'Improve shipping infrastructure', '2025-05-01', '2026-05-01', 700000.00, 'Ongoing'),
(4, 'Textile Boost Program', 'Support textile manufacturers', '2025-03-01', '2026-03-01', 400000.00, 'Ongoing'),
(5, 'Green Trade Initiative', 'Eco-friendly trade practices', '2025-02-01', '2026-02-01', 600000.00, 'Completed');

-- Resource
INSERT INTO Resource (ResourceID, ProgramID, Type, Quantity, Status)
VALUES
(1, 1, 'Trucks', 10, 'Available'),
(2, 1, 'Warehouses', 2, 'In Use'),
(3, 2, 'Funds', 100000, 'Allocated'),
(4, 3, 'Ships', 5, 'Available'),
(5, 4, 'Materials', 2000, 'Distributed');

-- BusinessDocument
INSERT INTO BusinessDocument (DocumentID, BusinessID, DocType, FileURI, UploadedDate, VerificationStatus)
VALUES
(1, 1, 'Registration Certificate', '/docs/business1_reg.pdf', '2025-12-01', 'Verified'),
(2, 2, 'Tax Certificate', '/docs/business2_tax.pdf', '2025-12-10', 'Pending'),
(3, 3, 'ID Proof', '/docs/business3_id.pdf', '2025-12-15', 'Verified'),
(4, 4, 'License Copy', '/docs/business4_license.pdf', '2025-12-20', 'Rejected'),
(5, 5, 'GST Certificate', '/docs/business5_gst.pdf', '2025-12-25', 'Verified');

-- LicenseDocument
INSERT INTO LicenseDocument (DocumentID, LicenseID, DocType, FileURI, UploadedDate, VerificationStatus)
VALUES
(1, 1, 'Application', '/docs/license1_app.pdf', '2025-12-05', 'Verified'),
(2, 2, 'Approval', '/docs/license2_approval.pdf', '2025-12-15', 'Verified'),
(3, 3, 'Application', '/docs/license3_app.pdf', '2025-12-20', 'Pending'),
(4, 4, 'Approval', '/docs/license4_approval.pdf', '2025-12-25', 'Verified'),
(5, 5, 'Application', '/docs/license5_app.pdf', '2025-12-30', 'Rejected');

-- ComplianceRecord
INSERT INTO ComplianceRecord (ComplianceID, EntityID, Type, Result, Date, Notes, LicenseID, ProgramID, TransactionID)
VALUES
(1, 1, 'Safety Audit', 'Pass', '2026-01-10', 'All standards met', 1, 1, 1),
(2, 2, 'Financial Audit', 'Fail', '2026-01-20', 'Issues in reporting', 2, 2, 2),
(3, 3, 'Program Review', 'Pass', '2026-01-25', 'Program objectives met', 3, 3, 3),
(4, 4, 'Transaction Check', 'Pass', '2026-02-01', 'Transaction verified', 4, 4, 4),
(5, 5, 'License Review', 'Fail', '2026-02-05', 'Expired license', 5, 5, 5);

-- Audit
INSERT INTO Audit (AuditID, OfficerID, Scope, Findings, Date, Status)
VALUES
(1, 2, 'Business Compliance', 'Minor issues found', '2026-02-01', 'Closed'),
(2, 4, 'License Audit', 'Expired license detected', '2026-02-05', 'Open'),
(3, 5, 'Program Audit', 'Budget exceeded', '2026-02-10', 'Closed'),
(4, 2, 'Transaction Audit', 'Fraudulent transaction flagged', '2026-02-15', 'Open'),
(5, 4, 'Market Audit', 'Market irregularities found', '2026-02-20', 'Closed');

-- AuditLog
INSERT INTO AuditLog (AuditID, UserID, Action, Resource, Timestamp)
VALUES
(1, 1, 'Reviewed Compliance Report', 'ComplianceRecord', '2026-02-01 10:30:00'),
(2, 2, 'Validated License', 'TradeLicense', '2026-02-05 11:00:00'),
(3, 3, 'Created Program', 'TradeProgram', '2026-02-10 09:15:00'),
(4, 4, 'Checked Transaction', 'BusinessTransaction', '2026-02-15 14:45:00'),
(5, 5, 'Reviewed Market Record', 'MarketRecord', '2026-02-20 16:20:00');

-- Notification
INSERT INTO Notification (NotificationID, UserID, EntityID, Message, Category, Status, CreatedDate)
VALUES
(1, 1, 1, 'Compliance record updated', 'Compliance', 'Unread', '2026-02-02 09:00:00'),
(2, 2, 2, 'License approved', 'License', 'Read', '2026-02-05 10:00:00'),
(3, 3, 3, 'New trade program assigned', 'Program', 'Unread', '2026-02-10 08:30:00'),
(4, 4, 4, 'Transaction flagged for review', 'Transaction', 'Unread', '2026-02-15 12:00:00'),
(5, 5, 5, 'Audit report available', 'Audit', 'Read', '2026-02-20 17:45:00');

-- MarketRecord
INSERT INTO MarketRecord (RecordID, TransactionID, OfficerID, Notes, Date, Status)
VALUES
(1, 1, 2, 'Transaction verified successfully', '2026-02-16', 'Approved'),
(2, 2, 2, 'Pending verification due to missing docs', '2026-02-20', 'Pending'),
(3, 3, 2, 'Transaction cleared without issues', '2026-02-22', 'Approved'),
(4, 4, 4, 'Cancelled transaction logged', '2026-02-25', 'Closed'),
(5, 5, 2, 'Large sale transaction reviewed', '2026-03-01', 'Approved');

-- Report
INSERT INTO Report (ReportID, Scope, Metrics, GeneratedDate)
VALUES
(1, 'Annual Trade Report', 'Revenue: 1.2M, Growth: 15%', '2026-02-28'),
(2, 'License Report', 'Valid: 4, Expired: 1', '2026-02-28'),
(3, 'Transaction Report', 'Completed: 3, Pending: 1, Cancelled: 1', '2026-02-28'),
(4, 'Program Efficiency Report', 'Ongoing: 3, Completed: 2', '2026-02-28'),
(5, 'Compliance Summary', 'Pass: 3, Fail: 2', '2026-02-28');

SELECT * FROM Business;

SELECT * FROM AppUser;