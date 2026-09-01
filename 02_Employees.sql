USE it_service_management;
SELECT
    employee_id,
    employee_code,
    first_name,
    last_name,
    job_title,
    location
FROM employees
WHERE department_id = 1
  AND employment_status = 'Active'
ORDER BY employee_id
LIMIT 20;
