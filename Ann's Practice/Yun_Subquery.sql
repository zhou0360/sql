# Subquery

#1 ##################################
SELECT first_name, last_name, salary
FROM employees
WHERE salary>
(SELECT salary FROM employees WHERE last_name = 'Bull'); 

#2 ###############################
SELECT first_name, last_name
FROM employees
WHERE department_id
IN (SELECT department_id 
    FROM departments
    WHERE department_name LIKE '%IT%');

#3
SELECT first_name, last_name
FROM employees
WHERE manager_id 
IN (SELECT employee_id FROM employees
    WHERE department_id 
    IN (SELECT department_id FROM departments
        WHERE location_id
        IN (SELECT location_id FROM locations
            WHERE country_id='US')));

#4 ################################## 
#Select employee_id that have appeared IN the manager_id list 
SELECT first_name, last_name 
FROM employees 
WHERE employee_id 
IN (SELECT manager_id FROM employees);    

#5
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 
(SELECT AVG(salary) FROM employees);

#6 #################################
# Min_salary in the job grade in the society
SELECT first_name, last_name, salary 
FROM employees 
WHERE employees.salary 
  = (SELECT min_salary 
     FROM jobs
     WHERE employees.job_id=jobs.job_id); 

#7 
SELECT first_name, last_name, salary
FROM employees

WHERE salary >
(SELECT AVG(salary)
 FROM employees)
 
AND department_id 
IN(SELECT department_id 
   FROM departments
   WHERE department_name LIKE 'IT%');
   
#8 
SELECT first_name, last_name, salary
FROM employees
WHERE salary >
(SELECT salary FROM employees
 WHERE last_name = 'Bell')
ORDER BY FIRST_NAME;

#9 
SELECT first_name, last_name, salary 
FROM employees
WHERE salary 
= (SELECT MIN(salary) FROM employees);

#10 ###################################
# Below shows the average salary of EVERY department
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id; 

# Select employee(s) who has salary higher than 
# average salary of ALL department. 
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 
ALL (SELECT AVG(salary) FROM employees
     GROUP BY department_id);

#11
SELECT first_name, last_name, salary 
FROM employees
WHERE salary > 
(SELECT MAX(salary) FROM employees
 WHERE job_id='SH_CLERK')
ORDER BY salary;

#11 or 
SELECT first_name,last_name, job_id, salary 
FROM employees 
WHERE salary > 
ALL (SELECT salary FROM employees 
     WHERE job_id = 'SH_CLERK') 
ORDER BY salary;
 
#12 <NOT IN>
SELECT employee_id, first_name, last_name
FROM employees 
WHERE employee_id 
NOT IN (SELECT manager_id FROM employees);

#12 OR <NOT EXISTS> is always better ###################################
SELECT b.first_name, b.last_name 
FROM employees b 
WHERE NOT EXISTS 
(SELECT 'X' FROM employees a 
 WHERE a.manager_id = b.employee_id);


#13 #####################################
#Note: we should consider all employees, 
#      including thoese who haven't been placed in a department. 
#      Thus, epartment_id should be a subquery as a union with other variables,
#      instead of a "inner join" connection variable.  
SELECT employee_id, first_name, last_name, 
(SELECT department_name 
 FROM departments d 
 WHERE e.department_id = d.department_id) AS department 
FROM employees e 
ORDER BY department;

# Below is wrong. 
SELECT employee_id, first_name, last_name, department_name 
FROM employees, departments 
WHERE employees.department_id = departments.department_id;

#14 ################################
SELECT employee_id, first_name, last_name, salary
FROM employees e 
WHERE salary > 
(SELECT AVG(salary) FROM employees 
 WHERE department_id = e.department_id);

#15 ###################################

# Select employees who have even ordering (not id)
# so, you have to create an arbituary ordering to take reminder 
# Starts from zero, uses a counter that increments by one for each row.
SET @i = 0; 
SELECT i, employee_id 
FROM (SELECT @i := @i + 1 AS i, employee_id 
      FROM employees) AS a 
WHERE MOD(a.i, 2) = 0; # MOD(n,m)= n MOD m = n % m


#16 ####################################
# limit(skip,pick)
select distinct salary 
from employees 
order by salary desc 
limit 4,1;

# 16 OR 
SELECT DISTINCT salary 
FROM employees e1 
WHERE 5 = (SELECT COUNT(DISTINCT salary) 
           FROM employees e2 
           WHERE e2.salary >= e1.salary);

#17 
SELECT distinct Salary 
FROM employees
ORDER BY salary ASC
LIMIT 3,1;

#17 OR 
SELECT DISTINCT salary 
FROM employees e1
WHERE 4 = (SELECT COUNT(DISTINCT salary)
           FROM employees e2
           WHERE e2.salary <= e1.salary);

#18 
SELECT * 
FROM (SELECT * FROM employees 
      ORDER BY employee_id DESC 
      LIMIT 10) X #X: subquery in from must have an alias
ORDER BY employee_id ASC; 

#19 
SELECT * 
FROM departments
WHERE department_id
NOT IN (SELECT department_id FROM employees);

#19 OR 
SELECT * 
FROM departments d 
WHERE NOT EXISTS 
(SELECT 'X' FROM employees e 
 WHERE d.department_id = e.department_id);

#20 3 Maximum Salaries 
SELECT DISTINCT salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 3; 

#20 MAX OR 
# 3>= : select 3 values 
SELECT DISTINCT salary 
FROM employees a 
WHERE 3 >= (SELECT COUNT(DISTINCT salary)
           FROM employees b
           WHERE b.salary >= a.salary)
ORDER BY a.salary DESC; 


#21 3 Minimum Salaries 
SELECT DISTINCT salary 
FROM employees
ORDER BY salary ASC
LIMIT 3; 

#21 MIN OR 
#1. Inner subquery: select *employee info* if the condition meets
#                   which is 3>=N
#2. Outer query: select salary from these 3 employee info. 
SELECT DISTINCT salary 
FROM employees a
WHERE 3 >= (SELECT COUNT(DISTINCT salary)
            FROM employees b
            WHERE b.salary <= a.salary)
ORDER BY a.salary DESC; 

##########################################
#22 Select 3th maximum salary of employees

SELECT * 
FROM employees a
WHERE (3) = (SELECT COUNT(DISTINCT salary)
             FROM employees b 
             WHERE b.salary >= a.salary);

#22 OR
SELECT * 
FROM employees a
WHERE (2) = (SELECT COUNT(DISTINCT salary)
             FROM employees b 
             WHERE b.salary > a.salary);











