#DATABASE CREATION & SETUP
-- ==========================================
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


-- ==========================================
-- 3. SQL QUESTIONS (1 to 34 Solutions)
-- ==========================================

-- 1. List all leave requests.
SELECT * FROM Leave_Requests;

-- 2. Display leave request with employee name.
SELECT L.leave_id, E.employee_name, L.start_date, L.end_date, L.status
FROM Leave_Requests L 
JOIN Employees E ON L.employee_id = E.employee_id;

-- 3. Show approved leave requests.
SELECT * FROM Leave_Requests WHERE status = 'Approved';

-- 4. Show pending leave requests.[cite: 3]
SELECT * FROM Leave_Requests WHERE status = 'Pending';

-- 5. Employees currently on leave.
SELECT E.employee_name, L.start_date, L.end_date
FROM Employees E 
JOIN Leave_Requests L ON E.employee_id = L.employee_id
WHERE L.status = 'Approved' 
  AND CURDATE() BETWEEN L.start_date AND L.end_date;

-- 6. Count leave requests department-wise.
SELECT D.department_name, COUNT(L.leave_id) AS total_requests
FROM Departments D 
LEFT JOIN Employees E ON D.department_id = E.department_id
LEFT JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY D.department_id, D.department_name;

-- 7. Count leave requests by status.
SELECT status, COUNT(*) AS total_requests
FROM Leave_Requests
GROUP BY status;

-- 8. Average leave days by department.
SELECT D.department_name, AVG(L.total_days) AS average_leave_days
FROM Departments D 
JOIN Employees E ON D.department_id = E.department_id
JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY D.department_id, D.department_name;

-- 9. Employee with maximum leave days.
SELECT E.employee_name, SUM(L.total_days) AS total_leave_days
FROM Employees E 
JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY E.employee_id, E.employee_name
ORDER BY total_leave_days DESC 
LIMIT 1;

-- 10. Department with maximum leave requests.
SELECT D.department_name, COUNT(L.leave_id) AS total_requests
FROM Departments D 
JOIN Employees E ON D.department_id = E.department_id
JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY D.department_id, D.department_name
ORDER BY total_requests DESC 
LIMIT 1;

-- 11. Employees with more than 2 leave requests.
SELECT E.employee_name, COUNT(L.leave_id) AS total_requests
FROM Employees E 
JOIN Leave_Requests L ON E.employee_id = L.employee_id
GROUP BY E.employee_id, E.employee_name
HAVING COUNT(L.leave_id) > 2;

-- 12. Employees who never applied for leave.
SELECT E.employee_id, E.employee_name
FROM Employees E 
LEFT JOIN Leave_Requests L ON E.employee_id = L.employee_id
WHERE L.leave_id IS NULL;

-- 13. Latest 5 leave requests.
SELECT * FROM Leave_Requests
ORDER BY start_date DESC 
LIMIT 5;

-- 14. Leave requests in last 30 days.
SELECT * FROM Leave_Requests
WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 15. Display employee names in uppercase and lowercase.
SELECT employee_name, 
       UPPER(employee_name) AS uppercase_name,
       LOWER(employee_name) AS lowercase_name
FROM Employees;

-- 16. Show first 3 characters of employee names.
SELECT employee_name, LEFT(employee_name, 3) AS first_three_characters
FROM Employees;

-- 17. Calculate leave duration.
SELECT leave_id, employee_id, start_date, end_date,
       DATEDIFF(end_date, start_date) + 1 AS leave_duration
FROM Leave_Requests;

-- 18. Generate Leave Reference (EL-1001).
SELECT leave_id, CONCAT('EL-', leave_id) AS leave_reference
FROM Leave_Requests;

-- 19. Leave types used more than 5 times.
SELECT T.leave_type_name, COUNT(L.leave_id) AS total_usage
FROM Leave_Types T 
JOIN Leave_Requests L ON T.leave_type_id = L.leave_type_id
GROUP BY T.leave_type_id, T.leave_type_name
HAVING COUNT(L.leave_id) > 5;

