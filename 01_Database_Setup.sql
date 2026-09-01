USE it_service_management;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_code VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    job_title VARCHAR(100),
    department_id INT NOT NULL,
    location VARCHAR(100),
    employment_status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);
DESCRIBE employees;

SELECT COUNT(*) AS total_employees
FROM employees;

SELECT *
FROM employees
LIMIT 10;
