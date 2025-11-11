--Ex 1:
-- Create table: employees
CREATE TABLE employees (
 emp_id INT PRIMARY KEY,
 emp_name VARCHAR(50),
 dept_id INT,
 salary DECIMAL(10, 2)
);
-- Create table: departments
CREATE TABLE departments (
 dept_id INT PRIMARY KEY,
 dept_name VARCHAR(50),
 location VARCHAR(50)
);
-- Create table: projects
CREATE TABLE projects (
 project_id INT PRIMARY KEY,
 project_name VARCHAR(50),
 dept_id INT,
 budget DECIMAL(10, 2));

--Ex 2.1:
CREATE VIEW employee_details AS SELECT e.emp_name, e.salary, d.dept_name, d.location FROM employees e JOIN departments d ON e.dept_id=d.dept_id;

--Ex 2.2:
CREATE VIEW dept_statistics AS 
SELECT d.dept_name, 
	   COUNT(e.emp_id) AS emp_count,
	   AVG(e.salary) AS salary_avg,
	   MAX(e.salary) AS salary_max, 
	   MIN(e.salary) AS salary_min 
FROM departments d LEFT JOIN employees e
ON e.dept_id=d.dept_id GROUP BY d.dept_name;

--Ex 2.3:
CREATE VIEW project_everview AS 
SELECT p.project_name, p.budget, d.dept_name, d.location, COUNT(e.emp_id) AS emp_count
FROM projects p LEFT JOIN departments d ON p.dept_id=p.dept_id
LEFT JOIN employees e ON d.dept_id=e.emp_id
 GROUP BY p.project_name, p.budget, d.dept_name, d.location; 

--Ex 2.4:
CREATE VIEW high_earners AS SELECT e.emp_name, e.salary, d.dept_name 
FROM employees e  JOIN departments d ON e.dept_id=d.dept_id
WHERE e.salary>55000;

--Ex 3.1:
CREATE OR REPLACE VIEW employee_details AS 
SELECT e.emp_name, e.salary, d.dept_name, d.location,
	CASE 
		WHEN e.salary>60000 THEN 'High'
		WHEN e.salary>50000 THEN 'Medium'
		ELSE 'Standart'
	END AS salary_grade
FROM employees e JOIN departments d 
ON e.dept_id=d.dept_id;

--Ex 3.2:
ALTER VIEW high_earners RENAME TO top_performers;

--Ex 3.3:
CREATE TEMP VIEW temp_view AS 
SELECT e.emp_name, e.salary,d.dept_name 
FROM employees e JOIN departments d ON e.dept_id=d.dept_id
WHERE e.salary<50000;
DROP VIEW IF EXISTS temp_view;

--Ex 4.1:
CREATE VIEW employee_salaries AS 
SELECT emp_id, emp_name, salary FROM employees;

--Ex 4.2:
UPDATE employee_salaries SET salary=52000 WHERE emp_name='John Smith';

--Ex 4.3:
INSERT INTO employee_salaries (emp_id,emp_name,dept_id,salary)
VALUES (6,'Alice Johnson',102,58000);

--Ex 4.4:
CREATE VIEW it_employees AS 
SELECT emp_id, emp_name, dept_id, salary FROM employees
WHERE dept_id=101 WITH CHECK OPTION;

--Ex 5.1:
CREATE MATERIALIZED VIEW dept_summary_mv AS
SELECT d.dept_id, d.dept_name,
	   COUNT(DISTINCT e.emp_id) AS total_numberemp,
	   COALESCE(SUM(e.salary),0) AS total_salaries,
	   SUM(p.project_id) AS total_projects,
	   COALESCE(SUM(p.budget),0) AS total_budget
FROM departments d LEFT JOIN employees e ON d.dept_id=e.dept_id
LEFT JOIN projects p ON p.dept_id=d.dept_id
GROUP BY d.dept_id,d.dept_name;

--Ex 5.2:
INSERT INTO employees (emp_id,emp_name,dept_id,salary)
VALUES (8,'Charlie Brown', 101, 54000);
REFRESH MATERIALIZED VIEW dept_summary_mv;

--Ex 5.3:
CREATE UNIQUE INDEX dept_summary_mv_indx ON dept_summary_mv(dept_id);
REFRESH MATERIALIZED VIEW CONCURRENTLY dept_summary_mv;

--Ex 5.4:
CREATE MATERIALIZED VIEW project_stats_mv AS
SELECT p.project_name,p.budget, d.dept_name, COUNT(e.emp_id) AS count_emp
FROM projects p LEFT JOIN departments d ON p.dept_id=d.dept_id
LEFT JOIN employees e ON p.dept_id=e.dept_id GROUP BY p.project_id,p.project_name,p.budget,d.dept_name
WITH NO DATA;

--Ex 6.1:
CREATE ROLE analyst;
CREATE ROLE data_viewer LOGIN PASSWORD 'viewer123';
CREATE ROLE report_user LOGIN PASSWORD 'report456';

SELECT rolname FROM pg_roles WHERE rolname NOT LIKE 'pg_%';

