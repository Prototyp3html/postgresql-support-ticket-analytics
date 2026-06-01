CREATE DATABASE customer_support_dw;
--Creates the main PostgreSQL database for the project.

CREATE SCHEMA raw;

CREATE SCHEMA staging;

CREATE SCHEMA warehouse;

CREATE SCHEMA analytics;
--Schemas organize database objects into logical layers.


CREATE TABLE raw.support_tickets (
    ticket_id TEXT,
    customer_name TEXT,
    customer_email TEXT,
    customer_age INT,
    customer_gender TEXT,
    product_purchased TEXT,
    date_of_purchase DATE,
    ticket_type TEXT,
    ticket_subject TEXT,
    ticket_description TEXT,
    ticket_status TEXT,
    resolution TEXT,
    ticket_priority TEXT,
    ticket_channel TEXT,
    first_response_time TIMESTAMP,
    time_to_resolution TIMESTAMP,
    customer_satisfaction_rating INT
);
/* Initial table creation(failed version)
This version attempted to:
-enforce datatypes immediately
-validate incoming data during ingestion

Examples:

age -> integer
timestamps -> timestamp
ratings -> integer */


CREATE TABLE raw.support_tickets (
    ticket_id TEXT,
    customer_name TEXT,
    customer_email TEXT,
    customer_age TEXT,
    customer_gender TEXT,
    product_purchased TEXT,
    date_of_purchase TEXT,
    ticket_type TEXT,
    ticket_subject TEXT,
    ticket_description TEXT,
    ticket_status TEXT,
    resolution TEXT,
    ticket_priority TEXT,
    ticket_channel TEXT,
    first_response_time TEXT,
    time_to_resolution TEXT,
    customer_satisfaction_rating TEXT
);
/* Final working table creation
Instead of strict typing,
all columns were imported as TEXT */

SELECT *
FROM raw.support_tickets
LIMIT 10;
--Used to inspect imported records,verify columns loaded correctly, and confirm successful ingestion.


SELECT

    COUNT(*) AS total_rows,

    COUNT(ticket_id) AS ticket_id_count,

    COUNT(first_response_time)
        AS first_response_time_count,

    COUNT(time_to_resolution)
        AS resolution_time_count,

    COUNT(customer_satisfaction_rating)
        AS satisfaction_count

FROM raw.support_tickets;
--Used to analyze missing values and NULL distributions.
