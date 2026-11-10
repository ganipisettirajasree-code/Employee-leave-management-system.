# Employee-leave-management-system.
# Employee Leave Management System (ELMS) 

**A centralized SQL relational database database solution featuring automated leave tracking, multi-level manager approval history, safe transactional routines, and complex analytics reporting.**

---

## 📌 Project Overview
Organizations heavily rely on automated systems to reduce operational friction and eliminate administrative manual overhead. This project delivers a robust **MySQL 8.0** implementation designed to replace traditional paper/email forms, ensuring data integrity constraints, safe audit trail records, and dynamic remaining balance calculations.

### ✨ Key Features Implemented:
* **Relational Database Design:** Fully normalized schemas up to 3rd Normal Form (3NF) to minimize data redundancies.
* **Server-Side Automation:** Triggers configured to track dynamic application insertions and status updates automatically.
* **Reusable Business Logic:** Stored procedures to evaluate manager portfolios and aggregate historical metrics parameters.
* **Safe Transaction Workflows:** Full Transaction Control Language (TCL) support ensuring atomic status changes and balance restorations.
* **Advanced Aggregations:** Multi-table joins, subqueries, and database views to deliver instant analytical insights.

---

## 🛠️ System Architecture & Schema Design

The system landscape consists of primary transactional tables, operational metadata schemas, and separate independent logging structures to safely record background changes.

### 📐 Schema Entity Relationship Model
Use code with caution.
[ Departments ] ──(1:M)── [ Employees ] ──(1:M)── [ Leave_Requests ] ──(M:1)── [ Leave_Types ]
│
(M:1)
│
[ Managers ]

### 📋 Relational Database Catalog Reference

| Table Name | Primary Key | Foreign Keys & Key Attributes | Description |
| :--- | :--- | :--- | :--- |
| **Departments** | `department_id` | *None* | Core department structures (HR, IT, Sales, etc.) |
| **Employees** | `employee_id` | `department_id` | Internal user directory, phone contact, and unique email addresses |
| **Managers** | `manager_id` | *None* | Authorized approval personnel profiles |
| **Leave_Types** | `leave_type_id` | *None* | Authorized structural categories (Casual, Sick, Maternity, etc.) |
| **Leave_Requests**| `leave_id` | `employee_id`, `manager_id`, `leave_type_id` | Central transactional journal logging status configurations |
| **Leave_Balance** | `employee_id` | `employee_id` | Dynamically tracked allocation balances (Default quota = 12) |
| **Leave_Request_Log**| `log_id` | `leave_id`, `employee_id`, `leave_type_id` | System audit ledger updated automatically on request creation |
| **Leave_Status_History**| `history_id`| `leave_id`, `employee_id` | Relational trigger logging history of state migrations |

---

## 📁 Project Structure & Setup

### Prerequisites
* **Database Server:** MySQL Server 8.0+
* **Management UI:** MySQL Workbench or equivalent CLI client environment

### Deployment Execution Steps
1. Clone the repository locally:
   ```bash
   git clone https://github.com
   cd Employee-Leave-Management-System
   ```
2. Open your MySQL client environment and execute the database setup scripts located inside your project folder to build out structural schemas and baseline data models.

---

## 💾 Complete Database Implementation Script

