/* Name: User-Level KPI Metrics
DESCRIPTION:
This query transforms raw event-level data into a granular User-Level dataset. 
It serves as the primary data source for the Dashboard Scorecards (KPIs), 
enabling global filtering by 'app_version' while maintaining user-specific context.

METRIC LOGIC:
1. is_complete: A binary flag (false/true) identifying users who successfully 
   finished the tutorial (step 8). Used to calculate global Completion Rate.
2. completion_time_minutes: Extracts the total duration only for successful 
   conversions, converted to minutes for business readability.
3. Behavioral Flags (had_error, did_skip): Boolean markers used to segment 
   the user base into "Smooth" vs. "Struggling" onboarding experiences.
4. total_errors: A count of all error events encountered by each user, 
   allowing for distribution analysis and outlier detection.

DATA GRANULARITY:
- Aggregated by 'user_id' and 'app_version'.
- Supports high-performance filtering in Looker Studio without re-scanning 
  the entire raw events table.
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
FROM `****.tutorial`
GROUP BY ALL
