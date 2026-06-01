CREATE TABLE staging.tickets_clean AS

SELECT

    ticket_id,

    customer_name,

    customer_email,

    CAST(customer_age AS INT)
        AS customer_age,

    customer_gender,

    product_purchased,

    CAST(date_of_purchase AS DATE)
        AS date_of_purchase,

    ticket_type,

    ticket_subject,

    ticket_description,

    ticket_status,

    resolution,

    ticket_priority,

    ticket_channel,

    CAST(first_response_time AS TIMESTAMP)
        AS first_response_time,

    CAST(time_to_resolution AS TIMESTAMP)
        AS time_to_resolution,

    CAST(
        customer_satisfaction_rating
        AS NUMERIC
    ) AS customer_satisfaction_rating

FROM raw.support_tickets;
--This query reads raw text data, converts columns into proper datatypes and creates cleaned operational table


SELECT *
FROM staging.tickets_clean
LIMIT 10;
--Verifying staging table



SELECT

    COUNT(*) AS total_rows,

    COUNT(first_response_time)
        AS response_time_count,

    COUNT(time_to_resolution)
        AS resolution_time_count,

    COUNT(customer_satisfaction_rating)
        AS satisfaction_count

FROM staging.tickets_clean;
--Checks for NULL values


ALTER TABLE staging.tickets_clean

ADD COLUMN resolution_hours NUMERIC;
--Adds a derived metric column used for SLA analysis, dashboard KPIs and support performance metrics



UPDATE staging.tickets_clean

SET resolution_hours =

EXTRACT(
    EPOCH FROM (
        time_to_resolution -
        first_response_time
    )
) / 3600;
--Initial resolution calculation
/* Failed because some rows produced negative values due to dataset timestamps being were inconsistent, 
some records had time_to_resolution earlier than first_response_time. */



UPDATE staging.tickets_clean

SET resolution_hours =

CASE

    WHEN first_response_time IS NOT NULL

    AND time_to_resolution IS NOT NULL

    THEN EXTRACT(

        EPOCH FROM (

            time_to_resolution -
            first_response_time

        )

    ) / 3600

    ELSE NULL

END;
--Updated resolution calculation 
--This query preserves unresolved tickets and avoids NULL calculation failures.




UPDATE staging.tickets_clean

SET resolution_hours = NULL

WHERE resolution_hours < 0;
--Negative durations were cleaned.




UPDATE staging.tickets_clean

SET resolution_hours = NULL

WHERE resolution_hours < 0
OR resolution_hours > 720;
--This removes negative durations andunrealistic durations (>30 days).


SELECT

    COUNT(*) AS total_rows,

    COUNT(resolution_hours)
        AS valid_resolution_rows

FROM staging.tickets_clean;
--verifies clean metrics



SELECT

    ROUND(
        AVG(resolution_hours),
        2
    ) AS avg_resolution_hours

FROM staging.tickets_clean;
--Business KPI query 




SELECT

    ticket_status,

    COUNT(*) AS total_tickets

FROM staging.tickets_clean

GROUP BY ticket_status;
--ticket status distribution query for dashboard and performance analysis.




SELECT

    ROUND(
        AVG(customer_satisfaction_rating),
        2
    ) AS avg_satisfaction

FROM staging.tickets_clean

WHERE customer_satisfaction_rating
IS NOT NULL;
--Customer satisfaction analysis query for dashboard and performance insights.











