/* Name: daily_performance_summary.sql
DESCRIPTION:
This query serves as the primary ETL process for the Executive Dashboard within the 
Business-Analytics-Sandbox. It transforms millions of raw transactional rows 
into a highly optimized, aggregated summary table.

TECHNICAL HIGHLIGHTS:
1. DATA WAREHOUSING (ETL): Implements the "Summary Table" method by materializing
   query results into the `final_project` schema, ensuring high-speed BI rendering.
2. DYNAMIC TIME-SHIFTING: Uses an automated offset logic to align historical
   gameplay data with the present day for a "live" dashboard feel.
3. CURRENCY UNIFICATION: Standardizes global revenue (JPY, EUR) into USD during
   the aggregation phase to save processing power in the visualization layer.

LOGIC STEPS:
1. Schema & Table Creation: Defines the persistent storage layer within the `project-ID` project.
2. Base Data Transformation: Calculates the date offset and identifies the first-touch (install) date.
3. Metric Aggregation: Groups data by dimensions to generate daily DAU, Revenue, and Acquisition counts.
*/
CREATE SCHEMA IF NOT EXISTS `project-ID.final_project`
  OPTIONS (location = 'US');

CREATE OR REPLACE TABLE `project-ID.final_project.agg_daily_performance`
AS
WITH
  base_data AS (
    SELECT
      DATE_ADD(
        DATE(time),
        INTERVAL (
          SELECT DATE_DIFF(CURRENT_DATE(), MAX(DATE(time)), DAY)
          FROM `Business-Analytics-Sandbox.gamepltx.fact`
        ) DAY) AS date,
      user_id,
      country,
      device_type,
      MIN(DATE(time)) OVER (PARTITION BY user_id) AS raw_install_date,
      ROUND(
        CASE
          WHEN currency = 'JPY' THEN price * 0.0066
          WHEN currency = 'EUR' THEN price * 1.08
          ELSE price
          END,
        0) AS rev,
      transaction_id
    FROM `Business-Analytics-Sandbox.gamepltx.fact`
  )
SELECT
  date,
  country,
  device_type,
  COUNT(DISTINCT user_id) AS dau,
  SUM(rev) AS revenue,
  COUNT(DISTINCT transaction_id) AS transactions,
  COUNT(
    DISTINCT
      CASE
        WHEN
          date = DATE_ADD(
            raw_install_date,
            INTERVAL (
              SELECT DATE_DIFF(CURRENT_DATE(), MAX(DATE(time)), DAY)
              FROM `Business-Analytics-Sandbox.gamepltx.fact`
            ) DAY)
          THEN user_id
        END) AS installs
FROM base_data
GROUP BY 1, 2, 3