-- 20. Manager-wise approved leave count.
SELECT M.manager_name, COUNT(L.leave_id) AS approved_count
FROM Managers M 
JOIN Leave_Requests L ON M.manager_id = L.manager_id
WHERE L.status = 'Approved'
GROUP BY M.manager_id, M.manager_name;

-- 21. Employees whose leave exceeds department average.[cite: 3]
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

-- 22. Show monthly leave statistics.
SELECT YEAR(start_date) AS year, MONTH(start_date) AS month,
       COUNT(*) AS total_requests, SUM(total_days) AS total_leave_days
FROM Leave_Requests
GROUP BY YEAR(start_date), MONTH(start_date)
ORDER BY year, month;

-- 23. Longest leave taken.
SELECT E.employee_name, L.start_date, L.end_date, L.total_days
FROM Employees E 
JOIN Leave_Requests L ON E.employee_id = L.employee_id
ORDER BY L.total_days DESC 
LIMIT 1;

-- 24. Remaining leave balance.
SELECT E.employee_name, B.remaining_days
FROM Employees E 
JOIN Leave_Balance B ON E.employee_id = B.employee_id;

-- 25. Open leave requests.
SELECT * FROM Leave_Requests WHERE status = 'Pending';

-- 26. Rejected leave requests.
SELECT * FROM Leave_Requests WHERE status = 'Rejected';

-- 27. Create a view for approved leaves.
CREATE OR REPLACE VIEW Approved_Leaves AS
SELECT L.leave_id, E.employee_name, L.start_date, L.end_date, L.total_days, L.status
FROM Leave_Requests L 
JOIN Employees E ON L.employee_id = E.employee_id
WHERE L.status = 'Approved';

SELECT * FROM Approved_Leaves;

-- 28. Create a view for pending leave
CREATE OR REPLACE VIEW Pending_Leaves AS
SELECT L.leave_id, E.employee_name, L.start_date, L.end_date, L.total_days, L.status
FROM Leave_Requests L 
JOIN Employees E ON L.employee_id = E.employee_id
WHERE L.status = 'Pending';

SELECT * FROM Pending_Leaves;

-- 29. Transaction to approve leave request.
START TRANSACTION;
UPDATE Leave_Requests SET status = 'Approved' WHERE leave_id = 1002;
COMMIT;

-- 30. Transaction to cancel leave request and restore balance.
START TRANSACTION;
UPDATE Leave_Requests SET status = 'Cancelled' WHERE leave_id = 1001;
UPDATE Leave_Balance SET remaining_days = remaining_days + 3 WHERE employee_id = 101;
COMMIT;


-- ==========================================
-- 4. STORED PROCEDURES (Questions 31 & 32)
-- ==========================================
#Create a stored procedure to display all leave requests handled by a particular manager. 
#• Input: manager_id  
#• Display employee name, leave type, start date, end date, and status.
CALL display_details(1);

select * from leave_requests;
select * from departments;
select * from employees;
select * from leave_balance;
select * from leave_request_log;
select * from leave_requests;
select * from leave_status_history;
select * from leave_types;
select * from managers;
# Create a stored procedure to calculate the total number of leave days taken by an employee. 
# Input: employee_id  
# Consider only leave requests with status Approved

# Create a trigger on the Leave_Requests table. 
# Whenever a new leave request is inserted, automatically store the leave_id, employee_id, leave_type_id, and status in a Leave_Request_Log table.  
# The log table should also store the date on which the request was created.
create table leave_request_log (leave_id int, leave_type_id int, status varchar(20));
insert into leave_request values(1011,110,5,1,'2026-07-21','2026-07-22',2,'Pending','Personal');

 #Create a trigger on Leave_Requests. 
# Whenever a leave request's status changes, store the leave_id, employee ID, old status, new status, and change date in a Leave_Status_History table.



