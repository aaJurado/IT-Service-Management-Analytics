USE it_service_management;

CREATE TABLE technicians (
    technician_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL UNIQUE,
    support_level VARCHAR(20) NOT NULL,
    specialty VARCHAR(50) NOT NULL,
    active_status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);
DESCRIBE technicians;

INSERT INTO technicians (
    employee_id,
    support_level,
    specialty
)
SELECT
    employee_id,

    CASE
        WHEN job_title LIKE '%Network%' THEN 'Tier 2'
        WHEN job_title LIKE '%Systems%' THEN 'Tier 2'
        ELSE 'Tier 1'
    END AS support_level,

    CASE
        WHEN job_title LIKE '%Network%' THEN 'Network Support'
        WHEN job_title LIKE '%Application%' THEN 'Application Support'
        WHEN job_title LIKE '%Systems%' THEN 'Systems Support'
        ELSE 'General IT Support'
    END AS specialty

FROM employees
WHERE department_id = 1
  AND employment_status = 'Active'
ORDER BY employee_id
LIMIT 12;
SELECT
    t.technician_id,
    e.employee_code,
    e.first_name,
    e.last_name,
    e.job_title,
    t.support_level,
    t.specialty,
    e.location
FROM technicians t
JOIN employees e
    ON t.employee_id = e.employee_id
ORDER BY t.technician_id;