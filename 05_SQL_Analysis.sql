USE it_service_management;

SELECT
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(sla_met) * 100, 1) AS sla_compliance_pct,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score
FROM support_tickets;

SELECT
    d.department_name,
    COUNT(st.ticket_id) AS total_tickets,
    ROUND(
        COUNT(st.ticket_id) * 100.0 /
        (SELECT COUNT(*) FROM support_tickets),
        1
    ) AS pct_of_all_tickets
FROM support_tickets st

JOIN employees e
    ON st.employee_id = e.employee_id

JOIN departments d
    ON e.department_id = d.department_id

GROUP BY d.department_id, d.department_name
ORDER BY total_tickets DESC;

SELECT
    issue_category,
    COUNT(*) AS total_tickets,
    ROUND(COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM support_tickets), 1
    ) AS pct_of_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(sla_met) * 100, 1) AS sla_compliance_pct,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM support_tickets
GROUP BY issue_category
ORDER BY total_tickets DESC;

SELECT
    issue_category,
    issue_subcategory,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    SUM(CASE WHEN sla_met = 0 THEN 1 ELSE 0 END) AS sla_missed,
    ROUND(AVG(sla_met) * 100, 1) AS sla_compliance_pct,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM support_tickets
GROUP BY issue_category, issue_subcategory
HAVING COUNT(*) >= 50
ORDER BY sla_compliance_pct ASC, total_tickets DESC;


SELECT
    d.department_name,
    COUNT(*) AS vpn_tickets,
    ROUND(AVG(st.resolution_time_hours), 2) AS avg_resolution_hours,
    SUM(CASE WHEN st.sla_met = 0 THEN 1 ELSE 0 END) AS sla_missed,
    ROUND(AVG(st.sla_met) * 100, 1) AS sla_compliance_pct,
    ROUND(AVG(st.satisfaction_score), 2) AS avg_satisfaction
FROM support_tickets st

JOIN employees e
    ON st.employee_id = e.employee_id

JOIN departments d
    ON e.department_id = d.department_id

WHERE st.issue_subcategory = 'VPN Connection'

GROUP BY d.department_id, d.department_name

ORDER BY vpn_tickets DESC;


SELECT
    t.technician_id,
    CONCAT(e.first_name, ' ', e.last_name) AS technician_name,
    t.support_level,
    t.specialty,
    COUNT(st.ticket_id) AS vpn_tickets,
    ROUND(AVG(st.resolution_time_hours), 2) AS avg_resolution_hours,
    SUM(CASE WHEN st.sla_met = 0 THEN 1 ELSE 0 END) AS sla_missed,
    ROUND(AVG(st.sla_met) * 100, 1) AS sla_compliance_pct,
    ROUND(AVG(st.satisfaction_score), 2) AS avg_satisfaction
FROM support_tickets st

JOIN technicians t
    ON st.technician_id = t.technician_id

JOIN employees e
    ON t.employee_id = e.employee_id

WHERE st.issue_subcategory = 'VPN Connection'

GROUP BY
    t.technician_id,
    e.first_name,
    e.last_name,
    t.support_level,
    t.specialty

ORDER BY sla_compliance_pct ASC;

SELECT
    t.technician_id,
    CONCAT(e.first_name, ' ', e.last_name) AS technician_name,
    COUNT(*) AS vpn_tickets,
    ROUND(AVG(st.resolution_time_hours), 2) AS avg_resolution_hours,
    SUM(CASE WHEN st.sla_met = 0 THEN 1 ELSE 0 END) AS sla_missed,
    ROUND(AVG(st.sla_met) * 100, 1) AS sla_compliance_pct
FROM support_tickets st
JOIN technicians t
    ON st.technician_id = t.technician_id
JOIN employees e
    ON t.employee_id = e.employee_id
WHERE st.issue_subcategory = 'VPN Connection'
GROUP BY
    t.technician_id,
    e.first_name,
    e.last_name
ORDER BY sla_compliance_pct ASC;

SELECT
    DATE_FORMAT(date_created, '%Y-%m') AS month,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(sla_met) * 100, 1) AS sla_compliance_pct,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM support_tickets
