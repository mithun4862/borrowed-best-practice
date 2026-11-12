
-- ==========================================================
-- BORROWED BEST PRACTICE POC
-- File: 01_setup.sql
-- Purpose: Prepare isolated data quality demonstration data
-- ==========================================================

-- Use your authorized role and an existing warehouse.
-- No new warehouse is created.

SELECT
    CURRENT_ROLE() AS ACTIVE_ROLE,
    CURRENT_WAREHOUSE() AS ACTIVE_WAREHOUSE;

-- 1. Create dedicated POC database and schema

CREATE DATABASE IF NOT EXISTS
    BORROWED_BEST_PRACTICE_POC;

CREATE SCHEMA IF NOT EXISTS
    BORROWED_BEST_PRACTICE_POC.DQ_DEMO;

-- 2. Create the sample sales orders table

CREATE TABLE IF NOT EXISTS
    BORROWED_BEST_PRACTICE_POC.DQ_DEMO.SALES_ORDERS
(
    ORDER_ID NUMBER(10,0),
    CUSTOMER_ID VARCHAR(20),
    CUSTOMER_EMAIL VARCHAR(200),
    ORDER_AMOUNT NUMBER(12,2),
    ORDER_DATE DATE,
    ORDER_STATUS VARCHAR(20)
);

-- 3. Load synthetic data only when the table is empty
-- Some rows deliberately contain data quality issues.

INSERT INTO
    BORROWED_BEST_PRACTICE_POC.DQ_DEMO.SALES_ORDERS
(
    ORDER_ID,
    CUSTOMER_ID,
    CUSTOMER_EMAIL,
    ORDER_AMOUNT,
    ORDER_DATE,
    ORDER_STATUS
)
SELECT
    column1::NUMBER(10,0),
    column2::VARCHAR,
    column3::VARCHAR,
    column4::NUMBER(12,2),
    TO_DATE(column5::VARCHAR),
    column6::VARCHAR
FROM VALUES
    (1001, 'C001', 'ana@example.com', 120.00, '2026-11-01', 'COMPLETED'),
    (1002, 'C002', 'ben@example.com', 75.50, '2026-11-02', 'COMPLETED'),
    (1003, 'C003', NULL, 64.00, '2026-11-03', 'COMPLETED'),
    (1004, 'C004', 'dee@example.com', -15.00, '2026-11-04', 'COMPLETED'),
    (1005, 'C005', 'eli@example.com', 220.00, '2026-11-05', 'PENDING'),
    (1006, 'C006', 'fin@example.com', 35.00, '2026-11-06', 'COMPLETED'),
    (1002, 'C002', 'ben@example.com', 75.50, '2026-11-02', 'COMPLETED'),
    (1007, 'C007', 'gio@example.com', 45.00, '2026-11-07', 'COMPLETED'),
    (1008, 'C008', 'hal@example.com', 100.00, '2026-11-08', 'CANCELLED'),
    (1009, 'C009', 'ivy@example.com', 59.99, '2026-11-09', 'COMPLETED')
WHERE NOT EXISTS (
    SELECT 1
    FROM BORROWED_BEST_PRACTICE_POC.DQ_DEMO.SALES_ORDERS
);

-- 4. Verify the loaded data

SELECT
    COUNT(*) AS TOTAL_RECORDS,
    COUNT_IF(CUSTOMER_EMAIL IS NULL) AS NULL_EMAIL_RECORDS,
    COUNT_IF(ORDER_AMOUNT < 0) AS NEGATIVE_AMOUNT_RECORDS,
    COUNT(*) - COUNT(DISTINCT ORDER_ID) AS DUPLICATE_ID_EXCESS
FROM BORROWED_BEST_PRACTICE_POC.DQ_DEMO.SALES_ORDERS;
