CREATE DATABASE IF NOT EXISTS tradenet;
USE tradenet;

-- =============================================
-- USER MANAGEMENT TABLE
-- =============================================
CREATE TABLE IF NOT EXISTS User (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    Status VARCHAR(50),
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- BUSINESS TABLES
-- =============================================
CREATE TABLE IF NOT EXISTS Business (
    BusinessID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Type VARCHAR(50),
    Address VARCHAR(200),
    ContactInfo VARCHAR(100),
    Status VARCHAR(50),
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS BusinessDocument (
    DocumentID INT PRIMARY KEY AUTO_INCREMENT,
    BusinessID INT NOT NULL,
    DocType VARCHAR(50),
    FileURI VARCHAR(200),
    UploadedDate DATE,
    VerificationStatus VARCHAR(50),
    FOREIGN KEY (BusinessID) REFERENCES Business(BusinessID) ON DELETE CASCADE
);

-- =============================================
-- LICENSE TABLES
-- =============================================
CREATE TABLE IF NOT EXISTS TradeLicense (
    LicenseID INT PRIMARY KEY AUTO_INCREMENT,
    BusinessID INT NOT NULL,
    Type VARCHAR(50),
    IssuedDate DATE,
    ExpiryDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (BusinessID) REFERENCES Business(BusinessID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS LicenseDocument (
    DocumentID INT PRIMARY KEY AUTO_INCREMENT,
    LicenseID INT NOT NULL,
    DocType VARCHAR(50),
    FileURI VARCHAR(200),
    UploadedDate DATE,
    VerificationStatus VARCHAR(50),
    FOREIGN KEY (LicenseID) REFERENCES TradeLicense(LicenseID) ON DELETE CASCADE
);

-- =============================================
-- TRANSACTION TABLES
-- =============================================
CREATE TABLE IF NOT EXISTS Transaction (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    BusinessID INT NOT NULL,
    Type VARCHAR(50),
    Amount DECIMAL(15,2),
    Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (BusinessID) REFERENCES Business(BusinessID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS MarketRecord (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    TransactionID INT NOT NULL,
    OfficerID INT NOT NULL,
    Notes TEXT,
    Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (TransactionID) REFERENCES Transaction(TransactionID) ON DELETE CASCADE,
    FOREIGN KEY (OfficerID) REFERENCES User(UserID) ON DELETE SET NULL
);

-- =============================================
-- TRADE PROGRAM & RESOURCES
-- =============================================
CREATE TABLE IF NOT EXISTS TradeProgram (
    ProgramID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100),
    Description TEXT,
    StartDate DATE,
    EndDate DATE,
    Budget DECIMAL(15,2),
    Status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Resource (
    ResourceID INT PRIMARY KEY AUTO_INCREMENT,
    ProgramID INT NOT NULL,
    Type VARCHAR(50),
    Quantity INT,
    Status VARCHAR(50),
    FOREIGN KEY (ProgramID) REFERENCES TradeProgram(ProgramID) ON DELETE CASCADE
);

-- =============================================
-- COMPLIANCE & AUDIT TABLES
-- =============================================
CREATE TABLE IF NOT EXISTS ComplianceRecord (
    ComplianceID INT PRIMARY KEY AUTO_INCREMENT,
    EntityID INT,
    Type VARCHAR(50),
    Result VARCHAR(50),
    Date DATE,
    Notes TEXT,
    LicenseID INT,
    ProgramID INT,
    TransactionID INT,
    FOREIGN KEY (LicenseID) REFERENCES TradeLicense(LicenseID) ON DELETE SET NULL,
    FOREIGN KEY (ProgramID) REFERENCES TradeProgram(ProgramID) ON DELETE SET NULL,
    FOREIGN KEY (TransactionID) REFERENCES Transaction(TransactionID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Audit (
    AuditID INT PRIMARY KEY AUTO_INCREMENT,
    OfficerID INT NOT NULL,
    Scope VARCHAR(100),
    Findings TEXT,
    Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (OfficerID) REFERENCES User(UserID) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS AuditLog (
    AuditLogID INT PRIMARY KEY AUTO_INCREMENT,
    AuditID INT NOT NULL,
    UserID INT NOT NULL,
    Action VARCHAR(100),
    Resource VARCHAR(100),
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AuditID) REFERENCES Audit(AuditID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

-- =============================================
-- NOTIFICATIONS & REPORTING
-- =============================================
CREATE TABLE IF NOT EXISTS Notification (
    NotificationID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    EntityID INT,
    Message TEXT,
    Category VARCHAR(50),
    Status VARCHAR(50),
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Report (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    Scope VARCHAR(100),
    Metrics TEXT,
    GeneratedDate DATE DEFAULT CURDATE()
);

-- =============================================
-- SAMPLE DATA
-- =============================================

-- Insert User Data
INSERT INTO User (Name, Role, Email, Phone, Status) VALUES 
('Ravi Kumar', 'Admin', 'ravi.kumar@tradenet.com', '9876543210', 'Active'),
('Anita Sharma', 'Officer', 'anita.sharma@tradenet.com', '9123456780', 'Active'),
('Sai Raju', 'Manager', 'sai.raju@tradenet.com', '9876543211', 'Active'),
('Chaitanya Kumar', 'Compliance', 'chaitanya.kumar@tradenet.com', '9876543212', 'Active'),
('Meera Nair', 'Auditor', 'meera.nair@tradenet.com', '9876543213', 'Active');

-- Insert Business Data
INSERT INTO Business (Name, Type, Address, ContactInfo, Status) VALUES 
('Global Traders Ltd', 'Retail', '123 Market Street, Chennai', 'info@globaltraders.com', 'Active'),
('Sunrise Exports', 'Export', '45 Harbor Road, Mumbai', 'contact@sunriseexports.com', 'Active'),
('Evergreen Imports', 'Import', '78 Green Lane, Delhi', 'evergreen@imports.com', 'Active'),
('Blue Ocean Shipping', 'Logistics', '12 Dockyard Road, Kochi', 'blueocean@shipping.com', 'Inactive'),
('Silverline Textiles', 'Manufacturing', '56 Textile Park, Surat', 'silverline@textiles.com', 'Active');

-- Insert Transaction Data
INSERT INTO Transaction (BusinessID, Type, Amount, Date, Status) VALUES
(1, 'Sale', 150000.00, '2026-02-15', 'Completed'),
(2, 'Purchase', 250000.00, '2026-02-20', 'Pending'),
(3, 'Sale', 100000.00, '2026-02-22', 'Completed'),
(4, 'Purchase', 50000.00, '2026-02-25', 'Cancelled'),
(5, 'Sale', 300000.00, '2026-03-01', 'Completed');

-- Insert TradeLicense Data
INSERT INTO TradeLicense (BusinessID, Type, IssuedDate, ExpiryDate, Status) VALUES
(1, 'Import License', '2025-01-01', '2026-01-01', 'Valid'),
(2, 'Export License', '2025-06-01', '2026-06-01', 'Valid'),
(3, 'Local License', '2025-07-01', '2026-07-01', 'Expired'),
(4, 'Import License', '2025-08-01', '2026-08-01', 'Valid'),
(5, 'Export License', '2025-09-01', '2026-09-01', 'Valid');

-- Insert TradeProgram Data
INSERT INTO TradeProgram (Title, Description, StartDate, EndDate, Budget, Status) VALUES
('Market Expansion Program', 'Expand into new regions', '2025-09-01', '2026-09-01', 500000.00, 'Ongoing'),
('Export Promotion Scheme', 'Support exporters with subsidies', '2025-01-01', '2026-01-01', 300000.00, 'Completed'),
('Logistics Upgrade', 'Improve shipping infrastructure', '2025-05-01', '2026-05-01', 700000.00, 'Ongoing'),
('Textile Boost Program', 'Support textile manufacturers', '2025-03-01', '2026-03-01', 400000.00, 'Ongoing'),
('Green Trade Initiative', 'Eco-friendly trade practices', '2025-02-01', '2026-02-01', 600000.00, 'Completed');

-- Insert Resource Data
INSERT INTO Resource (ProgramID, Type, Quantity, Status) VALUES
(1, 'Trucks', 10, 'Available'),
(1, 'Warehouses', 2, 'In Use'),
(2, 'Funds', 100000, 'Allocated'),
(3, 'Ships', 5, 'Available'),
(4, 'Materials', 2000, 'Distributed');

-- Insert BusinessDocument Data
INSERT INTO BusinessDocument (BusinessID, DocType, FileURI, UploadedDate, VerificationStatus) VALUES
(1, 'Registration Certificate', '/docs/business1_reg.pdf', '2025-12-01', 'Verified'),
(2, 'Tax Certificate', '/docs/business2_tax.pdf', '2025-12-10', 'Pending'),
(3, 'ID Proof', '/docs/business3_id.pdf', '2025-12-15', 'Verified'),
(4, 'License Copy', '/docs/business4_license.pdf', '2025-12-20', 'Rejected'),
(5, 'GST Certificate', '/docs/business5_gst.pdf', '2025-12-25', 'Verified');

-- Insert LicenseDocument Data
INSERT INTO LicenseDocument (LicenseID, DocType, FileURI, UploadedDate, VerificationStatus) VALUES
(1, 'Application', '/docs/license1_app.pdf', '2025-12-05', 'Verified'),
(2, 'Approval', '/docs/license2_approval.pdf', '2025-12-15', 'Verified'),
(3, 'Application', '/docs/license3_app.pdf', '2025-12-20', 'Pending'),
(4, 'Approval', '/docs/license4_approval.pdf', '2025-12-25', 'Verified'),
(5, 'Application', '/docs/license5_app.pdf', '2025-12-30', 'Rejected');

-- Insert ComplianceRecord Data
INSERT INTO ComplianceRecord (EntityID, Type, Result, Date, Notes, LicenseID, ProgramID, TransactionID) VALUES
(1, 'Safety Audit', 'Pass', '2026-01-10', 'All standards met', 1, 1, 1),
(2, 'Financial Audit', 'Fail', '2026-01-20', 'Issues in reporting', 2, 2, 2),
(3, 'Program Review', 'Pass', '2026-01-25', 'Program objectives met', 3, 3, 3),
(4, 'Transaction Check', 'Pass', '2026-02-01', 'Transaction verified', 4, 4, 4),
(5, 'License Review', 'Fail', '2026-02-05', 'Expired license', 5, 5, 5);

-- Insert Audit Data
INSERT INTO Audit (OfficerID, Scope, Findings, Date, Status) VALUES
(2, 'Business Compliance', 'Minor issues found', '2026-02-01', 'Closed'),
(4, 'License Audit', 'Expired license detected', '2026-02-05', 'Open'),
(5, 'Program Audit', 'Budget exceeded', '2026-02-10', 'Closed'),
(2, 'Transaction Audit', 'Fraudulent transaction flagged', '2026-02-15', 'Open'),
(4, 'Market Audit', 'Market irregularities found', '2026-02-20', 'Closed');

-- Insert AuditLog Data
INSERT INTO AuditLog (AuditID, UserID, Action, Resource, Timestamp) VALUES
(1, 1, 'Reviewed Compliance Report', 'ComplianceRecord', '2026-02-01 10:30:00'),
(2, 2, 'Validated License', 'TradeLicense', '2026-02-05 11:00:00'),
(3, 3, 'Created Program', 'TradeProgram', '2026-02-10 09:15:00'),
(4, 4, 'Checked Transaction', 'Transaction', '2026-02-15 14:45:00'),
(5, 5, 'Reviewed Market Record', 'MarketRecord', '2026-02-20 16:20:00');

-- Insert Notification Data
INSERT INTO Notification (UserID, EntityID, Message, Category, Status, CreatedDate) VALUES
(1, 1, 'Compliance record updated', 'Compliance', 'Unread', '2026-02-02 09:00:00'),
(2, 2, 'License approved', 'License', 'Read', '2026-02-05 10:00:00'),
(3, 3, 'New trade program assigned', 'Program', 'Unread', '2026-02-10 08:30:00'),
(4, 4, 'Transaction flagged for review', 'Transaction', 'Unread', '2026-02-15 12:00:00'),
(5, 5, 'Audit report available', 'Audit', 'Read', '2026-02-20 17:45:00');

-- Insert MarketRecord Data
INSERT INTO MarketRecord (TransactionID, OfficerID, Notes, Date, Status) VALUES
(1, 2, 'Transaction verified successfully', '2026-02-16', 'Approved'),
(2, 2, 'Pending verification due to missing docs', '2026-02-20', 'Pending'),
(3, 2, 'Transaction cleared without issues', '2026-02-22', 'Approved'),
(4, 4, 'Cancelled transaction logged', '2026-02-25', 'Closed'),
(5, 2, 'Large sale transaction reviewed', '2026-03-01', 'Approved');

-- Insert Report Data
INSERT INTO Report (Scope, Metrics, GeneratedDate) VALUES
('Annual Trade Report', 'Revenue: 1.2M, Growth: 15%', '2026-02-28'),
('License Report', 'Valid: 4, Expired: 1', '2026-02-28'),
('Transaction Report', 'Completed: 3, Pending: 1, Cancelled: 1', '2026-02-28'),
('Program Efficiency Report', 'Ongoing: 3, Completed: 2', '2026-02-28'),
('Compliance Summary', 'Pass: 3, Fail: 2', '2026-02-28');

-- =============================================
-- VIEW SAMPLE DATA
-- =============================================
SELECT * FROM User;
SELECT * FROM Business;
SELECT * FROM Transaction;
SELECT * FROM TradeLicense;
SELECT * FROM TradeProgram;
SELECT * FROM Report;
