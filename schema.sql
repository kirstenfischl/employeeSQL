departments
-
dept_no PK varchar
dept_name varchar

dept_employees
-
emp_no int FK - employees.emp_no
dept_no varchar FK  >- departments.dept_no
from_date date
to_date date

dept_manager
-
dept_no varchar FK >- departments.dept_no
emp_no int FK - employees.emp_no
from_date date
to_date date

employees
-
emp_no PK int
birth_date date
first_name varchar
last_name varchar
gender varchar
hire_date date

salaries
-
emp_no int FK - employees.emp_no
salary int
from_date date
to_date date

titles
-
emp_no int FK - employees.emp_no
title varchar
from_date date
to_date date