-- Exercise 6.2
CREATE ROLE db_creator LOGIN PASSWORD 'creator789' CREATEDB;
CREATE ROLE user_manager LOGIN PASSWORD 'manager101' CREATEROLE;
CREATE ROLE admin_user LOGIN PASSWORD 'admin999' SUPERUSER;


-- Exercise 6.3:
GRANT SELECT ON employees, departments, projects TO analyst;
GRANT ALL PRIVILEGES ON employee_details TO data_viewer;
GRANT SELECT, INSERT ON employees TO report_user;


-- Exercise 6.4
CREATE ROLE hr_team;
CREATE ROLE finance_team;
CREATE ROLE it_team;

CREATE ROLE hr_user1 LOGIN PASSWORD 'hr001';
CREATE ROLE hr_user2 LOGIN PASSWORD 'hr002';
CREATE ROLE finance_user1 LOGIN PASSWORD 'fin001';

GRANT hr_team TO hr_user1, hr_user2;
GRANT finance_team TO finance_user1;

GRANT SELECT, UPDATE ON employees TO hr_team;
GRANT SELECT ON dept_statistics TO finance_team;

-- Exercise 6.5
REVOKE UPDATE ON employees FROM hr_team;
REVOKE hr_team FROM hr_user2;
REVOKE ALL PRIVILEGES ON employee_details FROM data_viewer;


-- Exercise 6.6
ALTER ROLE analyst LOGIN PASSWORD 'analyst123';
ALTER ROLE user_manager SUPERUSER;
ALTER ROLE analyst PASSWORD NULL;
ALTER ROLE data_viewer CONNECTION LIMIT 5;

-- Exercise 7.1: 
CREATE ROLE read_only;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only;

CREATE ROLE junior_analyst LOGIN PASSWORD 'junior123';
CREATE ROLE senior_analyst LOGIN PASSWORD 'senior123';

GRANT read_only TO junior_analyst, senior_analyst;
GRANT INSERT, UPDATE ON employees TO senior_analyst;

-- Exercise 7.2: 
CREATE ROLE project_manager LOGIN PASSWORD 'pm123';
ALTER VIEW dept_statistics OWNER TO project_manager;
ALTER TABLE projects OWNER TO project_manager;

SELECT tablename, tableowner
FROM pg_tables
WHERE schemaname = 'public';


-- Exercise 7.3:
CREATE ROLE temp_owner LOGIN;
CREATE TABLE temp_table (id INT);
ALTER TABLE temp_table OWNER TO temp_owner;

REASSIGN OWNED BY temp_owner TO postgres;
DROP OWNED BY temp_owner;
DROP ROLE temp_owner;


-- Exercise 7.4: 
CREATE VIEW hr_employee_view AS
SELECT * FROM employees WHERE dept_id = 102;
GRANT SELECT ON hr_employee_view TO hr_team;

CREATE VIEW finance_employee_view AS
SELECT emp_id, emp_name, salary FROM employees;
GRANT SELECT ON finance_employee_view TO finance_team;


-- Exercise 8.1:
CREATE VIEW dept_dashboard AS
SELECT
    d.dept_name,
    d.location,
    COUNT(e.emp_id) AS employee_count,
    ROUND(AVG(e.salary)::numeric, 2) AS avg_salary,
    COUNT(p.project_id) AS project_count,
    COALESCE(SUM(p.budget),0) AS total_budget,
    ROUND(COALESCE(SUM(p.budget),0)/NULLIF(COUNT(e.emp_id),0),2) AS budget_per_employee
FROM departments d
LEFT JOIN employees e ON e.dept_id = d.dept_id
LEFT JOIN projects p ON p.dept_id = d.dept_id
GROUP BY d.dept_name, d.location;

-- Exercise 8.2:
ALTER TABLE projects ADD COLUMN created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

CREATE VIEW high_budget_projects AS
SELECT 
    p.project_name,
    p.budget,
    d.dept_name,
    p.created_date,
    CASE 
        WHEN p.budget > 150000 THEN 'Critical Review Required'
        WHEN p.budget > 100000 THEN 'Management Approval Needed'
        ELSE 'Standard Process'
    END AS approval_status
FROM projects p
JOIN departments d ON p.dept_id = d.dept_id
WHERE p.budget > 75000;

-- Exercise 8.3: 
-- Level 1: Viewer Role
CREATE ROLE viewer_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO viewer_role;

-- Level 2: Entry Role
CREATE ROLE entry_role;
GRANT viewer_role TO entry_role;
GRANT INSERT ON employees, projects TO entry_role;

-- Level 3: Analyst Role
CREATE ROLE analyst_role;
GRANT entry_role TO analyst_role;
GRANT UPDATE ON employees, projects TO analyst_role;

-- Level 4: Manager Role
CREATE ROLE manager_role;
GRANT analyst_role TO manager_role;
GRANT DELETE ON employees, projects TO manager_role;

-- Create users and assign roles
CREATE ROLE alice LOGIN PASSWORD 'alice123';
GRANT viewer_role TO alice;

CREATE ROLE bob LOGIN PASSWORD 'bob123';
GRANT analyst_role TO bob;

CREATE ROLE charlie LOGIN PASSWORD 'charlie123';
GRANT manager_role TO charlie;