-- Part A 1:
CREATE TABLE employees(
	emp_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	department VARCHAR(100),
	salary INT,
	hire_date DATE,
	status VARCHAR(100) DEFAULT 'Active'
);

CREATE TABLE departments(
	dept_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	dept_name VARCHAR(100),
	budget INT,
	manager_id INT
);

CREATE TABLE projects(
	project_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	project_name VARCHAR(100),
	dept_id INT,
	start_date DATE,
	end_date DATE,
	budget INT
);

--Part B 2:
INSERT INTO employees (first_name, last_name, department)
VALUES 
	('Akniet','Barakhan','sales'),
	('Ernar','Berenbay','sales'),
	('Saniya','Niyazkhan','HR');

--Part B 3:
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Zhanerke','Mukhametzhan', 'HR', DEFAULT, '2025-05-25', DEFAULT);

--Part B 4:
INSERT INTO departments (dept_name, budget, manager_id)
VALUES 
	('Sales', 50000, 1),
	('HR', 60000, 2),
	('IT', 70000,3);

--Part B 5:
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Aylin','Barakhan', 'IT', 50000*1.1, CURRENT_DATE, DEFAULT);

--Part B 6:
CREATE TEMPORARY TABLE temp_employees AS
SELECT emp_id, first_name, last_name, department, salary, hire_date, status
FROM employees;

--Part C 7:
UPDATE employees SET salary=salary*1.1;

--Part C 8:
UPDATE employees
SET status='Senior'
WHERE salary>60000 AND hire_date<'2020-01-01';

--Part C 9:
UPDATE employees
SET department=CASE
	WHEN salary>80000 THEN 'Management'
	WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
	ELSE 'Junior'
END;

--Part C 10:
UPDATE employees 
SET department=DEFAULT
WHERE status='Inactive';

--Part C 11:
UPDATE departments 
SET budget = (
	SELECT AVG(salary*1.2)
	FROM employees 
	WHERE employees.department=departments.dept_name
);

--Part C 12:
UPDATE employees
SET salary=salary*1.15,
	status='Promoted'
WHERE department='Sales';

--Part D 13:
DELETE FROM employees WHERE status='Terminated';

--Part D 14:
DELETE FROM employees WHERE salary<40000 AND hire_date>'2023-01-01' AND department IS NULL; 

--Part D 15:
DELETE FROM departments
WHERE departments.dept_name NOT IN (
	SELECT DISTINCT employees.department
	FROM employees
	WHERE employees.department IS NOT NULL
);

--Part D 16:
DELETE FROM projects WHERE end_date<'2023-01-01'
RETURNING *;

--Part E 17:
INSERT INTO employees(first_name, last_name, department, salary, hire_date,status)
VALUES ('Aikorkem','Barakhan','IT', NULL, '2024-02-18', NULL);

--Part E 18:
UPDATE employees 
SET department='Unassigned'
WHERE department IS NULL;

--Part E 19:
DELETE FROM employees WHERE salary IS NULL OR department IS NULL;

--Part F 20:
INSERT INTO employees (first_name, last_name, department, salary, hire_date,status)
VALUES ('Akbota','Barakhan','Sales', 100000, '2023-10-18', DEFAULT)
RETURNING emp_id, first_name ||' '|| last_name AS full_name;

--Part F 21:
UPDATE employees
SET salary=salary+5000
WHERE department='IT'
RETURNING emp_id, salary-5000 AS old_salary, salary AS new_salary;

--Part F 22:
DELETE FROM employees WHERE hire_date<'2020-01-01'
RETURNING *;

--Part G 23:
INSERT INTO employees (first_name, last_name, department, salary, hire_date,status)
SELECT 'Dana','Karimova','HR', 75000, '2016-05-01', 'Senior'
WHERE NOT EXISTS (
	SELECT 1
	FROM employees
	WHERE first_name='Dana'
	AND last_name='Karimova'
);

--Part G 24:
UPDATE employees
SET salary=salary *
	CASE
		WHEN departments.budget>100000 THEN 1.1
		ELSE 1.05
	END
FROM departments
WHERE employees.department=departments.dept_name;

--Part G 25:
INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES 
('Aida', 'Serikova', 'Sales', 60000, '2021-03-10', DEFAULT),
('Nurlan', 'Muratov', 'IT', 70000, '2020-07-15', DEFAULT),
('Dana', 'Karimova', 'HR', 55000, '2022-01-05', DEFAULT),
('Timur', 'Alimov', 'Finance', 80000, '2019-09-20', 'Inactive'),
('Zarina', 'Omarova', 'Marketing', 65000, '2022-11-12', DEFAULT);

UPDATE employees
SET salary = salary * 1.10
WHERE last_name IN ('Serikova', 'Muratov', 'Karimova', 'Alimov', 'Omarova');

--Part G 26:
CREATE TABLE employee_archive AS
TABLE employees WITH NO DATA;

INSERT INTO employee_archive
SELECT *
FROM employees
WHERE status = 'Inactive';

DELETE FROM employees
WHERE status = 'Inactive';


--Part F 27:
UPDATE projects p
SET end_date = p.end_date + INTERVAL '30 days'
WHERE p.budget > 50000
  AND (
    SELECT COUNT(*)
    FROM employees e
    WHERE e.department = (
        SELECT d.dept_name
        FROM departments d
        WHERE d.dept_id = p.dept_id
    )
  ) > 3;

