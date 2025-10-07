--Task 1.1:
SELECT CONCAT(first_name,' ',last_name) AS full_name, department,salary  FROM employees;

--Task 1.2:
SELECT DISTINCT department FROM employees;

--Task 1.3:
SELECT project_name,budget,
CASE 
	WHEN budget > 150000 THEN 'Large'
	WHEN budget BETWEEN 100000 AND 150000 THEN 'Medium'
	ELSE 'Small'
	END AS budget_category
FROM projects;

--Task 1.4:
SELECT first_name, COALESCE(email, 'No email provided') FROM employees;

--Task 2.1:
SELECT * FROM employees WHERE hire_date>'2020-01-01';

--Task 2.2:
SELECT * FROM employees WHERE salary BETWEEN 60000 AND 70000;

--Task 2.3:
SELECT * FROM employees WHERE last_name LIKE 'S%' OR last_name LIKE 'J%';

--Task 2.4:
SELECT * FROM employees WHERE manager_id IS NOT NULL AND department='IT';

--Task 3.1:
SELECT UPPER(first_name) AS first_name_upper,
	CHAR_LENGTH(last_name) AS last_name_length,
	SUBSTRING(email,1,3) AS email_firstthree
FROM employees;

--Task 3.2:
SELECT first_name,
		last_name,
		salary*12 AS annual_salary,
		ROUND(salary,2) AS monthly_salary,
		salary*0.1 AS raise_amount
FROM employees;

--Task 3.3:
SELECT format(
	'Project:%s - Budget:$%s - Status:%s',
	project_name,
	budget,
	status
) AS project_info FROM projects;

--Task 3.4:
SELECT AGE(CURRENT_DATE, hire_date) AS withthe_company FROM employees;

--Task 4.1:
SELECT department , AVG(salary) AS average_salary FROM employees GROUP BY department;

--Task 4.2:
SELECT project_name, SUM(a.hours_worked) AS total_hours
FROM assignments a
JOIN projects p ON a.project_id = p.project_id
GROUP BY p.project_name;

--Task 4.3:
SELECT department, COUNT(*) AS number_department FROM employees GROUP BY department HAVING COUNT(*)>1;

--Task 4.4:
SELECT 
	MIN(salary) AS min_salary,
	MAX(salary) AS max_salary,
	SUM(salary) AS sum_salary
FROM employees;

--Task 5.1:
  SELECT employee_id, first_name ||	' ' || last_name AS full_name, salary FROM employees WHERE salary>65000
  UNION 
  SELECT employee_id, first_name || ' ' || last_name AS full_name, salary FROM employees WHERE hire_date>'2020-01-01';

--Task 5.2:
SELECT employee_id, first_name || ' ' || last_name AS full_name, department, salary FROM employees WHERE department='IT'
INTERSECT 
SELECT employee_id, first_name || ' ' || last_name AS full_name, department, salary FROM employees WHERE salary>65000;

--Task 5.3:
SELECT employee_id, first_name || ' ' || last_name AS full_name FROM employees
EXCEPT
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name FROM employees e 
JOIN assignments a ON e.employee_id=a.employee_id;

--Task 6.1:
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name FROM employees e 
WHERE EXISTS(
	SELECT 1
	FROM assignments a
	WHERE e.employee_id=a.employee_id
);


--Task 6.2:
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name FROM employees e
WHERE e.employee_id IN (
	SELECT a.employee_id FROM assignments a
	JOIN projects p ON a.project_id=p.project_id
	WHERE status='Active'
);


--Task 6.3:
SELECT employee_id, first_name || ' ' || last_name AS full_name, department, salary FROM employees
WHERE salary > ANY (
        SELECT salary
        FROM employees
        WHERE department = 'Sales'
    );


--Task 7.1:
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name, e.department, COALESCE(AVG(a.hours_worked), 0) AS avg_hours_worked
FROM employees e
LEFT JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.department
ORDER BY e.department, e.salary DESC;

--Task 7.2:
SELECT p.project_name, SUM(a.hours_worked) AS total_hours, COUNT(DISTINCT a.employee_id) AS num_employees
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_name
HAVING SUM(a.hours_worked) > 150
ORDER BY total_hours DESC;
 
--Task 7.3:
SELECT e.department, COUNT(*) AS total_employees, ROUND(AVG(e.salary), 2) AS avg_salary,
    (
        SELECT emp.first_name || ' ' || emp.last_name
        FROM employees emp
        WHERE emp.department = e.department
        ORDER BY emp.salary DESC
        LIMIT 1
    ) AS highest_paid_employee,
    GREATEST(AVG(e.salary), MAX(e.salary)) AS higher_value,
    LEAST(AVG(e.salary), MIN(e.salary)) AS lower_value
FROM 
    employees e
GROUP BY 
    e.department
ORDER BY 
    avg_salary DESC; 