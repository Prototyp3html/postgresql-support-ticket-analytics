CREATE INDEX idx_ticket_status

ON warehouse.fact_support_tickets(ticket_status);
--Creates an index on ticket_status.
--Queries such as WHERE ticket_status = 'Resolved' become significantly faster.






CREATE INDEX idx_first_response_time

ON warehouse.fact_support_tickets(first_response_time);
--Optimizes time-based queries.





CREATE INDEX idx_product

ON warehouse.fact_support_tickets(product_purchased);
--Improves performance for product issue analysis and aggregations filtering.







CREATE VIEW analytics.ticket_kpis AS

SELECT

    ticket_status,

    COUNT(*) AS total_tickets,

    ROUND(
        AVG(resolution_hours),
        2
    ) AS avg_resolution_hours,

    ROUND(
        AVG(customer_satisfaction_rating),
        2
    ) AS avg_satisfaction

FROM warehouse.fact_support_tickets

GROUP BY ticket_status;
--Creates reusable KPI reporting layer.





CREATE VIEW analytics.monthly_ticket_trends AS

SELECT

    DATE_TRUNC(
        'month',
        first_response_time
    ) AS month,

    COUNT(*) AS total_tickets,

    ROUND(
        AVG(customer_satisfaction_rating),
        2
    ) AS avg_satisfaction

FROM warehouse.fact_support_tickets

WHERE first_response_time IS NOT NULL

GROUP BY 1

ORDER BY 1;
--Created monthly operational trend analysis.




CREATE OR REPLACE VIEW analytics.daily_ticket_trends AS

SELECT

    DATE(first_response_time) AS day,

    COUNT(*) AS total_tickets,

    ROUND(
        AVG(customer_satisfaction_rating),
        2
    ) AS avg_satisfaction

FROM warehouse.fact_support_tickets

WHERE first_response_time IS NOT NULL

GROUP BY 1

ORDER BY 1;
--A daily trend view was created in attempt to improve visual trend granularity and line chart storytelling






CREATE MATERIALIZED VIEW analytics.mv_ticket_summary AS

SELECT

    ticket_priority,

    COUNT(*) AS total_tickets,

    ROUND(
        AVG(resolution_hours),
        2
    ) AS avg_resolution_hours,

    ROUND(
        AVG(customer_satisfaction_rating),
        2
    ) AS avg_satisfaction

FROM warehouse.fact_support_tickets

GROUP BY ticket_priority;   
--Creates precomputed analytics results for faster reporting.








