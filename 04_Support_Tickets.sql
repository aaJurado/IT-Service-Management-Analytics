USE it_service_management;

CREATE TABLE support_tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_code VARCHAR(20) NOT NULL UNIQUE,

    employee_id INT NOT NULL,
    technician_id INT NOT NULL,

    date_created DATETIME NOT NULL,
    date_resolved DATETIME,

    issue_category VARCHAR(50) NOT NULL,
    issue_subcategory VARCHAR(100) NOT NULL,

    priority VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    channel VARCHAR(20) NOT NULL,

    resolution_time_hours DECIMAL(8,2),
    sla_target_hours INT NOT NULL,
    sla_met BOOLEAN,

    satisfaction_score INT,

    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id),

    FOREIGN KEY (technician_id)
        REFERENCES technicians(technician_id)
);
DESCRIBE support_tickets;

SELECT COUNT(*) AS total_tickets
FROM support_tickets;