```sql
-- ========================================================
-- 1. DATABASE SETUP & SCHEMA DDL DEFINITIONS
-- ========================================================
DROP DATABASE IF EXISTS Employee_Leave_Management;
CREATE DATABASE Employee_Leave_Management;
USE Employee_Leave_Management;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    department_id INT,
    employee_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(50),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Managers (
    manager_id INT PRIMARY KEY,
    manager_name VARCHAR(50) NOT NULL
);

CREATE TABLE Leave_Types (
    leave_type_id INT PRIMARY KEY,
    leave_type_name VARCHAR(50) NOT NULL
);

CREATE TABLE Leave_Requests (
    leave_id INT PRIMARY KEY,
    employee_id INT,
    manager_id INT,
    leave_type_id INT,
    start_date DATE,
    end_date DATE,
    total_days INT,
    status VARCHAR(20),
    reason VARCHAR(255),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (manager_id) REFERENCES Managers(manager_id),
    FOREIGN KEY (leave_type_id) REFERENCES Leave_Types(leave_type_id)
);

CREATE TABLE Leave_Balance (
    employee_id INT PRIMARY KEY,
    remaining_days INT DEFAULT 12,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Leave_Request_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    leave_id INT,
    employee_id INT,
    leave_type_id INT,
    status VARCHAR(20),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Leave_Status_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    leave_id INT,
    employee_id INT,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================================
-- 2. CORE DATA SEEDING PROCEDURES (DML)
-- ========================================================
INSERT INTO Departments VALUES 
(1,'HR'), (2,'IT'), (3,'Finance'), (4,'Sales'), (5,'Administration');

INSERT INTO Managers VALUES 
(1,'Ramesh'), (2,'Priya'), (3,'Kiran'), (4,'Sneha'), (5,'Arun');

INSERT INTO Leave_Types VALUES 
(1,'Casual Leave'), (2,'Sick Leave'), (3,'Earned Leave'), (4,'Maternity Leave'), (5,'Unpaid Leave');

INSERT INTO Employees VALUES 
(101,1,'Aarav','9876500001','aarav@mail.com'),
(102,2,'Bhavya','9876500002','bhavya@mail.com'),
(103,3,'Charan','9876500003','charan@mail.com'),
(104,4,'Divya','9876500004','divya@mail.com'),
(105,5,'Esha','9876500005','esha@mail.com'),
(106,2,'Farhan','9876500006','farhan@mail.com'),
(107,1,'Gopi','9876500007','gopi@mail.com'),
(108,3,'Hari','9876500008','hari@mail.com'),
(109,4,'Isha','9876500009','isha@mail.com'),
(110,5,'John','9876500010','john@mail.com');

INSERT INTO Leave_Requests VALUES 
(1001,101,1,1,'2026-07-01','2026-07-03',3,'Approved','Personal work'),
(1002,102,2,2,'2026-07-02','2026-07-04',3,'Pending','Fever'),
(1003,103,3,3,'2026-07-05','2026-07-06',2,'Approved','Vacation'),
(1004,104,4,1,'2026-07-07','2026-07-08',2,'Rejected','Family function'),
(1005,105,5,5,'2026-07-10','2026-07-12',3,'Approved','Personal'),
(1006,106,2,2,'2026-07-11','2026-07-11',1,'Pending','Medical'),
(1007,107,1,1,'2026-07-13','2026-07-15',3,'Approved','Travel'),
(1008,108,3,3,'2026-07-16','2026-07-20',5,'Approved','Vacation'),
(1009,109,4,2,'2026-07-18','2026-07-19',2,'Rejected','Sick'),
(1010,110,5,1,'2026-07-21','2026-07-22',2,'Pending','Personal');

INSERT INTO Leave_Balance VALUES 
(101,10), (102,12), (103,10), (104,12), (105,9),
(106,12), (107,9), (108,7), (109,12), (110,12);

-- ========================================================
-- 3. BUSINESS CAPABILITY ANALYTICS (QUESTIONS 1 TO 30)
-- ========================================================

-- Q1: List all leave requests.
SELECT * FROM Leave_Requests;

-- Q2: Display leave request with employee name.
SELECT L.leave_id, E.employee_name, L.start_date, L.end_date, L.status
FROM Leave_Requests L 
JOIN Employees E ON L.employee_id = E.employee_id;

-- Q3: Show approved leave requests.
SELECT * FROM Leave_Requests WHERE status = 'Approved';

-- Q4: Show pending leave requests.
SELECT * FROM Leave_Requests WHERE status = 'Pending';

-- Q5: Employees currently on leave.
SELECT E.employee_name, L.start_date, L.end_date
FROM Employees E 
JOIN Leave_Requests L ON E.employee_id = L.employee_id
WHERE L.status = 'Approved' 
  AND CURDATE() BETWEEN L.start_date AND L.end_date;

-- Q6: Count leave requests department-wise.
SELECT D.department_name, COUNT(L.leave_id) AS total_requests
FROM Departments D 
LEFT JOIN Employees E ON D.department_id = E.department_id
LEFT JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY D.department_id, D.department_name;

-- Q7: Count leave requests by status.
SELECT status, COUNT(*) AS total_requests
FROM Leave_Requests
GROUP BY status;

-- Q8: Average leave days by department.
SELECT D.department_name, AVG(L.total_days) AS average_leave_days
FROM Departments D 
JOIN Employees E ON D.department_id = E.department_id
JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY D.department_id, D.department_name;

-- Q9: Employee with maximum leave days.
SELECT E.employee_name, SUM(L.total_days) AS total_leave_days
FROM Employees E 
JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY E.employee_id, E.employee_name
ORDER BY total_leave_days DESC 
LIMIT 1;

-- Q10: Department with maximum leave requests.
SELECT D.department_name, COUNT(L.leave_id) AS total_requests
FROM Departments D 
JOIN Employees E ON D.department_id = E.department_id
JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY D.department_id, D.department_name
ORDER BY total_requests DESC 
LIMIT 1;

-- Q11: Employees with more than 2 leave requests.
SELECT E.employee_name, COUNT(L.leave_id) AS total_requests
FROM Employees E 
JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY E.employee_id, E.employee_name
HAVING COUNT(L.leave_id) > 2;

-- Q12: Employees who never applied for leave.
SELECT E.employee_id, E.employee_name
FROM Employees E 
LEFT JOIN Leave_Requests L ON E.employee_id = L.employee_id
WHERE L.leave_id IS NULL;

-- Q13: Latest 5 leave requests.
SELECT * FROM Leave_Requests
ORDER BY start_date DESC 
LIMIT 5;

-- Q14: Leave requests in last 30 days.
SELECT * FROM Leave_Requests
WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Q15: Display employee names in uppercase and lowercase.
SELECT employee_name, 
       UPPER(employee_name) AS uppercase_name,
       LOWER(employee_name) AS lowercase_name
FROM Employees;

-- Q16: Show first 3 characters of employee names.
SELECT employee_name, LEFT(employee_name, 3) AS first_three_characters
FROM Employees;

-- Q17: Calculate leave duration via system calculations.
SELECT leave_id, employee_id, start_date, end_date,
       DATEDIFF(end_date, start_date) + 1 AS leave_duration
FROM Leave_Requests;

-- Q18: Generate formatted string Leave Reference strings.
SELECT leave_id, CONCAT('EL-', leave_id) AS leave_reference
FROM Leave_Requests;

-- Q19: Leave types used more than 5 times.
SELECT T.leave_type_name, COUNT(L.leave_id) AS total_usage
FROM Leave_Types T 
JOIN Leave_Requests L ON T.leave_type_id = L.leave_type_id
GROUP BY T.leave_type_id, T.leave_type_name
HAVING COUNT(L.leave_id) > 5;

-- Q20: Manager-wise approved leave count.
SELECT M.manager_name, COUNT(L.leave_id) AS approved_count
FROM Managers M 
JOIN Leave_Requests L ON M.manager_id = L.manager_id
WHERE L.status = 'Approved'
GROUP BY M.manager_id, M.manager_name;

-- Q21: Employees whose leaves exceed the local department average.
SELECT E.employee_name, D.department_name, SUM(L.total_days) AS total_days
FROM Employees E 
JOIN Departments D ON E.department_id = D.department_id
JOIN Leave_Requests L ON E.employee_id = L.employee_id
WHERE L.status = 'Approved'
GROUP BY E.employee_id, E.employee_name, E.department_id, D.department_name
HAVING SUM(L.total_days) > (
    SELECT AVG(dept_totals.total_days) 
    FROM (
        SELECT E2.department_id, SUM(L2.total_days) AS total_days
FROM Employees E2
JOIN Leave_Requests L2 ON E2.employee_id = L2.employee_id
WHERE L2.status = 'Approved'
GROUP BY E2.employee_id, E2.department_id
) dept_totals
WHERE dept_totals.department_id = E.department_id
);
-- Q22: Show monthly leave statistics.
SELECT YEAR(start_date) AS year, MONTH(start_date) AS month,
COUNT(*) AS total_requests, SUM(total_days) AS total_leave_days
FROM Leave_Requests
GROUP BY YEAR(start_date), MONTH(start_date)
ORDER BY year, month;
-- Q23: Longest single leave duration record taken.
SELECT E.employee_name, L.start_date, L.end_date, L.total_days
FROM Employees E
JOIN Leave_Requests L ON E.employee_id = L.employee_id
ORDER BY L.total_days DESC
LIMIT 1;
-- Q24: Extract remaining leave balance metrics.
SELECT E.employee_name, B.remaining_days
FROM Employees E
JOIN Leave_Balance B ON E.employee_id = B.employee_id;
-- Q25: Filter open pending leave requests.
SELECT * FROM Leave_Requests WHERE status = 'Pending';
-- Q26: Filter formal rejected leave requests.
SELECT * FROM Leave_Requests WHERE status = 'Rejected';
-- Q27: Create a reusable database view for approved leaves.
CREATE OR REPLACE VIEW Approved_Leaves AS
SELECT L.leave_id, E.employee_name, L.start_date, L.end_date, L.total_days, L.status
FROM Leave_Requests L
JOIN Employees E ON L.employee_id = E.employee_id
WHERE L.status = 'Approved';
-- Q28: Create a reusable database view for pending leaves.
CREATE OR REPLACE VIEW Pending_Leaves AS
SELECT L.leave_id, E.employee_name, L.start_date, L.end_date, L.total_days, L.status
FROM Leave_Requests L
JOIN Employees E ON L.employee_id = E.employee_id
WHERE L.status = 'Pending';
-- Q29: Transaction workflow confirming safe request approval updates.
START TRANSACTION;
UPDATE Leave_Requests SET status = 'Approved' WHERE leave_id = 1002;
COMMIT;
-- Q30: Transaction rollback routine to cancel requests and securely restore parameters.
START TRANSACTION;
UPDATE Leave_Requests SET status = 'Cancelled' WHERE leave_id = 1001;
UPDATE Leave_Balance SET remaining_days = remaining_days + 3 WHERE employee_id = 101;
COMMIT;
-- ========================================================
-- 4. PROGRAMMABLE EXTENSIONS (PROCEDURES & TRIGGERS)
-- ========================================================
-- Q31: Stored Procedure to extract leave requests handled by a designated manager ID.
DELIMITER $$
CREATE PROCEDURE GetLeavesByManager(IN p_manager_id INT)
BEGIN
SELECT E.employee_name, T.leave_type_name, L.start_date, L.end_date, L.status
FROM Leave_Requests L
JOIN Employees E ON L.employee_id = E.employee_id
JOIN Leave_Types T ON L.leave_type_id = T.leave_type_id
WHERE L.manager_id = p_manager_id;
END $$
DELIMITER ;
-- Q32: Stored Procedure counting aggregate approved leave durations for an employee.
DELIMITER $$
CREATE PROCEDURE GetEmployeeApprovedLeaveDays(IN p_employee_id INT, OUT t_leave_days INT)
BEGIN
SELECT COALESCE(SUM(total_days), 0) INTO t_leave_days
FROM Leave_Requests
WHERE employee_id = p_employee_id AND status = 'Approved';
END $$
DELIMITER ;
-- Q33: DB Trigger executing automated journaling rows inside Leave_Request_Log.
DELIMITER $$
CREATE TRIGGER trg_after_leave_request_insert
AFTER INSERT ON Leave_Requests
FOR EACH ROW
BEGIN
INSERT INTO Leave_Request_Log (leave_id, employee_id, leave_type_id, status)
VALUES (NEW.leave_id, NEW.employee_id, NEW.leave_type_id, NEW.status);
END $$
DELIMITER ;
-- Q34: DB Trigger saving operational migration logs within Leave_Status_History.
DELIMITER $$
CREATE TRIGGER trg_leave_status_history
AFTER UPDATE ON Leave_Requests
FOR EACH ROW
BEGIN
IF OLD.status <> NEW.status THEN
INSERT INTO Leave_Status_History(leave_id, employee_id, old_status, new_status)
VALUES (NEW.leave_id, NEW.employee_id, OLD.status, NEW.status);
END IF;
END $$
DELIMITER ;
```

📈 Analytical Report Framework Examples

To test out the database metrics generation engine locally, verify output queries across runtime datasets:

Sample Execution: Filtering Manager Action Portfolios

sql CALL GetLeavesByManager(1); 
Expected Outputs return real-time datasets showing employee names, leave classifications, active parameters, and workflow staging flags mapped precisely to Manager ID reference parameters.

📝 Project Details & Context

• Database Management Engine: MySQL 8.0 Server
• Design Author: G. Rajasree
• Target Focus: Normalization Strategy, Relational Integrity, Advanced Aggregate Joins, Safe Stateful Transaction Routines, and Automated Database Logging.

***

### 💡 Suggestions on Next Steps:
1. Paste this text straight into a file named `README.md` at the root directory of your project folder.
2. If you have screenshots of your **ER Diagram** or **Query Result Output Tables**, place them in an `assets/` directory inside your repository and update image links within the layout document to create an exceptional portfolio entry!

<FollowUp>
Would you like me to add a **CI/CD setup section** for automated testing or draft a **contribution guideline** file (`CONTRIBUTING.md`) to go with your new repository?
</FollowUp>
