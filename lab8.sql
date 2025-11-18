--1
CREATE TABLE departments (
 dept_id INT PRIMARY KEY,
 dept_name VARCHAR(50),
 location VARCHAR(50)
);
CREATE TABLE employees (
 emp_id INT PRIMARY KEY,
 emp_name VARCHAR(100),
 dept_id INT,
 salary DECIMAL(10,2),
 FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
CREATE TABLE projects (
 proj_id INT PRIMARY KEY,
 proj_name VARCHAR(100),
 budget DECIMAL(12,2),
 dept_id INT,
 FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
-- Insert sample data
INSERT INTO departments VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Operations', 'Building C');
INSERT INTO employees VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 101, 55000),
(3, 'Mike Johnson', 102, 48000),
(4, 'Sarah Williams', 102, 52000),
(5, 'Tom Brown', 103, 60000);
INSERT INTO projects VALUES
(201, 'Website Redesign', 75000, 101),
(202, 'Database Migration', 120000, 101),
(203, 'HR System Upgrade', 50000, 102);

--2.1:
CREATE INDEX emp_salary_idx ON employees(salary);

--2.2:
CREATE INDEX emp_dept_idx ON employees(dept_id);

--2.3:
SELECT
 tablename,
 indexname,
 indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

--3.1:
CREATE INDEX dept_salary_idx ON employees(dept_id,salary);

--3.2:
CREATE INDEX salary_dept_idx ON employees(salary, dept_id);

--4.1:
ALTER TABLE employees ADD COLUMN email VARCHAR(100);

--4.2:
ALTER TABLE employees ADD COLUMN phone VARCHAR(20) UNIQUE;

--5.1
CREATE INDEX salary_desc_idx ON employees(salary DESC);

--5.2
CREATE INDEX dept_id_idx ON employees(dept_id) WHERE dept_id IS NULL;

--6.1
CREATE INDEX emp_name_lower ON employees(LOWER(emp_name));

--6.2
ALTER TABLE employees ADD COLUMN hire_date DATE;
CREATE INDEX emp_hire_year ON employees(EXTRACT(YEAR FROM hire_date));

--7.1
ALTER INDEX emp_salary_idx RENAME TO employees_salary_indx;

--7.2
DROP INDEX salary_dept_idx;

--7.3
REINDEX INDEX employees_salary_indx;

-- Exercise 8.1:
CREATE INDEX emp_salary_filter_idx ON employees(salary)
WHERE salary > 50000;

CREATE INDEX emp_salary_desc_idx ON employees(salary DESC);


-- Exercise 8.2:
CREATE INDEX proj_high_budget_idx ON projects(budget)
WHERE budget > 80000;

SELECT proj_name, budget
FROM projects
WHERE budget > 80000;


-- Exercise 8.3:
EXPLAIN SELECT * FROM employees WHERE salary > 52000;


---------------------------------------------------------
-- Exercise 9.1:
CREATE INDEX dept_name_hash_idx ON departments USING HASH (dept_name);

SELECT * FROM departments WHERE dept_name = 'IT';


---------------------------------------------------------
-- Exercise 9.2:
CREATE INDEX proj_name_btree_idx ON projects(proj_name);

CREATE INDEX proj_name_hash_idx ON projects USING HASH (proj_name);

SELECT * FROM projects WHERE proj_name = 'Website Redesign';

SELECT * FROM projects WHERE proj_name > 'Database';


---------------------------------------------------------
-- Exercise 10.1:
SELECT
  schemaname,
  tablename,
  indexname,
  pg_size_pretty(pg_relation_size(indexname::regclass)) AS index_size
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;


-- Exercise 10.2:
DROP INDEX IF EXISTS proj_name_hash_idx;


-- Exercise 10.3:
CREATE VIEW index_documentation AS
SELECT
  tablename,
  indexname,
  indexdef,
  'Improves salary-based queries' AS purpose
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname LIKE '%salary%';

SELECT * FROM index_documentation;


