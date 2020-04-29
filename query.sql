--drop tables for testing
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS salaries CASCADE;
DROP TABLE IF EXISTS dept_employees CASCADE;
DROP TABLE IF EXISTS dept_manager CASCADE;
DROP TABLE IF EXISTS titles CASCADE;

--create departments table
CREATE TABLE departments (
	dept_no VARCHAR NOT NULL,
	dept_name VARCHAR NOT NULL,
	PRIMARY KEY (dept_no)
);

--populate departments table
COPY departments FROM 'C:\EmployeeSQL\departments.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM departments;

--create employees table
CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

--populate employees table
COPY employees FROM 'C:\EmployeeSQL\employees.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM employees;

--create salaries table
CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL, 
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

--populate salaries table
COPY salaries FROM 'C:\EmployeeSQL\salaries.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM salaries;

--create dept_employees table
CREATE TABLE dept_employees (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

--populate dept_employees table
COPY dept_employees FROM 'C:\EmployeeSQL\dept_emp.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM dept_employees;

--create dept_manager table
CREATE TABLE dept_manager (
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

--populate dept_manager table
COPY dept_manager FROM 'C:\EmployeeSQL\dept_manager.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM dept_manager; 

--create titles table
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date VARCHAR NOT NULL,
	to_date VARCHAR NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

--populate titles table 
COPY titles FROM 'C:\EmployeeSQL\titles.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM titles;

--list the following details of each employee: 
--employee number, last name, first name, gender, and salary
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.gender, salaries.salary
FROM employees
JOIN salaries ON salaries.emp_no = employees.emp_no
ORDER BY employees.emp_no;

--list employees who were hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date >= '1986-01-01' and hire_date <= '1986-12-31';

--list the manager of each dept with the following info:
--dept no, dept name, manager emp no, last name, first name, start date, end date
--filter for current managers only
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name, dept_manager.from_date, dept_manager.to_date
FROM departments
JOIN dept_manager ON departments.dept_no = dept_manager.dept_no
JOIN employees ON employees.emp_no = dept_manager.emp_no
WHERE to_date='9999-01-01';

--list the dept of each employee with the following info:
--emp no, last name, first name, dept name
--filter for department they currently work in
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_employees ON dept_employees.emp_no=employees.emp_no
JOIN departments ON dept_employees.dept_no=departments.dept_no
WHERE dept_employees.to_date='9999-01-01'
ORDER BY employees.emp_no;

--list all employees whose first name is "hercules" and last name begins with "b"
SELECT first_name, last_name
FROM employees
WHERE first_name='Hercules' AND last_name LIKE 'B%';

--list all employees in sales dept, including:
--emp no, last name, first name, dept name
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_employees ON dept_employees.emp_no=employees.emp_no
JOIN departments ON departments.dept_no=dept_employees.dept_no
WHERE dept_name ='Sales';

--list all emps in sales and development depts, including:
--emp no, last name, first name, dept name
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_employees ON dept_employees.emp_no=employees.emp_no
JOIN departments ON departments.dept_no=dept_employees.dept_no
WHERE dept_name ='Sales' OR dept_name='Development';

--in desc order, list the frequency count of emp last names
SELECT last_name, COUNT(last_name) AS "Surname Count"
FROM employees
GROUP BY last_name
ORDER BY "Surname Count" DESC;