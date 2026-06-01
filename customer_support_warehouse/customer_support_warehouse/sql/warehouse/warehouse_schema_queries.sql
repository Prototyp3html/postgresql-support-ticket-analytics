/* Used Star Schema to organize analytics data and reduce data duplication that will
support dashboards and BI tools create scalable analytics models. */

CREATE TABLE warehouse.dim_customer AS

SELECT DISTINCT

    customer_email,
    customer_name,
    customer_age,
    customer_gender

FROM staging.tickets_clean;
--creates customer dimension table with unique customers and their attributes.


CREATE TABLE warehouse.dim_product AS

SELECT DISTINCT

    product_purchased

FROM staging.tickets_clean;
--Creates a unique product reference table.



CREATE TABLE warehouse.dim_channel AS

SELECT DISTINCT

    ticket_channel

FROM staging.tickets_clean;
--Creates support channel reference table.




CREATE TABLE warehouse.dim_priority AS

SELECT DISTINCT

    ticket_priority

FROM staging.tickets_clean;
--Creates ticket priority lookup dimension.




CREATE TABLE warehouse.dim_status AS

SELECT DISTINCT

    ticket_status

FROM staging.tickets_clean;
--Creates ticket lifecycle status dimension.






CREATE TABLE warehouse.fact_support_tickets AS

SELECT

    ticket_id,

    customer_email,

    product_purchased,

    ticket_channel,

    ticket_priority,

    ticket_status,

    ticket_type,

    first_response_time,

    time_to_resolution,

    resolution_hours,

    customer_satisfaction_rating

FROM staging.tickets_clean;
/* Creates the central analytics table that stores

-measurable business events
-operational metrics
-timestamps
-ticket lifecycle data */


SELECT *
FROM warehouse.fact_support_tickets
LIMIT 10;

SELECT COUNT(*)
FROM warehouse.fact_support_tickets;
--verifies fact table values and row count to ensure no no records were lost.







SELECT

    ticket_status,

    COUNT(*) AS total_tickets

FROM warehouse.fact_support_tickets

GROUP BY ticket_status;
--Calculates operational ticket distribution.




SELECT

    ROUND(
        AVG(resolution_hours),
        2
    ) AS avg_resolution_hours

FROM warehouse.fact_support_tickets;\
--Calculates average support ticket resolution time




SELECT

    ticket_priority,

    ROUND(
        AVG(customer_satisfaction_rating),
        2
    ) AS avg_satisfaction

FROM warehouse.fact_support_tickets

GROUP BY ticket_priority

ORDER BY avg_satisfaction DESC;
--Analyzes customer satisfaction across support priorities





SELECT

    product_purchased,

    COUNT(*) AS total_tickets

FROM warehouse.fact_support_tickets

GROUP BY product_purchased

ORDER BY total_tickets DESC;
--Identifies products generating the most support tickets





SELECT

    ticket_channel,

    COUNT(*) AS total_tickets,

    ROUND(
        AVG(customer_satisfaction_rating),
        2
    ) AS avg_satisfaction

FROM warehouse.fact_support_tickets

GROUP BY ticket_channel

ORDER BY avg_satisfaction DESC;
--Analyzes support performance by communication channel.





SELECT

    ROUND(

        COUNT(

            CASE
                WHEN resolution_hours <= 24
                THEN 1
            END

        ) * 100.0 / COUNT(*),

        2

    ) AS sla_compliance_rate

FROM warehouse.fact_support_tickets

WHERE resolution_hours IS NOT NULL;
--Calculates percentage of tickets resolved within 24 hours













