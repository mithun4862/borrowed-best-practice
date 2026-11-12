
---
name: snowflake-data-quality-review
description: Review Snowflake data quality using reusable SQL validation scripts. Use this skill to check row counts, NULL values, duplicate records, invalid amounts, and data quality issues in a dedicated Snowflake demo environment.
---

# Snowflake Data Quality Review

## Purpose

Provide a reusable, GitHub-hosted workflow for Snowflake data quality validation.

The skill performs automated SQL-based checks and produces a structured data quality report.

## Supported Capabilities

- Validate table row counts.
- Detect NULL values in required columns.
- Identify duplicate business keys.
- Detect invalid or negative transaction amounts.
- Report failed and passed validation checks.
- Generate a summary of data quality findings.
- Recommend corrective actions without modifying source data.

## Prerequisites

- An active Snowflake connection.
- An authorized Snowflake role.
- An available Snowflake warehouse.
- Access to the dedicated demo database.
- The SQL scripts included in this skill folder.

Never request or expose account passwords, private keys, or authentication tokens.

## Execution Workflow

### Step 1: Verify the Environment

Identify the active Snowflake connection, role, warehouse, and database.

Use only the designated demo environment:

Database: BORROWED_BEST_PRACTICE_POC

Schema: DQ_DEMO

Do not execute changes against production databases.

### Step 2: Prepare Sample Data

Read the bundled file:

scripts/01_setup.sql

Explain which demo objects it will create.

Execute the setup script only after the user approves object creation.

### Step 3: Execute Data Quality Checks

Read and execute:

scripts/02_validate.sql

Evaluate:
1. Total record count.
2. NULL values in required fields.
3. Duplicate identifiers.
4. Negative or invalid amounts.
5. Overall validation status.

Use the actual SQL query results.

### Step 4: Generate the Validation Report

Produce a report containing:

- Snowflake database and schema
- Validation timestamp
- Check name
- Records evaluated
- Failed record count
- PASS or FAIL status
- Recommended remediation

Clearly identify intentionally inserted demo anomalies.

Never report a validation as successful unless the SQL results support it.

### Step 5: Optional Cleanup

Read:

scripts/03_cleanup.sql

Explain the objects that would be removed.

Execute cleanup only after explicit user approval.

Never delete unrelated databases, schemas, tables, or existing user data.

## Execution Rules

- Prefer read-only validation operations.
- Use fully qualified Snowflake object names.
- Do not create or modify objects outside the dedicated demo schema.
- Never execute destructive SQL without explicit approval.
- Do not invent SQL execution results.
- If Snowflake execution tools are unavailable, provide the relevant SQL and clearly explain that it has not been executed.
- Do not automatically execute the cleanup script.

## Example User Request

"Use the snowflake-data-quality-review skill to validate the sample Snowflake dataset and generate a data quality report."

## Expected Output

A structured report showing validation results, detected quality issues, and recommended remediation actions.

The workflow must remain reusable without modifying the published skill files.
