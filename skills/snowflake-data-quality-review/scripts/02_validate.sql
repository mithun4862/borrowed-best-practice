
-- ==========================================================
-- BORROWED BEST PRACTICE POC
-- File: 02_validate.sql
-- Purpose: Execute Snowflake data quality checks
-- Type: Read-only validation
-- ==========================================================

WITH PROFILED AS (
    SELECT
        ORDER_ID,
        CUSTOMER_EMAIL,
        ORDER_AMOUNT,
        ROW_NUMBER() OVER (
            PARTITION BY ORDER_ID
            ORDER BY ORDER_DATE, CUSTOMER_ID
        ) AS ID_OCCURRENCE
    FROM BORROWED_BEST_PRACTICE_POC.DQ_DEMO.SALES_ORDERS
),

METRICS AS (
    SELECT
        COUNT(*) AS TOTAL_ROWS,

        COALESCE(SUM(IFF(
            CUSTOMER_EMAIL IS NULL
            OR TRIM(CUSTOMER_EMAIL) = '',
            1, 0
        )), 0) AS MISSING_EMAILS,

        COALESCE(SUM(IFF(
            ORDER_AMOUNT IS NULL
            OR ORDER_AMOUNT < 0,
            1, 0
        )), 0) AS INVALID_AMOUNTS,

        COALESCE(SUM(IFF(
            ORDER_ID IS NOT NULL
            AND ID_OCCURRENCE > 1,
            1, 0
        )), 0) AS DUPLICATE_ORDERS,

        COALESCE(SUM(IFF(
            ORDER_ID IS NULL,
            1, 0
        )), 0) AS MISSING_ORDER_IDS

    FROM PROFILED
),

CHECKS AS (

    -- Check 1: Expected row count
    SELECT
        '01_ROW_COUNT' AS CHECK_NAME,
        TOTAL_ROWS AS RECORDS_EVALUATED,
        ABS(TOTAL_ROWS - 10) AS FAILED_RECORD_COUNT,
        IFF(TOTAL_ROWS = 10, 'PASS', 'FAIL') AS CHECK_STATUS,
        'Verify expected demo row count' AS RECOMMENDATION
    FROM METRICS

    UNION ALL

    -- Check 2: Required customer email
    SELECT
        '02_REQUIRED_EMAIL',
        TOTAL_ROWS,
        MISSING_EMAILS,
        IFF(MISSING_EMAILS = 0, 'PASS', 'FAIL'),
        'Review missing customer email values'
    FROM METRICS

    UNION ALL

    -- Check 3: Non-negative order amounts
    SELECT
        '03_ORDER_AMOUNT',
        TOTAL_ROWS,
        INVALID_AMOUNTS,
        IFF(INVALID_AMOUNTS = 0, 'PASS', 'FAIL'),
        'Review NULL or negative order amounts'
    FROM METRICS

    UNION ALL

    -- Check 4: Duplicate order identifiers
    SELECT
        '04_DUPLICATE_ORDER_ID',
        TOTAL_ROWS,
        DUPLICATE_ORDERS,
        IFF(DUPLICATE_ORDERS = 0, 'PASS', 'FAIL'),
        'Investigate duplicate order identifiers'
    FROM METRICS

    UNION ALL

    -- Check 5: Required order identifiers
    SELECT
        '05_REQUIRED_ORDER_ID',
        TOTAL_ROWS,
        MISSING_ORDER_IDS,
        IFF(MISSING_ORDER_IDS = 0, 'PASS', 'FAIL'),
        'Review missing order identifiers'
    FROM METRICS
)

SELECT
    CURRENT_TIMESTAMP() AS VALIDATED_AT,
    'BORROWED_BEST_PRACTICE_POC' AS DATABASE_NAME,
    'DQ_DEMO' AS SCHEMA_NAME,
    CHECK_NAME,
    RECORDS_EVALUATED,
    FAILED_RECORD_COUNT,
    CHECK_STATUS,
    RECOMMENDATION,
    IFF(
        MAX(IFF(CHECK_STATUS = 'FAIL', 1, 0)) OVER () = 1,
        'FAIL',
        'PASS'
    ) AS OVERALL_STATUS
FROM CHECKS
ORDER BY CHECK_NAME;
