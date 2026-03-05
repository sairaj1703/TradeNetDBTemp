-- TradeNetDB.sql

-- Table Definitions

CREATE TABLE Report (
    report_id INT PRIMARY KEY,
    report_name VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Notification (
    notification_id INT PRIMARY KEY,
    user_id INT,
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE MarketRecord (
    market_record_id INT PRIMARY KEY,
    symbol VARCHAR(10),
    price DECIMAL(10, 2),
    volume INT,
    recorded_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ComplianceRecord (
    compliance_record_id INT PRIMARY KEY,
    user_id INT,
    report_id INT,
    status VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (report_id) REFERENCES Report(report_id)
);

CREATE TABLE Audit (
    audit_id INT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE AuditLog (
    audit_log_id INT PRIMARY KEY,
    audit_id INT,
    details TEXT,
    FOREIGN KEY (audit_id) REFERENCES Audit(audit_id)
);