GROUP BY DATE_FORMAT(date_created, '%Y-%m')
ORDER BY month;


SELECT
    DATE_FORMAT(date_created, '%Y-%m') AS month,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(sla_met) * 100, 1) AS sla_compliance_pct
FROM support_tickets
GROUP BY DATE_FORMAT(date_created, '%Y-%m')
ORDER BY total_tickets DESC
LIMIT 5;


WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(date_created, '%Y-%m') AS month,
        COUNT(*) AS total_tickets,
        AVG(resolution_time_hours) AS avg_resolution_hours,
        AVG(sla_met) * 100 AS sla_compliance_pct
    FROM support_tickets
    GROUP BY DATE_FORMAT(date_created, '%Y-%m')
),

average_volume AS (
    SELECT AVG(total_tickets) AS avg_monthly_tickets
    FROM monthly_metrics
)

SELECT
    CASE
        WHEN m.total_tickets >= a.avg_monthly_tickets
            THEN 'High-volume months'
        ELSE 'Lower-volume months'
    END AS volume_group,

    COUNT(*) AS number_of_months,

    ROUND(AVG(m.total_tickets), 1) AS avg_monthly_tickets,

    ROUND(AVG(m.avg_resolution_hours), 2)
        AS avg_resolution_hours,

    ROUND(AVG(m.sla_compliance_pct), 1)
        AS avg_sla_compliance_pct

FROM monthly_metrics m
CROSS JOIN average_volume a

GROUP BY
    CASE
        WHEN m.total_tickets >= a.avg_monthly_tickets
            THEN 'High-volume months'
        ELSE 'Lower-volume months'
    END;
    
    WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(date_created, '%Y-%m') AS month,
        COUNT(*) AS total_tickets,
        AVG(sla_met) * 100 AS sla_compliance_pct
    FROM support_tickets
    GROUP BY DATE_FORMAT(date_created, '%Y-%m')
),
average_volume AS (
    SELECT AVG(total_tickets) AS avg_monthly_tickets
    FROM monthly_metrics
)

SELECT
    CASE
        WHEN m.total_tickets >= a.avg_monthly_tickets
            THEN 'High-volume months'
        ELSE 'Lower-volume months'
    END AS volume_group,
    ROUND(AVG(m.sla_compliance_pct), 1) AS avg_sla_compliance_pct
FROM monthly_metrics m
CROSS JOIN average_volume a
GROUP BY
    CASE
        WHEN m.total_tickets >= a.avg_monthly_tickets
            THEN 'High-volume months'
        ELSE 'Lower-volume months'
    END;
    
    
    SELECT
    t.technician_id,
    CONCAT(e.first_name, ' ', e.last_name) AS technician_name,
    t.support_level,
    t.specialty,
    COUNT(st.ticket_id) AS total_tickets,
    ROUND(AVG(st.resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(st.sla_met) * 100, 1) AS sla_compliance_pct,
    ROUND(AVG(st.satisfaction_score), 2) AS avg_satisfaction
FROM support_tickets st
JOIN technicians t
    ON st.technician_id = t.technician_id
JOIN employees e
    ON t.employee_id = e.employee_id
GROUP BY
    t.technician_id,
    e.first_name,
    e.last_name,
    t.support_level,
    t.specialty
ORDER BY total_tickets DESC;




SELECT
    CASE
        WHEN sla_met = 1 THEN 'SLA Met'
        ELSE 'SLA Missed'
    END AS sla_status,
    
    COUNT(*) AS total_tickets,
    
    ROUND(AVG(resolution_time_hours), 2)
        AS avg_resolution_hours,
    
    ROUND(AVG(satisfaction_score), 2)
        AS avg_satisfaction

FROM support_tickets

GROUP BY
    CASE
        WHEN sla_met = 1 THEN 'SLA Met'
        ELSE 'SLA Missed'
    END;
    
    
   SELECT
    issue_category,
    COUNT(*) AS total_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(sla_met) * 100, 1) AS sla_compliance_pct,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM support_tickets
GROUP BY issue_category
ORDER BY avg_satisfaction ASC;