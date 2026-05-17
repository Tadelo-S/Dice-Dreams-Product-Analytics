/* Name:
This query generates the high-level performance benchmark for the tutorial, 
aggregated by app version. It provides the "bottom-line" metrics for the dashboard.

METRICS CALCULATED:
1. Total_Starters: Count of unique users who reached the first step (index 0).
2. Completion_Rate: Success percentage (Users who finished vs. Users who started).
3. AVG_error_Per_User: Total errors in the version divided by total starters 
   (Weighted friction score per potential finisher).
4. AVG_Completion_Time: Average duration (in minutes) for users who successfully 
   completed the tutorial (Completed = TRUE).
*/
SELECT
  app_version,
  COUNT(CASE WHEN step_index = 0 THEN user_id END) AS Total_Starters,
  ROUND(
    SAFE_DIVIDE(
      COUNT(
        DISTINCT
          CASE
            WHEN event_type = 'tutorial_ended' AND completed = TRUE THEN user_id
            END),
      COUNT(DISTINCT CASE WHEN step_index = 0 THEN user_id END))
      * 100,
    2) AS Completion_Rate,
  ROUND(
    SAFE_DIVIDE(
      COUNT(CASE WHEN event_type = 'tutorial_error' THEN user_id END),
      COUNT(CASE WHEN step_index = 0 THEN user_id END)),
    2) AS AVG_error_Per_User,
  ROUND(
    SAFE_DIVIDE(
      SUM(
        CASE
          WHEN event_type = 'tutorial_ended' AND completed = TRUE
            THEN total_time
          END)
        / 60,
      COUNT(
        CASE
          WHEN event_type = 'tutorial_ended' AND completed = TRUE THEN user_id
          END)),
    2) AS AVG_Completion_Time
FROM `*****.tutorial`
GROUP BY ALL
ORDER BY 1 DESC
