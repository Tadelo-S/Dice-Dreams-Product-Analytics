/* Name: 02_funnel_and_friction_analysis.sql
DESCRIPTION:
This query generates the core dataset for the middle section of the dashboard: 
The Step-by-Step Funnel and the Combined Friction Graph. 

LOGIC & TRANSFORMATIONS:
1. Granularity: Data is aggregated by Step ID and App Version to allow deep-dive 
   filtering and version comparison.
2. Step Normalization: Uses COALESCE(step_index, from_step) to ensure error events 
   (which often lack a direct step_index) are correctly mapped to their respective 
   tutorial stage.
3. Friction Categorization:
   - AVG_user_errors: Measures manual friction (wrong taps, invalid inputs) per unique user.
   - AVG_app_errors: Measures technical/system friction (timeouts) per unique user.
4. Time Metric: Calculates the total average time spent per step, including 
   recovery time after errors, to identify "bottleneck" steps.

FILTERS:
- Restricted to steps 0-8 to maintain focus on the core tutorial flow.
- Excludes NULL steps to ensure data integrity in the funnel visualization.
*/
SELECT
  COALESCE(step_index, from_step) AS step_id,
  MAX(step_name) AS step_label,
  app_version,
  COUNT(DISTINCT user_id) AS unique_users,
  ROUND(
    SAFE_DIVIDE(
      SUM(
        CASE
          WHEN
            event_type = 'tutorial_error'
            AND error_type IN ('tap_wrong_area', 'invalid_input')
            THEN 1
          ELSE 0
          END),
      COUNT(DISTINCT user_id)),
    2) AS AVG_user_errors,
  ROUND(
    SAFE_DIVIDE(
      SUM(
        CASE
          WHEN event_type = 'tutorial_error' AND error_type = 'timeout' THEN 1
          ELSE 0
          END),
      COUNT(DISTINCT user_id)),
    2) AS AVG_app_errors,
  ROUND(AVG(IFNULL(time_spent, 0) + IFNULL(recovery_time, 0)), 2)
    AS avg_total_step_time
FROM `*****.tutorial`
WHERE
  (step_index BETWEEN 0 AND 8 OR from_step BETWEEN 0 AND 8)
  AND (step_index IS NOT NULL OR from_step IS NOT NULL)
GROUP BY 1, 3
