/* Name: User-Level KPI Metrics
Description: Prepares granular user data for Looker Studio Scorecards. 
Supports global filtering by app_version.
Calculates: Completion Rate, Avg Time (Min), Error/Skip Flags, and Total Errors per user.
*/
SELECT
  user_id,
  app_version,
  MAX(
    CASE
      WHEN event_type = 'tutorial_ended' AND completed = TRUE THEN 1
      ELSE 0
      END) AS is_complete,
  MAX(
    CASE
      WHEN event_type = 'tutorial_ended' AND completed = TRUE THEN total_time
      END)
    / 60 AS completion_time_minutes,
  MAX(CASE WHEN event_type = 'tutorial_error' THEN 1 ELSE 0 END) AS had_error,
  MAX(CASE WHEN event_type = 'tutorial_step_skip' THEN 1 ELSE 0 END)
    AS did_skip,
  COUNT(CASE WHEN event_type = 'tutorial_error' THEN 1 END) AS total_errors
FROM `ppltx-ba-course.final_project.tutorial`
GROUP BY ALL
