/* Name: 02_funnel_and_friction_analysis.sql
Description: Combined data for Funnel Progression and Error Distribution.
Cleaned: Removed NULL steps and restricted to tutorial steps 0-8.
*/
SELECT 
  COALESCE(step_index, from_step) AS step_id,
  MAX(step_name) AS step_label,
  COUNT(DISTINCT user_id) AS unique_users,
  COUNT(CASE WHEN event_type = 'tutorial_error' AND error_type IN ('tap_wrong_area', 'invalid_input') THEN 1 END) AS user_friction_errors,
  COUNT(CASE WHEN event_type = 'tutorial_error' AND error_type = 'timeout' THEN 1 END) AS system_issue_errors,
  COUNT(CASE WHEN event_type = 'tutorial_error' THEN 1 END) AS total_errors
FROM `ppltx-ba-course.final_project.tutorial`
GROUP BY ALL