# TradeNetFB SQL Server Database

## 📖 Overview
This project models a **Trade Governance System** in SQL Server.  
It manages businesses, licenses, transactions, compliance, audits, and reporting — ensuring trade is transparent and well-documented.

---

## 🏗️ Database Structure (Visual Explanation)

### Core Entities
- **Business** → Registered companies.
- **AppUser** → System users (Admin, Officer, Auditor, etc.).
- **BusinessTransaction** → Sales and purchases.
- **TradeLicense** → Permissions granted to businesses.

### Supporting Entities
- **BusinessDocument** → Certificates and proofs for businesses.
- **LicenseDocument** → Documents tied to licenses.
- **TradeProgram** → Government initiatives.
- **Resource** → Assets allocated to programs.

### Oversight & Governance
- **ComplianceRecord** → Results of compliance checks.
- **Audit** → Official inspections.
- **AuditLog** → Actions taken during audits.
- **Notification** → Alerts sent to users.
- **MarketRecord** → Market regulation notes.
- **Report** → Summaries and analytics.

---

## 🔗 Relationships (Textual ER Diagram)

Business ──┐
├── TradeLicense ── LicenseDocument
├── BusinessTransaction ── MarketRecord
└── BusinessDocument

TradeProgram ── Resource

ComplianceRecord ── links to License / Program / Transaction

AppUser ──┐
├── Audit ── AuditLog
└── Notification
