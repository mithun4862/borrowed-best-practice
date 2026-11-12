
-- ==========================================================
-- BORROWED BEST PRACTICE POC
-- File: 03_cleanup.sql
-- Purpose: Inspect and optionally remove demo objects
-- ==========================================================

-- STEP 1: Check the active environment

SELECT
    CURRENT_ROLE() AS ACTIVE_ROLE,
    CURRENT_DATABASE() AS ACTIVE_DATABASE,
    CURRENT_SCHEMA() AS ACTIVE_SCHEMA,
    CURRENT_WAREHOUSE() AS ACTIVE_WAREHOUSE;

-- STEP 2: Inspect POC tables before cleanup

SELECT
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM BORROWED_BEST_PRACTICE_POC.INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'DQ_DEMO'
ORDER BY TABLE_NAME;

-- ==========================================================
-- OPTIONAL CLEANUP
-- Do not uncomment until the POC demonstration is complete.
-- Obtain explicit approval before deleting demo objects.
-- ==========================================================

-- STEP 3: Remove the sample table

-- DROP TABLE IF EXISTS
-- BORROWED_BEST_PRACTICE_POC.DQ_DEMO.SALES_ORDERS;

-- STEP 4: Remove the dedicated demo schema
-- Only if it contains no objects that must be retained.

-- DROP SCHEMA IF EXISTS
-- BORROWED_BEST_PRACTICE_POC.DQ_DEMO;

-- STEP 5: Remove the dedicated POC database
-- Only after independently confirming that the entire
-- database belongs to this POC and can be deleted.

-- DROP DATABASE IF EXISTS
-- BORROWED_BEST_PRACTICE_POC;

-- ==========================================================
-- END OF CLEANUP SCRIPT
-- ==========================================================
